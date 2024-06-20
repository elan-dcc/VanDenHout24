* Encoding: UTF-8.
*cleaning icpc diabetes type 1 T90.01.
*willemijn van den hout.
*13-11-2023.


FREQUENCIES VARIABLES=Diabetestype1
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


* Identify Duplicate Cases.
SORT CASES BY PATNR(A) Diabetestype1(A) Diabetestype1_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR Diabetestype1 Diabetestype1_date
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


Alter type Diabetestype1_date (sdate10).
FORMATS Diabetestype1_date (date11).

FREQUENCIES VARIABLES=Diabetestype1 
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

RECODE Diabetestype1 ('T90.01'=1) (ELSE =0) INTO diabetestype1_num.
Value labels diabetestype1_num 0 'geen' 1 'DM T90.01'.
Formats diabetestype1_num (f6.0).
execute.

FREQUENCIES VARIABLES=diabetestype1_num
  /FORMAT=NOTABLE
    /ORDER=ANALYSIS.
    

Delete variables Diabetestype1.



*datum van deze icpc had geen outliers.
*aleen eerste icpc alleen selecteren in aparte dataset voor mijn analsye.

SORT CASES BY PATNR(A) Diabetestype1_date(A).
DATASET DECLARE first.
AGGREGATE
  /OUTFILE='first'
  /BREAK=PATNR
  /Diabetestype1_date_first=FIRST(Diabetestype1_date) 
  /diabetestype1_num_first=FIRST(diabetestype1_num).

FREQUENCIES VARIABLES=diabetestype1_num_first
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
.

