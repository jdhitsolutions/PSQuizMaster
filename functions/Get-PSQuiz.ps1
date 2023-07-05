Function Get-PSQuiz {
    #list PSQuiz json files
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, HelpMessage = 'Specify a quiz name')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(HelpMessage = 'Enter the path to the folder with quiz json files')]
        [String]$Path = $PSQuizPath
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    if ($Name) {
        Write-Verbose "Searching for quiz '$Name' under $PSQuizPath"
    }
    else {
        Write-Verbose "Searching for all quizzes under $PSQuizPath"
    }

    $get = Get-ChildItem -Path $Path -Filter '*.quiz.json' -PipelineVariable pv | ForEach-Object {
        $json = Get-Content -Path $_.FullName | ConvertFrom-Json
        $json.metadata | Select-Object -Property @{Name = 'Name'; Expression = { $_.name } },
        @{Name = 'Author'; Expression = { $_.author } },
        @{Name = 'Version'; Expression = { $_.version } },
        @{Name = 'Description'; Expression = { $_.description } },
        @{Name = 'Questions'; Expression = { $json.questions.count } },
        @{Name = 'Updated'; Expression = { $_.updated -as [DateTime] } },
        @{Name = 'Path'; Expression = { $pv.FullName } }
    } #foreach-object

    Write-Verbose "Found $($get.count) total quizzes"
    if ($Name) {
        $get | Where-Object { $_.Name -match $Name }
    }
    else {
        $get
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
