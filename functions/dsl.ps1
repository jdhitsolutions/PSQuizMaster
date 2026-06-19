# define a domain specific language (DSL) for creating quizzes

function Quiz {
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
    if ($settings.Author) {
        $splat['Author'] = $settings.Author
    }
    else {
        $splat['Author'] = [System.Environment]::UserName
    }

    if ($host.name -match 'ISE') {
        Write-Host "Creating quiz file $Name at $($settings.Path)" -ForegroundColor Cyan
    }
    else {
         Write-Host ("Creating quiz file {0}{1}{4} at {2}{3}{4}" -f "$([char]27)[96;3m",$Name,"$([char]27)[38;5;192m",$settings.Path,"$([char]27)[0m")
    }
    try {
        $script:quizFile = New-PSQuizFile @splat
        if (Test-Path $script:quizFile) {
            $questionArray = $data | Select-Object -Skip 1
            if ($host.name -match "ISE") {
                Write-Host "Updating $script:quizFile with $($QuestionArray.count) questions" -ForegroundColor Cyan
            }
            else {
                Write-Host ("{0}Updating $script:quizFile with {1} questions:{2}" -f "$([char]27)[38;5;159m",$QuestionArray.Count,"$([char]27)[0m")
            }
            $questionArray | ForEach-Object {
                "  - $($_.Question)" | Write-Host -ForegroundColor yellow
            }
            Set-PSQuizFile -Path $script:quizFile -Question $questionArray
            if ($Protect) {
                Write-Host "Protecting quiz file" -ForegroundColor magenta
                Protect-PSQuizFile -Path $script:quizFile

                #open the file if in the ISE or VSCode integrated terminal
                If ($host.Name -match 'code|ise') {
                    psedit $script:quizFile
                }
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
    [ValidatePattern('\.ps1')]
    #,ErrorMessage = "The path should point to a .ps1 file.")]
    [ValidateNotNullOrEmpty()]
    [string]$Path,

    [Parameter(HelpMessage = "Do you want to protect the file quiz file")]
    [switch]$Protect,

    [Parameter(HelpMessage = "How many initial questions do you intend to ask?")]
    [PSDefaultValue(Value = 5)]
    [ValidateScript({$_ -gt 0})]
    #,ErrorMessage = "You must specify a value greater than 0")]
    [Alias("Count")]
    [int]$Questions = 5
    )

    if ($Protect) {
        $protectString = "-protect"
    }
    else {
        $protectString = $Null
    }

    $base = @"
#requires -version 5.1
#requires -module PSQuizMaster

#This is a fixture for a new quiz file

#usage: $path

#use -protect to mask all answers, distractors, and notes
Quiz '$Name' $protectString @(
    @{
        Path        = # specify the full path to the quiz json file, e.g. c:\quizzes\subject.quiz.json
        Author      = $([System.Environment]::UserName)
        Description = # add a meaningful one-line description
    }
    <#
        Remove -mask to show answers in plain text
        Delete Note if not used
        At least 4 distractors are recommended
        You can delete this comment
    #>

"@

    for ($i = 1;$i -le $Questions;$i++) {
        $base += @"
    Question -mask @{
        Question    = #What is your question
        Answer      = #what is the correct answer
        Distractors = #enter a comma-separated list of distractors
        Note        = #enter an optional note with more information
    }

"@
    } #adding questions

    #close
    $base += @"
)
"@

    $base | Out-File -FilePath $Path
    if (-Not ($PSCmdlet.ShouldProcess) -and (Test-Path $Path)) {
        Get-Item $Path
    }
}