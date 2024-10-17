---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/3Onr4rm
schema: 2.0.0
---

# New-PSQuizQuestion

## SYNOPSIS

Create a new quiz question.

## SYNTAX

```yaml
New-PSQuizQuestion [-Question] <String> [-Answer] <String> [-Distractors] <String[]> [[-Note] <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to create a quiz question. You should save it to a variable and then add it to a quiz file with Set-PSQuizFile.

## EXAMPLES

### Example 1

```powershell
PS C:\> $q = New-PSQuizQuestion -Question "What is the default script execution policy" -Answer "Restricted" -Distractors "Unrestricted","AllSigned","RemoteSigned","Bypass" -note "Execution policy is not a security setting."
PS C:\> Set-PSQuizFile -Path D:\temp\pshelp.quiz.json -Question $q -Version 0.2.0
```

Create a new question and then add it to a quiz file. The question Note is optional.

### Example 2

```powershell
PS C:\> New-PSQuizQuestion | ConvertTo-JSON | Set-Clipboard
```

Run through the prompts to setup a new quiz question. The output will be converted to JSON and copied to the Windows clipboard. You can paste the question directly into the quizzes JSON file.

## PARAMETERS

### -Answer

Enter the answer.
Enclose in single quotes if using a variable or $_.
Or escape the $.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Distractors

Enter an array of distractors.
Do NOT include your answer.
3-5 distractors is a good target.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Note

Enter an optional note to be displayed on correct answers.
Enclose in single quotes if using a variable or $_.
Or escape the $.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Question

Enter the question text.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.String[]

## OUTPUTS

### psQuizItem

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-PSQuizFile](New-PSQuizFile.md)

[New-PSQuiz](New-PSQuiz.md)
