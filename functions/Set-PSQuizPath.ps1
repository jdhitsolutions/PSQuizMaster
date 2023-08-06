Function Set-PSQuizPath {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None','System.IO.DirectoryInfo')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage= "Specify the new value for `$PSQuizPath. This will be stored as a persistent value until you change it. The folder must already exist."
        )]
        [ValidateScript({Test-Path $_})]
        [System.IO.DirectoryInfo]$Path,
        [switch]$Passthru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Updating `$PSQuizPath to $Path"
        $settings = [PSCustomObject]@{
            PSQuizPath = $Path.FullName
            Updated = (Get-Date).ToString()
            Computername = [System.Environment]::MachineName
        }
        #PSQuizSettingsFile is a private variable defined in PSQuizMaster.psm1
        $settings | ConvertTo-Json | Out-File -FilePath $PSQuizSettingsFile

        if ($PSCmdlet.ShouldProcess($Path.FullName)) {
            #update the variable in case it is using an old value
            Set-Variable -name PSQuizPath -value $Path.FullName -Scope Global
        }

        if ($Passthru -AND (-Not $WhatIfPreference)) {
            Get-Item -path $Path
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Set-PSQuizPath