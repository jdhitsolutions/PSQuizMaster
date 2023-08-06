Function Remove-PSQuizSetting {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('None')]
    Param( )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"

        $moduleRoot = (Get-Module PSQuizMaster).path | Split-Path
        $moduleDefault = Join-Path -Path $moduleRoot -ChildPath quizzes
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Removing $PSQuizSettingsFile"
        if (Test-Path -path $PSQuizSettingsFile) {
            #delete the file
            Remove-Item -path $PSQuizSettingsFile
            #set PSQuizPath back to module default
            Set-Variable -Name PSQuizPath -Value $moduleDefault -Scope Global
        }
        else {
        Write-Warning "Can't verify $PSQuizSettingsFile."
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Remove-PSQuizSetting