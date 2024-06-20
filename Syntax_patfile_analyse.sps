* Encoding: UTF-8.
* Encoding: .
* Encoding: .
* Encoding: .
*BMI-ELAN project*
*willemijn van den hout*
*bewerkt op 04-01-2023*



*analyse pat file voor bmi project met alles inclsuief bmis en icpcs etc. openzetten..
*variableen goed maken voor gebruik.
Alter type iOverlijdensjaar (F8.0).

* nieuwe variabelen jaar maken van /inschrijfdatum/uitschrijfdatum/datum bmis'. 
COMPUTE combinatieinschrijfdatumentarief_jaar=XDATE.YEAR(combinatieinschrijfdatumentarief).
VARIABLE LABELS combinatieinschrijfdatumentarief_jaar.
VARIABLE LEVEL combinatieinschrijfdatumentarief_jaar(SCALE).
FORMATS combinatieinschrijfdatumentarief_jaar(F8.0).
VARIABLE WIDTH combinatieinschrijfdatumentarief_jaar(8).
EXECUTE.

* nieuwe variabelen jaar maken van /inschrijfdatum/uitschrijfdatum/datum bmis'. 
COMPUTE combinatieuitschrijfdatumentarief_jaar=XDATE.YEAR(combinatieuitschrijfdatumentarief).
VARIABLE LABELS combinatieuitschrijfdatumentarief_jaar.
VARIABLE LEVEL combinatieuitschrijfdatumentarief_jaar(SCALE).
FORMATS combinatieuitschrijfdatumentarief_jaar(F8.0).
VARIABLE WIDTH combinatieuitschrijfdatumentarief_jaar(8).
EXECUTE.

*-----------------------------------------------------------------------.
*iedereen die nog geen 19 jaar is geworden eruit halen tijdens inschrijfperiode in de praktijk.
FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=761691

*datum begin periode onderzoek na 18 jaar, we doen plus 19 omdat in eht jaar dat de patietn 18 wordt de icpc's en lab data niet zijn megenomen, we nemen ze pas mee vanaf het 19e levensjaar..
compute Jaar19jaar=iGeboortejaar+19.
execute.

formats Jaar19jaar (f8.0).
*alle patienten slecteren die weer uitgeschreven waren voor het 18e levensjaar want we kijken alleen naar iedereen die 18 jaar en ouder is.
Temporary.
Select if Jaar19jaar>combinatieuitschrijfdatumentarief_jaar.
list Jaar19jaar combinatieuitschrijfdatumentarief_jaar.
FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=15082

Temporary.
Select if (Jaar19jaar<=combinatieuitschrijfdatumentarief_jaar) OR (missing(combinatieuitschrijfdatumentarief_jaar)) or missing (Jaar19Jaar).
FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=746609.


*deze zijn nog geen 18 geworden in onze odnerzoeksperiode ejn er dus helemaal uit halen of er is geen geboortejaar bekend..
Filter off.
UsE ALL.
select if (Jaar19jaar<=combinatieuitschrijfdatumentarief_jaar) OR (missing(combinatieuitschrijfdatumentarief_jaar)) or missing (Jaar19Jaar).
EXECUTE.

FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.


*746609.

*------------------overleden patienten voordat ze ingeschreven waren ind e praktijk------------------------------------------------.
*kijken of overlijdensjaar geliik is aan unschrijfdatum.

FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=746609.

temporary.
select if iOverlijdensjaar<combinatieinschrijfdatumentarief_jaar.
List combinatieinschrijfdatumentarief_jaar combinatieinschrijfdatumentarief_jaar iOverlijdensjaar.
FREQUENCIES VARIABLES=iOverlijdensjaar
  /ORDER=ANALYSIS.
*n=3.



Filter off.
UsE ALL.
select if iOverlijdensjaar>=combinatieinschrijfdatumentarief_jaar or missing(combinatieinschrijfdatumentarief) or missing (iOverlijdensjaar).
EXECUTE.

FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*N=746606.. 


*------------------------------------------------------------*
*Het selecteren van de juiste van onderzoeksperiode follow-up voor iedere patient.
*Pas van 18e levensjaar gaat iemand mee doen dua sl inschrijfdatum voor 18e valt, dan het op het 18e levensjaar zetten ipv op de inschrijfdatum).

*BEGINNEN MET BEGINONDERZOEKSPERIODE  AFHANKELIJK VAN LEEFTIJD EN STARTSDATUM IN PRAKTIJK.
FREQUENCIES VARIABLES=combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*inschrijf N=703348.
*uitschrijf N=696484

Temporary.
Select if Jaar19jaar>combinatieinschrijfdatumentarief_jaar.
list Jaar19jaar combinatieinschrijfdatumentarief_jaar.
FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=90217.



COMPUTE Datum19jaar=DATE.DMY(01, 01, Jaar19jaar).
VARIABLE LABELS  Datum19jaar "".
VARIABLE LEVEL  Datum19jaar (SCALE).
FORMATS  Datum19jaar (DATE11).
VARIABLE WIDTH  Datum19jaar(11).
eXECUTE.

compute beginonderzoeksperiode_date=combinatieinschrijfdatumentarief.
do if Datum19jaar>combinatieinschrijfdatumentarief.
    compute beginonderzoeksperiode_date = Datum19jaar.
end if.
execute.

FORMATS beginonderzoeksperiode_date (date11).

*contrloleren of compute goed is gegaan.
temporary.
select if beginonderzoeksperiode_date NE combinatieinschrijfdatumentarief.
FREQUENCIES VARIABLES=beginonderzoeksperiode_date
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=beginonderzoeksperiode_date
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.


*patienten pas vanaf 2007 meenemen in de follow up.
Temporary.
select if Beginonderzoeksperiode_date<DATE.DMY(01, 01, 2007).
FREQUENCIES VARIABLES=beginonderzoeksperiode_date
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=232.748.


do if beginonderzoeksperiode_date<DATE.DMY(01, 01, 2007).
    compute beginonderzoeksperiode_date = DATE.DMY(01, 01, 2007).
end if.
execute.

Temporary.
select if Beginonderzoeksperiode_date<DATE.DMY(01, 01, 2007).
FREQUENCIES VARIABLES=beginonderzoeksperiode_date
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.


FREQUENCIES VARIABLES=beginonderzoeksperiode_date
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.


*nu EINDONDERZOEKSPERIODE MAKEN afhankelijk van overlijdensjaar maken. Dus als mensen eerder zijn overleden dan uitschrijfdatum is overlijdensjaar.

temporary.
select if iOverlijdensjaar < combinatieuitschrijfdatumentarief_jaar.
list iOverlijdensjaar combinatieuitschrijfdatumentarief_jaar.
FREQUENCIES VARIABLES=iOverlijdensjaar
  /ORDER=ANALYSIS.
*n=24.

*onderzoeksperiode follow-up met datum maken
    * Date and Time Wizard: overlijdensdatum.
COMPUTE  overlijdensdatum=DATE.DMY(31, 12, iOverlijdensjaar).
VARIABLE LABELS overlijdensdatum "".
VARIABLE LEVEL overlijdensdatum (SCALE).
FORMATS  overlijdensdatum (DATE11).
VARIABLE WIDTH  overlijdensdatum(11).
EXECUTE.

compute eindeonderzoeksperiode_date=combinatieuitschrijfdatumentarief.
do if iOverlijdensjaar<combinatieuitschrijfdatumentarief_jaar.
    compute eindeonderzoeksperiode_date = overlijdensdatum.
end if.
execute.

FORMATS eindeonderzoeksperiode_date (date11).

temporary.
select if eindeonderzoeksperiode_date NE combinatieuitschrijfdatumentarief.
FREQUENCIES VARIABLES=eindeonderzoeksperiode_date
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=eindeonderzoeksperiode_date
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.


*even controleren of er nu geen beginonderzoeksperiode  voo reindeonderzoeksperiode is.
Temporary.
Select if eindeonderzoeksperiode_date<beginonderzoeksperiode_date.
list eindeonderzoeksperiode_date beginonderzoeksperiode_date patnr.
*n=1 patietn is overleden in 19e levensjaar. *bij follow-up wordt deze verwijderd want duur follow-up is nu 0.


*mensen staan voor 3 maanden ingeschreven nadat een tarief ontvangen is degen waarvan de datum nu nog een tarief is daarbij bij uitschrijfdatum dus 3 maanden optellen. 
*Einde gekregen onderzoeksperiode  van henk 30-06-2023 met betreffende icpc's =30 juni. daarnaast laatste tarief ontvangen op 1 juli 2023, dus 1 juli wel op 1 juli laten staan.


Temporary.
Select if eindeonderzoeksperiode_date= DATE.DMY(01, 07, 2023).
FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=338.792.

temporary.
select if (laatsteuitschrijftariefdatum=eindeonderzoeksperiode_date) AND (eindeonderzoeksperiode_date NE DATE.DMY(01, 07, 2023)).
FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*N=271.824.

Do if (laatsteuitschrijftariefdatum=eindeonderzoeksperiode_date) AND (eindeonderzoeksperiode_date NE DATE.DMY(01, 07, 2023)).
Compute eindeonderzoeksperiode_date=DATESUM(eindeonderzoeksperiode_date, 3, "months", 'closest').
end if.
execute.


Temporary.
Select if eindeonderzoeksperiode_date<beginonderzoeksperiode_date.
list eindeonderzoeksperiode_date beginonderzoeksperiode_date.




*leeftijd op begin onderzoeksperiode of einde onderzoeksperiode variabele aanmaken voor flowchart. En daardoor dus berekeken of er mensen onwaarschijnlijk oud zijn geworden afkappunt>112 jaar genomen.


COMPUTE beginonderzoeksperiode_jaar=XDATE.YEAR(beginonderzoeksperiode_date).
VARIABLE LABELS  beginonderzoeksperiode_jaar.
VARIABLE LEVEL  beginonderzoeksperiode_jaar(SCALE).
FORMATS  beginonderzoeksperiode_jaar(F8.0).
VARIABLE WIDTH  beginonderzoeksperiode_jaar(8).
EXECUTE.


COMPUTE eindeonderzoeksperiode_jaar=XDATE.YEAR(eindeonderzoeksperiode_date).
VARIABLE LABELS  eindeonderzoeksperiode_jaar.
VARIABLE LEVEL  eindeonderzoeksperiode_jaar(SCALE).
FORMATS  eindeonderzoeksperiode_jaar(F8.0).
VARIABLE WIDTH  eindeonderzoeksperiode_jaar(8).
EXECUTE.

compute leeftijdbeginonderzoeksperiode=beginonderzoeksperiode_jaar-iGeboortejaar.
execute.

compute leeftijdeindeonderzoeksperiode=eindeonderzoeksperiode_jaar-iGeboortejaar.
execute.


*---------------------------------------------------------------------------------------


*FLOW CHART 1.
* de cases nog eruit halen die missend zijn in data. Flow chart 1.

FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=746606.

temporary.
select if missing (combinatieinschrijfdatumentarief) OR missing (combinatieuitschrijfdatumentarief).
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=50546.
temporary.
select if missing (iGeboortejaar) OR leeftijdeindeonderzoeksperiode>112.
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
  *n=594.

temporary.
select if missing (combinatieinschrijfdatumentarief) OR missing (combinatieuitschrijfdatumentarief) OR missing (iGeboortejaar) OR leeftijdeindeonderzoeksperiode>112.
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=50949,



Temporary.
Select if not missing(combinatieuitschrijfdatumentarief) AND (not missing(combinatieinschrijfdatumentarief) AND (not missing(iGeboortejaar))) AND leeftijdeindonderzoeksperiode<=112.
FREQUENCIES VARIABLES= PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

Temporary.
    select if leeftijdeindeonderzoeksperiode>112.
FREQUENCIES VARIABLES= PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=135.

FILTER OFF.
USE ALL.
SELECT IF (not missing(combinatieuitschrijfdatumentarief) AND not 
    missing(combinatieinschrijfdatumentarief) AND not missing(iGeboortejaar)).
EXECUTE.

Filter off. 
Use all.
Select if leeftijdeindeonderzoeksperiode<=112.
execute.

FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
   *N=676.708. 



* Date and Time Wizard: follow_up_duur.
COMPUTE  follow_up_duur=(eindeonderzoeksperiode_date - beginonderzoeksperiode_date) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  follow_up_duur.
VARIABLE LEVEL  follow_up_duur (SCALE).
FORMATS  follow_up_duur (F8.2).
VARIABLE WIDTH  follow_up_duur(8).
EXECUTE.


temporary.
select if follow_up_duur=0.
FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=8394.

*follow-up duur korter dan eeen maand. 1 maand=0.083 jaar.
temporary.
    select if follow_up_duur<0.08333.  
FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=18949.

filter off.
USE ALL.
    select if follow_up_duur>=0.083333.  
EXECUTE.


*dit is de uiteindelijke database.
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
  *N=676.708.



*BMI's nog aan deze file toevoegen invan de BMIFILE --> RIJEN_BMIsonzeonderzoeksperiode_VOORANALYSE!!.

DATASET ACTIVATE DataSet1.
GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Files voor '+
    'analyse\NIEUWE\BMI file\RIJEN_BMIsleeftijdscategorie_VOORANALYSE.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /RENAME (dCategoriePatient EndDate StartDate Datum19jaar = d0 d1 d2 d3) 
  /FILE='DataSet2'
  /RENAME (beginonderzoeksperiode_date Datum19jaar eindeonderzoeksperiode_date follow_up_duur 
    geslacht_num iGeboortejaar iOverlijdensjaar Systeem Systeem_samengevoegdpromedico = d4 d5 d6 d7 d8 
    d9 d10 d11 d12) 
  /BY PATNR
  /DROP= d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12.
EXECUTE.


*dit is opnieuw toegevoegde bmis per leeftijdscategorie nu ook met datum van bmis gemetne.
DATASET ACTIVATE DataSet1.
GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Files voor '+
    'analyse\NIEUWE\BMI file\RIJEN_metdatumeerstebmi_leeftijdscategorie_VOORANALYSE.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY PATNR.
EXECUTE.

*en de bmis per jaar van 2007-2023.

DATASET ACTIVATE DataSet1.
GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Files voor '+
    'analyse\NIEUWE\BMI file\RIJEN_BMIsonzeonderzoeksperiode_perjaa_VOORANALYSE.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY PATNR.
EXECUTE.


*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------.
*variableen goed maken voor analyse..


RECODE dGeslacht ('M'=0) ('V'=1) (ELSE=sysmis) into geslacht_num.
Value labels geslacht_num 0 'man' 1 'vrouw'.
Formats geslacht_num (f6.0).
execute.

Delete variables dGeslacht.


Value labels Systeem 1 'Medicom' 3 'Promedico vdf' 5 'Microhis' 6 'Omnihis' 7 'Promedico asp'.

*in systeem de promedico vdf en asp samenveogen.
Recode Systeem (1=1) (3=2) (7=2) (5=3) (6=4) INTO Systeem_samengevoegdpromedico.
    Value labels Systeem_samengevoegdpromedico 1 'Medicom' 2 'Promedico vdf en asp' 3 'Microhis' 4 'Omnihis'.
EXECUTE.



FREQUENCIES VARIABLES=PATNR
/FORMAT=NOTABLE
  /ORDER=ANALYSIS.





*-------------------------------------------------------------------------------------.
*BMI waarden goed maken voor analsye. categoriale waarde van eerste availabe bmi.

RECODE BMIall_onderzoeksperiode (SYSMIS=SYSMIS) (30 thru Highest=3) (25.00000 thru 30.00000=2) (Lowest thru 25.0000000=1) 
    INTO BMIcat.
EXECUTE.

If missing (leeftijdscategorieBMI1) leeftijdscategorieBMI1=0.
execute.
If missing (leeftijdscategorieBMI2) leeftijdscategorieBMI2=0.
execute.
If missing (leeftijdscategorieBMI3) leeftijdscategorieBMI3=0.
execute.
If missing (leeftijdscategorieBMI4) leeftijdscategorieBMI4=0.
execute.
If missing (leeftijdscategorieBMI5) leeftijdscategorieBMI5=0.
execute.
If missing (leeftijdscategorieBMI6) leeftijdscategorieBMI6=0.
execute.
If missing (leeftijdscategorieBMI7) leeftijdscategorieBMI7=0.
execute.

If missing (bmiavailable) bmiavailable=0.
execute.
*-------------------------------------------------------------------------------------------------.


*persoonsjaren berekenen.


*persoonsjaren in categorie berekenen.
*datums maken van leeftijden, die van 19 bestaat al.
compute Jaar31jaar=iGeboortejaar+31.
execute.

formats Jaar31jaar (f8.0).

COMPUTE Datum31jaar=DATE.DMY(01, 01, Jaar31jaar).
VARIABLE LABELS  Datum31jaar "".
VARIABLE LEVEL  Datum31jaar (SCALE).
FORMATS  Datum31jaar (DATE11).
VARIABLE WIDTH  Datum31jaar(11).
eXECUTE.

compute Jaar41jaar=iGeboortejaar+41.
execute.

formats Jaar41jaar (f8.0).

COMPUTE Datum41jaar=DATE.DMY(01, 01, Jaar41jaar).
VARIABLE LABELS  Datum41jaar "".
VARIABLE LEVEL  Datum41jaar (SCALE).
FORMATS  Datum41jaar (DATE11).
VARIABLE WIDTH  Datum41jaar(11).
eXECUTE.


compute Jaar51jaar=iGeboortejaar+51.
execute.

formats Jaar51jaar (f8.0).

COMPUTE Datum51jaar=DATE.DMY(01, 01, Jaar51jaar).
VARIABLE LABELS  Datum51jaar "".
VARIABLE LEVEL  Datum51jaar (SCALE).
FORMATS  Datum51jaar (DATE11).
VARIABLE WIDTH  Datum51jaar(11).
eXECUTE.



compute Jaar61jaar=iGeboortejaar+61.
execute.

formats Jaar61jaar (f8.0).

COMPUTE Datum61jaar=DATE.DMY(01, 01, Jaar61jaar).
VARIABLE LABELS  Datum61jaar "".
VARIABLE LEVEL  Datum61jaar (SCALE).
FORMATS  Datum61jaar (DATE11).
VARIABLE WIDTH  Datum61jaar(11).
eXECUTE.



compute Jaar71jaar=iGeboortejaar+71.
execute.

formats Jaar71jaar (f8.0).

COMPUTE Datum71jaar=DATE.DMY(01, 01, Jaar71jaar).
VARIABLE LABELS  Datum71jaar "".
VARIABLE LEVEL  Datum71jaar (SCALE).
FORMATS  Datum71jaar (DATE11).
VARIABLE WIDTH  Datum71jaar(11).
eXECUTE.


compute Jaar81jaar=iGeboortejaar+81.
execute.

formats Jaar71jaar (f8.0).

COMPUTE Datum81jaar=DATE.DMY(01, 01, Jaar81jaar).
VARIABLE LABELS  Datum81jaar "".
VARIABLE LEVEL  Datum81jaar (SCALE).
FORMATS  Datum81jaar (DATE11).
VARIABLE WIDTH  Datum81jaar(11).
eXECUTE.

Delete variables Jaar31jaar Jaar41jaar Jaar51jaar Jaar61jaar Jaar71jaar Jaar81jaar.

*leeftijd op begin onderzoeksperiode of einde onderzoeksperiode.


COMPUTE beginonderzoeksperiode_jaar=XDATE.YEAR(beginonderzoeksperiode_date).
VARIABLE LABELS  beginonderzoeksperiode_jaar.
VARIABLE LEVEL  beginonderzoeksperiode_jaar(SCALE).
FORMATS  beginonderzoeksperiode_jaar(F8.0).
VARIABLE WIDTH  beginonderzoeksperiode_jaar(8).
EXECUTE.


COMPUTE eindeonderzoeksperiode_jaar=XDATE.YEAR(eindeonderzoeksperiode_date).
VARIABLE LABELS  eindeonderzoeksperiode_jaar.
VARIABLE LEVEL  eindeonderzoeksperiode_jaar(SCALE).
FORMATS  eindeonderzoeksperiode_jaar(F8.0).
VARIABLE WIDTH  eindeonderzoeksperiode_jaar(8).
EXECUTE.

compute leeftijdbeginonderzoeksperiode=beginonderzoeksperiode_jaar-iGeboortejaar.
execute.

compute leeftijdeindeonderzoeksperiode=eindeonderzoeksperiode_jaar-iGeboortejaar.
execute.




* per leeftijdscategorei kijken of de begin en eind leeftijd in onze onderzoeksperiode daarin ligt.
*leeftijdscategorie1.

Do if leeftijdbeginonderzoeksperiode<31.
compute leeftijdscategorie1start=beginonderzoeksperiode_date.
else if leeftijdbeginonderzoeksperiode>=31.
compute leeftijdscategorie1start=$SYSMIS.
else.
end if.
execute.


Do if leeftijdeindeonderzoeksperiode<31.
compute leeftijdscategorie1einde=eindeonderzoeksperiode_date.
else if not missing (leeftijdscategorie1start).
compute leeftijdscategorie1einde = Datum31jaar.
else if leeftijdeindeonderzoeksperiode>=31.
compute leeftijdscategorie1einde=$SYSMIS.
else.
end if.
execute.


FORMATS leeftijdscategorie1start leeftijdscategorie1einde(date11).


*LEEFTIJDSCATEGORIE2.

Do if (eindeonderzoeksperiode_date NE leeftijdscategorie1einde) AND not missing (leeftijdscategorie1einde).
compute leeftijdscategorie2start =Datum31jaar.
else if leeftijdbeginonderzoeksperiode>=31 AND leeftijdbeginonderzoeksperiode<41.
compute leeftijdscategorie2start=beginonderzoeksperiode_date.
else if leeftijdbeginonderzoeksperiode<31 AND leeftijdbeginonderzoeksperiode>=41.
compute leeftijdscategorie2start=$SYSMIS.
else.
end if.
execute.

*de laatste commando sluit aan dat iemand uit de leeftijdscategorie gaatt voor dat hij 31 is geworden) hij telt het jaar van het 31 worden niet meer mee. uds hij gaat eruit op uitschrijfdatum en verjaardag)

Do if leeftijdeindeonderzoeksperiode>=31 AND leeftijdeindeonderzoeksperiode<41 AND (eindeonderzoeksperiode_date NE Datum31jaar).
compute leeftijdscategorie2einde=eindeonderzoeksperiode_date.
else if not missing (leeftijdscategorie2start).
compute leeftijdscategorie2einde = Datum41jaar.
else if leeftijdeindeonderzoeksperiode<31 AND leeftijdeindeonderzoeksperiode>=41.
compute leeftijdscategorie2einde=$SYSMIS.
else.
end if.
execute.

FORMATS leeftijdscategorie2start leeftijdscategorie2einde(date11).



*LEEFTIJDSCATEGORIE3.



Do if (eindeonderzoeksperiode_date NE leeftijdscategorie2einde) AND not missing (leeftijdscategorie2einde).
compute leeftijdscategorie3start =Datum41jaar.
else if leeftijdbeginonderzoeksperiode>=41 AND leeftijdbeginonderzoeksperiode<51.
compute leeftijdscategorie3start=beginonderzoeksperiode_date.
else if leeftijdbeginonderzoeksperiode<41 AND leeftijdbeginonderzoeksperiode>=51.
compute leeftijdscategorie3start=$SYSMIS.
else.
end if.
execute.

*de laatste commando sluit aan dat iemand uit de leeftijdscategorie gaatt voor dat hij 31 is geworden) hij telt het jaar van het 31 worden niet meer mee. uds hij gaat eruit op uitschrijfdatum en verjaardag)

Do if leeftijdeindeonderzoeksperiode>=41 AND leeftijdeindeonderzoeksperiode<51 AND (eindeonderzoeksperiode_date NE Datum41jaar).
compute leeftijdscategorie3einde=eindeonderzoeksperiode_date.
else if not missing (leeftijdscategorie3start).
compute leeftijdscategorie3einde = Datum51jaar.
else if leeftijdeindeonderzoeksperiode<41 AND leeftijdeindeonderzoeksperiode>=51.
compute leeftijdscategorie3einde=$SYSMIS.
else.
end if.
execute.


FORMATS leeftijdscategorie3start leeftijdscategorie3einde(date11).



*LEEFTIJDSCATEGORIE4.

Do if (eindeonderzoeksperiode_date NE leeftijdscategorie3einde) AND not missing (leeftijdscategorie3einde).
compute leeftijdscategorie4start =Datum51jaar.
else if leeftijdbeginonderzoeksperiode>=51 AND leeftijdbeginonderzoeksperiode<61.
compute leeftijdscategorie4start=beginonderzoeksperiode_date.
else if leeftijdbeginonderzoeksperiode<51 AND leeftijdbeginonderzoeksperiode>=61.
compute leeftijdscategorie4start=$SYSMIS.
else.
end if.
execute.

*de laatste commando sluit aan dat iemand uit de leeftijdscategorie gaatt voor dat hij 31 is geworden) hij telt het jaar van het 31 worden niet meer mee. uds hij gaat eruit op uitschrijfdatum en verjaardag)

Do if leeftijdeindeonderzoeksperiode>=51 AND leeftijdeindeonderzoeksperiode<61 AND (eindeonderzoeksperiode_date NE Datum51jaar).
compute leeftijdscategorie4einde=eindeonderzoeksperiode_date.
else if not missing (leeftijdscategorie4start).
compute leeftijdscategorie4einde = Datum61jaar.
else if leeftijdeindeonderzoeksperiode<51 AND leeftijdeindeonderzoeksperiode>=61.
compute leeftijdscategorie4einde=$SYSMIS.
else.
end if.
execute.


FORMATS leeftijdscategorie4start leeftijdscategorie4einde(date11).



*LEEFTIJDSCATEGORIE5.


Do if (eindeonderzoeksperiode_date NE leeftijdscategorie4einde) AND not missing (leeftijdscategorie4einde).
compute leeftijdscategorie5start =Datum61jaar.
else if leeftijdbeginonderzoeksperiode>=61 AND leeftijdbeginonderzoeksperiode<71.
compute leeftijdscategorie5start=beginonderzoeksperiode_date.
else if leeftijdbeginonderzoeksperiode<61 AND leeftijdbeginonderzoeksperiode>=71.
compute leeftijdscategorie5start=$SYSMIS.
else.
end if.
execute.

*de laatste commando sluit aan dat iemand uit de leeftijdscategorie gaatt voor dat hij 31 is geworden) hij telt het jaar van het 31 worden niet meer mee. uds hij gaat eruit op uitschrijfdatum en verjaardag)

Do if leeftijdeindeonderzoeksperiode>=61 AND leeftijdeindeonderzoeksperiode<71 AND (eindeonderzoeksperiode_date NE Datum61jaar).
compute leeftijdscategorie5einde=eindeonderzoeksperiode_date.
else if not missing (leeftijdscategorie5start).
compute leeftijdscategorie5einde = Datum71jaar.
else if leeftijdeindeonderzoeksperiode<61 AND leeftijdeindeonderzoeksperiode>=71.
compute leeftijdscategorie5einde=$SYSMIS.
else.
end if.
execute.


FORMATS leeftijdscategorie5start leeftijdscategorie5einde(date11).



*LEEFTIJDSCATEGORIE 6.

Do if (eindeonderzoeksperiode_date NE leeftijdscategorie5einde) AND not missing (leeftijdscategorie5einde).
compute leeftijdscategorie6start =Datum71jaar.
else if leeftijdbeginonderzoeksperiode>=71 AND leeftijdbeginonderzoeksperiode<81.
compute leeftijdscategorie6start=beginonderzoeksperiode_date.
else if leeftijdbeginonderzoeksperiode<71 AND leeftijdbeginonderzoeksperiode>=81.
compute leeftijdscategorie6start=$SYSMIS.
else.
end if.
execute.

*de laatste commando sluit aan dat iemand uit de leeftijdscategorie gaatt voor dat hij 31 is geworden) hij telt het jaar van het 31 worden niet meer mee. uds hij gaat eruit op uitschrijfdatum en verjaardag)

Do if leeftijdeindeonderzoeksperiode>=71 AND leeftijdeindeonderzoeksperiode<81 AND (eindeonderzoeksperiode_date NE Datum71jaar).
compute leeftijdscategorie6einde=eindeonderzoeksperiode_date.
else if not missing (leeftijdscategorie6start).
compute leeftijdscategorie6einde = Datum81jaar.
else if leeftijdeindeonderzoeksperiode<71 AND leeftijdeindeonderzoeksperiode>=81.
compute leeftijdscategorie6einde=$SYSMIS.
else.
end if.
execute.


FORMATS leeftijdscategorie6start leeftijdscategorie6einde(date11).

*LEEFTIJDSCATEGORIE 7.

*de laatste commando sluit aan dat iemand uit de leeftijdscategorie gaatt voor dat hij 31 is geworden) hij telt het jaar van het 31 worden niet meer mee. uds hij gaat eruit op uitschrijfdatum en verjaardag)

Do if (eindeonderzoeksperiode_date NE leeftijdscategorie6einde) AND not missing (leeftijdscategorie6einde).
compute leeftijdscategorie7start =Datum81jaar.
else if leeftijdbeginonderzoeksperiode>=81. 
compute leeftijdscategorie7start=beginonderzoeksperiode_date.
else if leeftijdbeginonderzoeksperiode<81.
compute leeftijdscategorie7start=$SYSMIS.
else.
end if.
execute.

*de laatste commando sluit aan dat iemand uit de leeftijdscategorie gaatt voor dat hij 31 is geworden) hij telt het jaar van het 31 worden niet meer mee. uds hij gaat eruit op uitschrijfdatum en verjaardag)

Do if leeftijdeindeonderzoeksperiode>=81 AND (eindeonderzoeksperiode_date NE Datum81jaar).
compute leeftijdscategorie7einde=eindeonderzoeksperiode_date.
else if not missing (leeftijdscategorie7start).
compute leeftijdscategorie7einde = eindeonderzoeksperiode_date.
else if leeftijdeindeonderzoeksperiode<81.
compute leeftijdscategorie7einde=$SYSMIS.
else.
end if.
execute.

FORMATS leeftijdscategorie7start leeftijdscategorie7einde(date11).


*persoonsjaren na bmi meting eruit halen.
If leeftijdscategorieBMI1=1 leeftijdscategorie1einde=datumbmileeftijdscategorie1.
If leeftijdscategorieBMI2=1 leeftijdscategorie2einde=datumbmileeftijdscategorie2.
If leeftijdscategorieBMI3=1 leeftijdscategorie3einde=datumbmileeftijdscategorie3.
If leeftijdscategorieBMI4=1 leeftijdscategorie4einde=datumbmileeftijdscategorie4.
If leeftijdscategorieBMI5=1 leeftijdscategorie5einde=datumbmileeftijdscategorie5.
If leeftijdscategorieBMI6=1 leeftijdscategorie6einde=datumbmileeftijdscategorie6.
If leeftijdscategorieBMI7=1 leeftijdscategorie7einde=datumbmileeftijdscategorie7.
EXECUTE.


*BEREKEN VAN PERSOONSJAREN IN IEDERE CATEGORIE.)..

* Date and Time Wizard: persoonsjarencategorie1.
COMPUTE  persoonsjarencategorie1=(leeftijdscategorie1einde - leeftijdscategorie1start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjarencategorie1.
VARIABLE LEVEL  persoonsjarencategorie1 (SCALE).
FORMATS  persoonsjarencategorie1 (F8.2).
VARIABLE WIDTH  persoonsjarencategorie1(8).
EXECUTE.


COMPUTE  persoonsjarencategorie2=(leeftijdscategorie2einde - leeftijdscategorie2start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjarencategorie2.
VARIABLE LEVEL  persoonsjarencategorie2 (SCALE).
FORMATS  persoonsjarencategorie2 (F8.2).
VARIABLE WIDTH  persoonsjarencategorie2(8).
EXECUTE.


COMPUTE  persoonsjarencategorie3=(leeftijdscategorie3einde - leeftijdscategorie3start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjarencategorie3.
VARIABLE LEVEL  persoonsjarencategorie3 (SCALE).
FORMATS  persoonsjarencategorie3 (F8.2).
VARIABLE WIDTH  persoonsjarencategorie3(8).
EXECUTE.


COMPUTE  persoonsjarencategorie4=(leeftijdscategorie4einde - leeftijdscategorie4start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjarencategorie4.
VARIABLE LEVEL  persoonsjarencategorie4 (SCALE).
FORMATS  persoonsjarencategorie4 (F8.2).
VARIABLE WIDTH  persoonsjarencategorie4(8).
EXECUTE.

COMPUTE  persoonsjarencategorie5=(leeftijdscategorie5einde - leeftijdscategorie5start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjarencategorie5.
VARIABLE LEVEL  persoonsjarencategorie5 (SCALE).
FORMATS  persoonsjarencategorie5 (F8.2).
VARIABLE WIDTH  persoonsjarencategorie5 (8).
EXECUTE.

COMPUTE  persoonsjarencategorie6=(leeftijdscategorie6einde - leeftijdscategorie6start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjarencategorie6.
VARIABLE LEVEL  persoonsjarencategorie6 (SCALE).
FORMATS  persoonsjarencategorie6 (F8.2).
VARIABLE WIDTH  persoonsjarencategorie6 (8).
EXECUTE.


COMPUTE  persoonsjarencategorie7=(leeftijdscategorie7einde - leeftijdscategorie7start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjarencategorie7.
VARIABLE LEVEL  persoonsjarencategorie7 (SCALE).
FORMATS  persoonsjarencategorie7 (F8.2).
VARIABLE WIDTH  persoonsjarencategorie7 (8).
EXECUTE.



If missing (persoonsjarencategorie1) persoonsjarencategorie1=0.
execute.
If missing (persoonsjarencategorie2) persoonsjarencategorie2=0.
execute.
If missing (persoonsjarencategorie3) persoonsjarencategorie3=0.
execute.
If missing (persoonsjarencategorie4) persoonsjarencategorie4=0.
execute.
If missing (persoonsjarencategorie5) persoonsjarencategorie5=0.
execute.
If missing (persoonsjarencategorie6) persoonsjarencategorie6=0.
execute.
If missing (persoonsjarencategorie7) persoonsjarencategorie7=0.
execute.


*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
*NU ook per jaar maken het aantal persoonsjaren 2007-2023.

If missing (BMIinjaar2007) BMIinjaar2007=0.
EXECUTE.
If missing (BMIinjaar2008) BMIinjaar2008=0.
EXECUTE.
If missing (BMIinjaar2009) BMIinjaar2009=0.
EXECUTE.
If missing (BMIinjaar2010) BMIinjaar2010=0.
EXECUTE.
If missing (BMIinjaar2011) BMIinjaar2011=0.
EXECUTE.
If missing (BMIinjaar2012) BMIinjaar2012=0.
EXECUTE.
If missing (BMIinjaar2013) BMIinjaar2013=0.
EXECUTE.
If missing (BMIinjaar2014) BMIinjaar2014=0.
EXECUTE.
If missing (BMIinjaar2015) BMIinjaar2015=0.
EXECUTE.
If missing (BMIinjaar2016) BMIinjaar2016=0.
EXECUTE.
If missing (BMIinjaar2017) BMIinjaar2017=0.
EXECUTE.
If missing (BMIinjaar2018) BMIinjaar2018=0.
EXECUTE.
If missing (BMIinjaar2019) BMIinjaar2019=0.
EXECUTE.
If missing (BMIinjaar2020) BMIinjaar2020=0.
EXECUTE.
If missing (BMIinjaar2021) BMIinjaar2021=0.
EXECUTE.
If missing (BMIinjaar2022) BMIinjaar2022=0.
EXECUTE.
If missing (BMIinjaar2023) BMIinjaar2023=0.
EXECUTE.


*JAAR 2007.

Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2007) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2007)  .
    compute persoonsjaren2007start=DATE.DMY (01,01,2007).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2007) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2007).
compute persoonsjaren2007start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2007) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2007).
compute persoonsjaren2007eind=DATE.DMY (31,12, 2007).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2007) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2007).
 compute persoonsjaren2007eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2007=1.
    compute persoonsjaren2007eind=eerstedatumbmi2007.
end if.
execute.

FORMATS persoonsjaren2007start persoonsjaren2007eind (date11).

COMPUTE  persoonsjaren2007=(persoonsjaren2007eind - persoonsjaren2007start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2007.
VARIABLE LEVEL  persoonsjaren2007 (SCALE).
FORMATS  persoonsjaren2007 (F8.2).
VARIABLE WIDTH  persoonsjaren2007 (8).
EXECUTE.

*JAAR 2008.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2008) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2008)  .
    compute persoonsjaren2008start=DATE.DMY (01,01,2008).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2008) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2008).
compute persoonsjaren2008start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2008) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2008).
compute persoonsjaren2008eind=DATE.DMY (31,12, 2008).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2008) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2008).
 compute persoonsjaren2008eind=eindeonderzoeksperiode_date.
end if.
execute.


do if BMIinjaar2008=1.
    compute persoonsjaren2008eind=eerstedatumbmi2008.
end if.
execute.

FORMATS persoonsjaren2008start persoonsjaren2008eind (date11).

COMPUTE  persoonsjaren2008=(persoonsjaren2008eind - persoonsjaren2008start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2008.
VARIABLE LEVEL  persoonsjaren2008 (SCALE).
FORMATS  persoonsjaren2008 (F8.2).
VARIABLE WIDTH  persoonsjaren2008 (8).
EXECUTE.


*JAAR 2009.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2009) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2009)  .
    compute persoonsjaren2009start=DATE.DMY (01,01,2009).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2009) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2009).
compute persoonsjaren2009start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2009) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2009).
compute persoonsjaren2009eind=DATE.DMY (31,12, 2009).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2009) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2009).
 compute persoonsjaren2009eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2009=1.
    compute persoonsjaren2009eind=eerstedatumbmi2009.
end if.
execute.

FORMATS persoonsjaren2009start persoonsjaren2009eind (date11).

COMPUTE  persoonsjaren2009=(persoonsjaren2009eind - persoonsjaren2009start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2009.
VARIABLE LEVEL  persoonsjaren2009 (SCALE).
FORMATS  persoonsjaren2009 (F8.2).
VARIABLE WIDTH  persoonsjaren2009 (8).
EXECUTE.


*JAAR 2010.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2010) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2010)  .
    compute persoonsjaren2010start=DATE.DMY (01,01,2010).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2010) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2010).
compute persoonsjaren2010start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2010) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2010).
compute persoonsjaren2010eind=DATE.DMY (31,12, 2010).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2010) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2010).
 compute persoonsjaren2010eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2010=1.
    compute persoonsjaren2010eind=eerstedatumbmi2010.
end if.
execute.

FORMATS persoonsjaren2010start persoonsjaren2010eind (date11).

COMPUTE  persoonsjaren2010=(persoonsjaren2010eind - persoonsjaren2010start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2010.
VARIABLE LEVEL  persoonsjaren2010 (SCALE).
FORMATS  persoonsjaren2010 (F8.2).
VARIABLE WIDTH  persoonsjaren2010 (8).
EXECUTE.


*JAAR 2011.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2011) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2011)  .
    compute persoonsjaren2011start=DATE.DMY (01,01,2011).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2011) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2011).
compute persoonsjaren2011start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2011) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2011).
compute persoonsjaren2011eind=DATE.DMY (31,12, 2011).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2011) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2011).
 compute persoonsjaren2011eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2011=1.
    compute persoonsjaren2011eind=eerstedatumbmi2011.
end if.
execute.

FORMATS persoonsjaren2011start persoonsjaren2011eind (date11).

COMPUTE  persoonsjaren2011=(persoonsjaren2011eind - persoonsjaren2011start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2011.
VARIABLE LEVEL  persoonsjaren2011 (SCALE).
FORMATS  persoonsjaren2011(F8.2).
VARIABLE WIDTH  persoonsjaren2011 (8).
EXECUTE.



*JAAR 2012.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2012) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2012)  .
    compute persoonsjaren2012start=DATE.DMY (01,01,2012).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2012) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2012).
compute persoonsjaren2012start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2012) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2012).
compute persoonsjaren2012eind=DATE.DMY (31,12, 2012).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2012) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2012).
 compute persoonsjaren2012eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2012=1.
    compute persoonsjaren2012eind=eerstedatumbmi2012.
end if.
execute.

FORMATS persoonsjaren2012start persoonsjaren2012eind (date11).

COMPUTE  persoonsjaren2012=(persoonsjaren2012eind - persoonsjaren2012start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2012.
VARIABLE LEVEL  persoonsjaren2012 (SCALE).
FORMATS  persoonsjaren2012 (F8.2).
VARIABLE WIDTH  persoonsjaren2012 (8).
EXECUTE.


*JAAR 2013.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2013) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2013)  .
    compute persoonsjaren2013start=DATE.DMY (01,01,2013).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2013) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2013).
compute persoonsjaren2013start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2013) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2013).
compute persoonsjaren2013eind=DATE.DMY (31,12, 2013).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2013) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2013).
 compute persoonsjaren2013eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2013=1.
    compute persoonsjaren2013eind=eerstedatumbmi2013.
end if.
execute.

FORMATS persoonsjaren2013start persoonsjaren2013eind (date11).

COMPUTE  persoonsjaren2013=(persoonsjaren2013eind - persoonsjaren2013start) / (365.25 * time.days(1)).
VARIABLE LABELS  persoonsjaren2013.
VARIABLE LEVEL  persoonsjaren2013 (SCALE).
FORMATS  persoonsjaren2013 (F8.2).
VARIABLE WIDTH  persoonsjaren2013 (8).
EXECUTE.


*JAAR 2014.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2014) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2014)  .
    compute persoonsjaren2014start=DATE.DMY (01,01,2014).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2014) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2014).
compute persoonsjaren2014start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2014) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2014).
compute persoonsjaren2014eind=DATE.DMY (31,12, 2014).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2014) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2014).
 compute persoonsjaren2014eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2014=1.
    compute persoonsjaren2014eind=eerstedatumbmi2014.
end if.
execute.

FORMATS persoonsjaren2014start persoonsjaren2014eind (date11).

COMPUTE  persoonsjaren2014=(persoonsjaren2014eind - persoonsjaren2014start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2014.
VARIABLE LEVEL  persoonsjaren2014 (SCALE).
FORMATS  persoonsjaren2014 (F8.2).
VARIABLE WIDTH  persoonsjaren2014 (8).
EXECUTE.


*JAAR 2015.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2015) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2015)  .
    compute persoonsjaren2015start=DATE.DMY (01,01,2015).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2015) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2015).
compute persoonsjaren2015start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2015) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2015).
compute persoonsjaren2015eind=DATE.DMY (31,12, 2015).
else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2015) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2015).
 compute persoonsjaren2015eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2015=1.
    compute persoonsjaren2015eind=eerstedatumbmi2015.
end if.
execute.

FORMATS persoonsjaren2015start persoonsjaren2015eind (date11).

COMPUTE  persoonsjaren2015=(persoonsjaren2015eind - persoonsjaren2015start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2015.
VARIABLE LEVEL  persoonsjaren2015 (SCALE).
FORMATS  persoonsjaren2015 (F8.2).
VARIABLE WIDTH  persoonsjaren2015 (8).
EXECUTE.


*JAAR 2016.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2016) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2016)  .
    compute persoonsjaren2016start=DATE.DMY (01,01,2016).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2016) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2016).
compute persoonsjaren2016start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2016) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2016).
compute persoonsjaren2016eind=DATE.DMY (31,12, 2016).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2016) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2016).
 compute persoonsjaren2016eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2016=1.
    compute persoonsjaren2016eind=eerstedatumbmi2016.
end if.
execute.

FORMATS persoonsjaren2016start persoonsjaren2016eind (date11).

COMPUTE  persoonsjaren2016=(persoonsjaren2016eind - persoonsjaren2016start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2016.
VARIABLE LEVEL  persoonsjaren2016 (SCALE).
FORMATS  persoonsjaren2016 (F8.2).
VARIABLE WIDTH  persoonsjaren2016 (8).
EXECUTE.


*JAAR 2017.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2017) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2017)  .
    compute persoonsjaren2017start=DATE.DMY (01,01,2017).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2017) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2017).
compute persoonsjaren2017start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2017) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2017).
compute persoonsjaren2017eind=DATE.DMY (31,12, 2017).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2017) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2017).
 compute persoonsjaren2017eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2017=1.
    compute persoonsjaren2017eind=eerstedatumbmi2017.
end if.
execute.

FORMATS persoonsjaren2017start persoonsjaren2017eind (date11).

COMPUTE  persoonsjaren2017=(persoonsjaren2017eind - persoonsjaren2017start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2017.
VARIABLE LEVEL  persoonsjaren2017 (SCALE).
FORMATS  persoonsjaren2017 (F8.2).
VARIABLE WIDTH  persoonsjaren2017 (8).
EXECUTE.


*JAAR 2018.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2018) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2018)  .
    compute persoonsjaren2018start=DATE.DMY (01,01,2018).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2018) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2018).
compute persoonsjaren2018start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2018) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2018).
compute persoonsjaren2018eind=DATE.DMY (31,12, 2018).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2018) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2018).
 compute persoonsjaren2018eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2018=1.
    compute persoonsjaren2018eind=eerstedatumbmi2018.
end if.
execute.

FORMATS persoonsjaren2018start persoonsjaren2018eind (date11).

COMPUTE  persoonsjaren2018=(persoonsjaren2018eind - persoonsjaren2018start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2018.
VARIABLE LEVEL  persoonsjaren2018 (SCALE).
FORMATS  persoonsjaren2018 (F8.2).
VARIABLE WIDTH  persoonsjaren2018 (8).
EXECUTE.


*JAAR 2019.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2019) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2019)  .
    compute persoonsjaren2019start=DATE.DMY (01,01,2019).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2019) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2019).
compute persoonsjaren2019start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2019) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2019).
compute persoonsjaren2019eind=DATE.DMY (31,12, 2019).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2019) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2019).
 compute persoonsjaren2019eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2019=1.
    compute persoonsjaren2019eind=eerstedatumbmi2019.
end if.
execute.

FORMATS persoonsjaren2019start persoonsjaren2019eind (date11).

COMPUTE  persoonsjaren2019=(persoonsjaren2019eind - persoonsjaren2019start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2019.
VARIABLE LEVEL  persoonsjaren2019 (SCALE).
FORMATS  persoonsjaren2019 (F8.2).
VARIABLE WIDTH  persoonsjaren2019 (8).
EXECUTE.


*JAAR 2020.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2020) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2020)  .
    compute persoonsjaren2020start=DATE.DMY (01,01,2020).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2020) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2020).
compute persoonsjaren2020start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2020) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2020).
compute persoonsjaren2020eind=DATE.DMY (31,12, 2020).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2020) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2020).
 compute persoonsjaren2020eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2020=1.
    compute persoonsjaren2020eind=eerstedatumbmi2020.
end if.
execute.

FORMATS persoonsjaren2020start persoonsjaren2020eind (date11).

COMPUTE  persoonsjaren2020=(persoonsjaren2020eind - persoonsjaren2020start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2020.
VARIABLE LEVEL  persoonsjaren2020(SCALE).
FORMATS  persoonsjaren2020(F8.2).
VARIABLE WIDTH  persoonsjaren2020 (8).
EXECUTE.


*JAAR 2021.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2021) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2021)  .
    compute persoonsjaren2021start=DATE.DMY (01,01,2021).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2021) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2021).
compute persoonsjaren2021start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2021) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2021).
compute persoonsjaren2021eind=DATE.DMY (31,12, 2021).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2021) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2021).
 compute persoonsjaren2021eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2021=1.
    compute persoonsjaren2021eind=eerstedatumbmi2021.
end if.
execute.

FORMATS persoonsjaren2021start persoonsjaren2021eind (date11).

COMPUTE  persoonsjaren2021=(persoonsjaren2021eind - persoonsjaren2021start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2021.
VARIABLE LEVEL  persoonsjaren2021(SCALE).
FORMATS  persoonsjaren2021 (F8.2).
VARIABLE WIDTH  persoonsjaren2021 (8).
EXECUTE.


*JAAR 2022.
Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2022) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2022)  .
    compute persoonsjaren2022start=DATE.DMY (01,01,2022).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2022) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2022).
compute persoonsjaren2022start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2022) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2022).
compute persoonsjaren2022eind=DATE.DMY (31,12, 2022).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2022) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2022).
 compute persoonsjaren2022eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2022=1.
    compute persoonsjaren2022eind=eerstedatumbmi2022.
end if.
execute.

FORMATS persoonsjaren2022start persoonsjaren2022eind (date11).

COMPUTE  persoonsjaren2022=(persoonsjaren2022eind - persoonsjaren2022start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2022.
VARIABLE LEVEL  persoonsjaren2022 (SCALE).
FORMATS  persoonsjaren2022 (F8.2).
VARIABLE WIDTH  persoonsjaren2022 (8).
EXECUTE.


*JAAR 2023.
    Do if beginonderzoeksperiode_date<=DATE.DMY(01, 01, 2023) AND eindeonderzoeksperiode_date>=DATE.DMY(01, 01, 2023)  .
    compute persoonsjaren2023start=DATE.DMY (01,01,2023).
    else if beginonderzoeksperiode_date >=DATE.DMY(01,01, 2023) AND beginonderzoeksperiode_date <=DATE.DMY(31,12, 2023).
compute persoonsjaren2023start=beginonderzoeksperiode_date.
end if.
execute.

Do if  eindeonderzoeksperiode_date >=DATE.DMY(31, 12, 2023) AND beginonderzoeksperiode_date<=DATE.DMY (31, 12, 2023).
compute persoonsjaren2023eind=DATE.DMY (31,12, 2023).
 else if eindeonderzoeksperiode_date>=DATE.DMY (01,01, 2023) AND eindeonderzoeksperiode_date <=DATE.DMY (31,12, 2023).
 compute persoonsjaren2023eind=eindeonderzoeksperiode_date.
end if.
execute.

do if BMIinjaar2023=1.
    compute persoonsjaren2023eind=eerstedatumbmi2023.
end if.
execute.

FORMATS persoonsjaren2023start persoonsjaren2023eind (date11).

COMPUTE  persoonsjaren2023=(persoonsjaren2023eind - persoonsjaren2023start) / (365.25 * 
    time.days(1)).
VARIABLE LABELS  persoonsjaren2023.
VARIABLE LEVEL  persoonsjaren2023 (SCALE).
FORMATS  persoonsjaren2023 (F8.2).
VARIABLE WIDTH  persoonsjaren2023 (8).
EXECUTE.

If missing (persoonsjaren2007) persoonsjaren2007=0.
EXECUTE.
If missing (persoonsjaren2008) persoonsjaren2008=0.
EXECUTE.
If missing (persoonsjaren2009) persoonsjaren2009=0.
EXECUTE.
If missing (persoonsjaren2010) persoonsjaren2010=0.
EXECUTE.
If missing (persoonsjaren2011) persoonsjaren2011=0.
EXECUTE.
If missing (persoonsjaren2012) persoonsjaren2012=0.
EXECUTE.
If missing (persoonsjaren2013) persoonsjaren2013=0.
EXECUTE.
If missing (persoonsjaren2014) persoonsjaren2014=0.
EXECUTE.
If missing (persoonsjaren2015) persoonsjaren2015=0.
EXECUTE.
If missing (persoonsjaren2016) persoonsjaren2016=0.
EXECUTE.
If missing (persoonsjaren2017) persoonsjaren2017=0.
EXECUTE.
If missing (persoonsjaren2018) persoonsjaren2018=0.
EXECUTE.
If missing (persoonsjaren2019) persoonsjaren2019=0.
EXECUTE.
If missing (persoonsjaren2020) persoonsjaren2020=0.
EXECUTE.
If missing (persoonsjaren2021) persoonsjaren2021=0.
EXECUTE.
If missing (persoonsjaren2022) persoonsjaren2022=0.
EXECUTE.
If missing (persoonsjaren2023) persoonsjaren2023=0.
EXECUTE.


*-------------------------------------------------------------------------------------------------------------------------------------.
*START ANALYSE.
*tabel 1.

FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=geslacht_num
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=iGeboortejaar
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MINIMUM MAXIMUM MEDIAN
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=Follow_up_duur
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MINIMUM MAXIMUM MEDIAN
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=leeftijdbeginonderzoeksperiode
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MINIMUM MAXIMUM MEDIAN
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.


temporary.
select if BMIcat=1.
FREQUENCIES VARIABLES=BMIall_onderzoeksperiode
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MINIMUM MAXIMUM MEDIAN
  /ORDER=ANALYSIS.

temporary.
select if BMIcat=2.
FREQUENCIES VARIABLES=BMIall_onderzoeksperiode
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MINIMUM MAXIMUM MEDIAN
  /ORDER=ANALYSIS.

temporary.
select if BMIcat=3.
FREQUENCIES VARIABLES=BMIall_onderzoeksperiode
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=MINIMUM MAXIMUM MEDIAN
  /ORDER=ANALYSIS.


temporary.
select if bmiavailable=1.
FREQUENCIES VARIABLES=geslacht_num
  /ORDER=ANALYSIS.


temporary.
select if bmiavailable=1.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
*kijken of er een verschil zit tussen mannen en vrouwen.

SORT CASES  BY geslacht_num.
SPLIT FILE LAYERED BY geslacht_num.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
split file off.


FREQUENCIES VARIABLES=T83_overweightnum_first T82_obesitasnum_first hypertensie_num_first 
    Eatingdisorder_num_first diabetesT90_num_first diabetestype1_num_first diabetestype2_num_first 
    Depression_num_first copd_num_first
  /ORDER=ANALYSIS.


FREQUENCIES VARIABLES=Systeem_samengevoegdpromedico
  /ORDER=ANALYSIS.


FREQUENCIES VARIABLES=BMIcat
  /ORDER=ANALYSIS.

*TABEL 2.

*aantal patienten aan begin van de leeftijdscategorei n=population per leeftdijscategorie.
FREQUENCIES VARIABLES=leeftijdscategorie1start leeftijdscategorie2start leeftijdscategorie3start 
    leeftijdscategorie4start leeftijdscategorie5start leeftijdscategorie6start leeftijdscategorie7start
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=persoonsjarencategorie1 persoonsjarencategorie2 persoonsjarencategorie3 persoonsjarencategorie4 persoonsjarencategorie5 persoonsjarencategorie6 persoonsjarencategorie7
  /FORMAT=NOTABLE
  /STATISTICS=SUM
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=leeftijdscategorieBMI1 leeftijdscategorieBMI2 leeftijdscategorieBMI3 leeftijdscategorieBMI4 leeftijdscategorieBMI5 leeftijdscategorieBMI6 leeftijdscategorieBMI7
  /ORDER=ANALYSIS.


*gesplitst voor man en vrouw.

SORT CASES  BY geslacht_num.
SPLIT FILE LAYERED BY geslacht_num.

FREQUENCIES VARIABLES=leeftijdscategorie1start leeftijdscategorie2start leeftijdscategorie3start 
    leeftijdscategorie4start leeftijdscategorie5start leeftijdscategorie6start leeftijdscategorie7start
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=persoonsjarencategorie1 persoonsjarencategorie2 persoonsjarencategorie3 persoonsjarencategorie4 persoonsjarencategorie5 persoonsjarencategorie6 persoonsjarencategorie7
  /FORMAT=NOTABLE
  /STATISTICS=SUM
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=leeftijdscategorieBMI1 leeftijdscategorieBMI2 leeftijdscategorieBMI3 leeftijdscategorieBMI4 leeftijdscategorieBMI5 leeftijdscategorieBMI6 leeftijdscategorieBMI7
  /ORDER=ANALYSIS.

split file off.



*anlyse voor per jaar.


FREQUENCIES VARIABLES=persoonsjaren2007start persoonsjaren2008start persoonsjaren2009start persoonsjaren2010start persoonsjaren2011start persoonsjaren2012start
  persoonsjaren2013start persoonsjaren2014start persoonsjaren2015start persoonsjaren2016start persoonsjaren2017start persoonsjaren2018start persoonsjaren2019start
  persoonsjaren2020start persoonsjaren2021start persoonsjaren2022start persoonsjaren2023start
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=persoonsjaren2007 persoonsjaren2008 persoonsjaren2009 persoonsjaren2010 persoonsjaren2011 persoonsjaren2012 persoonsjaren2013 
  persoonsjaren2014 persoonsjaren2015 persoonsjaren2016 persoonsjaren2017 persoonsjaren2018 persoonsjaren2019 persoonsjaren2020 persoonsjaren2021 
  persoonsjaren2022 persoonsjaren2023
  /FORMAT=NOTABLE
  /STATISTICS=SUM
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES= BMIinjaar2007 BMIinjaar2008 BMIinjaar2009 BMIinjaar2010 BMIinjaar2011 BMIinjaar2012 BMIinjaar2013 BMIinjaar2014 BMIinjaar2015 
  BMIinjaar2016 BMIinjaar2017 BMIinjaar2018 BMIinjaar2019 BMIinjaar2020 BMIinjaar2021 BMIinjaar2022 BMIinjaar2023
  /ORDER=ANALYSIS.

*variabele die net nodig zijn voor verdere analys everwijderen.
Delete variables Datum31jaar to Datum19jaar.
Delete variables leeftijdscategorie1start to leeftijdscategorie7einde.
DELETE VARIABLES persoonsjaren2007start persoonsjaren2007eind.
DELETE VARIABLES persoonsjaren2008start persoonsjaren2008eind.
DELETE VARIABLES persoonsjaren2009start persoonsjaren2009eind.
DELETE VARIABLES persoonsjaren2010start persoonsjaren2010eind.
DELETE VARIABLES persoonsjaren2011start persoonsjaren2011eind.
DELETE VARIABLES persoonsjaren2012start persoonsjaren2012eind.
DELETE VARIABLES persoonsjaren2013start persoonsjaren2013eind.
DELETE VARIABLES persoonsjaren2014start persoonsjaren2014eind.
DELETE VARIABLES persoonsjaren2015start persoonsjaren2015eind.
DELETE VARIABLES persoonsjaren2016start persoonsjaren2016eind.
DELETE VARIABLES persoonsjaren2017start persoonsjaren2017eind.
DELETE VARIABLES persoonsjaren2018start persoonsjaren2018eind.
DELETE VARIABLES persoonsjaren2019start persoonsjaren2019eind.
DELETE VARIABLES persoonsjaren2020start persoonsjaren2020eind.
DELETE VARIABLES persoonsjaren2021start persoonsjaren2021eind.
DELETE VARIABLES persoonsjaren2022start persoonsjaren2022eind.
DELETE VARIABLES persoonsjaren2023start persoonsjaren2023eind.


*TABEL 4.
Temporary.
select if T83_overweightnum_first=1.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.

Temporary.
  select if T82_obesitasnum_first=1.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.

Temporary.
  select if T82_obesitasnum_first=1 OR T83_overweightnum_first=1.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.


Temporary.
  select if copd_num_first=1 OR copd_num_first=2 OR copd_num_first=3 OR copd_num_first=4.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.


Temporary.
  select if hypertensie_num_first=1 OR hypertensie_num_first=2 OR hypertensie_num_first=3.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.


Temporary.
  select if diabetestype1_num_first=1.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.

Temporary.
  select if diabetestype2_num_first=1.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.


Temporary.
  select if Eatingdisorder_num_first=1 OR Eatingdisorder_num_first=2 OR Eatingdisorder_num_first=3.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.


Temporary.
  select if Depression_num_first=1 OR Depression_num_first=2 OR Depression_num_first=3 OR Depression_num_first=4.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.




*icpc in onze onderzoeksperiode.

Temporary.
  select if Depression_num_inonderzoeksperiodefirst=1 OR Depression_num_inonderzoeksperiodefirst=2 OR Depression_num_inonderzoeksperiodefirst=3 OR Depression_num_inonderzoeksperiodefirst=4.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.


Temporary.
  select if eatingdisorder_num_inonderzoeksperiodefirst=1 OR eatingdisorder_num_inonderzoeksperiodefirst=2 OR eatingdisorder_num_inonderzoeksperiodefirst=3.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.


*TABEL 5.



FREQUENCIES VARIABLES=Systeem_samengevoegdpromedico
  /ORDER=ANALYSIS.


Temporary.
  select if Systeem_samengevoegdpromedico=1. 
FREQUENCIES VARIABLES=bmiavailable T83_overweightnum_first T82_obesitasnum_first
  /ORDER=ANALYSIS.


Temporary.
  select if Systeem_samengevoegdpromedico=2.
FREQUENCIES VARIABLES=bmiavailable T83_overweightnum_first T82_obesitasnum_first
  /ORDER=ANALYSIS.
execute.

Temporary.
  select if Systeem_samengevoegdpromedico=3.
FREQUENCIES VARIABLES=bmiavailable T83_overweightnum_first T82_obesitasnum_first
  /ORDER=ANALYSIS.
execute.

Temporary.
  select if Systeem_samengevoegdpromedico=4.
FREQUENCIES VARIABLES=bmiavailable T83_overweightnum_first T82_obesitasnum_first
  /ORDER=ANALYSIS.
execute.
    

AUTORECODE VARIABLES=PRAKNR 
  /INTO aantalpraktijken
  /PRINT.

*aantal praktijken totaal is 152 zie value labels.


Temporary.
  select if Systeem_samengevoegdpromedico=1. 
FREQUENCIES VARIABLES=aantalpraktijken
  /ORDER=ANALYSIS.


Temporary.
  select if Systeem_samengevoegdpromedico=2. 
FREQUENCIES VARIABLES=aantalpraktijken
  /ORDER=ANALYSIS.

Temporary.
  select if Systeem_samengevoegdpromedico=3. 
FREQUENCIES VARIABLES=aantalpraktijken
  /ORDER=ANALYSIS.


Temporary.
  select if Systeem_samengevoegdpromedico=4. 
FREQUENCIES VARIABLES=aantalpraktijken
  /ORDER=ANALYSIS.


*Dummy variabele maken voo ronderlinge vergelijken.
do if Systeem_samengevoegdpromedico=1.
compute medicom=1.
else if Systeem_samengevoegdpromedico=2 or Systeem_samengevoegdpromedico=3 or Systeem_samengevoegdpromedico=4.
    compute medicom=0.
end if.
execute.

do if Systeem_samengevoegdpromedico=2.
compute promedico=1.
else if Systeem_samengevoegdpromedico=1 or Systeem_samengevoegdpromedico=3 or Systeem_samengevoegdpromedico=4.
    compute promedico=0.
end if.
execute.

do if Systeem_samengevoegdpromedico=3.
compute microhis=1.
else if Systeem_samengevoegdpromedico=1 or Systeem_samengevoegdpromedico=2 or Systeem_samengevoegdpromedico=4.
    compute microhis=0.
end if.
execute.

do if Systeem_samengevoegdpromedico=4.
compute omnihis=1.
else if Systeem_samengevoegdpromedico=1 or Systeem_samengevoegdpromedico=2 or Systeem_samengevoegdpromedico=3.
    compute omnihis=0.
end if.
execute.


*nu ook vergelijken met log regressie.
LOGISTIC REGRESSION VARIABLES bmiavailable
  /METHOD=ENTER Systeem_samengevoegdpromedico 
  /CONTRAST (Systeem_samengevoegdpromedico)=Indicator(1)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20) CUT(.5).


* voor extra anlyse van depressie en eating diosrerd alleen degenene geselecterrd met icpc in onze onderzoeksperiode.
DATASET ACTIVATE DataSet1.
GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Alleen eerste '+
    'ICPC_gecleand\depressie_eersteicpc_inmijnonderzoeksperiode.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY PATNR.
EXECUTE.

GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Alleen eerste '+
    'ICPC_gecleand\eatingdisorder_eersteicpc_inmijnonderzoeksperiode.sav'.
DATASET NAME DataSet3.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet3.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet3'
  /BY PATNR.
EXECUTE.

* voor extra anlyse van icpc overgewicht en obesitas alleen degenene geselecterrd met icpc in onze onderzoeksperiode.

DATASET ACTIVATE DataSet1.
GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Alleen eerste '+
    'ICPC_gecleand\Overgewicht_eersteicpc _inmijnonderzoeksperiode.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY PATNR.
EXECUTE.

GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Alleen eerste '+
    'ICPC_gecleand\obesity_eersteicpci_inmijnonderzoeksperiode.sav'.
DATASET NAME DataSet3.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet3.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet3'
  /BY PATNR.
EXECUTE.

*en ook nog toevoegen van de bmi file of ooit bmi is gemeten boven de 25 of boven 30.

DATASET ACTIVATE DataSet1.
GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Files voor '+
    'analyse\NIEUWE\BMI file\RIJEN_bmiscategorieen.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /RENAME (bmiall.1 bmidatumall.1 = d0 d1) 
  /BY PATNR
  /DROP= d0 d1.
EXECUTE.

*BEHOORT BIJ tabel 4 (figuur 4).

temporary.
  select if Depression_num_inonderzoeksperiodefirst=1 OR Depression_num_inonderzoeksperiodefirst=2 OR Depression_num_inonderzoeksperiodefirst=3 OR Depression_num_inonderzoeksperiodefirst=4.
 FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.

Temporary.
  select if eatingdisorder_num_inonderzoeksperiodefirst=1 OR eatingdisorder_num_inonderzoeksperiodefirst=2 OR eatingdisorder_num_inonderzoeksperiodefirst=3.
FREQUENCIES VARIABLES=bmiavailable
  /ORDER=ANALYSIS.
execute.



*
tabel 3 FIGUUR 3
*variabelen met bmi in onze onderzoeksperiode gemeten normaal, overgewciht of obesitas goed maken voor analyse.

If missing (NormaalBMIgemeten) NormaalBMIgemeten=0.
execute.
If missing (OvergewichtBMIgemeten) OvergewichtBMIgemeten=0.
execute.
If missing (ObesitasBMIgemeten) ObesitasBMIgemeten=0.
execute.


*icpcs overgewicht en obesitas gehele tijd samenvoegen in een variabelen.
Do if T83_overweightnum_first=1 OR T82_obesitasnum_first=1.
    compute ICPCobesitasovergewicht =1.
end if.
execute.

*icpcs overgewicht en obesitas onze onderzoeksperiode samenvoegen in een variabelen.
Do if OvergewichtT83_num_inonderzoeksperiodefirst=1 OR T82obesity_num_inonderzoeksperiodefirst=1.
    compute ICPConzeonderzoeksperiodeobesitasovergewicht =1.
end if.
execute.


FREQUENCIES VARIABLES= T83_overweightnum_first OvergewichtT83_num_inonderzoeksperiodefirst 
  T82_obesitasnum_first T82obesity_num_inonderzoeksperiodefirst
   ICPCobesitasovergewicht ICPConzeonderzoeksperiodeobesitasovergewicht
  /ORDER=ANALYSIS.

temporary.
select if OvergewichtBMIgemeten=1.
FREQUENCIES VARIABLES= ICPConzeonderzoeksperiodeobesitasovergewicht ICPCobesitasovergewicht
  /ORDER=ANALYSIS.

temporary.
select if OvergewichtBMIgemeten=1.
FREQUENCIES VARIABLES=OvergewichtT83_num_inonderzoeksperiodefirst T83_overweightnum_first
  /ORDER=ANALYSIS.

temporary.
select if OvergewichtBMIgemeten=1.
FREQUENCIES VARIABLES=T82obesity_num_inonderzoeksperiodefirst T82_obesitasnum_first
  /ORDER=ANALYSIS.


*en nu voor obesitas gemeten bmi boven de 30.

temporary.
select if ObesitasBMIgemeten=1.
FREQUENCIES VARIABLES= ICPConzeonderzoeksperiodeobesitasovergewicht ICPCobesitasovergewicht
      /ORDER=ANALYSIS.


temporary.
select if ObesitasBMIgemeten=1.
FREQUENCIES VARIABLES=OvergewichtT83_num_inonderzoeksperiodefirst T83_overweightnum_first
      /ORDER=ANALYSIS.


temporary.
select if ObesitasBMIgemeten=1.
FREQUENCIES VARIABLES= T82obesity_num_inonderzoeksperiodefirst T82_obesitasnum_first
      /ORDER=ANALYSIS.

*en nu iedereen boven de 25.

temporary.
select if ObesitasBMIgemeten=1 OR OvergewichtBMIgemeten=1.
FREQUENCIES VARIABLES= ICPConzeonderzoeksperiodeobesitasovergewicht ICPCobesitasovergewicht
      /ORDER=ANALYSIS.


temporary.
select if ObesitasBMIgemeten=1 OR OvergewichtBMIgemeten=1.
FREQUENCIES VARIABLES=OvergewichtT83_num_inonderzoeksperiodefirst T83_overweightnum_first
      /ORDER=ANALYSIS.


temporary.
select if ObesitasBMIgemeten=1 OR OvergewichtBMIgemeten=1.
FREQUENCIES VARIABLES= T82obesity_num_inonderzoeksperiodefirst T82_obesitasnum_first
      /ORDER=ANALYSIS.


*bekijken van de beschikbare bmis hoeveel een icpc overgewicht of obesitas heeft.


temporary.
select if T83_overweightnum_first=1.
      FREQUENCIES VARIABLES= bmiavailable
      /ORDER=ANALYSIS.

temporary.
select if OvergewichtT83_num_inonderzoeksperiodefirst=1.
      FREQUENCIES VARIABLES= bmiavailable
      /ORDER=ANALYSIS.



temporary.
select if T82_obesitasnum_first=1.
      FREQUENCIES VARIABLES= bmiavailable
      /ORDER=ANALYSIS.

temporary.
select if T82obesity_num_inonderzoeksperiodefirst=1.
      FREQUENCIES VARIABLES= bmiavailable
      /ORDER=ANALYSIS.


temporary.
select if ICPCobesitasovergewicht=1.
      FREQUENCIES VARIABLES= bmiavailable
      /ORDER=ANALYSIS.

temporary.
select if ICPConzeonderzoeksperiodeobesitasovergewicht=1.
      FREQUENCIES VARIABLES= bmiavailable
      /ORDER=ANALYSIS.


*------------------------------------------------------------------------------------------------------------------------------------------.

*aanpatfile, toeveogen of iemand binnen het jaar voor of binnen het jaar na de diagnose depressie/eating disorder een bmi gemeten heeft BEHOORT BJI FIGUUR 4). 

*Dit halen uit de file : RIJEN_depressie_eatingdisorders_BMI.sav.


GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by '+
    'itself\Each_variable_all\ICPC_depressie_eatingdisorder_binnenjaar\RIJEN_depressieeatingdisorde'+
    'rs_BMIbinnenjaar.sav'.
DATASET NAME DataSet3.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet3.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet3'
  /RENAME (beginonderzoeksperiode_date depression_date_inonderzoeksperiodefirst 
    Depression_num_inonderzoeksperiodefirst eatingdisorder_date_inonderzoeksperiodefirst 
    eatingdisorder_num_inonderzoeksperiodefirst eindeonderzoeksperiode_date follow_up_duur geslacht_num 
    iGeboortejaar iOverlijdensjaar Jaar19jaar Systeem Systeem_samengevoegdpromedico = d0 d1 d2 d3 d4 d5 
    d6 d7 d8 d9 d10 d11 d12) 
  /BY PATNR
  /DROP= d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12.
EXECUTE.



If missing (bmidepressiegemetenbinnen1jaar) bmidepressiegemetenbinnen1jaar=0.
execute.

If missing (bmieatingdisordergemetenbinnen1jaar) bmieatingdisordergemetenbinnen1jaar=0.
execute.


Temporary.
  select if eatingdisorder_num_inonderzoeksperiodefirst=1 OR eatingdisorder_num_inonderzoeksperiodefirst=2 OR eatingdisorder_num_inonderzoeksperiodefirst=3.
FREQUENCIES VARIABLES=bmieatingdisordergemetenbinnen1jaar
  /ORDER=ANALYSIS.
execute.


temporary.
  select if Depression_num_inonderzoeksperiodefirst=1 OR Depression_num_inonderzoeksperiodefirst=2 OR Depression_num_inonderzoeksperiodefirst=3 OR Depression_num_inonderzoeksperiodefirst=4.
 FREQUENCIES VARIABLES=bmidepressiegemetenbinnen1jaar
  /ORDER=ANALYSIS.
execute.


*anslyses voor significant verschil mannen envrouwen figuur 2. *zie syntax 



CROSSTABS
  /TABLES=medicom BY bmiavailable
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ RISK 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=promedico BY bmiavailable
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ RISK 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=microhis BY bmiavailable
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ RISK 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.

CROSSTABS
  /TABLES=omnihis BY bmiavailable
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ RISK 
  /CELLS=COUNT ROW 
  /COUNT ROUND CELL.
