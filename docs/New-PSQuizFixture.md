---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://jdhitsolutions.com/yourls/f65753
schema: 2.0.0
---

# New-PSQuizFixture

## SYNOPSIS

Create a new PSQuiz fixture script

## SYNTAX

```yaml
New-PSQuizFixture [-Name] <String> -Path <String> [-Protect] [-Questions <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Run this command to create a new PSQuiz fixture script. This is a PowerShell script file configured to use the PSQuiz Domain Specific Language (DSL) to help you quickly generate a quiz. Once you edit the script file created with this command, you can run it to generate the quiz.

If you import the PSQuiz module in the VS Code integrated PowerShell terminal, you will able to use the dynamic parameter -UseEditor. This will open the new file in VS Code.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-PSQuizFixture "PowerShell Scripting Basics" -path c:\work\PSScripting-Basics.ps1 -protect

    Directory: C:\work

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           6/22/2026  8:29 AM           1911 PSScripting-Basics.ps1
```

Create a new fixture script in the designated file to create a PSQuiz called 'PowerShell Scripting Basics'. When the fixture script is executed, it will use the PSQuiz DSL to create a quiz JSON file with answers, distractors, and notes protected.

## PARAMETERS

### -Name
What is the long name for your new quiz?

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

### -Path
Specify the path and filename for the fixture file.
It should be a .ps1 file.

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

### -Protect
Do you want to protect the file quiz file

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

### -Questions
How many initial questions do you intend to ask?

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Count

Required: False
Position: Named
Default value: 5
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

### None

## OUTPUTS

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[about_PSQuizDSL](about_PSQuizDSL.md)
