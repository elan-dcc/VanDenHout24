* Encoding: UTF-8.
* syntax voor cleaning variabelen dinschrijfdatum en duitschrijfdatum ELAN.
* igeboortejaar moet al gecleand zijn op moment van runnen.
 *willemijn van den Hout
 * 26-10-2023.


*VARIABELE INSCHRIJFDATUM.

FREQUENCIES VARIABLES=dinschrijfdatum
  /ORDER=ANALYSIS.
*n=13432 = NA bij inschrijfdatum.

*sommige data worden verkeerd geconverteerd van string naar numeric, bv 0001-01-01 wordt 01 januari 2001 bij atlertype dus missing maken.
RECODE dinschrijfdatum ('0001-01-01'= 'N/A').
RECODE dinschrijfdatum ('0022-01-01'= 'N/A').
RECODE dinschrijfdatum ('1098-08-31'= 'N/A').
RECODE dinschrijfdatum ('1335-07-04'= 'N/A').
Execute. 

FREQUENCIES VARIABLES=dinschrijfdatum
  /ORDER=ANALYSIS.
*n=5 N/A.

Alter type dinschrijfdatum (sdate10).
FORMATS dinschrijfdatum (date11).

*outliers inschrijfdatum eruit halen.
Temporary.
SELECT IF (dinschrijfdatum>= (DATE.DMY(01,01,2024)) or (dinschrijfdatum< (DATE.DMY(01,01,1902)))) .
LIST dinschrijfdatum.
*n=105.

DO IF (dinschrijfdatum>= (DATE.DMY(01,01,2024)) or  (dinschrijfdatum< (DATE.DMY(01,01,1902)))).
RECODE dinschrijfdatum (ELSE=SYSMIS).
END if.
Execute.

* nieuwe variabelen jaar maken van inschrijfdatum om t ekunnen vergelijken met het geboortejaar: Inschrijfdatum_years.
COMPUTE Inschrijfdatum_years=XDATE.YEAR(dinschrijfdatum).
VARIABLE LABELS Inschrijfdatum_years.
VARIABLE LEVEL Inschrijfdatum_years(SCALE).
FORMATS Inschrijfdatum_years(F8.0).
VARIABLE WIDTH Inschrijfdatum_years(8).
EXECUTE.

TEMPORARY.
SELECT IF (Inschrijfdatum_years < iGeboortejaar) .
LIST iGeboortejaar Inschrijfdatum_years dinschrijfdatum.
*n=320 missing.

DO IF (Inschrijfdatum_years < iGeboortejaar).
RECODE dinschrijfdatum (ELSE=SYSMIS).
END if.
Execute.

FREQUENCIES VARIABLES= dinschrijfdatum
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
n= 13862 missing.



*VARIABELE UITSCHRIJFDATUM.

FREQUENCIES VARIABLES=duitschrijfdatum
  /ORDER=ANALYSIS.
*n=482757 = NA bij inschrijfdatum.



Temporary.
select if not missing(dinschrijfdatum) AND (duitschrijfdatum='NA').
FREQUENCIES VARIABLES=duitschrijfdatum dinschrijfdatum
  /ORDER=ANALYSIS.
*n=474064.

*NA vervangen door extractiedatum bij uitschrijfdatum, alleen als de inschrijfdatum ook niet missend is..
DO IF (duitschrijfdatum= 'NA') AND not missing(dinschrijfdatum).
compute duitschrijfdatum = Extractiedatum.
End if.
EXECUTE.

*0001-01-01 wordt oa verkeerd geconverteerd (als datum 01 januari 2001) bij atlertype dus missing maken.
RECODE duitschrijfdatum ('0001-01-01 '= 'N/A').
RECODE duitschrijfdatum ('0201-01-01'= 'N/A').
RECODE duitschrijfdatum ('0994-01-01'= 'N/A').
RECODE duitschrijfdatum ('0995-11-03 '= 'N/A').
RECODE duitschrijfdatum ('0998-01-03'= 'N/A').
RECODE duitschrijfdatum ('1097-07-19'= 'N/A').
EXECUTE.


FREQUENCIES VARIABLES=duitschrijfdatum
  /ORDER=ANALYSIS.
*n=11368 = N/A bij uitschrijfdatum.
*n=8693 = NA bij uitschrijfdatum.
*n=totaal=20061.

Alter type duitschrijfdatum (sdate10).
FORMATS duitschrijfdatum (date11).

*outliers uitschrijfdatum eruit halen.
Temporary.
SELECT IF (duitschrijfdatum>= (DATE.DMY(01,01,2024)) or (duitschrijfdatum< (DATE.DMY(01,01,1940)))) .
LIST duitschrijfdatum.
*n=56.

DO IF (duitschrijfdatum>= (DATE.DMY(01,01,2024)) or  (duitschrijfdatum< (DATE.DMY(01,01,1940)))).
RECODE duitschrijfdatum (ELSE=SYSMIS).
END if.
Execute.

* nieuwe variabelen jaar maken van uitschrijfdatum om te kunnen vergelijken met het geboortejaar: UItschrijfdatum_years.
COMPUTE Uitschrijfdatum_years=XDATE.YEAR(duitschrijfdatum).
VARIABLE LABELS Uitschrijfdatum_years.
VARIABLE LEVEL Uitschrijfdatum_years(SCALE).
FORMATS Uitschrijfdatum_years(F8.0).
VARIABLE WIDTH Uitschrijfdatum_years(8).
EXECUTE.


TEMPORARY.
SELECT IF (Uitschrijfdatum_years < iGeboortejaar) .
LIST iGeboortejaar Uitschrijfdatum_years duitschrijfdatum.
*n=624.

DO IF (Uitschrijfdatum_years < iGeboortejaar).
RECODE duitschrijfdatum (ELSE=SYSMIS).
END if.
Execute.

* als inschrijfdatum voor uitschrijfdatum ligt dan beiden missing maken.
TEMPORARY.
SELECT IF (dinschrijfdatum > duitschrijfdatum) .
LIST dinschrijfdatum duitschrijfdatum.
*n=41877.


*inschrijfdatum missing bij  inschrijfdatum>uitschrijfdatum.
DO IF (dinschrijfdatum > duitschrijfdatum).
RECODE dinschrijfdatum (ELSE=SYSMIS).
RECODE duitschrijfdatum (ELSE=SYSMIS) .
END if.
Execute.

FREQUENCIES VARIABLES=duitschrijfdatum
  /ORDER=ANALYSIS.
*N=62618.

*nog aantallen runnen na inschrijfdatum >uitschrijfdatum voor de inschrijfdatum.
FREQUENCIES VARIABLES=dinschrijfdatum
  /ORDER=ANALYSIS.
*N=55739.


Delete variables Inschrijfdatum_years Uitschrijfdatum_years.





*--------------------------------eventueel-------------------------------------.
* als inschrijfdatum is missing en uitschrijfdatum niet. 
Temporary.
Select IF (MISSING(dinschrijfdatum)) AND (~MISSING(duitschrijfdatum)).
List dinschrijfdatum duitschrijfdatum.
Execute.
*N=5146 (eventueel nog missing maken bij uitschrijfdatum).

* als uitschrijfdatum is missing en inschrijfdatum  niet. 
Temporary.
Select IF (MISSING(duitschrijfdatum)) AND (~MISSING(dinschrijfdatum)).
List dinschrijfdatum duitschrijfdatum.
Execute.
*N=12025 (eventueel nog missing maken bij uitschrijfdatum).


FREQUENCIES VARIABLES=duitschrijfdatum dinschrijfdatum
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
