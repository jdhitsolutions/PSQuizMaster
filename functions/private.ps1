#private functions for this module

function Invoke-QuizQuestion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Question,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Answer,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Distractors,
        [Parameter(ValueFromPipelineByPropertyName)]
        [String]$Note,
        [String]$Title = 'PowerShell Quiz',
        [string]$Version,
        [switch]$Protected
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {
        Write-Verbose $Question

        #Modified 8/15/2023 to allow for a masked answer. Issue #3
        # 29 June 2026 get protection settings from metadata
        if ($Protected -And ($answer -match '^[\s\d+]+$')) {
                Write-Verbose 'Unmasking Answer'
                $answer = _showAnswer -ProtectedAnswer $answer
        }
        If ($Protected -AND (($note -match '^[\s\d+]+$') )) {
            #19 June 2026 Unmask Notes
                Write-Verbose 'Unmasking note'
                $note = _showAnswer -ProtectedAnswer $note
            #}
        } #unmask

        Write-Verbose "Detected $($distractors.count) distractors"
        #17 Oct 2024 unmask distractors if protected
        $Distractors = foreach ($distractor in $Distractors) {
            If ($protected -AND ($distractor -match '^[\s\d+]+$')) {
                Write-Verbose "Unmasking distractor: $distractor"
                _showAnswer -ProtectedAnswer $distractor
            }
            else {
                $distractor
            }
        }
        $possible = @($Answer, $Distractors) | Get-Random -Count ($Distractors.count + 1)

        $cue = @"

$Question

$(Write-SpectreRule -Width 75 -LineColor $psQuizTheme.BorderColor)
"@
#$('-'*75)

        for ($i = 1; $i -lt $possible.count + 1; $i++) {
            $cue += "[[$i]]  $($possible[$i-1])`n"
        }

        $cue += "[[$i]]  Quit`n"
     #   $cue += $(Write-SpectreRule -Width 75 -LineColor PaleGreen1)
        #$('-' * 75)
      #  Write-SpectreHost ("[{0}]$Title[/]" -f $psQuizTheme.Title)
        Write-SpectreHost ('[{0}]Question {1}/{2}[/]' -f $psQuizTheme.Question,$QuestionCount, $AllCount)
        Write-SpectreHost $cue
        Write-SpectreRule -Width 75 -LineColor $psQuizTheme.BorderColor

        $count = $Distractors.count + 1
        Write-Verbose "$count answers"
        do {
            try {
                #[ValidateScript( { $_ -ge 1 -and $_ -le $count + 1 })][int32]$r = Read-Host -Prompt "Select an answer [1-$($count+1)]" -ErrorAction stop
                [ValidateScript( { $_ -ge 1 -and $_ -le $count + 1 })][int32]$r = Read-SpectreText -Message "[italic]Select an answer[/] [[1-$($count+1)]]" -ErrorAction stop
                Write-Verbose "You entered $r"
            }
            catch {
                #ignore the error
                #Write-Warning $_.exception.message
                Write-Warning "Please select a value between 1 and $($count+1)"
                $r = 0
            }
        } until ($r -gt 0)

        if ($possible[$r - 1] -eq $answer) {
            Write-SpectreHost ("[{0}]Correct![/]`n" -f $psQuizTheme.correct)
            $True
        }
        elseif ($r -eq $count + 1) {
            Write-Verbose 'You selected Quit'
            return -1
        }
        else {
            Write-SpectreHost ("[{0}]`nThe correct answer is:[/] $answer`n" -f $psQuizTheme.Incorrect)
            $false
        }

        if ($Note) {
            Write-SpectreHost ("`n[{0}]Additional Notes[/]" -f $psQuizTheme.Note)
            #Write-Host '----------------' -ForegroundColor yellow
            #Write-Host $Note -ForegroundColor Yellow
            Write-SpectreHost $Note
            Write-SpectreHost "`n"
        }
    } #process
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }

} #close function

function Get-GPA {
    [CmdletBinding()]
    param([int32]$Correct, [int32]$Possible)

    $grades = [ordered]@{
        'A'  = 4
        'A-' = 3.7
        'B+' = 3.3
        'B'  = 3
        'B-' = 2.7
        'C+' = 2.3
        'C'  = 2.0
        'C-' = 1.7
        'D+' = 1.3
        'D'  = 1
        'D-' = .7
        'F'  = 0
    }

    #2 July 2026 Allow for the user to quit before answering any questions
    if ($Possible -gt 0) {
        $pct = ($Correct / $Possible) * 100
        $gpa = [math]::round(($pct / 20), 1)
        $grade = $grades.GetEnumerator() | Where-Object { $_.value -le $gpa } | Select-Object -First 1

        [PSCustomObject]@{
            Grade   = $grade.name
            Minimum = $grade.Value
            GPA     = $GPA
        }
    }
} #end Get-GPA


#functions to obfuscate the answer

<#
[regex]$word = "\b\S+\b"
$message = "I am foo"
$test = foreach ($part in $message) {
 $word.Matches($part).Value.ForEach({
    $_.toCharArray().Foreach({ "{0:d3}" -f ($_ -as [int])}) -join ''
 }) -join ' '
}


[regex]$number = "\d{3}"
$out = foreach ($part in $test.split()) {
#write-host $part -fore cyan
  $number.Matches($part).Value.ForEach({
   ([int]$_ -as [string][char])
  })  -join ''
}
$out -join ' '

#>

function _hideAnswer {
    param([string]$Answer)
    [regex]$word = '\S+'
    foreach ($part in $Answer) {
        $word.Matches($part).Value.ForEach({
                $_.toCharArray().Foreach({ '{0:d3}' -f ($_ -as [int]) }) -join ''
            }) -join ' '
    }
}

function _showAnswer {
    param([string]$ProtectedAnswer)
    [regex]$number = '\d{3}'
    $out = foreach ($part in $ProtectedAnswer.split()) {
        $number.Matches($part).Value.ForEach({
                ([int]$_ -as [string][char])
            }) -join ''
    }
    $out -join ' '
}

function _GetSelected {
    $Context = $psEditor.GetEditorContext()
    $selected = [Microsoft.PowerShell.EditorServices.Extensions.FileRange, Microsoft.PowerShell.EditorServices]::new($Context.SelectedRange.Start, $Context.SelectedRange.end)
    [string]$text = $Context.CurrentFile.GetText($selected)
    [PSCustomObject]@{
        File         = $Context.CurrentFile.Path
        SelectedText = $text
        Start        = $Selected.Start
        End          = $selected.end
        Context      = $Context
    }
}