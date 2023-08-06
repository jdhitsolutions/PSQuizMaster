---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version:
schema: 2.0.0
---

# Set-PSQuizPath

## SYNOPSIS

Save the user's PSQuizPath setting to a file.

## SYNTAX

```yaml
Set-PSQuizPath [-Path] <DirectoryInfo> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The default location of $PSQuizPath is the module sample quiz folder. This global variable is the default for most commands in this module. Use this command to set a new location. This value will be stored in a settings file under $HOME called .psquizsettings.json. You shouldn't need to do anything with this file. If the file exists, the module will set $PSQuizPath to the saved value.

The $PSQuizPath variable will also be updated to use the new location.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-PSQuizPath C:\work\quizzes\
PS C:\> $PSQuizPath
C:\work\quizzes\
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

### -Passthru

Display the new folder location.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Specify the new value for $PSQuizPath.
This will be stored as a persistent value until you change it.
The folder must already exist.

```yaml
Type: DirectoryInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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

### System.IO.DirectoryInfo

## NOTES

## RELATED LINKS

[Copy-PSQuizFile](Copy-PSQuizFile.md)

[Remove-PSQuizSetting](Remove-PSQuizSetting.md)
