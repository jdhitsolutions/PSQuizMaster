#
# Module manifest for module 'PSQuizMaster'
@{
    RootModule           = 'PSQuizmaster.psm1'
    ModuleVersion        = '1.3.0'
    CompatiblePSEditions = @('Desktop', 'Core')
    GUID                 = '3f2c62ca-3370-4173-92d5-6b2b4da136a7'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2017-2024 JDH Information Technology Solutions, Inc.'
    Description          = 'A module for running and creating quizzes to learn PowerShell. Quizzes are stored as JSON files.'
    PowerShellVersion    = '5.1'
    FunctionsToExport    = @(
        'Invoke-PSQuiz',
        'Get-PSQuiz',
        'New-PSQuizQuestion',
        'Invoke-PSQuickQuiz',
        'New-PSQuizQuestion',
        'New-PSQuizFile',
        'Set-PSQuizFile',
        'New-PSQuiz',
        'Set-PSQuizPath',
        'Remove-PSQuizSetting',
        'Copy-PSSampleQuiz',
        'Protect-PSQuizFile',
        'Unprotect-PSQuizFile'
    )
    FormatsToProcess     = @(
        'formats\psquiz.format.ps1xml',
        'formats\psquizItem.format.ps1xml',
        '.\formats\psquizresult.format.ps1xml'
    )
    CmdletsToExport      = ''
    VariablesToExport    = 'PSQuizPath'
    AliasesToExport      = @('Start-PSQuiz', 'Make-PSQuiz')
    PrivateData          = @{
        PSData = @{
            Tags         = @('teaching', 'learn', 'quiz', 'training')
            LicenseUri   = 'https://github.com/jdhitsolutions/PSQuizMaster/blob/master/License.txt'
            ProjectUri   = 'https://github.com/jdhitsolutions/PSQuizMaster'
            # IconUri = ''
            ReleaseNotes = @"
## 1.3.0

### Added

- Added missing online help links.

### Changed

- Modify masking commands to also obfuscate or reveal distractors. [Issue #3](https://github.com/jdhitsolutions/PSQuizMaster/issues/3)
- Updated `Invoke-PSQuickQuiz` to use `System.Collections.Generic.List[]` instead of an array.

Full release change log at https://github.com/jdhitsolutions/PSQuizMaster/blob/master/README.md
"@
        }
    }

}

