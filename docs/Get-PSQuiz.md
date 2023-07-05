---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version:
schema: 2.0.0
---

# Get-PSQuiz

## SYNOPSIS

Get quizzes from the default quiz path.

## SYNTAX

```yaml
Get-PSQuiz [[-Name] <String>] [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to find quiz files. The default is to search for all quiz files in the $PSQuizPath variable, although you can specify a different path. The quiz file must follow the naming convention of <shortname>.quiz.json.

## EXAMPLES

### Example 1

```powershell
PS C:\>  Get-PSQuiz

Name        : PowerShell Aliases
Author      : Jeff Hicks
Version     : 0.2.0
Description : A short quiz on using aliases in PowerShell.
Questions   : 2
Updated     : 06/27/2023 18:26:48
Path        : C:\Scripts\PSQuizMaster\quizzes\Aliases.quiz.json

Name        : PowerShell Remoting
Author      : Jeff Hicks
Version     : 0.1.0
Description : A short quiz on PowerShell remoting concepts.
Questions   : 2
Updated     : 06/29/2023 10:21:21
Path        : C:\Scripts\PSQuizMaster\quizzes\remoting.quiz.json
```

### Example 2

```powershell
PS C:\> Get-PSQuiz -Name "Powershell remoting"

Name        : PowerShell Remoting
Author      : Jeff Hicks
Version     : 0.1.0
Description : A short quiz on PowerShell remoting concepts.
Questions   : 2
Updated     : 06/29/2023 10:21:21
Path        : C:\Scripts\PSQuizMaster\quizzes\remoting.quiz.json
```

## PARAMETERS

### -Name

Specify a quiz name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Enter the path to the folder with quiz json files. The quiz files must follow the naming convention of <shortname>.quiz.json.

```yaml
Type: String
Parameter Sets: (All)
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

### System.Object

## NOTES

## RELATED LINKS

[Invoke-PSQuiz](Invoke-PSQuiz.md)
