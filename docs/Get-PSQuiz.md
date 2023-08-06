---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/3OnLjFd
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

   Path: C:\work\quizzes\Aliases.quiz.json [7/7/2023 6:28:58 PM]

Name                Version    Description                            Questions
----                -------    -----------                            ---------
PowerShell Aliases  0.6.0      A short quiz on using aliases ....             3

   Path: C:\work\quizzes\demo.quiz.json [6/29/2023 9:15:26 AM]

Name                Version    Description                            Questions
----                -------    -----------                            ---------
My Demo Quiz        0.3.0      This is a demo quiz file                       7

   Path: C:\work\quizzes\pshelp.quiz.json [7/7/2023 6:29:22 PM]

Name                Version    Description                            Questions
----                -------    -----------                           ---------
PowerShell Help     0.2.1      How to use help                                2

   Path: C:\work\quizzes\remoting.quiz.json [7/5/2023 11:36:18 AM]

Name                Version    Description                            Questions
----                -------    -----------                            ---------
PowerShell Remoting 0.2.1      A short quiz on PowerShell remoti...       .   5
```

### Example 2

```powershell
PS C:\> Get-PSQuiz -Name "Powershell remoting" | Format-List

Name        : PowerShell Remoting
Author      : Jeff Hicks
Version     : 0.2.0
Description : A short quiz on PowerShell remoting concepts.
Questions   : 5
Updated     : 7/5/2023 11:36:18 AM
Path        : C:\work\quizzes\remoting.quiz.json
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

### psQuiz

## NOTES

## RELATED LINKS

[Invoke-PSQuiz](Invoke-PSQuiz.md)
