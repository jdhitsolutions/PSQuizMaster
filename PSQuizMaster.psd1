#
# Module manifest for module 'PSQuizMaster'

@{
    RootModule        = 'PSQuizmaster.psm1'
    ModuleVersion     = '0.2.0'
    CompatiblePSEditions = @("Desktop")
    GUID              = '3f2c62ca-3370-4173-92d5-6b2b4da136a7'
    Author            = 'Jeff Hicks'
    CompanyName       = 'JDH Information Technology Solutions, Inc.'
    Copyright         = '(c) 2017-2023 JDH Information Technology Solutions, Inc.'
    Description       = 'A module for running and creating quizzes to learn PowerShell.'
    PowerShellVersion = '5.1'
    # ScriptsToProcess = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    FunctionsToExport = @(
        'Invoke-PSQuiz',
        'Get-PSQuiz',
        'New-PSQuizQuestion',
        'Invoke-PSQuickQuiz',
        'New-PSQuizQuestion',
        'New-PSQuizFile',
        'Set-PSQuizFile'
        )
    CmdletsToExport   = '*'
    VariablesToExport = 'PSQuizPath'
    AliasesToExport   = ''
    PrivateData       = @{
        PSData = @{
            Tags         = @("teaching", "learn")
            LicenseUri   = ''
            ProjectUri   = 'https://github.com/jdhitsolutions/PSQuizMaster'
            # IconUri = 'https://github.com/jdhitsolutions/PSQuizMaster/blob/master/License.txt'
            ReleaseNotes = 'https://github.com/jdhitsolutions/PSQuizMaster/blob/master/README.md'
        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

