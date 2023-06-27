Function Get-PSQuiz {
    #list PSQuiz json files
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Enter the path to the folder with quiz json files')]
        [String]$Path = $PSQuizPath
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose "Searching for quizzes under $PSQuizPath"
    Get-ChildItem -Path $Path -Filter '*.quiz.json' -PipelineVariable pv | ForEach-Object {
        $json = Get-Content -Path $_.FullName | ConvertFrom-Json
        $json.metadata | Select-Object -Property @{Name="Name"; Expression = { $_.name }},
        @{Name='Author'; Expression = { $_.author }},
        @{Name='Version'; Expression = { $_.version }},
        @{Name='Description'; Expression = { $_.description }},
        @{Name='Questions'; Expression = { $json.questions.count }},
        @{Name='Updated'; Expression = { $_.updated -as [DateTime] }},
        @{Name = 'Path'; Expression = { $pv.FullName } }
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
