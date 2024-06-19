* Encoding: UTF-8.
*cleaning icpc diabetes T90.
*willemijn van den hout.
*13-11-2023.


FREQUENCIES VARIABLES=Diabetes
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


* Identify Duplicate Cases.
SORT CASES BY PATNR(A) Diabetes(A) Diabetes_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR Diabetes Diabetes_date
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

Alter type Diabetes_date (sdate10).
FORMATS Diabetes_date (date11).
Delete variables PrimaryLast.
EXECUTE.

FREQUENCIES VARIABLES=Diabetes 
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

RECODE Diabetes ('T90'=1) (Else=0) INTO diabetesT90_num.
Value labels diabetesT90_num 0 'geen' 1 'DM T90.0'.
Formats diabetesT90_num (f6.0).
execute.

FREQUENCIES VARIABLES=diabetesT90_num 
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
Delete variables Diabetes.


*datum van deze icpc diabetes had geen outliers. .


*eerste icpc s alleen selecteren in database voor mijn analsye.

SORT CASES BY PATNR(A) Diabetes_date(A).
DATASET DECLARE first.
AGGREGATE
  /OUTFILE='first'
  /BREAK=PATNR
  /Diabetes_date_first=FIRST(Diabetes_date) 
  /diabetesT90_num_first=FIRST(diabetesT90_num).

FREQUENCIES VARIABLES=diabetesT90_num_first
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
