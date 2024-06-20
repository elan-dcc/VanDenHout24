* Encoding: UTF-8.
*cleaning icpc hypertensie.
*willemijn van den hout.
*13-11-2023.


FREQUENCIES VARIABLES=hypertension
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


* Identify Duplicate Cases.
SORT CASES BY PATNR(A) hypertension(A) hypertension_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR hypertension hypertension_date
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



ALter type hypertension_date (sdate10).
FORMATS hypertension_date (date11).

*datum van icpc cleanen.
DO IF (hypertension_date>= (DATE.DMY(01,07,2023))).
RECODE hypertension_date (ELSE=SYSMIS).
END if.
Execute.


FREQUENCIES VARIABLES=hypertension 
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

RECODE hypertension ('K85'=1) ('K86'=2) ('K87'=3) (ELSE = 0) INTO hypertensie_num.
Value labels hypertensie_num 0 'geen' 1 'hoge bloeddruk K85 ' 2 'HT zonder orgaanschade K86' 3 'HT met orgaanschade K87'.
Formats hypertensie_num (f6.0).
EXECUTE.

Delete variables hypertension.

FREQUENCIES VARIABLES=hypertensie_num 
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


*tot slot voor mijn onderzoek apart bestand gemaakt met alleen de eerste icpc van iedere patient (sommigen hebben namelijk meerdere keer de icpc code.
SORT CASES BY PATNR(A) hypertension_date(A).
DATASET DECLARE first.
AGGREGATE
  /OUTFILE='first'
  /BREAK=PATNR
  /hypertension_date_first=FIRST(hypertension_date) 
  /hypertensie_num_first=FIRST(hypertensie_num).

FREQUENCIES VARIABLES=hypertensie_num_first
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=97545.
