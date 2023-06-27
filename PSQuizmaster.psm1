#load functions

$FunFolder =Join-path -path $PSScriptRoot -ChildPath functions
Get-ChildItem -Path $FunFolder -filter *.ps1 |
ForEach-Object { . $_.FullName}

$PSQuizPath = Join-Path -Path $PSScriptRoot -ChildPath "quizzes"

Register-ArgumentCompleter -CommandName Invoke-PSQuiz -ParameterName Path -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #PowerShell code to populate $WordToComplete
    Get-ChildItem -path $PSQuizPath -filter *quiz.json |
    Where-Object   { $_.Name -like "$wordToComplete*" } |
        ForEach-Object {
            # completion text,listitem text,result type,Tooltip
            [System.Management.Automation.CompletionResult]::new($_.fullName, $_.name, 'ParameterValue', $_.FullName)
        }
}

Export-ModuleMember -variable PSQuizPath