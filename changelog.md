# Changelog for PSQuizmaster

## [Unreleased]

## [0.4.0] - 2023-08-06
### Added
- Added format file `psquiz.format.ps1xml`.
- Added argument completer for the `Path` parameter in `Set-PSQuizFile`.
- Added support for a JSON schema for the quiz files.
- Added command `Set-PSQuizPath`.
- Added command `Remove-PSQuizSetting`.
- Added command `Copy-PSSampleQuiz` to copy module sample quizzes to a new location.

### Changed
- Modified `Get-PSQuiz` to output a typed object and updated the associated format.ps1xml file.
- Modified manifest to reflect that this module should work in Windows PowerShell and PowerShell 7.
- Updated help documentation.
- Updated quiz JSON schema to use online source.

- ## v0.3.0

### Fixed
- Updated root module file to export command aliases.
-
- Fixed path bug in `New-PSQuizFile`
-
- ## v0.1.0
-
- initial module files

[Unreleased]: ENTER-URL-HERE
[0.4.0]: ENTER-URL-HERE