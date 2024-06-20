* Encoding: UTF-8.
*cleaning icpc diabetes type 2 T90.02.
*willemijn van den hout.
*13-11-2023.


FREQUENCIES VARIABLES=Diabetestype2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


* Identify Duplicate Cases.
SORT CASES BY PATNR(A) Diabetestype2(A) Diabetestype2_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR Diabetestype2 Diabetestype2_date
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


ALter type Diabetestype2_date (sdate10).
FORMATS Diabetestype2_date (date11).


FREQUENCIES VARIABLES=Diabetestype2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

RECODE Diabetestype2 ('T90.02'=1) (ELSE =0) INTO diabetestype2_num.
Value labels diabetestype2_num 0 'geen' 1 'DM T90.02'.
Formats diabetestype2_num (f6.0).
execute.


Delete variables Diabetestype2.

*datum van deze icpc bevatte geen outliers.


*aleen eerste icpc alleen selecteren in aparte dataset voor mijn analsye.

SORT CASES BY PATNR(A) Diabetestype2_date(A).
DATASET DECLARE first.
AGGREGATE
  /OUTFILE='first'
  /BREAK=PATNR
  /Diabetestype2_date_first=FIRST(Diabetestype2_date) 
  /diabetestype2_num_first=FIRST(diabetestype2_num).

FREQUENCIES VARIABLES=diabetestype2_num_first
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=32546.



