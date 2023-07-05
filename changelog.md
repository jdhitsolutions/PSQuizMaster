# Changelog for PSQuizmaster

## v0.3.0

### Changed

- Changed parameter type for `Updated` in `Set-PSQuizFile` to `[datetime]` from `[string]`
- Modified `Set-PSQuizFile` to accept pipeline input for the file name. Made the path mandatory

### Added

- Added parameter `Name` to `Get-PSQuizFile` to retrieve a quiz by name
- Added alias `Start-PSQuiz` for `Invoke-PSQuiz`
- Added command `New-PSQuiz` with an alias of `Make-PSQuiz`, to guide a quiz creator through the process of creating a quiz file with questions.
- Added format file `psquizItem.format.ps1xml` to display quiz questions in a list format by default.

## v0.2.0

### Changed

- re-organized module layout
- Revised `New-PSQuizFile` to include a `Questions` property
- Configured quiz files to use UTC time for timestamps. `"{0:u}" -f (Get-Date).ToUniversalTime()`

### Added

- Added `New-PSQuizQuestion`
- Added `Set-PSQuizFile`
- Added `New-PSQuizFile`
- Added argument completer for `Invoke-PSQuiz`
- Added Alias sample quiz

### Fixed

- Fixed path bug in `New-PSQuizFile`

## v0.1.0

- initial module files
