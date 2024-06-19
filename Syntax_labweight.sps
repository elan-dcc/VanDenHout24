* Encoding: UTF-8.
*cleaning labwaarde  weight.
*willemijn van den hout.
*31-10-2023.


FREQUENCIES VARIABLES=weight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n =2.076.335

* Identify Duplicate Cases.
SORT CASES BY PATNR(A) weight(A) weight_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR weight weight_date
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

FREQUENCIES VARIABLES=weight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

*n=1.879.619..


*nu outliers selecteren van gewicht in kg.
Temporary.
select if  (weight < 20 OR weight >250).
FREQUENCIES VARIABLES=weight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=3621.


*outliers missing maken. 
Do IF weight<20 OR weight>250.
RECODE weight (ELSE=SYSMIS).
RECODE weight_date (ELSE=SYSMIS).
End if.
Execute.


FREQUENCIES VARIABLES=weight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

GRAPH
  /HISTOGRAM=weight.
