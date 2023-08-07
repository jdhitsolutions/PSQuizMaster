#private functions for this module

Function Invoke-QuizQuestion {
    [CmdletBinding()]
    Param(
        [Parameter(mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Question,
        [Parameter(mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String]$Answer,
        [Parameter(mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Distractors,
        [Parameter(ValueFromPipelineByPropertyName)]
        [String]$Note,
        [String]$Title = 'PowerShell Quiz'
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    Process {
        Write-Verbose $Question

        Write-Verbose "Detected $($distractors.count) distractors"
        $possible = @($Answer, $Distractors) | Get-Random -Count ($Distractors.count + 1)

        $cue = @"

$Question
$('-'*75)

"@

        for ($i = 1; $i -lt $possible.count + 1; $i++) {
            $cue += "[$i]  $($possible[$i-1])`n"
        }

        $cue += "[$i]  Quit`n"
        $cue += $('-' * 75)
        Write-Host $Title -ForegroundColor Cyan
        Write-Host ('Question {0}/{1}' -f $QuestionCount, $AllCount) -ForegroundColor green
        Write-Host $cue

        $count = $Distractors.count + 1
        Write-Verbose "$count answers"
        Do {
            try {
                [ValidateScript( { $_ -ge 1 -AND $_ -le $count + 1 })][int32]$r = Read-Host -Prompt 'Select a menu choice [1-5]' -ErrorAction stop
                Write-Verbose "You entered $r"
            }
            Catch {
                #ignore the error
                #Write-Warning $_.exception.message
                Write-Warning "Please select a value between 1 and $($count+1)"
                $r = 0
            }
        } Until ($r -gt 0)

        if ($possible[$r - 1] -eq $answer) {
            Write-Host 'Correct!' -ForegroundColor green
            $True
        }
        elseif ($r -eq $count + 1) {
            Write-Verbose 'You selected Quit'
            return -1
        }
        else {
            Write-Host "The correct answer is: $answer" -ForegroundColor magenta
            $false
        }

        if ($Note) {
            Write-Host "`nAdditional Notes" -ForegroundColor yellow
            Write-Host '----------------' -ForegroundColor yellow
            Write-Host $Note -ForegroundColor Yellow
            Write-Host "`n"
        }
    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    }

} #close function

Function Get-GPA {
    [CmdletBinding()]
    Param([int32]$Correct, [int32]$Possible)

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

    $pct = ($Correct / $Possible) * 100
    $gpa = [math]::round(($pct / 20), 1)
    $grade = $grades.GetEnumerator() | Where-Object { $_.value -le $gpa } | Select-Object -First 1

    [PSCustomObject]@{
        Grade   = $grade.name
        Minimum = $grade.Value
        GPA     = $GPA
    }
} #end function

