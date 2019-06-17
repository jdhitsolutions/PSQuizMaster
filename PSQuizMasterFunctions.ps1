# public commands for the PSQuizMaster module

#all messaging is displayed in the host

Function Get-PSQuiz {
    #list PSQuiz json files
    [cmdletbinding()]
    Param(
        [Parameter(HelpMessage = "Enter the path to the folder with quiz json files")]
        [string]$Path = (Join-Path -path $PSScriptRoot -Childpath "quizzes")
    )

    Write-Verbose "Starting $($myinvocation.MyCommand)"
    Get-Childitem -path $Path -filter "*.quiz.json"  -PipelineVariable pv| foreach-Object {
       $json = Get-Content -path $_.fullname | ConvertFrom-Json
       $json.metadata | Select-Object -property *,@{Name="Path";Expression = {$pv.fullname}}
    }

    Write-Verbose "Ending $($myinvocation.MyCommand)"
}

Function Invoke-PSQuiz {
    #load a quiz from a json file
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory)]
        [ValidateScript( {Test-Path $_})]
        [string]$Path
    )

    Write-Verbose "Starting $($myinvocation.MyCommand)"
    Write-Verbose "Loading test from $Path"
    Write-Verbose "Test Details:"
    $test = Get-Content -Path $path | ConvertFrom-Json
    Write-Verbose "`n$(($test.metadata | Out-string).Trim())"

    $in = Get-Content -path $path | ConvertFrom-Json

    $title = "{0} [v{1}]" -f $in.metadata.name, $in.metadata.version

    $questioncount = 0
    $correctcount = 0
    #randomize the questions
    $allquestions = $in.questions | Get-Random -Count $in.questions.count
    $allcount = $allquestions.count
    foreach ($question in $allquestions) {
       # Clear-Host
        $questioncount++
        $answer = $question | Invoke-QuizQuestion -title $title
        write-verbose "Answer = $answer"
        if ($answer -is [int]) {
            write-Verbose "Ending the quiz."
            #decrease the question count since the last one didn't technically get an answer
            $questioncount--
            break
        }
        elseif ($answer) {
            $correctcount++
        }
        pause
    }

    [PSCustomObject]@{
        PSTypeName     = "psQuizResult"
        Test           = $in.metadata.Name
        TotalQuestions = $questioncount
        TotalCorrect   = $correctcount
        Date           = (Get-Date)
    }

    Write-Verbose "Ending $($myinvocation.MyCommand)"
}

Function Invoke-PSQuickQuiz {

    <#
.Synopsis
Run a PowerShell quiz
.Description
Use this script to test your knowledge of PowerShell commands, which given the Verb-Noun naming pattern should be pretty easy.

The default behavior is to use all cmdlets and functions from installed modules with an option to exclude an array of module names. Wildcards are allowed. You also have the option to specify a single module for testing.


.Example
PS C:\> Invoke-PSQuickQuiz

PowerShell Pop Quiz

Given this short cmdlet description:

 Creates a new System.Windows.Markup.RoutedEventConverter

 What command would you use?

  [1]   Invoke-CauScan
  [2]   Clear-Tpm
  [3]   Remove-WindowsCapability
  [4]   Get-IscsiTargetServerSetting
  [5]   New-RoutedEventConverter

Select a menu choice [1-5]: 5

You are Correct!!

Do you want another question? Press any key to continue or Q to quit: q
You scored 1 correct out of 1 for a GPA of 5. Your grade is A.
.Example
PS C:\> Invoke-PSQuickQuiz -module Hyper-V

Launch the quiz but only use commands from the Hyper-V module.

.Example
PS C:\> Invoke-PSQuickQuiz -exclude ISE,WPK,my*

Launch the quiz using all modules except ISE, WPK and any modules that start with 'my'.

.Example
PS C:\> Invoke-PSQuickQuiz -exclude ISE,WPK,my* -path c:\work\quiz.txt

Launch the quiz using all modules except ISE, WPK and any modules that start with 'my'. Record results in a transcript file, C:\Work\quiz.txt.

.Link
Get-Help
.Link
Get-Command
.Notes
Version 0.9.1

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/


#>
    [cmdletbinding(DefaultParameterSetName = "all")]
    Param(
        [Parameter(ParameterSetName = "single")]
        [ValidateScript( {Get-Module $_ -list})]
        #You can specify a single module for testing. The default is all modules.
        [string]$ModuleName,
        [Parameter(ParameterSetName = "all")]
        #Enter a comma separated list of module names to ignore. You can use wildcards.
        [string[]]$Exclude,
        #This is used to indicate a continuing test. You should never need to use this parameter.
        [switch]$NextQuestion,
        [Parameter(HelpMessage = "Enter a path and filename for a quiz transcript.")]
        [ValidateScript( {
                $parent = Split-Path $_
                if (Test-Path $parent) {
                    return $True
                }
                else {
                    Throw "Failed to find $parent for your transcript."
                    return $false
                }
            })]
        [alias("transcript")]
        [string]$Path
    )

    If ($Path -AND (-not $NextQuestion)) {
        #first time through so initialize a new transcript file.
        $header = @"
PowerShell Quiz - $(Get-Date)
-------------------------------------
PowerShell version: $($psversiontable.PSVersion)
User              : $($env:USERDOMAIN)\$($env:username)
Quiz parameters   :

$(($PSBoundParameters | Out-String).trim())
-------------------------------------
"@
        #create a new transcript file
        Set-Content -Value $header -Path $Path

    }
    Clear-Host
    Write-Verbose "Starting $($myinvocation.MyCommand)"
    Write-Verbose "PSBoundParameters:"
    write-verbose $($psboundparameters | out-string).Trim()

    if (-Not $NextQuestion) {
        Write-Verbose "First question setup"
        #initialize some variables to keep track of correct answers
        $global:QuestionCount = 0
        $global:CorrectCount = 0
        $global:CommandCache = @()

        if ($ModuleName) {
            $Status = "Getting commands from module $modulename."
            Write-Verbose $Status
            Write-Progress -Activity $myinvocation.MyCommand -Status $status -CurrentOperation "Please wait..."
            $global:CommandCache = Get-command -CommandType Cmdlet, Function -Module $ModuleName

        }
        else {
            $status = "Getting commands from all available modules."

            if ($exclude) {
                $status += " Excluding these modules: $($exclude -join ',') "
                #define a separate filter because this causes a problem in PowerShell v6 if $exclude is not specified
                $filter = {$_.Source -AND $_.source -notmatch $($exclude -join '|')}
            }
            else {
                $filter = {$_.Source}
            }
            Write-Verbose $status
            Write-Progress -Activity $myinvocation.MyCommand -Status $status -CurrentOperation "Please wait..."
            #get cmdlets and function that have a defined source which should be a module or snapin
            $global:CommandCache = (Get-command -CommandType Cmdlet, Function).Where($filter)
        }
        Write-Progress -Activity  $myinvocation.MyCommand -Completed
        Write-Verbose "Added $(($global:commandCache).count) commands to the command cache"
        if ((($global:commandCache).count) -eq 0) {
            Write-Warning "Failed to find commands in any matching modules."
            #bail out
            Return
        }
    }
    else {
        Write-Verbose "Continuing the quiz"
        Write-Verbose "Current question count: $($global:QuestionCount)"
        Write-Verbose "Current correct count: $($global:CorrectCount)"
        Write-Verbose "Current command cache: $(($global:commandCache).count)"
    }

    #select a random command with a legitimate synopsis
    Write-Verbose "Selecting a random command"
    do {
        $cmd = $global:CommandCache | Get-Random
        $synopsis = ($cmd | Get-Help).synopsis

    } until ($synopsis -notmatch "(This cmdlet is not supported)|\[|(Fill in the Synopsis)" -AND $synopsis -match "\w{4,}")

    #get other noun related commands
    [object[]]$commands = @($cmd)
    $commands += get-command -noun $cmd.noun | Where-Object {$_.name -ne $cmd.name} | Select-Object -first 4

    #get additional random commands if there are not enough noun-related
    if ($commands.count -lt 5) {
        Write-Verbose "Getting supplemental commands for answers"
        While ($commands.count -lt 5) {
            $add = Get-command -CommandType Cmdlet | Get-Random |
                Where-Object {$commands.name -notcontains $_.name}
            $commands += $add
        }
    }
    #randomize
    $commands = $commands | get-random -count $commands.count

    $Title = "PowerShell Pop Quiz"
    $Cue = @"

Given this short cmdlet description:

 $synopsis

 What command would you use?


"@

    for ($i = 1; $i -lt $commands.count + 1; $i++) {

        $Cue += "  [$i]`t$($commands[$i-1].Name)`n"
    }

    Write-host $Title -ForegroundColor Cyan
    Write-Host $Cue -ForegroundColor Yellow
    If ($Path) {
        Add-Content -Value $cue -Path $Path
    }

    Do {
        try {
            [validaterange(1, 5)][int32]$r = Read-Host -prompt "Select a menu choice [1-5]" -erroraction stop
            write-verbose "You entered $r"
        }
        Catch {
            #ignore the error
            write-warning $_.exception.message
            $r = 0
        }
    } Until ($r -ge 1 -AND $r -le 5)

    #increment the question counter
    $global:QuestionCount++
    if ($commands[$r - 1].name -eq $cmd.Name) {
        $global:CorrectCount++
        Write-Host "`nYou are Correct!!" -foregroundcolor green
        If ($Path) {
            Add-Content -Value "$($cmd.name) is correct!" -Path $Path
        }
    }
    else {
        $msg = "`nThe correct answer is $($cmd.name)"
        Write-Host $msg -foregroundcolor Red
        if ($Path) {
            Add-Content -value $msg -Path $Path
        }
    }

    [string]$s = Read-Host "`nDo you want another question? Press any key to continue or Q to quit"
    if ($s -match "^q") {

        $score = Get-GPA -Correct $global:CorrectCount -Possible $global:QuestionCount
        $result = "`nYou scored {0} correct out of {1} for a GPA of {2}. Your grade is {3}." -f $global:CorrectCount, $global:QuestionCount, $score.gpa, $score.Grade
        #colorize output based on gpa
        if ($score.Grade -match "A") {
            $fg = "green"
        }
        elseif ($score.grade -match "B|C") {
            $fg = "yellow"
        }
        else {
            $fg = "red"
        }
        Write-Host $result -ForegroundColor $fg
        if ($path) {
            Add-Content -value $result -path $Path
            Add-Content -value "`nEnding PowerShell Quiz $(Get-Date)" -path $Path
            Write-Host "`nSee $path for a transcript of this quiz." -ForegroundColor Green
        }
        Remove-Variable CorrectCount, QuestionCount, CommandCache -Scope global
    }
    else {
        if (-Not ($psboundParameters.containsKey("NextQuestion"))) {
            Write-Verbose "Flagging for next question"
            $psboundparameters.add("NextQuestion", $True)
        }
        Write-Verbose "Invoking quiz"
        #Write-verbose ($myinvocation.mycommand | out-string)
        &$($myinvocation.mycommand) @PSBoundParameters

    }


}

Function New-PSQuizFile {
    #create a new quiz json file
    write-host "In development" -ForegroundColor red
}

Function Add-PSQuizQuestion {
    #add PSQuizQuestion to a quiz json file
    write-host "In development" -ForegroundColor red
}