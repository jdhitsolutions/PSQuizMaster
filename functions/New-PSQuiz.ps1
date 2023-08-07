#This is a wizard-like command that will prompt the user for the information needed to create a new quiz.

Function New-PSQuiz {
    [cmdletbinding()]
    [OutputType("None","PSQuiz")]
    [Alias('Make-PSQuiz')]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = 'Specify the folder for the new quiz file. The default is $PSQuizPath.'
        )]
        [ValidateScript({ Test-Path $_ })]
        [string]$Path = $PSQuizPath
    )
    DynamicParam {
        # Open the new file in the current editor
        If ($host.name -match 'code|ise') {

            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            # Defining parameter attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ParameterSetName = '__AllParameterSets'
            $attributes.HelpMessage = 'Open the new quiz file in the current editor.'
            $attributeCollection.Add($attributes)

            # Defining the runtime parameter
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('UseEditor', [Switch], $attributeCollection)
            $paramDictionary.Add('UseEditor', $dynParam1)

            return $paramDictionary
        } # end if
    } #end DynamicParam

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    } #Begin
    Process {

        $newQuizFileParams = @{
            Name        = Read-Host 'What is the full name of your quiz?'
            ShortName   = Read-Host 'What is the short quiz name? This will be used as part of the file name'
            Description = Read-Host 'Enter a quiz description. You can always edit this later'
            Author      = Read-Host 'Enter the author name'
            Path        = $Path
        }

        Write-Verbose "Creating the new quiz file called $($new.newQuizFileParams.Name)"
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
        if ($PSBoundParameters.ContainsKey("UseEditor")) {
            Write-Verbose "Opening $($quizFile.FullName) in the current editor"
            psedit $quizFile.FullName
        }
        else {
            Get-PSQuiz -name $newQuizFileParams.Name -path $Path
        }
    } #Process

    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #End
}