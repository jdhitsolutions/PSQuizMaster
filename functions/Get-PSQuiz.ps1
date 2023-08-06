Function Get-PSQuiz {
    #list PSQuiz json files
    [CmdletBinding()]
    [OutputType('psQuiz')]
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

    $get = Get-ChildItem -Path $Path -Filter '*.quiz.json' -PipelineVariable pv |
    ForEach-Object {
        $json = Get-Content -Path $_.FullName | ConvertFrom-Json
        #create a typed custom object for the format file
        [PSCustomObject]@{
            PSTypeName  = 'psQuiz'
            Name        = $json.metadata.name
            Author      = $json.metadata.author
            Version     = $json.metadata.version
            Description = $json.metadata.description
            Questions   = $json.questions.count
            Updated     = $json.metadata.updated -as [DateTime]
            Path        = $pv.FullName
        }
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
