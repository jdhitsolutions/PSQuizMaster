# Changelog for PSQuizmaster

## [Unreleased]

## [1.3.0] - 2024-10-17

### Added

- Added missing online help links.

### Changed

- Modify masking commands to also obfuscate or reveal distractors. [Issue #3](https://github.com/jdhitsolutions/PSQuizMaster/issues/3)
- Updated `Invoke-PSQuickQuiz` to use `System.Collections.Generic.List[]` instead of an array.

## [1.2.0] - 2023-08-25

### Added

- Added format file `psquizresult.format.ps1xml`.
- Added a `TestTime`, `TestVersion`, and `Path` properties to the quiz result from `Invoke-PSQuiz`.

### Changed

- Updated help for `New-PSQuiz` to reflect new parameters.
- Updated `README.md`.
- Updated help documentation.

### Fixed

- Updated masking and unmasking code to handle integer answers.
- Fixed regex pattern in `Protect-PSQuizFile` and `Unprotect-PSQuizFile`.

## [1.1.0] - 2023-08-24

### Added

- Added commands `Protect-PSQuizFile` and `Unprotect-PSQuizFile`, along with private helper functions, to mask or unmask answers. [[Issue #3](https://github.com/jdhitsolutions/functions/issues/3)]

### Changed

- Updated `Invoke-PSQuiz to start a quiz based on the quiz name. [[Issue #1](https://github.com/jdhitsolutions/PSQuizMaster/issues/1)]
- Updated `Invoke-PSQuiz` to accept quiz by pipeline input.
- Help documentation updates.
- Modified `Get-PSQuiz` to better support wildcards for the quiz name. [[Issue #2](https://github.com/jdhitsolutions/PSQuizMaster/issues/2)]
- Updated `README.md`.

## [1.0.0] - 2023-08-07

This is the first version published to the PowerShell Gallery.

### Added

- Added a dynamic parameter called `UseEditor` to `New-PSQuizFile` and `New-PSQuiz`. If running either command in VSCode or the PowerShell ISE, you can use the dynamic parameter open the new quiz file in the current editor.
- Added a pshelp sample quiz.
- Added an ISE add-on menu command to insert the UTC formatted datetime into a JSON quiz file.
- Added a VSCode additional command to insert the UTC formatted datetime into a JSON quiz file.
- Added PSHelp sample quiz.

### Changed

- Updated sample quizzes.
- Help updates.
- Updated `README.md`

## [0.5.0] - 2023-08-06

### Changed

- Updated `README.me`.
- Updated command help with online links.

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
- Fixed path bug in `New-PSQuizFile`

- ## v0.1.0

- initial module files

[Unreleased]: https://github.com/jdhitsolutions/PSQuizMaster/compare/v1.3.0..HEAD
[1.3.0]: https://github.com/jdhitsolutions/PSQuizMaster/compare/v1.2.0..v1.3.0
[1.2.0]: https://github.com/jdhitsolutions/PSQuizMaster/compare/v1.1.0..v1.2.0
[1.1.0]: https://github.com/jdhitsolutions/PSQuizMaster/compare/v1.0.0..v1.1.0
[1.0.0]: https://github.com/jdhitsolutions/PSQuizMaster/compare/v0.5.0..v1.0.0
[0.5.0]: https://github.com/jdhitsolutions/PSQuizMaster/tree/v0.5.0