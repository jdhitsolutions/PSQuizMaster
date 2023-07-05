---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version:
schema: 2.0.0
---

# Invoke-PSQuiz

## SYNOPSIS

Start a PowerShell quiz

## SYNTAX

```yaml
Invoke-PSQuiz [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION

Use this command to start a quiz. You need to specify the path to the quiz file.

## EXAMPLES

### Example 1

```powershell
PS C:\> Invoke-PSQuiz -Path C:\Scripts\PSQuizMaster\quizzes\Aliases.quiz.json
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

## PARAMETERS

### -Path

Enter the full path to the quiz file. The command will auto-complete quiz files found in $PSQuizPath.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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

## RELATED LINKS

[Invoke-PSQuickQuiz](Invoke-PSQuickQuiz.md)

[Get-PSQuiz](Get-PSQuiz.md)
