# VanDenHout24
Paper Willemijn van den Hout et al. (2024)

De R syntax  dec2023_R_Syntax_each variabele, bevat het pre-proces van de gekregen raw data naar alle variabelen in aparte bestanden (echter dan nog niet gecleand). 

De syntaxen: Syntax_COPD, Syntax_DM1, Syntax_DM2, Syntax_depression, Syntax_diabetes, Syntax_eatingdisorders, Syntax_hypertension, Syntax_obesity, Syntax_overweight bevatten de cleaning van de comorbiditeiten met hun bijbehorende ICPC

De syntaxen: Syntax_labBMI_hoogste, Syntax_labweight, Syntax_labheight_geslacht bevatten de gecleande lab waarden van lengte gewicht en BMI.

De syntax: syntax_bmiheightweight_hoogste bevat de combinatie van de waarden van de gecleande lengte en het gecleande gewicht. Dit is samengevoegd tot een BMI waarde. Waarbij de BMI dan is berekend vanaf de gemeten lengte en het gemetne gewicht

De syntaxen: Syntax_combinatieallebmis bevat het samenvogen van de gecleande BMI lab waarde met de samengevoegde gecleande lengte en gewicht. Hierin wordt gekeken en besloten welke waarden wordt gekozen, dus de lab waarde of de berekende lengte/gewicht waarde.

De syntaxen: Syntax_insenuitschrijfdatum en Syntax_inschrijfdatum en Syntax_geboortejaar, bevat d ecleaning van deze datums, welke later gebruikt kunnen worden om de juiste patienten te selecteren.

De syntax: Syntax_databaseselctie_combinatietarievenendata .combineert de gecleande inschrijftarieven en inschrijfdata, waarop een keuze wordt gemaakt welke van de twee het meest adequaat is. Volgens de werkwijze vanuit CBS wordt in principe uitgegaan dat eerst de tarieven worden gebruikt, mocht die niet beschikbaar zijn dan wordt de inschrijf en uitschrijfdatum gebruikt.

De syntax: syntax_patfile_analyse bevat de analyse (tabellen en figuren) van de paper recording practices of BMI. Waarbij in de eerste stappen toch nog wat finetuning van de cleaning van de data was, omdat bleek dat sommige patienten onrealistisch oud waren..... Daarna volgen de analyses van de tabellen en figuren.


