---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version:
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

If you masked answers in a PSQuiz file, you can use this command to update the file with unmasked answers.

## EXAMPLES

### Example 1

```powershell
PS C:\>  Unprotect-PSQuizFile C:\work\quizzes\remoting.quiz.json -Verbose
VERBOSE: [09:00:47.4388741 BEGIN  ] Starting Unprotect-PSQuizFile
VERBOSE: [09:00:47.4408880 BEGIN  ] Running under PowerShell version 5.1.22621.1037
VERBOSE: [09:00:47.4428757 PROCESS] Unmasking answers in C:\work\quizzes\remoting.quiz.json
VERBOSE: [09:00:47.4464409 PROCESS] 069110116101114045080083083101115115105111110
VERBOSE: [09:00:47.4484036 PROCESS] 053057056053
VERBOSE: [09:00:47.4503082 PROCESS] 087083077097110
VERBOSE: [09:00:47.4513487 PROCESS] 078101119045080083083101115115105111110
VERBOSE: [09:00:47.4543385 PROCESS] 082101109111116105110103 117115101115 097 115105110103108101 112111114116 097110100
 105115 101110099114121112116101100 098121 100101102097117108116046
VERBOSE: [09:00:47.4588974 PROCESS] 087083077097110
VERBOSE: [09:00:47.4639022 END    ] Ending Unprotect-PSQuizFile
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

## RELATED LINKS

[Protect-PSQuizFile](Protect-PSQuizFile.md)
