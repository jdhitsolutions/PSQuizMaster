---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/3S1ELPq
schema: 2.0.0
---

# Unprotect-PSQuizFile

## SYNOPSIS

Unmask answers in a PSQuiz file.

## SYNTAX

```yaml
Unprotect-PSQuizFile [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

If you masked answers in a PSQuiz file, you can use this command to update the file with unmasked answers and distractors. If the file has not been protected, nothing will be done.

## EXAMPLES

### Example 1

```powershell
PS C:\>  Unprotect-PSQuizFile C:\work\quizzes\remoting.quiz.json
```

## PARAMETERS

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Enter the path of the quiz json file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### None

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Protect-PSQuizFile](Protect-PSQuizFile.md)
