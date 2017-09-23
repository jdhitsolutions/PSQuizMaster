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
    #if ($Distractors -match "#") {
    #    [string[]]$Distractors = $Distractors -split "#"
    #}
    Write-debug "Detected $($distractors.count) distractors"
    $possible = @($Answer,$Distractors) | Get-random -count ($Distractors.count+1)

    $cue = @"

$Question
$('-'*75)

"@

for ($i=1;$i -lt $possible.count+1;$i++) {
    $cue+="[$i]  $($possible[$i-1])`n"
}

$cue+=$('-'*75)
Write-Host $Title -ForegroundColor Cyan
Write-Host $cue 

$count = $Distractors.count+1
Write-verbose "$count answers"
Do {
    try {
        [ValidateScript({$_ -ge 1 -AND $_ -le $count})][int32]$r = Read-Host -prompt "Select a menu choice [1-5]" -erroraction stop
        write-verbose "You entered $r"
    }
    Catch {
        #ignore the error
        #write-warning $_.exception.message
        Write-Warning "Please select a value between 1 and $count"
        $r = 0
    }
} Until ($r -gt 0)

if ($possible[$r-1] -eq $answer) {
    Write-Host "Correct!" -ForegroundColor green
    $True
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
    foreach ($question in $in.questions) {
        Clear-Host
        $questioncount++
        $answer = $question | Invoke-QuizQuestion -title $title 
        if ($answer) {
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