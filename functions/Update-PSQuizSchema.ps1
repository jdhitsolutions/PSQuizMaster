#update the PSQuiz schema to version 2

function Update-PSQuizSchema {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('None', 'FileInfo')]
    param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'Enter the path of the quiz json file.'
        )]
        [ValidateNotNullOrEmpty()]
        [ArgumentCompleter({
                (Get-ChildItem -Path $PSQuizPath -Filter *.json).fullName
            })]
        [ValidateScript({ Test-Path -Path $_ }, ErrorMessage = 'Failed to find or validate {0}.')]
        [String]$Path,

        [Parameter(HelpMessage = 'Add the protected metadata setting.')]
        [switch]$IsProtected,

        [Parameter(HelpMessage = 'Add the logo setting. You will need to edit the file and specify the full path.')]
        [switch]$AddLogo,

        [Parameter(HelpMessage = 'Get the updated quiz file.')]
        [switch]$Passthru
    )
    dynamicparam {
        # Open the new file in the current editor
        if ($host.name -eq 'Visual Studio Code Host') {

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
    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        #set a flag indicating if the file needs to be updated.
        $update = $false
    } #begin

    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Protecting answers in $Path"
        $quiz = Get-Content -Path $Path | ConvertFrom-Json

        #update schema to version 2
        if ($quiz.'$schema' -notmatch 'v2') {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating the schema to version 2"
            $quiz.'$schema' = $PSQuizSchema
            $update = $True
        }

        if ($IsProtected) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding protected metadata setting"
            $quiz.metadata | Add-Member -MemberType NoteProperty -Name protected -Value $True -Force
            $update = $True
        }

        If ($AddLogo -AND ($quiz.PSObject.Properties.Name -notContains "logo")) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding the logo setting."
            $quiz | Add-Member -MemberType NoteProperty -Name logo -value "" -Force
            $update = $True
        }

        if ($update) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating the json file"
            $quiz | ConvertTo-Json -Depth 5 | Out-File -FilePath $Path -Encoding UTF8 -Force
            Write-Verbose "[$((Get-Date).TimeOfDay) END    ] You might want to update the quiz version"
        }

        if ($PSBoundParameters.ContainsKey('UseEditor') -And (-not $WhatIfPreference)) {
            psedit $Path
        }
        elseif ($Passthru -And (-not $WhatIfPreference)) {
            Get-Item -Path $Path
        }
    }

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    }

}