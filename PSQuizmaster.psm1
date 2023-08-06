#load functions

$FunFolder =Join-path -path $PSScriptRoot -ChildPath functions

Get-ChildItem -Path $FunFolder -filter *.ps1 |
ForEach-Object { . $_.FullName}

#this is a private variable not exposed to the user
$PSQuizSettingsFile = Join-Path -Path $HOME -ChildPath '.psquizsettings.json'

if (Test-Path -path $PSQuizSettingsFile) {
    $PSQuizSettings = Get-Content -path $PSQuizSettingsFile | ConvertFrom-Json
    Set-Variable -name PSQuizPath -value $PSQuizSettings.PSQuizPath
}
else {
    Set-Variable -name PSQuizPath -value (Join-Path -Path $PSScriptRoot -ChildPath "quizzes")
}

#Path to the JSON schema file
#this is an internal variable
#THIS WON'T WORK WHILE THE REPO IS PRIVATE
#$PSQuizSchema = 'https://raw.githubusercontent.com/jdhitsolutions/PSQuizMaster/main/psquiz.schema.json'

$PSQuizSchema = "https://raw.githubusercontent.com/jdhitsolutions/PSQuizMaster/main/psquiz.schema.json"
#for local testing
# "file:///c://scripts//psquizmaster//psquiz.schema.json"

Register-ArgumentCompleter -CommandName Invoke-PSQuiz -ParameterName Path -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #PowerShell code to populate $WordToComplete
    Get-ChildItem -path $PSQuizPath -filter *quiz.json |
    Where-Object   { $_.Name -like "$wordToComplete*" } |
        ForEach-Object {
            # completion text,listItem text,result type,Tooltip
            [System.Management.Automation.CompletionResult]::new($_.fullName, $_.name, 'ParameterValue', $_.FullName)
        }
}

Export-ModuleMember -Variable PSQuizPath -Alias "Start-PSQuiz","Make-PSQuiz"