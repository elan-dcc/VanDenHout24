* Encoding: UTF-8.
*cleaning labwaarde  height.
*willemijn van den hout.
*31-10-2023.


*aan de height dataset ook geslacht toevoegen om afkappunten te bepalen voor mannen en vrouwen.


GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\PAT.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /TABLE='DataSet2'
  /RENAME (Extractiedatum Systeem StartDate EndDate PRAKNR dPostcodecijfers iGeboortejaar 
    iOverlijdensjaar dCategoriePatient dinschrijfdatum duitschrijfdatum = d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 
    d10) 
  /BY PATNR
  /DROP= d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10.
EXECUTE.


FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n =1.246.475.

* Identify Duplicate Cases.
SORT CASES BY PATNR(A) height(A) height_date(A).
MATCH FILES
  /FILE=*
  /BY PATNR height height_date
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

FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

*n=120.686.

RECODE dGeslacht ('M'=0) ('V'=1) (ELSE=sysmis) into geslacht_num.
Value labels geslacht_num 0 'man' 1 'vrouw'.
Formats geslacht_num (f6.0).
execute.

Delete variables dGeslacht.


* Variabele eenheid lijkt neit betrouwbaar, emermaals staat er een cm achter een lengte die eerder in meter lijkt te zijn en andersom.
*het blijkt dat er soms een meter achter de cm staat en soms een cm achter de lengte als het meter moet zijn en omgekeerd. Dus de eenheid is niet betrouwbaar altijd. 
*Nu ervoor gekozen om te varen om de waarden dus als het is binnen de range van waarden van meters valt: 1.45 t/m 2.05 deze waarden allemaal omgerekend in cm ervan uit gaande
    *dat deze dus in meters zijn weergegeven en wel plausibel zijn. Dus niet gevaart op de eenheid, want dan krijg je bepaalde waarden die dan ipv 168 (m?) die worden dan 16800 bijvoorbeeld.


FREQUENCIES VARIABLES=Eenheid
  /ORDER=ANALYSIS.

Temporary.
Select if (Eenheid= 'm' or Eenheid= ',m' or Eenheid= ' m' or Eenheid= 'meter' or Eenheid= 'M').
FREQUENCIES VARIABLES=height
    /FORMAT=NOTABLe
  /ORDER=ANALYSIS.
*n=101.475.
*dit zijn de aantallen dus die in meter zijn, maar daar lijken dus ook aantallen tussen te zitten waar de eenheid toch cm  blijtk te zijn.
*dus onderstaande strategeie gehandhaafd als waarden 1.45 t/m2.05 blijkt te zijn, deze vermenigvuldigd met 100 ongeacht de eenheid.

*mannen.
Temporary.
select if  geslacht_num=0 AND (height >=1.55 AND height<=2.05).
FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=74.874.


*vrouwen.
Temporary.
select if  geslacht_num=1 AND (height >=1.45 AND height<=1.95).
FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=77.225.

*mannen envrouwen samen met ander afkappunt.
Temporary. 
select if  (geslacht_num=1 AND (height >=1.45 AND height<=1.95)) OR (geslacht_num=0 AND (height >=1.55 AND height<=2.05)).
FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=152.099.

IF (geslacht_num=1 AND (height >=1.45 AND height<=1.95)) OR (geslacht_num=0 AND (height >=1.55 AND height<=2.05)) height=height * 100.
EXECUTE.


FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

*nu outliers selecteren van lengte in cm.
Temporary.
select if  (geslacht_num=1 AND (height <145 OR height>195)) OR (geslacht_num=0 AND (height <155 OR height>205)) OR ((missing(geslacht_num) AND (height <145 OR height>205))).
FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=8541.

*outliers missing maken. 

Do IF (geslacht_num=1 AND (height <145 OR height>195)) OR (geslacht_num=0 AND (height <155 OR height>205)) OR ((missing(geslacht_num) AND (height <145 OR height>205))).
RECODE height (ELSE=SYSMIS).
End if.
Execute.


FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1.117.248.





*HIERONDER KIJKEN OF ER NOG OUTLIERS PER INDIVIDU ZIJN.
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
*standaarddeviaties berekenen in een individu.



AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_sd=SD(height).

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_mean=MEAN(height).

COMPUTE min2SDheight = height_mean - (2*height_sd).
execute.

COMPUTE plus2SDheight = height_mean+(2*height_sd).
execute.

COMPUTE tweeSDafwijkend = $SYSMIS.
EXECUTE.

temporary.
Select IF (height<min2SDheight OR height >plus2SDheight).
FREQUENCIES VARIABLES=height min2SDheight plus2SDheight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n = 23005..

Do IF (height<min2SDheight OR height >plus2SDheight).
compute tweeSDafwijkend=1.
End if.
Execute.


*sd afwijkend.
COMPUTE min1SDheight = height_mean - (height_sd).
execute.

COMPUTE plus1SDheight = height_mean+(height_sd).
execute.

COMPUTE eenSDafwijkend = $SYSMIS.
EXECUTE.

temporary.
Select IF (height<min1SDheight OR height >plus1SDheight).
FREQUENCIES VARIABLES=height min2SDheight plus2SDheight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n = 114.605.

Do IF (height<min1SDheight OR height >plus1SDheight).
compute eenSDafwijkend=1.
End if.
Execute.


*ook  drie SD afwijkend gemaakt.

COMPUTE min3SDheight = height_mean - (3*height_sd).
execute.

COMPUTE plus3SDheight = height_mean+(3*height_sd).
execute.


COMPUTE drieSDafwijkend = $SYSMIS.
EXECUTE.

temporary.
Select IF (height<min3SDheight OR height >plus3SDheight).
FREQUENCIES VARIABLES=height min2SDheight plus2SDheight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n = 5907.

Do IF (height<min3SDheight OR height >plus3SDheight).
compute drieSDafwijkend=1.
End if.
Execute.

Delete variables plus1SDheight min1SDheight min2SDheight plus2SDheight min3SDheight plus3SDheight .
*nu heb ik 1 2 en 3 standaardeviaties berkeend binnen een individu.



*minimum en maximum selecteren en het verschil berekend.

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_min=MIN(height).

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_max=MAX(height).

Compute Verschilminmax=height_max - height_min.
    execute.





Temporary.
select if Verschilminmax>8.
FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*verschil is meer dan 8 cm.
*n=27516.

temporary.
select if Verschilminmax>8.
FREQUENCIES VARIABLES=tweeSDafwijkend eenSDafwijkend drieSDafwijkend
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

Temporary.
select if Verschilminmax>10.
FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*verschil is meer dan 10 cm.
*n=14017.
    





temporary.
select if Verschilminmax>10.
FREQUENCIES VARIABLES=tweeSDafwijkend eenSDafwijkend drieSDafwijkend
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*verschil is meer dan 10 cm.
*n=14017.
    

*nu gekozemn voor 10 cm overshchilmdat literatuur zegt dat mensen 1cm per 10 jaar krimpen.



temporary.
select if Verschilminmax>10 AND eenSDafwijkend=1.
FREQUENCIES VARIABLES=height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=2918..

Do if verschilminmax>10 AND eenSDafwijkend=1.
compute height=$sysmis.
end if.
execute.







*------------------------------------------------------------..
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_min2=MIN(height).

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_max2=MAX(height).

Compute Verschilminmax2=height_max2-height_min2.
    execute.

temporary.
select if Verschilminmax2>10.
FREQUENCIES VARIABLES=height PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1628. =is ongeveer  n=130 patienten .


*dit patientenummer heeft heel veel gemeten lengtes, waarbij er geen peil op te trekken is, welke de goede is, het kan zo om de dag heel veel cm wisselen.
USE ALL.
COMPUTE filter_$=(PATNR=772570533).
VARIABLE LABELS filter_$ ' (PATNR=772570533)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES=height
  /ORDER=ANALYSIS.

*n=1044 metingen in deze patienten....
*na overleg besloten deze patient er helemaal uit te halen.

if patnr=772570533 height=$SYSMIS.
execute.

filter off.


*kijken hoeveel er nog extreme verschillen hebben tussen de hoogste en laagste waarden na uitsluiten van bovenstaande.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_min3=MIN(height).

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_max3=MAX(height).

Compute Verschilminmax3=height_max3-height_min3.
    execute.


temporary.
select if Verschilminmax3>10.
FREQUENCIES VARIABLES=height PATNR
    /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=530. (waarvan al 54 missing in een deel van de lengtes).

.

*nieuwe variabelen maken voor betrouwbaarheidsintervallen van mannen en vrouwen om zo de laatste meest waarshcijnlijke lengtes te selecteren.
compute CI95ondergrens=$SYSMIS.
Compute CI95bovengrens=$SYSMIS.


*gebaseerd op tabel van CBS spreiding van mannen lijkt iets groter te zijn. ongeveer + en =2% van gemiddelde gekozen.


USE ALL.
COMPUTE filter_$=(Verschilminmax3>10).
VARIABLE LABELS filter_$ 'Verschilminmax3>10 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


Do if geslacht_num =0.
   compute CI95ondergrens=164.
    compute CI95bovengrens= 198.
    end if.
Do if geslacht_num =1.
   compute CI95ondergrens= 153.
    compute CI95bovengrens= 182.
end if.

execute.


Temporary.
select if (height<CI95ondergrens OR height>CI95bovengrens) AND Verschilminmax3>10.
FREQUENCIES VARIABLES=height PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=63 vallen er buiten CI.

Temporary.
select if (height>=CI95ondergrens AND height<=CI95bovengrens) AND Verschilminmax3 >10.    .
FREQUENCIES VARIABLES=height PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=467 vallen binnnen CI.

compute lengtebuitenCI=$SYSMIS.
Do if (height<CI95ondergrens OR height>CI95bovengrens) AND Verschilminmax3>10.
compute lengtebuitenCI=1.
end if.

execute.

compute lengtebinnenCI=$SYSMIS.
Do if (height>=CI95ondergrens AND height<=CI95bovengrens) AND Verschilminmax3>10.
compute lengtebinnenCI=1.
end if.

execute.


FREQUENCIES VARIABLES=lengtebuitenCI lengtebinnenCI
  /ORDER=ANALYSIS.
*n=63 lengtes die niet binnen het CI vallen.
*n=467 vallen erbinnen.


TEMPORARY.
select if Verschilminmax3>10.
FREQUENCIES VARIABLES=lengtebuitenCI lengtebinnenCI
  /ORDER=ANALYSIS.


*deze lengtes verwijderen.
Do if lengtebuitenCI=1 AND Verschilminmax3>10.
   compute height=$SYSMIS.
end if.
execute.


*kijken hoeveel er nog extreme verschillen hebben tussen de hoogste en laagste waarden.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_min4=MIN(height).

AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /height_max4=MAX(height).

Compute Verschilminmax4=height_max4-height_min4.
    execute.




temporary.
select if Verschilminmax4>10.
FREQUENCIES VARIABLES=height Verschilminmax4
  /ORDER=ANALYSIS.
*n=446.

*deze lengtes verwijderen want beiden lengtes vallen in het CI maar liggen wel 10cm uit elkaar. onduidelijk welke dan nu genomen moete worden.
Do if verschilminmax4>10.
   compute height=$SYSMIS.
end if.
execute.
*n=446.



Delete variables height_sd to Verschilminmax4.

GRAPH
  /HISTOGRAM=height.

FREQUENCIES VARIABLES=height
  /ORDER=ANALYSIS.



