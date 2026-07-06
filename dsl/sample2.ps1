#requires -version 7
#requires -module PSQuizMaster

#This is a fixture for a new quiz file that was created using New-PSQuizFixture

#usage: c:\scripts\PSQuizMaster\dsl\sample2.ps1

Quiz 'PowerShell 7 Sample Quiz' @(
    @{
        Path        = 'C:\work\quizzes\ps7.quiz.json'
        Author      = 'Jeff Hicks'
        Description = 'A quick quiz on PowerShell 7 basics'
    }

    Question @{
        Question    = 'What platform is not supported by PowerShell 7?'
        Answer      = 'Windows 8'
        Distractors = 'MacOS', 'Windows 10', 'Windows 11', 'Ubuntu', 'RHEL'
    }
    Question @{
        Question    = 'What is the PowerShell 7 executable?'
        Answer      = 'pwsh.exe'
        Distractors = 'powershell.exe', 'ps.cmd', 'pwsh.cmd', 'ps7.exe'
        Note        = 'This also true on non-Windows systems.'
    }
    Question @{
        Question    = 'What additional remoting protocol is supported in PowerShell 7?'
        Answer      = 'ssh'
        Distractors = 'ftp', 'vpn', 'ras', 'scp', 'token ring'
        Note        = 'ssh must be installed and configured to support PowerShell 7 remoting'
    }
    Question @{
        Question    = 'Which of the following is NOT a PowerShell 7 feature?'
        Answer      = 'PowerShell workflow'
        Distractors = 'Ternary operator', 'pipeline chain operator', 'background operator', 'character ranges'
        Note        = 'help about_operators'
    }
    Question @{
        Question    = 'Which of the following modules is not supported or included with PowerShell 7?'
        Answer      = 'PSScheduledJob'
        Distractors = 'CimCmdlets', 'Microsoft.PowerShell.Archive', 'Microsoft.PowerShell.ThreadJob', 'PSDiagnostics'
    }
)
