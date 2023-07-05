#This is a wizard-like command that will prompt the user for the information needed to create a new quiz.

Function New-PSQuiz {
    [cmdletbinding()]
    [Alias('Make-PSQuiz')]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = 'Specify the folder for the new quiz file. The default is $PSQuizPath.'
        )]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path = $PSQuizPath
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    $newQuizFileParams = @{
        Name        = Read-Host 'What is the full name of your quiz?'
        ShortName   = Read-Host 'What is the short quiz name? This will be used as part of the file name'
        Description = Read-Host 'Enter a quiz description. You can always edit this later'
        Author      = Read-Host 'Enter the author name'
        Path        = $Path
    }

    Write-Verbose 'Creating the new quiz file'
    $quizFile = New-PSQuizFile @newQuizFileParams

    $questions = [System.Collections.Generic.list[object]]::New()

    Write-Verbose 'Adding questions to the quiz file'
    Do {
        $newQuestionParams = @{
            Question    = Read-Host 'Enter the question'
            Answer      = Read-Host 'Enter the answer'
            Distractors = (Read-Host 'Enter a comma-separated list of distractors') -split ','
            Note        = Read-Host 'Enter any notes for this question'
        }
        $questions.Add((New-PSQuizQuestion @newQuestionParams))
        $R = Read-Host 'Add another question? (Y/N)'
    } While ($r -eq 'Y')

    Write-Verbose "Adding $($questions.Count) questions to the quiz file"
    Set-PSQuizFile -path $quizFile.FullName -Question $questions

    Write-Verbose "Quiz file created at $($quizFile.FullName)"

    Get-PSQuiz -name $newQuizFileParams.Name -path $Path

    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}