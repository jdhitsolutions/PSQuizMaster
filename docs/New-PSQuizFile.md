---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/45jiosW
schema: 2.0.0
---

# New-PSQuizFile

## SYNOPSIS

Create an empty quiz file

## SYNTAX

```yaml
New-PSQuizFile [-Name] <String> [-ShortName] <String> -Author <String> -Description <String> [-Version <Version>] [-Path <String>] [-NoClobber] [-Encoding <String>] [-WhatIf] [-Confirm]  [<CommonParameters>]
```

## DESCRIPTION

This command will create an empty quiz file. You can then use New-PSQuizQuestion to define a new set of questions and add them to the file using Set-PSQuizFile.

## EXAMPLES

### Example 1

```powershell
PS C:\>  New-PSQuizFile -Name "PowerShell Scripting" -ShortName scripting -Author "Jeff Hicks" -Description "A quick quiz on PowerShell scripting" -Path d:\temp

    Directory: D:\temp

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          07/05/2024    13:03            580 scripting.quiz.json

PS C:\> Get-Content D:\temp\scripting.quiz.json
{
  "metadata": {
    "name": "PowerShell Scripting",
    "author": "Jeff Hicks",
    "description": "A quick quiz on PowerShell scripting",
    "version": "0.1.0",
    "id": "f3d3b784-b838-405e-84fb-594600c82189",
    "updated": "2024-07-05 17:03:45Z"
  },
  "questions": []
}
```

The default location is $PSQuizPath. You can specify a different location with the -Path parameter.

## PARAMETERS

### -Author

Enter the quiz author.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

Enter a quiz description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encoding

Specify encoding for the text file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Unicode, BigEndianUnicode, UTF8, UTF7, UTF32, ASCII, Default, OEM

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Enter your quiz name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoClobber

Don't overwrite an existing file with the same name.

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

Enter the path or directory to store the quiz json file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PSQuizPath
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShortName

Enter your quiz short name which will be used as part of the filename.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version

Enter a semantic version number for your quiz

```yaml
Type: Version
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0.1.0
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

### System.IO.FileInfo

## NOTES

If you run this command from within the integrated terminal in VSCode or in the PowerShell ISE, you can use the dynamic parameter, UseEditor, to open the new file in the current editor.

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-PSQuiz](New-PSQuiz.md)

[New-PSQuizQuestion](New-PSQuizQuestion.md)

[Set-PSQuizFile](Set-PSQuizFile.md)
