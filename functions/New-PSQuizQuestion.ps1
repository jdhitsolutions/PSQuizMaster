Function New-PSQuizQuestion {
    #create a new PSQuizQuestion
    [CmdletBinding()]
    [OutputType('psQuizItem')]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the question text'
            )]
        [String]$Question,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the answer. Enclose in single quotes if using a variable or `$_. Or escape the `$."
            )]
        [String]$Answer,
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter an array of distractors. Do NOT include your answer. 3-5 distractors is a good target.'
            )]
        [string[]]$Distractors,
        [Parameter(
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter an optional note to be displayed on correct answers. Enclose in single quotes if using a variable or `$_. Or escape the `$."
            )]
        [String]$Note,
        [Parameter(HelpMessage = "Mask the answer so it is not displayed in plain text in the JSON file.")]
        [switch]$MaskAnswer
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        Write-Verbose "Processing quiz file $Path"
        Write-Verbose 'Using these bound parameters'
        $PSBoundParameters | Out-String | Write-Verbose

        #Modified 8/15/2023 to allow for a masked answer. Issue #3
        if ($MaskAnswer) {
            Write-Verbose "Masking answer $Answer"
            $Answer = _hideAnswer $Answer
        }
        #create a copy of PSBoundParameters
        $Data = [PSCustomObject]@{
            PSTypeName  = 'psQuizItem'
            question    = $Question
            answer      = $Answer
            distractors = $Distractors -as [array]
            note        = $Note
        }

        $data

    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #end
}
