#load a quiz from a json file
function Invoke-PSQuiz {
    [CmdletBinding(DefaultParameterSetName = 'path')]
    [OutputType('pzQuizResult')]
    [alias('Start-PSQuiz')]
    param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the full path to the quiz file',
            ParameterSetName = 'path'
        )]
        [ValidateScript({Test-Path -path $_},ErrorMessage = "Failed to find or validate {0}.")]
        [String]$Path,

        [Parameter(
            ParameterSetName = 'name',
            HelpMessage = 'Specify the quiz name.'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Get-PSQuiz -Name $_},ErrorMessage = "Can't find a quiz called {0} in `$PSQuizPath.")]
        [String]$Name
    )
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    process {
        #6 July 2026 Do not run quiz in the VSCode Integrated console since it doesn't display images properly.
        if ($Host.Name -eq 'Visual Studio Code Host') {
            Write-Warning "Running a PSQuiz is not supported in the integrated VS Code terminal."
            return
        }
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting path to $Name quiz"
            $Path = (Get-PSQuiz -Name $Name).path
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Loading test from $Path"
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Test Details:"

        $in = Get-Content -Path $path | ConvertFrom-Json
        Write-Verbose "`n$(($in.metadata | Out-String).Trim())"
        #29 June 2026 Get protection setting from the metadata

       # $title = '{0} [[v{1}]]' -f $in.metadata.name, $in.metadata.version
       # $title = $in.metadata.name

       #align the title to the center of the image
       $logo = ($in.Logo -AND (Test-Path $in.Logo)) ? $in.Logo : $global:PSQuizTheme.defaultLogo

       $titlePad = ((Get-SpectreImage -ImagePath $logo -MaxWidth 10) | Get-SpectreRenderableSize).height/2 -1
        $title = "[{0}]{1}[/]" -f $psQuizTheme.Title,$in.metadata.name | Format-SpectrePadded -top $titlePad -Bottom 0 -Left 1 -Right 0
        $version = $in.metadata.version
        $QuestionCount = 0
        $CorrectCount = 0
        #randomize the questions
        $AllQuestions = $in.questions | Get-Random -Count $in.questions.count
        #$AllCount is used in the private Invoke-QuizQuestion function
        $AllCount = $AllQuestions.count

        #capture the quiz start time
        $StartTime = Get-Date
        foreach ($question in $AllQuestions) {
            $data = @((Get-SpectreImage -ImagePath $logo -MaxWidth 10),$title) |
            Format-SpectreColumns |
            Format-SpectrePadded -Top 1 -Left 1 -Right 0 -Bottom 1
            $width = ($data | Get-SpectreRenderableSize).Width + 5
            write-information $data
            $data | Format-SpectrePanel -Color $psQuizTheme.BorderColor -Header "v$Version" -Width $width |
            Out-SpectreHost

            $QuestionCount++
            $answer = $question | Invoke-QuizQuestion -title $title -version $version -Protected:$in.metadata.protected
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
            #Pause
            Read-SpectrePause
        }

        #capture the stop time
        $StopTime = Get-Date
        #This is the output from this function
        #19 June 2026 Update to include GPA
        [PSCustomObject]@{
            PSTypeName     = 'psQuizResult'
            Test           = $in.metadata.Name
            TestVersion    = $in.metadata.version -as [Version]
            TotalQuestions = $QuestionCount
            TotalCorrect   = $CorrectCount
            GPA            = (Get-GPA -Correct $CorrectCount -Possible $QuestionCount).Grade
            Date           = (Get-Date)
            TestTime       = New-TimeSpan -Start $StartTime -End $StopTime
            Path           = Convert-Path $Path
        }
    } #process
    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
