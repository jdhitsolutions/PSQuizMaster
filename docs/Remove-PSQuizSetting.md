---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/47nsYks
schema: 2.0.0
---

# Remove-PSQuizSetting

## SYNOPSIS

Remove the PSQuizPath settings file.

## SYNTAX

```yaml
Remove-PSQuizSetting [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

When you run Set-PSQuizPath the command creates a JSON file under $HOME called .psquizsettings.json. Use this command if you want to delete the file. This will also set the value of $PSQuizPath back to the module default.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-PSQuizSetting
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

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Set-PSQuizPath](Set-PSQuizPath.md)
