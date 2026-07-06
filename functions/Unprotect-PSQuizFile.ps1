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
        [ValidateScript({Test-Path -path $_},ErrorMessage = "Failed to find or validate {0}.")]
        [String]$Path
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Unmasking answers in $Path"
        $quiz = Get-Content -Path $Path | ConvertFrom-Json

        #update schema to version 2
        if ($quiz.'$schema' -NotMatch "v2") {
             Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating the schema to version 2"
            $quiz.'$schema' = $PSQuizSchema
        }

        foreach ($question in $quiz.questions) {
            if ($question.answer -Match '^(\d{3})+') {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] From: $($question.answer)"
                $question.answer = _showAnswer $question.Answer
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] To: $($question.answer)"
                #19 June 2026 unmask notes
                if ($question.note -Match '^(\d{3})+') {
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] From masked note: $($question.note)"
                    $question.note = _showAnswer $question.note
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] To: $($question.note)"
                }
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
            If ($unmaskedDistractors) {
                $question.distractors = $unmaskedDistractors
            }
        } #foreach Question

        #29 June 2026 update the quiz metadata
        $quiz.metadata | Add-Member -MemberType NoteProperty -Name protected -Value $false -Force
        $quiz | ConvertTo-Json -Depth 5 | Out-File -FilePath $Path -Encoding UTF8 -Force
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] You might want to update the quiz version"
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Protect-PSQuizFile