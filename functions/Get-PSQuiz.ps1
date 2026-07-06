#list PSQuiz json files

<#
#add a cancel option to the list
Add a menu
get-psquiz |
Select *,@{Name="info";Expression = {"{0} - {1}" -f $_.Name,$_.Description}} |
Read-SpectreSelection -Title "Select a quiz" -ChoiceLabelProperty Info -PageSize 10  -Color Gold1

#>

#TODO: Fix this. There should be parameter sets
Function Get-PSQuiz {
    [CmdletBinding(DefaultParameterSetName = "path")]
    [OutputType('psQuiz')]
    Param(
        [Parameter(
            Mandatory,
            HelpMessage = 'Specify a quiz name',
            ParameterSetName = "name"
        )]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(
            Position = 0,
            ParameterSetName = "path",
            HelpMessage = 'Enter the path to the folder with quiz json files'
        )]
        [ValidateScript({Test-Path -path $_},ErrorMessage = "Failed to find or validate {0}.")]
        [String]$Path = $PSQuizPath,

        [Parameter(ParameterSetName = "path",HelpMessage = "Display a menu of quizzes in the specified path")]
        [switch]$Menu
    )

    Write-Verbose "Starting $($MyInvocation.MyCommand)"
    if ($Name) {
        Write-Verbose "Searching for quiz '$Name' under $PSQuizPath"
    }
    else {
        Write-Verbose "Searching for all quizzes under $PSQuizPath"
    }

    $get = Get-ChildItem -Path $Path -Filter '*.quiz.json' -PipelineVariable pv |
    ForEach-Object {
        $json = Get-Content -Path $_.FullName | ConvertFrom-Json
        #create a typed custom object for the format file
        [PSCustomObject]@{
            PSTypeName  = 'psQuiz'
            Name        = $json.metadata.name
            Author      = $json.metadata.author
            Version     = $json.metadata.version
            Description = $json.metadata.description
            Questions   = $json.questions.count
            Updated     = $json.metadata.updated -as [DateTime]
            Path        = $pv.FullName
        }
    } #foreach-object

    Write-Verbose "Found $($get.count) total quizzes"
    if ($Name) {
        $get | Where-Object { $_.Name -Like $Name }
    }
    elseif ($Menu) {
        Write-Verbose "Displaying selection menu"
        #29 June 2026 add a selection menu
        $get += @{
            Name = "[OrangeRed1]Cancel[/]"
            Description = "[OrangeRed1]Do not select anything[/]"
            Path = $Null

        }
        $r = $get | Select-Object Name,Description,Path,@{Name="info";Expression = {"{0} - [italic]{1}[/]" -f $_.Name,$_.Description}} |
Read-SpectreSelection -Title "[Chartreuse2 italic bold]`nSelect a PSQuiz from the list:[/]" -ChoiceLabelProperty Info -PageSize 10 -EnableSearch -Color Gold1
        if ($r.Path) {
            $r
        }
    }
    else {
        $get
    }
    Write-Verbose "Ending $($MyInvocation.MyCommand)"
}
