#load functions

#1 July 2026 Defining the PSQuizTheme as a custom object
class PSQuizTheme {
    $Title = 'PaleTurquoise1 bold'
    $Question = 'SeaGreen2'
    $Correct = 'Chartreuse1'
    $Incorrect = 'DeepPink2'
    $BorderColor = 'PaleGreen1'
    $Note = 'LightGoldenrod2_2 Underline'
    $DefaultLogo

    <#
        I am cheating here because Write-SpectreHost doesn't
        write to the pipeline, but a return type of [Void] might
        be misleading. This is also easier and faster than creating
        a custom format file to convert the SpectreConsole colors
        into ANSI and then display them.
    #>

    [string]Show() {
        Write-Host "`r"
        $This.PSObject.Properties.Where({$_.name -notMatch "logo"}).foreach({
            $setting = "{0} [{1}]{1}[/]" -f $_.name.PadRight(12), $_.Value
            Write-SpectreHost $setting
        })
        Return ""
    }
}

$FunFolder = Join-Path -Path $PSScriptRoot -ChildPath functions

Get-ChildItem -Path $FunFolder -Filter *.ps1 |
ForEach-Object { . $_.FullName }

#this is a private variable not exposed to the user
$PSQuizSettingsFile = Join-Path -Path $HOME -ChildPath '.psquizsettings.json'

#3 July 2026 Added support for a logo image
$defaultLogo = "$PSScriptRoot\assets\MsPowerShell.jpg"

if (Test-Path -Path $PSQuizSettingsFile) {
    #if the settings file is found, use it to define $PSQuizSettingsFile
    $PSQuizSettings = Get-Content -Path $PSQuizSettingsFile | ConvertFrom-Json
    Set-Variable -Name PSQuizPath -Value $PSQuizSettings.PSQuizPath -Scope Global
    if ($PSQuizSettings.psQuizTheme) {
        #write-host "Using saved quiz theme"
        Set-Variable -Name psQuizTheme -Value ([PSQuizTheme]::new()) -Scope Global
        $global:PSQuizTheme.Title = $PSQuizSettings.psQuizTheme.Title
        $global:PSQuizTheme.Question = $PSQuizSettings.psQuizTheme.Question
        $global:PSQuizTheme.Correct = $PSQuizSettings.psQuizTheme.Correct
        $global:PSQuizTheme.Incorrect = $PSQuizSettings.psQuizTheme.Incorrect
        $global:psQuizTheme.BorderColor = $PSQuizSettings.psQuizTheme.BorderColor
        $global:PSQuizTheme.Note = $PSQuizSettings.psQuizTheme.Note
        $global:psQuizTheme.DefaultLogo = $PSQuizSettings.psQuizTheme.DefaultLogo
    } else {
        #use default values
        #write-host "Creating default quiz theme"
        $global:PSQuizTheme = [PSQuizTheme]::new()
        $global:psQuizTheme.DefaultLogo = $defaultLogo
    }
}
else {
    #write-host "no saved quiz settings found"
    #otherwise set $PSQuizSettingsFile to the module's Quizzes folder
    Set-Variable -Name PSQuizPath -Value (Join-Path -Path $PSScriptRoot -ChildPath 'quizzes') -Scope Global

    #27 June 2026 Support SpectreConsole theming for the quiz
    #use default values
    $global:PSQuizTheme = [PSQuizTheme]::new()
    $global:psQuizTheme.DefaultLogo = $defaultLogo
}

#Path to the JSON schema file
#this is an internal variable
$PSQuizSchema = "https://raw.githubusercontent.com/jdhitsolutions/PSQuizMaster/main/psquiz.schema-v2.json"

#v1 schema
#'https://raw.githubusercontent.com/jdhitsolutions/PSQuizMaster/main/psquiz.schema.json'
#for local testing
# $PSQuizSchema = "file:///c://scripts//psquizmaster//psquiz.schema.json"

Register-ArgumentCompleter -CommandName Invoke-PSQuiz -ParameterName Path -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #PowerShell code to populate $WordToComplete
    Get-ChildItem -Path $PSQuizPath -Filter *quiz.json |
    Where-Object { $_.Name -like "$wordToComplete*" } |
    ForEach-Object {
        # completion text,listItem text,result type,Tooltip
        [System.Management.Automation.CompletionResult]::new($_.fullName, $_.name, 'ParameterValue', $_.FullName)
    }
}

#add a VSCode menu item to insert the UTC date time into a quiz file
if ($host.Name -eq 'Visual Studio Code Host') {
    $psEditor.Window.ShowInformationMessage('Loading PSQuizMaster VSCode features')
    $sb = {
        $utc = '{0:u}' -f (Get-Date).ToUniversalTime()
        $Context = $psEditor.GetEditorContext()
        $context.CurrentFile.InsertText($utc)
    }
    Register-EditorCommand -Name QuizDate -DisplayName 'Insert PSQuiz date' -ScriptBlock $sb

    <#
    In some cases, you may need to reload the window (Command Palette - Developer Reload windows).
    Especially if you are masking and unmasking the same long string in the same session.
    You will need to re-import the module after reloading the window.

    Note that if you remove the module, the underlying VSCode functions will be removed but the
    command palette menu choices will remain, but won't work. Reloading the window will reset
    the command palette.
    #>
    function global:MaskQuizItem {
        param($Context)
        function _hideAnswer {
            param([string]$Answer)
            #match on non-whitespace word
            [regex]$word = '\S+'
            foreach ($part in $Answer) {
                $word.Matches($part).Value.ForEach({
                        $_.toCharArray().Foreach({ '{0:d3}' -f ($_ -as [int]) }) -join ''
                    }) -join ' '
            }
        }

        if ($Context.CurrentFile.language -ne 'json') {
            $psEditor.Window.ShowWarningMessage('This command must be run on a PSQuiz json file')
        }
        else {
            # Write-Host "Masking selected quiz item"
            $selected = [Microsoft.PowerShell.EditorServices.Extensions.FileRange, Microsoft.PowerShell.EditorServices]::new($Context.SelectedRange.Start, $Context.SelectedRange.end)
            [string]$text = $Context.CurrentFile.GetText($selected)
            [string]$mask = _hideAnswer $text
            $context.CurrentFile.InsertText($mask)
        }
    }

    Register-EditorCommand -Name MaskQuizItem -DisplayName 'Mask Quiz Item' -Function MaskQuizItem

    function global:UnmaskQuizItem {
        param($Context)
        function _showAnswer {
            param([string]$ProtectedAnswer)
            [regex]$number = '\d{3}'
            $out = foreach ($part in $ProtectedAnswer.split()) {
                $number.Matches($part).Value.ForEach({
                        ([int]$_ -as [string][char])
                    }) -join ''
            }
            $out -join ' '
        }

        if ($Context.CurrentFile.language -ne 'json') {
            $psEditor.Window.ShowWarningMessage('This command must be run on a PSQuiz json file')
        }
        else {
            #write-Host "Unmasking selected quiz item"
            $selected = [Microsoft.PowerShell.EditorServices.Extensions.FileRange, Microsoft.PowerShell.EditorServices]::new($Context.SelectedRange.Start, $Context.SelectedRange.end)
            [string]$text = $Context.CurrentFile.GetText($selected)
            #write-host "unmasking $text [$($text.Length)]"
            [string]$plain = _showAnswer $text
            #write-host "with $plain"
            if ($plain.length -gt 0) {
                $context.CurrentFile.InsertText($plain)
            }
            else {
                $psEditor.Window.ShowWarningMessage('Failed to unmask the selected item. You might need to reload the window and re-import the module into the integrated PowerShell terminal. Command Palette - Developer: Reload Window')
            }
        }
    }

    Register-EditorCommand -Name UnmaskQuizItem -DisplayName 'Unmask Quiz Item' -Function UnmaskQuizItem

    function global:InsertQuizItem {
        param($Context)

        #insert the JSON for a new quiz item
        if ($Context.CurrentFile.language -ne 'json') {
            $psEditor.Window.ShowWarningMessage('This command must be run on a PSQuiz json file')
        }
        else {
            $template = @'
{
    "question" : "<enter your question>",
    "answer" : "<the correct answer>",
    "distractors" : [
        "<distractor #1>",
        "<distractor #2>",
        "<distractor #3>",
        "<distractor #4>"
        ],
    "note" : "<enter an optional note or delete this line>"
    }
'@

            $context.CurrentFile.InsertText($template)
        }
    }

    Register-EditorCommand -Name InsertQuizItem -DisplayName 'Insert Quiz Item' -Function InsertQuizItem
}

#add OnRemove event to clean up global variable
$onRemoveScript = {
    Remove-Variable -Name PSQuizPath -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable -Name PSQuizTheme -Scope Global -ErrorAction SilentlyContinue

    if ($host.Name -match 'code') {
        #command names are case-sensitive
        Unregister-EditorCommand -Name UnmaskQuizItem
        Unregister-EditorCommand -Name MaskQuizItem
        Unregister-EditorCommand -Name QuizDate
        Unregister-EditorCommand -Name InsertQuizItem
    }
}
$ExecutionContext.SessionState.Module.OnRemove += $OnRemoveScript
