#load a quiz from a json file
Function Invoke-PSQuiz {
    [CmdletBinding(DefaultParameterSetName = 'path')]
    [OutputType('pzQuizResult')]
    [alias('Start-PSQuiz')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the full path to the quiz file',
            ParameterSetName = 'path'
        )]
        [ValidateScript({ Test-Path $_ })]
        [String]$Path,

        [Parameter(
            ParameterSetName = 'name',
            HelpMessage = 'Specify the quiz name.'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if (Get-PSQuiz -Name $_) {
                $True
            }
            else {
                Write-Warning "Can't find a quiz with the name in $PSQuizPath."
                $False
            }
        })]
        [String]$Name
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting path to $Name quiz"
            $Path = (Get-PSQuiz -Name $Name).path
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Loading test from $Path"
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS]  Test Details:"
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

        #capture the quiz start time
        $StartTime = Get-Date

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

        #capture the stop time
        $StopTime = Get-Date
        #This is the output from this function
        [PSCustomObject]@{
            PSTypeName     = 'psQuizResult'
            Test           = $in.metadata.Name
            TestVersion    = $in.metadata.version -as [Version]
            TotalQuestions = $QuestionCount
            TotalCorrect   = $CorrectCount
            Date           = (Get-Date)
            TestTime       = New-TimeSpan -Start $StartTime -End $StopTime
            Path           = Convert-Path $Path
        }
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

}
