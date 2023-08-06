Function Copy-PSSampleQuiz {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType('System.IO.FileInfo')]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            HelpMessage = "Specify the target folder. It is assumed that the location will be your new value for `$PSQuizPath. The folder must already exist."
        )]
        [alias("Destination")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_})]
        [System.IO.DirectoryInfo]$Path
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
        $moduleRoot = (Get-Module PSQuizMaster).path | Split-Path
        $moduleDefault = Join-Path -Path $moduleRoot -ChildPath quizzes
    } #begin

    Process {
        if ($Path -ne $moduleDefault) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Copying sample quiz files from $moduleDefault to $Path "
            Get-ChildItem -path $moduleDefault -filter *.json |
            Copy-Item -Destination $Path -PassThru
        }
        else {
            #this should almost never happen
            Write-Warning "The path must be different than the module default."
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close Copy-PSSampleQuiz