function Set-PSQuizPath {
    [cmdletbinding(SupportsShouldProcess)]
    [Alias('Save-PSQuizSettings')]
    [OutputType('None', 'System.IO.DirectoryInfo')]
    param(
        [Parameter(
            Position = 0,
            HelpMessage = "Specify the new value for `$PSQuizPath. This will be stored as a persistent value until you change it. The folder must already exist."
        )]
        [ValidateScript({ Test-Path $_ })]
        [System.IO.DirectoryInfo]$Path = $global:PSQuizPath,
        [switch]$Passthru
    )

    begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Saving `$PSQuizPath and `$psQuizTheme settings to $Path"
        $settings = [PSCustomObject]@{
            PSQuizPath   = $Path.FullName
            psQuizTheme  = $psQuizTheme
            Updated      = (Get-Date).ToString()
            Username     = [System.Environment]::UserName
            Computername = [System.Environment]::MachineName
        }
        #PSQuizSettingsFile is a private variable defined in PSQuizMaster.psm1
        $settings | ConvertTo-Json | Out-File -FilePath $PSQuizSettingsFile

        if ($PSCmdlet.ShouldProcess($Path.FullName)) {
            #update the variable in case it is using an old value
            Set-Variable -Name PSQuizPath -Value $Path.FullName -Scope Global
        }

        if ($Passthru -and (-not $WhatIfPreference)) {
            Get-Item -Path $Path
        }
    } #process

    end {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Set-PSQuizPath