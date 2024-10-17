---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/3S1Iv3M
schema: 2.0.0
---

# Protect-PSQuizFile

## SYNOPSIS

Mask answers and distractors in a PSQuiz file.

## SYNTAX

```yaml
Protect-PSQuizFile [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

PSQuizzes are stored by default in plaintext JSON files. You can use this command to mask the answers and distractors. The obfuscation technique is not complicated and anyone with access to this module can easily reveal the answers. But this will deter casual "cheating."

For best results, your answers should be in text and not a numeric answer. If you must use a numeric answer, it must not be three digits.

## EXAMPLES

### Example 1

```powershell

PS C:\> Protect-PSQuizFile C:\work\quizzes\remoting.quiz.json
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

[Unprotect-PSQuizFile](Unprotect-PSQuizFile.md)
