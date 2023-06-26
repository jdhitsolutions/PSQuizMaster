Function New-PSQuizFile {
    #create a new quiz json file
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType( { 'System.IO.FileInfo' })]
    Param (
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Enter your quiz name'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(
            Position = 1,
            Mandatory,
            HelpMessage = 'Enter your quiz short name which will be used as part of the filename'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ShortName,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the quiz author.'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Author,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter a quiz description'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(HelpMessage = 'Enter a semantic version number for your quiz')]
        [ValidateNotNullOrEmpty()]
        [version]$Version = '0.1.0',

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

        [Parameter(HelpMessage = "Don't overwrite an existing file with the same name.")]
        [Switch]$NoClobber,

        [Parameter(HelpMessage = 'Specify encoding for the text file.')]
        [ValidateSet('Unicode', 'BigEndianUnicode', 'UTF8', 'UTF7', 'UTF32', 'ASCII', 'Default', 'OEM')]
        [String]$Encoding = 'Unicode'
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    Write-Verbose 'Using these parameter values'
    $MyInvocation.BoundParameters | Out-String | Write-Verbose

    $QuizPath = Join-Path -Path $PSQuizPath -ChildPath "$shortname.quiz.json"
    $MetaHash = [ordered]@{
        name        = $Name
        author      = $author
        description = $description
        version     = $version.ToString()
        id          = (New-Guid).guid
        updated     = (Get-Date).ToShortDateString()
    }
    $MetaData = [PSCustomObject]@{
        MetaData = $MetaHash
    }

    if ($PSCmdlet.ShouldProcess($QuizPath, "Create Quiz file $Name by $Author [$version]")) {
        $MetaData | ConvertTo-Json | Out-File -FilePath $QuizPath -Encoding $encoding -NoClobber:$noclobber
        #give the file an opportunity to close
        Start-Sleep -Seconds 1
        #write the file object to the pipeline
        Get-Item -Path $QuizPath
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
