---
external help file: PSQuizmaster-help.xml
Module Name: PSQuizMaster
online version: https://bit.ly/3OjtLdk
schema: 2.0.0
---

# New-PSQuiz

## SYNOPSIS

Create a new quiz.

## SYNTAX

```yaml
New-PSQuiz [[-Path] <String>] [-MaskAnswer] [<CommonParameters>]
```

## DESCRIPTION

This command serves as a kind of "wizard" to guide a quiz creator through the process of creating a quiz file with questions. You can modify the quiz file later by modifying the JSON file or using Set-PSQuizFile.

Use the MaskAnswer parameter if you want to hide the answers in the JSON file.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-PSQuiz -Path d:\temp
What is the full name of your quiz?: Using PowerShell Help
What is the short quiz name? This will be used as part of the file name: pshelp
Enter a quiz description. You can always edit this later: A brief quiz on using the PowerShell help system
Enter the author name: Jeff Hicks
Enter the question: What command do you use to install the latest version of the help documentation?
Enter the answer: Update-Help
Enter a comma-separated list of distractors: Install-Help,Get-Help,Find-Help,Get-Help -online
Enter any notes for this question: A few errors are to be expected when running Update-Help
Add another question? (Y/N): n

Name        : Using PowerShell Help
Author      : Jeff Hicks
Version     : 0.1.0
Description : A brief quiz on using the PowerShell help system
Questions   : 1
Updated     : 07/05/2023 12:53:23
Path        : D:\temp\pshelp.quiz.json
```

The default path location is $PSQuizPath. You can specify a different location with the -Path parameter.

## PARAMETERS

### -Path

Specify the folder for the new quiz file.
The default is $PSQuizPath.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaskAnswer
Mask the answer so it is not displayed in plain text in the JSON file. You can use Unprotect-PSQuizFile to unmask the answers.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

### psQuiz

## NOTES

This command has an alias of Make-Quiz. If you run this command from within the integrated terminal in VSCode or in the PowerShell ISE, you can use the dynamic parameter, UseEditor, to open the new file in the current editor.

## RELATED LINKS

[New-PSQuizFile](New-PSQuizFile.md)

[New-PSQuizQuestion](New-PSQuizQuestion.md)

[Set-PSQuizFile](Set-PSQuizFile.md)

[Protect-PSQuizFile](Protect-PSQuizFile.md)

[Unprotect-PSQuizFile](Unprotect-PSQuizfile.md)
