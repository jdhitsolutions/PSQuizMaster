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

#add a VSCode menu item to insert the UTC date time into a quiz file
If ($host.Name -eq 'Visual Studio Code Host') {
    $sb = {
        $utc = "{0:u}" -f (Get-Date).ToUniversalTime()
        $Context = $psEditor.GetEditorContext()
        $context.CurrentFile.InsertText($utc)
    }
    Register-EditorCommand -Name QuizDate -DisplayName "Insert PSQuiz date" -ScriptBlock $sb
}
elseif ($host.name -eq 'Windows PowerShell ISE Host') {
    #add an ISE menu shortcut
    $sb = {
        $utc = "{0:u}" -f (Get-Date).ToUniversalTime()
        $psise.CurrentFile.Editor.InsertText($utc)
        }

        [void]$psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Insert Quiz UTC Date",$sb,$null)
}

Export-ModuleMember -Variable PSQuizPath -Alias "Start-PSQuiz","Make-PSQuiz"