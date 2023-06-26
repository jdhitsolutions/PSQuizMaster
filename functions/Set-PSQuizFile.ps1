Function Set-PSQuizFile {
    #update a quiz file with new metadata and or questions
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(HelpMessage = 'Enter the path or directory to store the quiz json file.')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
            if (Test-Path -Path $_) {
                return $True
            }
            else {
                Throw "Can't verify $_ as a valid path."
                Return $false
            }
        })]
        [String]$Path = $PSQuizPath,
        [Parameter(HelpMessage = 'Enter a new name for your quiz')]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        [Parameter(HelpMessage = 'Enter a new author for your quiz')]
        [ValidateNotNullOrEmpty()]
        [String]$Author,
        [Parameter(HelpMessage = 'Enter a new version number for your quiz')]
        [ValidateNotNullOrEmpty()]
        [String]$Version,
        [Parameter(HelpMessage = 'Enter a new description for your quiz')]
        [ValidateNotNullOrEmpty()]
        [String]$Description,
        [ValidateNotNullOrEmpty()]
        [Parameter(HelpMessage = 'Enter an optional update value. The default is today.')]
        [String]$Updated = $(Get-Date).ToShortDateString(),
        [Parameter(HelpMessage = 'Enter in a one or more question items')]
        [ValidateNotNullOrEmpty()]
        [object[]]$Question
    )
    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        Write-Verbose "Getting file content from $Path - converted to json"
        $content = Get-Content -Path $Path | ConvertFrom-Json
    } #begin
    Process {
        Write-Verbose 'Updating metadata'
        $PSBoundParameters.Keys.toLower() | Where-Object { $_ -match 'name|author|version|description' } |
        ForEach-Object {
            Write-Verbose "...$_"
            $content.metadata.$_ = $PSBoundParameters.Item($_)
        }
        #set the date in metadata
        $content.metadata.updated = $Updated

        if ($content.questions) {
            Write-Verbose 'Appending to existing questions'
            $content.questions += $question
        }
        else {
            Write-Verbose 'Defining new questions'
            $content | Add-Member -MemberType NoteProperty -Name questions -Value $question
        }

        $set = [PSCustomObject]@{
            metadata  = $content.metadata
            questions = $content.questions
        }
        if ($PSCmdlet.ShouldProcess($path)) {
            $set | ConvertTo-Json -depth 5 | Out-File -FilePath $Path -Encoding Unicode -Force
        }
    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #3nd
}
