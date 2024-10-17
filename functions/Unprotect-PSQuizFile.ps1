Function Unprotect-PSQuizFile {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the path of the quiz json file.')]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter({
            (Get-ChildItem -Path $PSQuizPath -Filter *.json).fullName
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
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Unmasking answers in $Path"
        $quiz = Get-Content -Path $Path | ConvertFrom-Json
        foreach ($question in $quiz.questions) {
            if ($question.answer -Match '^(\d{3})+') {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] From: $($question.answer)"
                $question.answer = _showAnswer $question.Answer
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] To: $($question.answer)"
            }
            #17 Oct 2024 mask distractors
            $unmaskedDistractors = @()
            foreach ($distractor in $question.distractors) {
                if ($distractor -Match '^(\d{3})+') {
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Unmasking distractor: $($distractor)"
                    $unmaskedDistractors += _showAnswer $distractor
                }
            } #foreach distractor
            #replace distractors with masked values
            $question.distractors = $unmaskedDistractors
        } #foreach Question

        $quiz | ConvertTo-Json -Depth 5 | Out-File -FilePath $Path -Encoding Unicode -Force
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Protect-PSQuizFile