* Encoding: UTF-8.
*database selectie voorbeeld voor na 2007.
*willemijn van den Hout.
*30-10-2023.

*gecleand epat file openzetten.

* de files inschrijftarieen gecleand en de gecleande PAT (gecleande inschrijfdatum enuitschrijfdatum engeboortejaar) moeten gemerged zijn.

DATASET ACTIVATE DataSet1.
GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Inschrijftarieven_gecleand.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR PRAKNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR PRAKNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /FILE='DataSet2'
  /BY PATNR PRAKNR.
EXECUTE.


Alter type Extractiedatum (sdate10).
FORMATS Extractiedatum (date11).


Delete variables ins_23  to ins_jan06.


*als na cleaning inschrijftarieven en uitschrijftarieven datum missen dan vervangen door gecleande inschrifjdatum en uitschrijfdatum.

    
temporary.
select if Extractiedatum<laatsteuitschrijftariefdatum.
FREQUENCIES VARIABLES= laatsteuitschrijftariefdatum Extractiedatum
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS. 
*n=372266.



Temporary.
SELECT IF (Extractiedatum<duitschrijfdatum).
FREQUENCIES VARIABLES=duitschrijfdatum Extractiedatum
       /FORMAT=NOTABLE
  /ORDER=ANALYSIS. 
list duitschrijfdatum Extractiedatum.
*n=419.



Temporary.
Select if missing (eersteinschrijftariefdatum) AND missing(laatsteuitschrijftariefdatum).
FREQUENCIES VARIABLES= eersteinschrijftariefdatum laatsteuitschrijftariefdatum
       /FORMAT=NOTABLE
  /ORDER=ANALYSIS. 
*n=264557


*als na cleaning inschrijftarieven en uitschrijftarieven datum missen dan vervangen door gecleande inschrifjdatum en uitschrijfdatum.
*nieuwevariabele aanmaken combinatie  van de variabelen tarieven en datums waarvan dus 264557 geen tarife hebben en wroden vervangen door de variablene inschrijf en uitschrijfdatum.
Compute combinatieinschrijfdatumentarief=eersteinschrijftariefdatum.
compute combinatieuitschrijfdatumentarief=laatsteuitschrijftariefdatum.
formats combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief (date11).
execute.



* op basis van missende uitschrijfdatumtarief (hierbij missen ook de inschrijfdatumtarieven) deze vervangen door inschrijfdatum en uitschrijfdatum. *n=264557

If missing(laatsteuitschrijftariefdatum) combinatieinschrijfdatumentarief =dinschrijfdatum.
execute.
If missing(laatsteuitschrijftariefdatum) combinatieuitschrijfdatumentarief =duitschrijfdatum.
execute. 

FREQUENCIES VARIABLES= combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=847669 totaal bij combinatieinschrijfdatumentarief n=45612 missing.
*n=843159 totaal bij combinatieuitschrijfdatumentarief n=50122 missing.


Temporary.
select if missing (combinatieuitschrijfdatumentarief) AND not missing (combinatieinschrijfdatumentarief).
FREQUENCIES VARIABLES= combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=7288.

Temporary.
select if missing (combinatieinschrijfdatumentarief) AND missing (combinatieuitschrijfdatumentarief).
FREQUENCIES VARIABLES= combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=50562.

Temporary.
select if missing (combinatieinschrijfdatumentarief) OR missing (combinatieuitschrijfdatumentarief).
FREQUENCIES VARIABLES= combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=42834.

Temporary.
select if missing (combinatieinschrijfdatumentarief) AND not missing (combinatieuitschrijfdatumentarief).
FREQUENCIES VARIABLES= combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=2778.


Temporary.
Select if combinatieuitschrijfdatumentarief >= DATE.DMY(1,1,2007) AND (not missing(combinatieuitschrijfdatumentarief)) AND (not missing(combinatieinschrijfdatumentarief)). 
FREQUENCIES VARIABLES= combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=711.129.


Temporary.
Select if combinatieuitschrijfdatumentarief >= DATE.DMY(1,1,2007) AND (not missing(combinatieuitschrijfdatumentarief)) 
    AND (not missing(combinatieinschrijfdatumentarief) AND (not missing(iGeboortejaar))).
FREQUENCIES VARIABLES= combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
  *N=710861.

Temporary.
Select if combinatieuitschrijfdatumentarief >= DATE.DMY(1,1,2007) AND (not missing(combinatieuitschrijfdatumentarief)) 
    AND (not missing(combinatieinschrijfdatumentarief) AND (missing(iGeboortejaar))).
FREQUENCIES VARIABLES= combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=268.


*n=711.129.
Temporary.
Select if combinatieuitschrijfdatumentarief >= DATE.DMY(1,1,2007).
FREQUENCIES VARIABLES= combinatieuitschrijfdatumentarief combinatieinschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=711.569.

Temporary.
Select if (combinatieuitschrijfdatumentarief >= DATE.DMY(1,1,2007)) OR (missing(combinatieuitschrijfdatumentarief)). 
FREQUENCIES VARIABLES= combinatieuitschrijfdatumentarief
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=711.569.

Temporary.
  Select if missing (combinatieuitschrijfdatumentarief) OR missing (iGeboortejaar).
FREQUENCIES VARIABLES= combinatieuitschrijfdatumentarief iGeboortejaar
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

Temporary.
  Select if missing (combinatieuitschrijfdatumentarief) and missing (iGeboortejaar).
FREQUENCIES VARIABLES= combinatieuitschrijfdatumentarief iGeboortejaar
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

COMPUTE filter_$=((combinatieuitschrijfdatumentarief >= DATE.DMY(1,1,2007)) OR (missing(combinatieuitschrijfdatumentarief))). 
VARIABLE LABELS filter_$ 'combinatieuitschrijfdatumentarief >= DATE.DMY(1,1,2007) OR '+
    '(missing(combinatieuitschrijfdatumentarief)) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*zowel de missende meenemen in nieuwe database als iedereen na 2007 obv combinatie uitschrijftarief en uitschrijfdatum.
DATASET COPY  PAT_na2007.
DATASET ACTIVATE  PAT_na2007.
FILTER OFF.
USE ALL.
SELECT IF ((combinatieuitschrijfdatumentarief >= DATE.DMY(1,1,2007)) OR (missing(combinatieuitschrijfdatumentarief))).
EXECUTE.
*n=711569 (missing n=50122).


GRAPH
  /HISTOGRAM=combinatieinschrijfdatumentarief.


GRAPH
  /HISTOGRAM=combinatieuitschrijfdatumentarief.


