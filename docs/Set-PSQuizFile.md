---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/45kzFlt
schema: 2.0.0
---

# Set-PSQuizFile

## SYNOPSIS

Update a quiz file.

## SYNTAX

```yaml
Set-PSQuizFile [-Path] <String> [-Name <String>] [-Author <String>] [-Version <String>] [-Description <String>] [-Updated <DateTime>] [-Question <Object[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to update a quiz file. You can update the author, version, description, and questions. You can also add new questions to the quiz file.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSQuiz -Name "Powershell remoting" | Set-PSQuizFile -Updated (Get-Date) -Version 0.2.1
```

## PARAMETERS

### -Author

Enter a new author for your quiz.

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

### -Description

Enter a new description for your quiz.

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

### -Name

Enter a new name for your quiz.

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

### -Path

Enter the path or directory to store the quiz json file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: $PSQuizPath
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Question

Enter in a one or more question items.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Updated

Enter an optional update value.
The default is today.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version

Enter a new version number for your quiz.

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

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Get-PSQuiz](Get-PSQuiz.md)

[New-PSQuiz](New-PSQuiz.md)

[New-PSQuizFile](New-PSQuizFile.md)

