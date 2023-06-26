Function New-PSQuizQuestion {
    #create a new PSQuizQuestion
    [CmdletBinding()]
    [OutputType('psQuizItem')]
    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'Enter the question text')]
        [String]$Question,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = "Enter the answer. Enclose in single quotes if using a variable or `$_. Or escape the `$.")]
        [String]$Answer,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, HelpMessage = 'Enter an array of distractors. Do NOT include your answer. 3-5 destractors is a good target.')]
        [string[]]$Distractors,
        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "Enter an optional note to be displayed on correct answers. Enclose in single quotes if using a variable or `$_. Or escape the `$.")]
        [String]$Note
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        Write-Verbose "Processing quiz file $Path"
        Write-Verbose 'Using these bound parameters'
        $PSBoundParameters | Out-String | Write-Verbose
        #create a copy of PSBoundParameters
        $Data = [PSCustomObject]@{
            PSTypeName  = 'psQuizItem'
            question    = $Question
            answer      = $Answer
            distractors = $Distractors -as [array]
            note        = $note
        }

        $data

    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end
}
