---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://jdhitsolutions.com/yourls/740313
schema: 2.0.0
---

# Update-PSQuizSchema

## SYNOPSIS

Update the schema for a PSQuiz file.

## SYNTAX

```yaml
Update-PSQuizSchema [-Path] <String> [-IsProtected] [-AddLogo] [-Passthru]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Version 2.0 of this module introduced new features and a new schema version. Quizzes created with this version of the module will use the new schema. If you have existing quizzes, you may want to update the schema. There are several options.

First, if you protect with Protect-PSQuizFile or unprotect with Unprotect-PSQuizFile, the schema setting automatically be updated to v2.

Your other option is to use this command. In addition to updating the schema setting, you can opt to the protected metadata setting and the new logo setting. You should verify the protected setting is accurate. You will need to manually enter to complete path to the logo image file.

If you update the schema, you should update the internal version number of your quiz. Updating the schema will not change the Updated property. That is intended to reflect changes in the quiz content.

If you import the PSQuiz module in the VS Code integrated PowerShell terminal, you will able to use the dynamic parameter -UseEditor. This will open the new file in VS Code.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSQuiz | Update-PSQuizSchema
```

Get all quizzes in $PSQuizPath and update the schema to version 2.

### Example 2

```powershell
PS C:\> Update-PSQuizSchema -Path C:\work\quizzes\Aliases.quiz.json -AddLogo -Passthru

    Directory: C:\work\quizzes

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---            7/6/2026  2:31 PM           1921 Aliases.quiz.json
```

Update the quiz schema to v2 and add the logo setting which will need to be manually updated.

## PARAMETERS

### -AddLogo
Add the logo setting.
You will need to edit the file and specify the full path.

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

### -IsProtected
Add the protected metadata setting.

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

### -Passthru
Get the updated quiz file.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### None

### FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Protect-PSQuizFile](Protect-PSQuizFile.md)

[Unprotect-PSQuizFile](Unprotect-PSQuizFile.md)