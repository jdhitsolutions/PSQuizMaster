---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/3OocjEC
schema: 2.0.0
---

# Copy-PSSampleQuiz

## SYNOPSIS

Copy module sample quiz files.

## SYNTAX

```yaml
Copy-PSSampleQuiz [[-Path] <DirectoryInfo>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

If you decide to create a new location for $PSQuizPath, you can use this command to copy the sample quizzes from the PSQuizMaster module to the new folder. The location must already exist.

## EXAMPLES

### Example 1

```powershell
PS C:\> Copy-PSSampleQuiz -Path C:\work\quizzes\

    Directory: C:\work\quizzes

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            7/6/2023 11:03 AM           2494 Aliases.quiz.json
-a---            7/7/2023  2:21 PM           6202 demo.quiz.json
-a---            7/7/2023  2:21 PM           4156 remoting.quiz.json
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

Specify the target folder.
It is assumed that the location will be your new value for $PSQuizPath.
The folder must already exist.

```yaml
Type: DirectoryInfo
Parameter Sets: (All)
Aliases: Destination

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
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

### System.IO.DirectoryInfo

## OUTPUTS

### System.IO.FileInfo

## NOTES

## RELATED LINKS

[Set-PSQuizPath](Set-PSQuizPath.md)
