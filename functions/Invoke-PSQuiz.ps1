#load a quiz from a json file
Function Invoke-PSQuiz {
    [CmdletBinding()]
    [OutputType("pzQuizResult")]
    [alias("Start-PSQuiz")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = 'Enter the full path to the quiz file')]
        [ValidateScript( { Test-Path $_ })]
        [String]$Path
    )
    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose "Loading test from $Path"
    Write-Verbose 'Test Details:'
    $test = Get-Content -Path $path | ConvertFrom-Json
    Write-Verbose "`n$(($test.metadata | Out-String).Trim())"

    $in = Get-Content -Path $path | ConvertFrom-Json

    $title = '{0} [v{1}]' -f $in.metadata.name, $in.metadata.version

    $QuestionCount = 0
    $CorrectCount = 0
    #randomize the questions
    $AllQuestions = $in.questions | Get-Random -Count $in.questions.count
    #$AllCount is used in the private Invoke-QuizQuestion function
    $AllCount = $AllQuestions.count
    foreach ($question in $AllQuestions) {
        $QuestionCount++
        $answer = $question | Invoke-QuizQuestion -title $title
        Write-Verbose "Answer = $answer"
        if ($answer -is [Int]) {
            Write-Verbose 'Ending the quiz.'
            #decrease the question count since the last one didn't technically get an answer
            $QuestionCount--
            break
        }
        elseif ($answer) {
            $CorrectCount++
        }
        Pause
    }
    #This is the output from this function
    [PSCustomObject]@{
        PSTypeName     = 'psQuizResult'
        Test           = $in.metadata.Name
        TotalQuestions = $QuestionCount
        TotalCorrect   = $CorrectCount
        Date           = (Get-Date)
    }

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
