#load functions

$FunFolder =Join-path -path $PSScriptRoot -ChildPath functions
Get-ChildItem -Path $FunFolder -filter *.ps1 |
ForEach-Object { . $_.FullName}

$PSQuizPath = Join-Path -Path $PSScriptRoot -ChildPath "quizzes"

Export-ModuleMember -variable PSQuizPath