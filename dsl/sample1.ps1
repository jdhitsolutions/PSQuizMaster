#sample DSL quiz file

#the quiz will be created in %TEMP%

#remove -protect to create a quiz with plaintext answers, distractors, and notes

Quiz 'New York' -protect @(
    @{
        Path        = $(Join-Path -Path ([system.io.path]::GetTempPath()) -ChildPath 'ny.quiz.json')
        Author      = 'Al Dente'
        Description = 'My sample DSL created quiz about New York state'
    }
    Question @{
        Question    = 'What is the capital of New York state?'
        Answer      = 'Albany'
        Distractors = 'Buffalo', 'Rochester', 'Syracuse', 'Ithaca', 'New York City'
    }
    Question @{
        Question    = 'What is the highest point in New York state?'
        Answer      = 'Mt Marcy'
        Distractors = 'Empire State Building', 'Niagara Falls', 'Tug Hill plateau', 'Mt Rushmore'
        Note        = 'Mt Marcy is in the Adirondacks and stands at 5344 ft'
    }
    Question @{
        Question    = "What New York waterway is known as Clinton's Big Ditch?"
        Answer      = 'The Erie Canal'
        Distractors = 'The Hudson River', 'Niagara Falls', 'Seneca Lake', 'The Big Moose River'
        Note        = 'The Erie Canal opened in 1825 and is still in use to day, primarily for recreational boating.'
    }
    Question @{
        Question    = 'What is the primary state motto of New York?'
        Answer      = 'Excelsior'
        Distractors = 'E Pluribus Unum', 'Lorem Ipsum Dolor', 'Veni, vedi, vici', 'Ad astra per aspera'
        Note        = "Excelsior means 'Ever Upward'. 'E pluribus unum was added as a secondary motto in 2020."
    }
    Question @{
        Question    = 'What is the state fruit?'
        Answer      = 'Apple'
        Distractors = 'Pear', 'Blueberry', 'Peach', 'Grape', 'Cherry'
    }
)
