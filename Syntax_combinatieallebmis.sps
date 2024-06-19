* Encoding: UTF-8.
*syntax all bmi file zowel lab als lengte en gewicht gecombineerd.
*willemijn van den Hout.

*zet bmi lab open en voeg daar aan toe bmi van height en weight.

DATASET ACTIVATE DataSet1.
ADD FILES /FILE=*
  /FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Gecleande '+
    'variabelen vanaf 2007\BMIWeightheight_hoogste_gecleand_2007.sav'
  /RENAME (height2 height2_date weight=d0 d1 d2)
  /DROP=d0 d1 d2.
EXECUTE.

FREQUENCIES VARIABLES=bmi BMIheightweight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.




*ervoor zorgen dat als er nu twee bij de bmi van lab en de zelf berekende bmi's van lengte en gewicht ze op dezelfde datum zijn, deze op een rij komen te staan.

SORT CASES BY PATNR BMI_date weight_date (A).
COMPUTE weight_date2 = $SYSMIS.
COMPUTE BMIheightweight2 = $SYSMIS.  

DO REPEAT #i = 1 TO 310.
  DO IF (PATNR = LAG(PATNR, #i) AND BMI_date = LAG(weight_date, #i)).
    COMPUTE weight_date2= BMI_date.
    COMPUTE BMIheightweight2 = LAG(BMIheightweight, #i).
end if.
END REPEAT.
Execute.


Formats weight_date2 (date11).

* en ervoor zorgen dat alle overige bmis(de lengtes die niet overeenkomen tussen weight date en bmidate) ook in de kolom komen die nieuw is gemaakt .
SORT CASES BY PATNR weight_date weight_date2(A). 
Compute nieuwe_variabele=$SYSMIS.
  DO REPEAT #i = 1 TO 350.
   Do  IF (weight_date = LAG(weight_date2, #i) AND PATNR = LAG(PATNR, #i)). 
      COMPUTE nieuwe_variabele = 1.
    END IF.
  END REPEAT.
EXECUTE.


FREQUENCIES VARIABLES=bmi BMIheightweight2 nieuwe_variabele
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=N=1.333.135  hebben overlap in de datum van bmi lab en berekende bmi van gewicht en lengte. Dus zowel een berekende bmi als een lab waarde bmi.



* de dubbele eruit halen.
DO IF nieuwe_variabele =1.
    Recode weight_date(ELSE=SYSMIS).
    Recode BMIheightweight (ELSE=SYSMIS).
End if.
Execute.

* degene die over blijven in de nieuwe datum variabele (weight2_date) zetten. 
Do if not missing (weight_date).
    Compute weight_date2=weight_date.
End if.
execute.

* degene die over blijven in de nieuwe bmi variabele (bmiheightweight2) zetten. 
Do if not missing (BMIheightweight).
    Compute BMIheightweight2=BMIheightweight.
End if.
execute.

DELETE VARIABLES BMIheightweight weight_date.

* cases nu eruit halen die alleen maar sysmis bevatten.
FREQUENCIES VARIABLES=nieuwe_variabele
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

temporary.
select if nieuwe_variabele =1.
FREQUENCIES VARIABLES=bmi BMI_date BMIheightweight2 weight_date2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


USe all.
SELECT IF (missing(nieuwe_variabele)).
EXECUTE.
FILTER OFF.

FREQUENCIES VARIABLES=nieuwe_variabele bmi BMIheightweight2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.



DELETE VARIABLES nieuwe_variabele.

*nu zorgen dat er geen dubbele meer instaan van bmi lab en bmi berkend height en weight (


GRAPH
  /SCATTERPLOT(BIVAR)=BMIheightweight2 WITH bmi
  /MISSING=LISTWISE.


compute verschilinbmi=BMIheightweight2-bmi.
execute.

*nog even kijken hoeveel van de verschillen in bmi op twee dagen geen vershcil hebben dus verschil im bmi=0.

formats verschilinbmi (f3.2).
temporary.
select if verschilinbmi<0.01 and verschilinbmi>-0.01.
FREQUENCIES VARIABLES= verschilinbmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1.123.821.
temporary.
select if verschilinbmi>2 or verschilinbmi<-2.
FREQUENCIES VARIABLES= bmi BMIheightweight2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=5708..



*variabele maken met alle bmi lab waarden en de overige height weight, 
    maar ook  de andere variable maken met alle berekende bmi's van lengte en gewicht en de overige lab waarden aangevuld, 
    om zo de SD van ieder individu te kunen berekenen en te kijken welke van de twee waarden die op dezelfde dagen zijn gemeten het meest toereikend is.

*dit zijn alle gekozen waarden berekend van bmi height en weight aangevuld met de bmi lab.
compute bmiheightweight2alle =$SYSMIS.
execute.

Do if missing(BMIheightweight2).
compute bmiheightweight2alle=bmi.
end if.
execute.
do if not missing( BMIheightweight2).
compute bmiheightweight2alle=bmiheightweight2.
end if.
execute.



*dit zijn alle gekozen waarden van lab bmi aangevuld met de bmi height weight.
compute bmilaballe =$SYSMIS.
execute.

Do if missing(bmi).
compute bmilaballe=BMIheightweight2.
end if.
execute.
do if not missing( bmi).
compute bmilaballe=bmi.
end if.
execute.

*SD berkeenen van allebee de variabelen. er wordt uiteindelijk gekozen voor de bmi die ervoor zorgt dat de SD het kleinst is, 
    dan is de spreiding dus het laagst en ligt die waarden het dichts bij de vorige.

*SD berekenen.
AGGREGATE
  /OUTFILE=* MODE=ADDVARIABLES
  /BREAK=PATNR
  /bmiheightweight2alle_mean=MEAN(bmiheightweight2alle) 
  /bmiallelab_mean=MEAN(bmilaballe) 
  /bmiheightweight2alle_sd=SD(bmiheightweight2alle) 
  /bmiallelab_sd=SD(bmilaballe).


USE ALL.
COMPUTE filter_$=(verschilinbmi>2 or verschilinbmi<-2.).
VARIABLE LABELS filter_$ 'verschilinbmi>2 or verschilinbmi<-2. (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
.

FREQUENCIES VARIABLES=verschilinbmi
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

filter off.

*kijken wanneer de sd het grootste is.
temporary.
select if (verschilinbmi>2 or verschilinbmi<-2) AND (bmiallelab_sd<bmiheightweight2alle_sd).
FREQUENCIES VARIABLES=bmi BMIheightweight2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


Do if (verschilinbmi>2 or verschilinbmi<-2) AND (bmiallelab_sd<bmiheightweight2alle_sd). 
compute BMIheightweight2 = $SYSMIS.
    compute weight_date2=$SYSMIS.
end if.
    execute.
*N=1766..

temporary.
select if  (verschilinbmi>2 or verschilinbmi<-2) AND bmiallelab_sd>bmiheightweight2alle_sd.
FREQUENCIES VARIABLES=bmi BMIheightweight2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

Do if  (verschilinbmi>2 or verschilinbmi<-2) AND bmiallelab_sd>bmiheightweight2alle_sd.
compute bmi = $SYSMIS.
    compute BMI_date=$SYSMIS.
end if.
    execute.
*N=3842,.


*indien er een verschil van groter dan 2 kg/m2 maar ook een missende sd binnen deze dan zijn er maar metingen gedaan op 1 dag.
temporary.
select if  (verschilinbmi>2 or verschilinbmi<-2) AND missing (bmiallelab_sd).
FREQUENCIES VARIABLES=bmi BMIheightweight2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

Do if (verschilinbmi>2 or verschilinbmi<-2) AND missing (bmiallelab_sd).
compute BMIheightweight2 = $SYSMIS.
    compute weight_date2=$SYSMIS.
end if.
execute.
*n=97.

filter off.

*bij n=97 is er geen sd berkeend omdat er dan dus maar 1 datum een beschikbaar bmi van lab heeft en van height en weight. Bij deze gekozen voor de bmi van lab.


temporary.
select if (verschilinbmi>2 OR verschilinbmi<-2) AND (bmiheightweight2alle_sd=bmiallelab_sd).
FREQUENCIES VARIABLES= bmi BMIheightweight2 weight_date2 BMI_date
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

*n=3.
*dit blijft over.


DO if (verschilinbmi>2 OR verschilinbmi<-2) AND (bmiheightweight2alle_sd=bmiallelab_sd).
compute BMIheightweight2 = $sysmis.
compute weight_date2 = $sysmis.
end if.
execute.
*n=3.


* de overige dubbele data met bmis die dus minder dan <2kg/m2 verschillenworden vervangen door bmi van lab.
temporary.
select if (weight_date2=BMI_date).
FREQUENCIES VARIABLES= bmi BMIheightweight2 weight_date2 BMI_date
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1.327.427.



DO if weight_date2=BMI_date.
compute BMIheightweight2 = $sysmis.
compute weight_date2 = $sysmis.
end if.
execute.
*n=1.327.427.




FREQUENCIES VARIABLES=BMI_date bmi BMIheightweight2 weight_date2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.


*totaal n= 1.798.053 BMIs (n=1.405.995 bmi lab en n=392058 van lengte en gewicht).

filter off.


Delete variables verschilinbmi to bmiallelab_sd.
 * 1 bmi heeft geen patientnummer deze verwijderd.

*nu van beide variabelen zowel berekende als lab samenvoegen in een variabelen met alle bmi's.

Compute bmiall=bmi.
Compute bmidatumall=BMI_date.

Do if missing (bmiall) and missing(bmidatumall).
compute bmiall=BMIheightweight2.
compute bmidatumall=weight_date2.
end if.
execute.

Formats bmidatumall (date11).



FREQUENCIES VARIABLES=bmiall bmidatumall
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*N=1.798.052.

*tot slot voor mijn onderzoek apart bestand gemaakt met alleen de eerste bmi van iedere patient voor het hoofdbestand de PAT file.
SORT CASES BY PATNR(A) bmidatumall(A).
DATASET DECLARE first.
AGGREGATE
  /OUTFILE='first'
  /BREAK=PATNR
  /bmidatumall_first=FIRST(bmidatumall) 
  /bmiall_first=FIRST(bmiall).

FREQUENCIES VARIABLES=bmiall_first
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.




