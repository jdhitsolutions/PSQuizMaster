#requires -version 7.6
#requires -module PSQuizMaster

#This is a fixture for a new quiz file

#usage: c:\scripts\PSQuizMaster\dsl\sample3.ps1

<#
  Use -protect to mask all answers, distractors, and notes
  distractors, and notes.
#>

Quiz 'PowerShell Objects' @(
    @{
        Path        = "C:\work\quizzes\objects.ps1"
        Author      = "Jeff Hicks"
        Description = "A short quiz on using objects in PowerShell"
    }
    Question @{
        Question    = "What can you use to have PowerShell treat a hashtable as an object?"
        Answer      = "[PSCustomObject]"
        Distractors = "[Array]","(Object)","[PSObject]","-AsObject","`$PSCmdlet"
    }
    Question @{
        Question    = "What is the best command for discovering information about an object?"
        Answer      = "Get-Member"
        Distractors = "Add-Member","Out-Member","Select-Object","Measure-Object"
        Note        = "Read the help for Get-Member because there is much you can do with it."
    }
    Question @{
        Question    = "What is the PowerShell concept that lets you pass an object from one command to another?"
        Answer      = "The pipeline"
        Distractors = "Workflow","script blocks","hashtables","bash"
        Note        = "The pipeline character is |"
    }
    Question @{
        Question    = "What is the part of an object that describes it?"
        Answer      = "property"
        Distractors = "method","event","note","description"
    }
    Question @{
        Question    = "What is the part of an object to defines what it can do or have done to it?"
        Answer      = "method"
        Distractors = "property","event","action","workflow"
        Note        = "Use Get-Member to discover an object's methods and properties."
    }
)
