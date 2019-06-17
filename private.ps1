#private functions for this module

Function Invoke-QuizQuestion {

    [cmdletbinding()]
    Param(
        [Parameter(mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Question,
        [Parameter(mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Answer,
        [Parameter(mandatory, ValueFromPipelineByPropertyName)]
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
        Write-Verbose $Question

        Write-Verbose "Detected $($distractors.count) distractors"
        $possible = @($Answer, $Distractors) | Get-random -count ($Distractors.count + 1)

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
        write-host ("Question {0}/{1}" -f $questioncount, $allcount) -ForegroundColor green
        Write-Host $cue

        $count = $Distractors.count + 1
        Write-verbose "$count answers"
        Do {
            try {
                [ValidateScript( {$_ -ge 1 -AND $_ -le $count + 1})][int32]$r = Read-Host -prompt "Select a menu choice [1-5]" -erroraction stop
                write-verbose "You entered $r"
            }
            Catch {
                #ignore the error
                #write-warning $_.exception.message
                Write-Warning "Please select a value between 1 and $($count+1)"
                $r = 0
            }
        } Until ($r -gt 0)

        if ($possible[$r - 1] -eq $answer) {
            Write-Host "Correct!" -ForegroundColor green
            $True
        }
        elseif ($r -eq $count + 1) {
            write-verbose "You selected Quit"
            return -1
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

Function Get-GPA {
        [cmdletbinding()]
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
        $grade = $grades.GetEnumerator() | where {$_.value -le $gpa}  | select -first 1

        [pscustomobject]@{
            Grade   = $grade.name
            Minimum = $grade.Value
            GPA     = $GPA
        }
    } #end function