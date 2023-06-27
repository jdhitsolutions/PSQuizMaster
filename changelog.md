# Changelog for PSQuizmaster

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
