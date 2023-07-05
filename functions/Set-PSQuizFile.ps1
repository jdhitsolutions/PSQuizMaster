#update a quiz file with new metadata and or questions
Function Set-PSQuizFile {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the path of the quiz json file.')]
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
        [String]$Path,
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
        [DateTime]$Updated = $(Get-Date),
        [Parameter(HelpMessage = 'Enter in a one or more question items')]
        [ValidateNotNullOrEmpty()]
        [object[]]$Question
    )
    Begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        Write-Verbose "Getting file content from $Path - converted to json"
        $content = Get-Content -Path $Path | ConvertFrom-Json
        Write-Verbose 'Updating metadata'
        $PSBoundParameters.Keys.toLower() | Where-Object { $_ -match 'name|author|version|description' } |
        ForEach-Object {
            Write-Verbose "...$_ $($PSBoundParameters.Item($_))"
            $content.metadata.$_ = $PSBoundParameters.Item($_)
        }
        #set the date in metadata
        $updateTime = '{0:u}' -f $Updated.ToUniversalTime()
        Write-Verbose "Setting update time to $updateTime"
        $content.metadata.updated = $updateTime

        if ($content.questions -AND $PSBoundParameters.ContainsKey('question')) {
            Write-Verbose 'Appending to existing questions'
            $content.questions += $question
        }
        elseif ($PSBoundParameters.ContainsKey('question')) {
            Write-Verbose 'Defining new questions'
            $content | Add-Member -MemberType NoteProperty -Name questions -Value $question -Force
        }

        $set = [PSCustomObject]@{
            metadata  = $content.metadata
            questions = $content.questions
        }
        if ($PSCmdlet.ShouldProcess($path)) {
            $set | ConvertTo-Json -Depth 5 | Out-File -FilePath $Path -Encoding Unicode -Force
        }
    } #process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"
    } #3nd
}
