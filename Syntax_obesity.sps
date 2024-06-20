* Encoding: UTF-8.
*cleaning icpc obesitas.
*willemijn van den hout.
*13-11-2023.


FREQUENCIES VARIABLES=Obesity
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

* Identify Duplicate Cases.
SORT CASES BY PATNR(A) Obesity(A) Obesity_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR Obesity Obesity_date
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.


FILTER OFF.
USE ALL.
SELECT IF ( (PrimaryLast= 1)).
EXECUTE.

Delete variables PrimaryLast.
EXECUTE.

Alter type Obesity_date (sdate10).
FORMATS Obesity_date (date11).

*datum van icpc cleanen.
DO IF (Obesity_date>= (DATE.DMY(01,07,2023))).
RECODE Obesity_date (ELSE=SYSMIS).
END if.
Execute.
.

FREQUENCIES VARIABLES=obesity
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.



RECODE Obesity ('T82'=1) (ELSE = 0) INTO T82_obesitasnum.
Value labels T82_obesitasnum 0 'geen' 1 'obesitas T82'.
Formats T82_obesitasnum (f6.0).
EXECUTE.

Delete variables obesity.


*tot slot voor mijn onderzoek apart bestand gemaakt met alleen de eerste icpc van iedere patient (sommigen hebben namelijk meerdere keer de icpc code.
SORT CASES BY PATNR(A) Obesity_date(A).
DATASET DECLARE first.
AGGREGATE
  /OUTFILE='first'
  /BREAK=PATNR
  /Obesity_date_first=FIRST(Obesity_date) 
  /T82_obesitasnum_first=FIRST(T82_obesitasnum).

FREQUENCIES VARIABLES=T82_obesitasnum_first
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.






*en ook nog gekeken naar alleen overgewicht icpc in onze onderzoeksperiode.
*hiervoor begin en einde onderzoeksperiode datum aan de icpc overgewicht toegevoegd.


GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Files voor '+
    'analyse\NIEUWE\PAT file\ANALYSE_PATfile_icpcbmileeftijdcategorie_naflowchart.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /TABLE='DataSet2'
  /RENAME (Extractiedatum Systeem PRAKNR dPostcodecijfers iGeboortejaar iOverlijdensjaar 
    dinschrijfdatum duitschrijfdatum laatsteuitschrijftariefdatum eersteinschrijftariefdatum 
    missing_between_tarieven combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief 
    Overgewicht_date_first T83_overweightnum_first Obesity_date_first T82_obesitasnum_first 
    hypertension_date_first hypertensie_num_first Eatingdisorder_date_first Eatingdisorder_num_first 
    Diabetes_date_first diabetesT90_num_first Diabetestype1_date_first diabetestype1_num_first 
    Diabetestype2_date_first diabetestype2_num_first depression_date_first Depression_num_first 
    copd_date_first copd_num_first waist_circumference_date_first waist_circumference_first 
    combinatieinschrijfdatumentarief_jaar combinatieuitschrijfdatumentarief_jaar Datum19jaar 
    overlijdensdatum follow_up_duur geslacht_num Systeem_samengevoegdpromedico bmilab_onderzoeksperiode 
    BMIlab_date_onderzoeksperiode BMIheightweight_date_onderzoeksperiode 
    BMIlheightweight_onderzoeksperiode BMIall_onderzoeksperiode BMIall_date_onderzoeksperiode 
    leeftijdscategorieBMI1 leeftijdscategorieBMI2 leeftijdscategorieBMI3 leeftijdscategorieBMI4 
    leeftijdscategorieBMI5 leeftijdscategorieBMI6 leeftijdscategorieBMI7 bmiavailable BMIcat 
    Datum31jaar Datum41jaar Datum51jaar Datum61jaar Datum71jaar Datum81jaar beginonderzoeksperiode_jaar 
    eindeonderzoeksperiode_jaar leeftijdbeginonderzoeksperiode leeftijdeindeonderzoeksperiode 
    leeftijdscategorie1start leeftijdscategorie1einde leeftijdscategorie2start leeftijdscategorie2einde 
    leeftijdscategorie3start leeftijdscategorie3einde leeftijdscategorie4start leeftijdscategorie4einde 
    leeftijdscategorie5start leeftijdscategorie5einde leeftijdscategorie6start leeftijdscategorie6einde 
    leeftijdscategorie7start leeftijdscategorie7einde persoonsjarencategorie1 persoonsjarencategorie2 
    persoonsjarencategorie3 persoonsjarencategorie4 persoonsjarencategorie5 persoonsjarencategorie6 
    persoonsjarencategorie7 ICPCobesitasovergewicht aantalpraktijken 
    depression_date_inonderzoeksperiodefirst Depression_num_inonderzoeksperiodefirst 
    eatingdisorder_date_inonderzoeksperiodefirst eatingdisorder_num_inonderzoeksperiodefirst = d0 d1 d2 
    d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 
    d29 d30 d31 d32 d33 d34 d35 d36 d37 d38 d39 d40 d41 d42 d43 d44 d45 d46 d47 d48 d49 d50 d51 d52 d53 
    d54 d55 d56 d57 d58 d59 d60 d61 d62 d63 d64 d65 d66 d67 d68 d69 d70 d71 d72 d73 d74 d75 d76 d77 d78 
    d79 d80 d81 d82 d83 d84 d85 d86 d87 d88 d89 d90 d91) 
  /BY PATNR
  /DROP= d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 
    d25 d26 d27 d28 d29 d30 d31 d32 d33 d34 d35 d36 d37 d38 d39 d40 d41 d42 d43 d44 d45 d46 d47 d48 d49 
    d50 d51 d52 d53 d54 d55 d56 d57 d58 d59 d60 d61 d62 d63 d64 d65 d66 d67 d68 d69 d70 d71 d72 d73 d74 
    d75 d76 d77 d78 d79 d80 d81 d82 d83 d84 d85 d86 d87 d88 d89 d90 d91.
EXECUTE.


*nu alleen icpcs selecteren in de periode dat iemand ingeschreven staat.

TEMPORARY.
select if (Obesity_date>=beginonderzoeksperiode_date) AND (Obesity_date<=eindeonderzoeksperiode_date).
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=15996.

filter off.
use all.
select if (Obesity_date>=beginonderzoeksperiode_date) AND (Obesity_date<=eindeonderzoeksperiode_date).
execute.

*en dan de eerste in onze onderzoeksperiode.
SORT CASES BY PATNR(A) Obesity_date(A).
DATASET DECLARE first.
AGGREGATE
  /OUTFILE='first'
  /BREAK=PATNR
  /obesity_date_inonderzoeksperiodefirst=FIRST(Obesity_date) 
  /T82obesity_num_inonderzoeksperiodefirst=FIRST(T82_obesitasnum).

FREQUENCIES VARIABLES=T82obesity_num_inonderzoeksperiodefirst
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=15246.

