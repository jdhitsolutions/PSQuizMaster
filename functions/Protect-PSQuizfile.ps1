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
        [ValidateScript({Test-Path -path $_},ErrorMessage = "Failed to find or validate {0}.")]
        [String]$Path
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Protecting answers in $Path"
        $quiz = Get-Content -path $Path | ConvertFrom-Json

        #update schema to version 2
        if ($quiz.'$schema' -NotMatch "v2") {
             Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating the schema to version 2"
            $quiz.'$schema' = $PSQuizSchema
        }

        foreach ($question in $quiz.questions) {
            #only hide answer if not already hidden
            if ($question.answer -notMatch "^(\d{3})+") {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Masking answer: $($question.answer)"
                $question.answer = _hideAnswer $question.Answer
                #19 June 2026 hide the note
                $question.note = _hideAnswer $question.note
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

        #29 June 2026 update the quiz metadata
        $quiz.metadata | Add-Member -MemberType NoteProperty -Name protected -Value $True -Force
        $quiz | ConvertTo-Json -Depth 5 | Out-File -FilePath $Path -Encoding UTF8 -Force
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] You might want to update the quiz version"
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Protect-PSQuizFile