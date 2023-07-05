Function Invoke-PSQuickQuiz {

    [CmdletBinding(DefaultParameterSetName = 'all')]
    Param(
        [Parameter(ParameterSetName = 'single')]
        [ValidateScript( { Get-Module $_ -list })]
        #You can specify a single module for testing. The default is all modules.
        [String]$ModuleName,
        [Parameter(ParameterSetName = 'all')]
        #Enter a comma separated list of module names to ignore. You can use wildcards.
        [string[]]$Exclude,
        #This is used to indicate a continuing test. You should never need to use this parameter.
        [Switch]$NextQuestion,
        [Parameter(HelpMessage = 'Enter a path and filename for a quiz transcript.')]
        [ValidateScript( {
            $parent = Split-Path $_
            if (Test-Path $parent) {
                return $True
            }
            else {
                Throw "Failed to find $parent for your transcript."
                return $false
            }
        })]
        [alias('transcript')]
        [String]$Path
    )

    If ($Path -AND (-not $NextQuestion)) {
        #first time through so initialize a new transcript file.
        $header = @"
PowerShell Quiz - $(Get-Date)
-------------------------------------
PowerShell version: $($PSVersionTable.PSVersion)
User              : $($env:USERDOMAIN)\$($env:username)
Quiz parameters   :

$(($PSBoundParameters | Out-String).trim())
-------------------------------------
"@
        #create a new transcript file
        Set-Content -Value $header -Path $Path

    }
    Clear-Host
    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose 'PSBoundParameters:'
    Write-Verbose $($PSBoundParameters | Out-String).Trim()

    if (-Not $NextQuestion) {
        Write-Verbose 'First question setup'
        #initialize some variables to keep track of correct answers
        $global:QuestionCount = 0
        $global:CorrectCount = 0
        $global:CommandCache = @()

        if ($ModuleName) {
            $Status = "Getting commands from module $modulename."
            Write-Verbose $Status
            Write-Progress -Activity $MyInvocation.MyCommand -Status $status -CurrentOperation 'Please wait...'
            $global:CommandCache = Get-Command -CommandType Cmdlet, Function -Module $ModuleName

        }
        else {
            $status = 'Getting commands from all available modules.'

            if ($exclude) {
                $status += " Excluding these modules: $($exclude -join ',') "
                #define a separate filter because this causes a problem in PowerShell v6 if $exclude is not specified
                $filter = { $_.Source -AND $_.source -notmatch $($exclude -join '|') }
            }
            else {
                $filter = { $_.Source }
            }
            Write-Verbose $status
            Write-Progress -Activity $MyInvocation.MyCommand -Status $status -CurrentOperation 'Please wait...'
            #get cmdlets and function that have a defined source which should be a module or snapin
            $global:CommandCache = (Get-Command -CommandType Cmdlet, Function).Where($filter)
        }
        Write-Progress -Activity $MyInvocation.MyCommand -Completed
        Write-Verbose "Added $(($global:commandCache).count) commands to the command cache"
        if ((($global:commandCache).count) -eq 0) {
            Write-Warning 'Failed to find commands in any matching modules.'
            #bail out
            Return
        }
    }
    else {
        Write-Verbose 'Continuing the quiz'
        Write-Verbose "Current question count: $($global:QuestionCount)"
        Write-Verbose "Current correct count: $($global:CorrectCount)"
        Write-Verbose "Current command cache: $(($global:commandCache).count)"
    }

    #select a random command with a legitimate synopsis
    Write-Verbose 'Selecting a random command'
    do {
        $cmd = $global:CommandCache | Get-Random
        $synopsis = ($cmd | Get-Help).synopsis

    } until ($synopsis -notmatch '(This cmdlet is not supported)|\[|(Fill in the Synopsis)' -AND $synopsis -match '\w{4,}')

    #get other noun related commands
    [object[]]$commands = @($cmd)
    $commands += Get-Command -Noun $cmd.noun | Where-Object { $_.name -ne $cmd.name } | Select-Object -First 4

    #get additional random commands if there are not enough noun-related
    if ($commands.count -lt 5) {
        Write-Verbose 'Getting supplemental commands for answers'
        While ($commands.count -lt 5) {
            $add = Get-Command -CommandType Cmdlet | Get-Random |
            Where-Object { $commands.name -NotContains $_.name }
            $commands += $add
        }
    }
    #randomize
    $commands = $commands | Get-Random -Count $commands.count

    $Title = 'PowerShell Pop Quiz'
    $Cue = @"

Given this short cmdlet description:

 $synopsis

 What command would you use?


"@

    for ($i = 1; $i -lt $commands.count + 1; $i++) {

        $Cue += "  [$i]`t$($commands[$i-1].Name)`n"
    }

    Write-Host $Title -ForegroundColor Cyan
    Write-Host $Cue -ForegroundColor Yellow
    If ($Path) {
        Add-Content -Value $cue -Path $Path
    }

    Do {
        try {
            [ValidateRange(1, 5)][int32]$r = Read-Host -Prompt 'Select a menu choice [1-5]' -ErrorAction stop
            Write-Verbose "You entered $r"
        }
        Catch {
            #ignore the error
            Write-Warning $_.exception.message
            $r = 0
        }
    } Until ($r -ge 1 -AND $r -le 5)

    #increment the question counter
    $global:QuestionCount++
    if ($commands[$r - 1].name -eq $cmd.Name) {
        $global:CorrectCount++
        Write-Host "`nYou are Correct!!" -ForegroundColor green
        If ($Path) {
            Add-Content -Value "$($cmd.name) is correct!" -Path $Path
        }
    }
    else {
        $msg = "`nThe correct answer is $($cmd.name)"
        Write-Host $msg -ForegroundColor Red
        if ($Path) {
            Add-Content -Value $msg -Path $Path
        }
    }

    [String]$s = Read-Host "`nDo you want another question? Press any key to continue or Q to quit"
    if ($s -match '^q') {

        $score = Get-GPA -Correct $global:CorrectCount -Possible $global:QuestionCount
        $result = "`nYou scored {0} correct out of {1} for a GPA of {2}. Your grade is {3}." -f $global:CorrectCount, $global:QuestionCount, $score.gpa, $score.Grade
        #colorize output based on gpa
        if ($score.Grade -match 'A') {
            $fg = 'green'
        }
        elseif ($score.grade -match 'B|C') {
            $fg = 'yellow'
        }
        else {
            $fg = 'red'
        }
        Write-Host $result -ForegroundColor $fg
        if ($path) {
            Add-Content -Value $result -Path $Path
            Add-Content -Value "`nEnding PowerShell Quiz $(Get-Date)" -Path $Path
            Write-Host "`nSee $path for a transcript of this quiz." -ForegroundColor Green
        }
        Remove-Variable CorrectCount, QuestionCount, CommandCache -Scope global
    }
    else {
        if (-Not ($PSBoundParameters.containsKey('NextQuestion'))) {
            Write-Verbose 'Flagging for next question'
            $PSBoundParameters.add('NextQuestion', $True)
        }
        Write-Verbose 'Invoking quiz'
        #Write-Verbose ($MyInvocation.MyCommand | Out-String)
        &$($MyInvocation.MyCommand) @PSBoundParameters
    }
}
