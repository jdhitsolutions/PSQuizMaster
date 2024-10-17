Function Protect-PSQuizFile {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the path of the quiz json file.'
        )]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter({
            (Get-ChildItem -path $PSQuizPath -Filter *.json).fullName
        })]
        [ValidateScript( {
            if (Test-Path -Path $_) {
                return $True
            }
            else {
                Throw "Can't verify $_ as a valid path."
                Return $false
            }
        })]
        [String]$Path
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Protecting answers in $Path"
        $quiz = Get-Content -path $Path | ConvertFrom-Json
        foreach ($question in $quiz.questions) {
            #only hide answer if not already hidden
            if ($question.answer -notMatch "^(\d{3})+") {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Masking answer: $($question.answer)"
                $question.answer = _hideAnswer $question.Answer
            }
            #17 Oct 2024 mask distractors
            $maskedDistractors = @()
            foreach ($distractor in $question.distractors) {
                if ($distractor -notMatch "^(\d{3})+") {
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Masking distractor: $($distractor)"
                    $maskedDistractors += _hideAnswer $distractor
                }
            } #foreach distractor
            #replace distractors with masked values
            $question.distractors = $maskedDistractors
        } #foreach question
        $quiz | ConvertTo-Json -Depth 5 | Out-File -FilePath $Path -Encoding Unicode -Force
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Protect-PSQuizFile