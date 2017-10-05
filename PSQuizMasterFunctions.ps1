#requires -version 5.0

#commands for the PSQuizMaster module

#this function will write True or False to the pipeline
#all other messaging is display in the host
Function Invoke-QuizQuestion {
    [cmdletbinding()]
    Param(
        [Parameter(mandatory,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Question,
        [Parameter(mandatory,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Answer,
        [Parameter(mandatory,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Distractors,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Note,
        [string]$Title = "PowerShell Quiz"   
    )

    Begin {
     Write-verbose "Starting $($myinvocation.mycommand)"
    }

    Process {
    Write-debug $Question

    Write-debug "Detected $($distractors.count) distractors"
    $possible = @($Answer,$Distractors) | Get-random -count ($Distractors.count+1)

    $cue = @"

$Question
$('-'*75)

"@

for ($i=1;$i -lt $possible.count+1;$i++) {
    $cue+="[$i]  $($possible[$i-1])`n"
}

$cue+="[$i]  Quit`n"
$cue+=$('-'*75)
Write-Host $Title -ForegroundColor Cyan
write-host ("Question {0}/{1}" -f $questioncount,$allcount) -ForegroundColor green
Write-Host $cue 

$count = $Distractors.count+1
Write-verbose "$count answers"
Do {
    try {
        [ValidateScript({$_ -ge 1 -AND $_ -le $count+1})][int32]$r = Read-Host -prompt "Select a menu choice [1-5]" -erroraction stop
        write-verbose "You entered $r"
    }
    Catch {
        #ignore the error
        #write-warning $_.exception.message
        Write-Warning "Please select a value between 1 and $($count+1)"
        $r = 0
    }
} Until ($r -gt 0)

if ($possible[$r-1] -eq $answer) {
    Write-Host "Correct!" -ForegroundColor green
    $True
}
elseif ($r -eq $count+1) {
 write-verbose "You selected Quit"
 return -1
}
else {
    Write-Host "The correct answer is: $answer" -ForegroundColor magenta
    $false
}

if ($Note) {
    write-Host "`nAdditional Notes" -ForegroundColor yellow
    Write-host "----------------" -ForegroundColor yellow
    Write-Host $Note -ForegroundColor Yellow
    Write-Host "`n"
}
    } #process
    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }

} #close function

Function Get-PSQuiz {
    [cmdletbinding()]
    Param()
    Write-Verbose "Starting $($myinvocation.MyCommand)"
    write-host "Under development"


    Write-Verbose "Ending $($myinvocation.MyCommand)"
}

Function Invoke-PSQuiz {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0,Mandatory)]
        [ValidateScript({Test-Path $_})]
        [string]$Path
    )

    Write-Verbose "Starting $($myinvocation.MyCommand)"
    Write-Verbose "Loading test from $Path"
    Write-Verbose "Test Details:"
    $test = Get-Content -Path $path | ConvertFrom-Json
    Write-Verbose "`n$(($test.metadata | Out-string).Trim())"

    $in = Get-Content -path $path | ConvertFrom-Json
    
    $title = "{0} [v{1}]" -f $in.metadata.name,$in.metadata.version
    
    $questioncount = 0
    $correctcount = 0
    #randomize the questions
    $allquestions = $in.questions | Get-Random -Count $in.questions.count
    $allcount=$allquestions.count
    foreach ($question in $allquestions) {
        Clear-Host
        $questioncount++
        $answer = $question | Invoke-QuizQuestion -title $title 
        write-verbose "Answer=$answer"
        if ($answer -eq -1) {
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
        Test = $in.metadata.Name
        TotalQuestions = $questioncount
        TotalCorrect = $correctcount
        Date = (Get-Date)
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
PS C:\> c:\scripts\PSQuiz.ps1

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
PS C:\> c:\scripts\PSQuiz.ps1 -module Hyper-V

Launch the quiz but only use commands from the Hyper-V module.

.Example
PS C:\> c:\scripts\PSQuiz.ps1 -exclude ISE,WPK,my*

Launch the quiz using all modules except ISE, WPK and any modules that start with 'my'.

.Example
PS C:\> c:\scripts\PSQuiz.ps1 -exclude ISE,WPK,my* -path c:\work\quiz.txt

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
    #Enter a path for a transcript file of your quiz.
    [string]$Path
)

#a nested function to provide GPA score
Function Get-GPA {
    [cmdletbinding()]
    Param([int32]$Correct,[int32]$Possible)
    
    $grades = [ordered]@{
    'A' = 4
    'A-' = 3.7
    'B+' = 3.3
    'B' = 3
    'B-' = 2.7
    'C+' = 2.3
    'C' = 2.0
    'C-' = 1.7
    'D+' = 1.3
    'D' = 1
    'D-' = .7
    'F' = 0
    }
    
    $pct = ($Correct/$Possible)*100
    $gpa = [math]::round(($pct/20),1)
    $grade = $grades.GetEnumerator() | where {$_.value -le $gpa}  | select -first 1
    
    [pscustomobject]@{
    Grade = $grade.name
    Minimum = $grade.Value
    GPA = $GPA
    }
} #end function

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
        $global:CommandCache = Get-command -CommandType Cmdlet,Function -Module $ModuleName   
        
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
        $global:CommandCache = (Get-command -CommandType Cmdlet,Function).Where($filter)
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
    $result = "`nYou scored {0} correct out of {1} for a GPA of {2}. Your grade is {3}." -f $global:CorrectCount,$global:QuestionCount,$score.gpa,$score.Grade
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
    Remove-Variable CorrectCount, QuestionCount,CommandCache -Scope global
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