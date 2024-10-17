---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/3OqhUKx
schema: 2.0.0
---

# Invoke-PSQuiz

## SYNOPSIS

Start a PowerShell quiz

## SYNTAX

### path (Default)

```yaml
Invoke-PSQuiz [-Path] <String> [<CommonParameters>]
```

### name

```yaml
Invoke-PSQuiz [-Name <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to start a quiz. You can specify the path to the quiz file or use the name of a quiz that is in the $PSQuizPath location.

## EXAMPLES

### Example 1

```powershell
PS C:\> Invoke-PSQuiz -Path C:\work\quizzes\Aliases.quiz.json
PowerShell Aliases [v0.2.0]
Question 1/2

What command will display currently defined PowerShell aliases?
---------------------------------------------------------------------------
[1]  Show-Alias
[2]  Get-AliasDefinition
[3]  $PSAlias
[4]  Get-Alias
[5]  Find-PSAlias
[6]  Quit
---------------------------------------------------------------------------
Select a menu choice [1-5]:
```

The command will auto-complete quiz files found in $PSQuizPath.

### Example 2

```powershell
PS C:\> Get-PSQuiz *remoting*  | Start-PSQuiz
```

Get a quiz using a wildcard pattern and pipe it to Invoke-PSQuiz, using its alias Start-PQuiz, to begin the quiz.

## PARAMETERS

### -Path

Enter the full path to the quiz file. The command will auto-complete quiz files found in $PSQuizPath.

```yaml
Type: String
Parameter Sets: path
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specify the quiz name.

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### pzQuizResult

## NOTES

This command has an alias of Start-PSQuiz.

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Invoke-PSQuickQuiz](Invoke-PSQuickQuiz.md)

[Get-PSQuiz](Get-PSQuiz.md)
