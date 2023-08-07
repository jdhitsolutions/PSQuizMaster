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
            HelpMessage = 'Enter your quiz short name which will be used as part of the filename.'
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
        Write-Verbose 'Using these parameter values'
        $MyInvocation.BoundParameters | Out-String | Write-Verbose
    } #Begin
    Process {
        $QuizPath = Join-Path -Path $Path -ChildPath "$shortname.quiz.json"
        $MetaHash = [ordered]@{
            name        = $Name
            author      = $Author
            description = $Description
            version     = $Version.ToString()
            id          = (New-Guid).guid
            updated     = '{0:u}' -f (Get-Date).ToUniversalTime()
        }

        $QuizFile = [PSCustomObject]@{
            '$schema' = $PSQuizSchema
            metadata  = $MetaHash
            questions = @()
        }

        if ($PSCmdlet.ShouldProcess($QuizPath, "Create Quiz file $Name by $Author [$version]")) {
            Try {
                $QuizFile |
                ConvertTo-Json -ErrorAction Stop |
                Out-File -FilePath $QuizPath -Encoding $encoding -NoClobber:$NoClobber -ErrorAction Stop

            }
            Catch {
                Throw $_
            }
            #give the file an opportunity to close
            Start-Sleep -Seconds 1
            if ($PSBoundParameters.ContainsKey("UseEditor")) {
                psedit $QuizPath
            }
            else {
                #write the file object to the pipeline
                Get-Item -Path $QuizPath
            }
        }
    } #Process
    End {
        Write-Verbose "Ending $($MyInvocation.MyCommand)"

    } #End
}
