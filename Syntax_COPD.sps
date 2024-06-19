* Encoding: UTF-8.
*cleaning icpc copd.
*willemijn van den hout.
*13-11-2023.


FREQUENCIES VARIABLES=copd
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

* Identify Duplicate Cases.
SORT CASES BY PATNR(A) copd(A) copd_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR copd copd_date
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

FREQUENCIES VARIABLES=copd
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

Alter type copd_date (sdate10).
FORMATS copd_date (date11).

RECODE copd ('R95'=1) ('R91'=2) ('R91.01'=3) ('R91.02'=4) (ELSE = 0) INTO copd_num.
Value labels copd_num 0 'geen' 1 'COPD/emfyseem R95' 2 'chronische bronchitiis/bronchiectasieen R91' 3 'Chronische bronchitis R91.01' 4 'Bronchiectasieen R91.02'.
Formats copd_num (f6.0).
execute.

Delete variables copd.

*er waren geen outliers van de variabele datum copd (COPD_date).


*tot slot voor mijn onderzoek apart bestand gemaakt met alleen de eerste icpc van iedere patient (sommigen hebben namelijk meerdere keer de icpc code.
SORT CASES BY PATNR(A) copd_date(A).
DATASET DECLARE first.
AGGREGATE
  /OUTFILE='first'
  /BREAK=PATNR
  /copd_date_first=FIRST(copd_date) 
  /copd_num_first=FIRST(copd_num).

FREQUENCIES VARIABLES=copd_num_first
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n17466.
