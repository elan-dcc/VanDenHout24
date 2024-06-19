* Encoding: UTF-8.
*cleaning labwaarde bmi ELAN.
*willemijn van den hout.
*31-10-2023.


FREQUENCIES VARIABLES=bmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n =1.538.020.

* Identify Duplicate Cases.
SORT CASES BY PATNR(A) bmi(A) BMI_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR bmi BMI_date
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

*dubbele N= 101.093.


FILTER OFF.
USE ALL.
SELECT IF ( (PrimaryLast= 1)).
EXECUTE.


Delete variables PrimaryLast.



*outliers eruit halen.
Temporary.
select if  bmi<10 OR bmi>80.
FREQUENCIES VARIABLES=bmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=9176..

Do IF bmi<10 OR bmi>80.
RECODE bmi (ELSE=SYSMIS).
    Recode BMI_date (ELSE=SYSMIS).
End if.
Execute.


FREQUENCIES VARIABLES=bmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

*dubbele metingen op een dag eruit halen bmi (laagste bmi wordt geselecteerd en er uitendleijk uit gehaald, hoogste blijft.).
SORT CASES BY PATNR(A)  BMI_date (A) bmi(D). 
Compute dubbel_bmi=$SYSMIS.
  DO REPEAT #i = 1 TO 700.
   Do  IF (BMI_date = LAG(BMI_date, #i) AND PATNR = LAG(PATNR, #i)). 
      COMPUTE dubbel_bmi = 1.
    END IF.
  END REPEAT.
EXECUTE.

*meerdere metingen op 1 dag.
FREQUENCIES VARIABLES=dubbel_bmi
  /ORDER=ANALYSIS.
 *n=17.272.
.
* de dubbele data van bmi eruit halen de laagste bmi wordt eruit gehaald, de hoogste blijft.
DO IF dubbel_bmi =1.
    Recode BMI_date(ELSE=SYSMIS).
    Recode bmi (ELSE=SYSMIS).
End if.
Execute.

FREQUENCIES VARIABLES=bmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

*de dubbele cases helemaal verwijderen odmat er nu 1 bmi per dag gekozen wordt.


FILTER OFF.
USE ALL.
SELECT IF (missing (dubbel_bmi)).
EXECUTE.

FREQUENCIES VARIABLES=bmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

.
*dit patientenummer heeft heel veel gemeten bmis wel 600, waarbij er geen peil op te trekken is, welke de goede is, het kan zo om de dag heel veel kg/m2 wisselen.
USE ALL.
COMPUTE filter_$=(PATNR=772570533).
VARIABLE LABELS filter_$ ' (PATNR=772570533)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES=bmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

*n=642 metingen in deze patienten....
*na overleg besloten deze patient er helemaal uit te halen.

if patnr=772570533 bmi=$SYSMIS.
execute.

filter off.


FREQUENCIES VARIABLES=bmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

* alle cases verwijderen met nu missing bmi want geen adequaat bmi beschikbaar dan.
FILTER OFF.
USE ALL.
SELECT IF ~ missing (bmi).
EXECUTE.


formats bmi (f3.2).

FREQUENCIES VARIABLES=bmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


Delete variables dubbel_bmi.
Delete variables filter_$.


GRAPH
  /HISTOGRAM=bmi.
