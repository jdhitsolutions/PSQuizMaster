# define a domain specific language (DSL) for creating quizzes

#Platyps apparently won't generate help for non-standard names so I'll use comment based help.
function Quiz {
    <#
    .SYNOPSIS
    A PSQuiz DSL command to define a quiz

    .DESCRIPTION
This command is used in a PSQuiz fixture, which is a PowerShell script written using the PSQuiz Domain Specific Language (DSL). This makes it easier to create a quiz. This is not a command you should run from a command prompt. It is designed to be used in a script file. Run New-PSQuizFixture to generate a script file using this DSL element.

If you run the fixture script in the VSCode integrated terminal, VSCode will open the JSON file for further editing and review.

The basic syntax looks like this:

Quiz 'Your quiz name' -protect @(
    #settings hashtable must be the first element
    @{
        Path        = "c:\quiz-source\quiz-src.ps1"
        Author      = "Art Deco"
        Description = "my first quiz"
    }
    #followed by a list of questions
    Question @{}
    Question @{}
)

You can use -protect to mask all answers, distractors, and notes. Or you can mask individual questions. See Questions.
Do not include SpectreConsole formatting in the quiz. You also do not need to escape square brackets. That will handled when the JSON file is created.

    .PARAMETER Name
    The quiz name. This should be a little descriptive, e.g. 'PowerShell Remoting Basics'

    .PARAMETER Protect
    Mask all answers, distractors, notes. If you use this, you don't need to mask individual questions.

    .PARAMETER Data
    The data used to create the quiz. The first item must be the settings hashtable.

    .EXAMPLE
    PS C:\> help about_PSQuizDSL

This command is intended to be used in a script file. Read the about help topic for more information.

    .INPUTS
    None

    .OUTPUTS
    System.IO.FileInfo

    .LINK
    New-PSQuizFixture

    .LINK
    Question
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position = 0, Mandatory,HelpMessage = "The quiz name")]
        [string]$Name,
        [Parameter(Position = 1, Mandatory,HelpMessage = "The data used to create the quiz" )]
        [object[]]$Data,
        [Parameter(HelpMessage = "Mask all answers and distractors")]
        [alias("Mask")]
        [switch]$Protect
    )

    $settings = $Data[0]
    $splat = @{
        Name        = $Name
        Path        = Split-Path $settings.Path
        ShortName   = ($settings.Path | Split-Path -Leaf).split('.')[0]
        Description = $settings.Description
        ErrorAction = 'Stop'
    }

    #validate the path
    if (-not (Test-Path -path $splat.path)) {
        #create a detailed warning message
        $pro = ($Protect) ?"-protect" : $null
        $msg = @"
`e[38;5;208m
WARNING Failed to find or validate the folder: $($splat.path). You might need to update the settings hashtable.

Quiz '$Name' $pro @(

    @{
        Path        = `e[3;5m$($settings.path)`e[0m`e[38;5;208m
        Author      = $($settings.author)
        Description = $($settings.description)
    }

...`e[0m
"@
        Write-Host $msg
        Return
    }

    if ($settings.Author) {
        $splat['Author'] = $settings.Author
    }
    else {
        $splat['Author'] = [System.Environment]::UserName
    }

    Write-Host ("Creating quiz file {0}{1}{4} at {2}{3}{4}" -f "`e[96;3m",$Name,"`e[38;5;192m",$settings.Path,"`e[0m")

    try {
        $script:quizFile = New-PSQuizFile @splat
        if (Test-Path $script:quizFile) {
            $questionArray = $data | Select-Object -Skip 1
            Write-Host ("{0}Updating $script:quizFile with {1} questions:{2}" -f "`e[38;5;159m",$QuestionArray.Count,"`e[0m")

            $questionArray | ForEach-Object {
                "  - $($_.Question)" | Write-Host -ForegroundColor yellow
            }
            Set-PSQuizFile -Path $script:quizFile -Question $questionArray

            if ($Protect) {
                Write-Host "Protecting quiz file" -ForegroundColor magenta
                Protect-PSQuizFile -Path $script:quizFile
            }
            #open the file if in VSCode
            If ($host.Name -match 'code') {
                Write-Host "Opening $script:quizFile in VSCode"
                psedit $script:quizFile
            }

        }
        else {
            Write-Warning 'Quiz file was not created.'
        }
    } #try
    catch {
        $_
    }
}

function Question {
    <#
    .SYNOPSIS
    A PSQuiz DSL command to create a quiz question
    .DESCRIPTION
    This command is intended to be used in a PSQuiz fixture to define a new quiz. Read about_PSQuizDSL
to learn more.

    .EXAMPLE
    PS C:\> help about_PSQuizDSL

This command is intended to be used in a script file. Read the about help topic for more information.

    .INPUTS
    None

    .OUTPUTS
    psQuizItem

    .LINK
    New-PSQuizFixture

    .LINK
    New-PSQuizQuestion

    .LINK
    Quiz

    #>
    [cmdletbinding()]
    param(
        [hashtable]$Data,
        [switch]$Mask
    )

    New-PSQuizQuestion @data -MaskAnswer:$Mask
}

#a function to generate a DSL outline
Function New-PSQuizFixture {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("System.IO.FileInfo")]
    Param(
        [Parameter(Position = 0, Mandatory,HelpMessage = "What is the long name for your new quiz?")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory,HelpMessage = "Specify the path and filename for the fixture file. It should be a .ps1 file.")]
        [ValidatePattern('\.ps1',ErrorMessage = "The path should point to a .ps1 file.")]
        [ValidateScript({Split-Path $_ | Test-Path},ErrorMessage = "Failed to find or verify the parent folder for {0}")]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(HelpMessage = "Do you want to protect the file quiz file")]
        [switch]$Protect,

        [Parameter(HelpMessage = "How many initial questions do you intend to ask?")]
        [ValidateScript({$_ -gt 0},ErrorMessage = "You must specify a value greater than 0")]
        [Alias("Count")]
        [int]$Questions = 5
    )
    DynamicParam {
        # Open the new file in the current editor
        If ($host.name -eq 'Visual Studio Code Host') {
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            # Defining parameter attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = '__AllParameterSets'
            $attributes.HelpMessage = 'Open the new quiz file in the current editor.'
            $attributeCollection.Add($attributes)

            # Defining the runtime parameter
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('UseEditor', [Switch], $attributeCollection)
            $paramDictionary.Add('UseEditor', $dynParam1)

            return $paramDictionary
        } # end if
    } #end DynamicParam

    Begin {
        if ($Protect) {
            $protectString = "-protect"
        }
        else {
            $protectString = $Null
        }
    } #begin
    Process {
    $base = @"
#requires -version 7.6
#requires -module PSQuizMaster

#This is a fixture for a new quiz file

#usage: $path

<#
  Use -protect to mask all answers, distractors, and notes
  Do not include SpectreConsole formatting in the quiz. You also
  do not need to escape square brackets. That will be handled 
  when the JSON file is created.
#>

Quiz '$Name' $protectString @(
    @{
        Path        = # specify the full path to the quiz json file, e.g. c:\quizzes\subject.quiz.json
        Author      = $([System.Environment]::UserName)
        Description = # add a meaningful one-line description
    }

"@

    for ($i = 1;$i -le $Questions;$i++) {
        $base += @"
    Question $($protect ? $null : '-mask') @{
        Question    = #What is your question
        Answer      = #what is the correct answer
        Distractors = #enter a comma-separated list of distractors
        Note        = #enter an optional note with more information
    }

"@

} #adding questions
    #close
    $base += @"

    <#  $($protect ? $null : "`n`t`tYou can remove -mask to unprotect answers")
        You can delete Note if not used
        At least 4 distractors are recommended
        You can delete this comment
    #>
)
"@

        $base | Out-File -FilePath $Path
        if ( (-Not $WhatIfPreference) -and (Test-Path $Path)) {
            Get-Item $Path
        }
    } #process

    End {
        if ($PSBoundParameters.ContainsKey("UseEditor")) {
            psedit $path
        }
    } #end
}