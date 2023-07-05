---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version:
schema: 2.0.0
---

# Invoke-PSQuickQuiz

## SYNOPSIS

Run a PowerShell quiz

## SYNTAX

### all (Default)

```yaml
Invoke-PSQuickQuiz [-Exclude <String[]>] [-NextQuestion] [-Path <String>] [<CommonParameters>]
```

### single

```yaml
Invoke-PSQuickQuiz [-ModuleName <String>] [-NextQuestion] [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION

Use this script to test your knowledge of PowerShell commands, which given the Verb-Noun naming pattern should be pretty easy.

The default behavior is to use all cmdlets and functions from installed modules with an option to exclude an array of module names.
Wildcards are allowed.
You also have the option to specify a single module for testing.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Invoke-PSQuickQuiz

PowerShell Pop Quiz

Given this short cmdlet description:

 Creates a new System.Windows.Markup.RoutedEventConverter

 What command would you use?

  [1]   Invoke-CauScan
  [2]   Clear-Tpm
  [3]   Remove-WindowsCapability
  [4]   Get-IscsiTargetServerSetting
  [5]   New-RoutedEventConverter

Select a menu choice [1-5]: 5

You are Correct!!

Do you want another question?
Press any key to continue or Q to quit: q
You scored 1 correct out of 1 for a GPA of 5.
Your grade is A.
```

### EXAMPLE 2

```powershell
PS C:\> Invoke-PSQuickQuiz -module Hyper-V
```

Launch the quiz but only use commands from the Hyper-V module.

### EXAMPLE 3

```powershell
PS C:\> Invoke-PSQuickQuiz -exclude ISE,WPK,my*
```

Launch the quiz using all modules except ISE, WPK and any modules that start with 'my'.

### EXAMPLE 4

```powershell
PS C:\> Invoke-PSQuickQuiz -exclude ISE,WPK,my* -path c:\work\quiz.txt
```

Launch the quiz using all modules except ISE, WPK and any modules that start with 'my'.
Record results in a transcript file, C:\Work\quiz.txt.

## PARAMETERS

### -ModuleName

You can specify a single module for testing.
The default is all modules.

```yaml
Type: String
Parameter Sets: single
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude

Enter a comma separated list of module names to ignore.
You can use wildcards.

```yaml
Type: String[]
Parameter Sets: all
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NextQuestion

This is used to indicate a continuing test.
You should never need to use this parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Enter a path and filename for a quiz transcript.

```yaml
Type: String
Parameter Sets: (All)
Aliases: transcript

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Invoke-PSQuiz](Invoke-PSQuiz.md)
