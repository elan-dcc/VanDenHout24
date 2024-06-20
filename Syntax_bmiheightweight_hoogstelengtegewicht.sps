* Encoding: UTF-8.
*cleaning bmi van de variabelen height en weight.
*willemijn van den Hout
 * 03-11-2023.

*bestanden van gecleande height en weight samenvoegen.

*daarbij gecleande weight openzetten bestand en daarbij met de volgende command height gecleand toevoegen.


*lengte aan gewicht toevoegen.
ADD FILES /FILE=*
  /FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Gecleande '+
    'variabelen vanaf 2007\Height_gecleand_2007.sav'.
EXECUTE.

DELETE VARIABLES Eenheid geslacht_num.

FREQUENCIES VARIABLES=weight height
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.



*ervoor zorgen dat lengte en gewicht die op dezelfde datum zijn gemeten bij elkaar in dezelfde rij komen te staan.

SORT CASES BY PATNR weight_date height_date (A).
COMPUTE height2_date = $SYSMIS.
COMPUTE height2 = $SYSMIS.  

DO REPEAT #i = 1 TO 350.
  DO IF (PATNR = LAG(PATNR, #i) AND weight_date = LAG(height_date, #i)).
    COMPUTE height2_date = weight_date.
    COMPUTE height2 = LAG(height, #i).
end if.
END REPEAT.
Execute.

Formats height2_date (date11).

* en ervoor zorgen dat alle overige lengtes(de lengtes die niet overeenkomen tussen height date en weightdate) ook in de kolom komen die nieuw is gemaakt .
SORT CASES BY PATNR height_date height2_date. 
Compute nieuwe_variabele=$SYSMIS.
  DO REPEAT #i = 1 TO 350.
   Do  IF (height_date = LAG(height2_date, #i) AND PATNR = LAG(PATNR, #i)). 
      COMPUTE nieuwe_variabele = 1.
    END IF.
  END REPEAT.
EXECUTE.

* de dubbele eruit halen.
DO IF nieuwe_variabele =1.
    Recode height_date(ELSE=SYSMIS).
    Recode height (ELSE=SYSMIS).
End if.
Execute.

* degene die over blijven in de nieuwe datum variabele (height2_date) zetten. 
Do if not missing (height_date).
    Compute height2_date=height_date.
End if.
execute.

* degene die over blijven in de nieuwe lengte variabele (height) zetten. 
Do if not missing (height).
    Compute height2=height.
End if.
execute.

DELETE VARIABLES height_date height.

* cases nu eruit halen die alleen maar sysmis bevatten.
FREQUENCIES VARIABLES=nieuwe_variabele
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=837293.

FILTER OFF.
USE ALL.
SELECT IF (missing(nieuwe_variabele)).
EXECUTE.

Delete variables nieuwe_variabele.

*nu staan alle gewichten en lengtes met een zelfde datum binnen een patient in dezelfde rij.

FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1.925.998.

Temporary.
select if not missing (weight) ANd missing (height2).
FREQUENCIES VARIABLES=weight height2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
  *n=798.819.

Temporary.
select if missing (weight) ANd not missing (height2).
FREQUENCIES VARIABLES=weight height2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
 *n=42.962.


*dubbele metingen op een dag eruit halen gewicht (laagste gewicht wordt geselecteerd).
SORT CASES BY PATNR(A)  weight_date (A) weight(D). 
Compute dubbel_gewichth=$SYSMIS.
  DO REPEAT #i = 1 TO 350.
   Do  IF (weight_date = LAG(weight_date, #i) AND PATNR = LAG(PATNR, #i)). 
      COMPUTE dubbel_gewichth = 1.
    END IF.
  END REPEAT.
EXECUTE.


*dubbele metingen op een dag eruit halen lengte (laagste lengte selecteren).
SORT CASES BY  PATNR(A) height2_date(A) height2 (D). 
Compute dubbel_lengteh=$SYSMIS.
  DO REPEAT #i = 1 TO 350.
   Do  IF (height2_date = LAG(height2_date, #i) AND PATNR = LAG(PATNR, #i)). 
      COMPUTE dubbel_lengteh = 1.
    END IF.
  END REPEAT.
EXECUTE.





*meerdere metingen op 1 dag.
FREQUENCIES VARIABLES=dubbel_lengteh dubbel_gewichth
  /ORDER=ANALYSIS.
 *n=10321..
*n=13424..


* de dubbele data van height eruit halen de laagste lengte wordt eruit gehaald, de hoogste blijft.
DO IF dubbel_lengteh =1.
    Recode height2_date(ELSE=SYSMIS).
    Recode height2 (ELSE=SYSMIS).
End if.
Execute.


* de dubbele data van weight eruit halende laagste gewicht wordt eruit gehaald, de hoogste blijft.
Do if dubbel_gewichth =1.
 Recode weight_date(ELSE=SYSMIS).
  Recode weight (ELSE=SYSMIS).
End if.
Execute.





Temporary.
select if dubbel_lengteh=1 OR dubbel_gewichth =1.
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=293151.



Temporary.
select if dubbel_lengteh=1 AND dubbel_gewichth =1.
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.





*als nu blijkt dat alle variabelen missing zijn omdat de lengte en gewicht nu zijn samengevoegd de case eruit halen.
FILTER OFF.
USE ALL.
SELECT IF ( ~ missing (weight_date) OR  ~ missing( height2_date) OR  ~  missing(height2) OR  ~ missing (weight)).
EXECUTE.

FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1.908492.

DELETE VARIABLES dubbel_gewichth dubbel_lengteh.

 
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.

*aantallen bekijken die een missende lengte hebben bij wel een gemeten gewicht.
Temporary.
select if not missing (weight) ANd missing (height2).
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
  *n=794.911.

Temporary.
select if not missing (weight_date) ANd missing (height2_date).
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
 *n=787.126.

*aantallen bekijken die een missend gewicht hebben bij wel een gemeten lengte.

Temporary.
select if missing (weight) ANd not missing (height2).
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
 *n=42925. 


Temporary.
select if missing (weight_date) ANd not missing (height2_date).
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
 *n=45674.

* nu alle gewichten die geen lengte hebben vervangen * als de lengte al eerder gemeten is.

If not missing (weight) AND missing (height2) lengte_eerdergemeten = 1.
execute.

FREQUENCIES VARIABLES=lengte_eerdergemeten 
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=794.911.


compute vorigelengte = $sysmis.

SORT CASES BY PATNR(A) weight_date (A) height2_date(A) .  
  DO REPEAT #i = 1 TO 350.
   Do IF (lengte_eerdergemeten=1) AND (PATNR = LAG(PATNR, #i)). 
        COMPUTE vorigelengte = LAG(height2).
END IF.
End repeat.
execute.

SORT CASES BY PATNR(A) weight_date (A) height2_date(A) .  
  DO REPEAT #i = 1 TO 350.
Do if (lengte_eerdergemeten=1) AND missing (vorigelengte) AND (PATNR = LAG(PATNR, #i)).
Compute vorigelengte= LAG (vorigelengte,#i).
END IF.
End repeat.
execute.

* het aantal 'oude'lengtes dat bij een gewicht toegevoegd wordt.
FREQUENCIES VARIABLES=vorigelengte 
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=653.719.



compute BMIheightweight = weight/ ((height2)/100)**2.
execute.

FREQUENCIES VARIABLES=BMIheightweight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1.067.663.. 

compute BMIheightweight2= weight/ (vorigelengte/100)**2.
execute.

*aantal bmis berekend van dichtsbijzijnde lengte.
FREQUENCIES VARIABLES=BMIheightweight2
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=653.719.

DO If not missing (BMIheightweight2).
    Compute BMIheightweight=BMIheightweight2.
end if.
Execute.

FREQUENCIES VARIABLES=BMIheightweight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1.721.382
*missing N=186.866..


*als dan blijkt dat er geen bmi wordt berekend dan is er dus alleen een legnte of een gewicht beschikbaar, deze eruit halen dan, want wordt niet meegeteld als bmi.
FILTER OFF.
USE ALL.
SELECT IF ( ~ missing (weight_date) OR  ~ missing( height2_date) OR  ~  missing(height2) OR  ~ missing (weight)).
EXECUTE.


*Outliers eruit halen.
Temporary.
select if  BMIheightweight<10 OR BMIheightweight>80.
list BMIheightweight.
*n=31.

Do IF BMIheightweight<10 OR BMIheightweight>80.
RECODE BMIheightweight(ELSE=SYSMIS).
End if.
Execute.


FREQUENCIES VARIABLES=BMIheightweight
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*Totaal n=1.721.351
Missing n=186.897.


*als dan blijkt dat er geen bmi wordt berekend dan is er dus alleen een adequate legnte of een gewicht beschikbaar, deze eruit halen dan, want wordt niet meegeteld als bmi.
FILTER OFF.
USE ALL.
SELECT IF ~ missing (BMIheightweight).
EXECUTE.

GRAPH
  /HISTOGRAM=BMIheightweight.

Delete variables lengte_eerdergemeten vorigelengte BMIheightweight2.

FREQUENCIES VARIABLES=BMIheightweight
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN MEDIAN
  /ORDER=ANALYSIS.

FREQUENCIES VARIABLES=weight height2
  /FORMAT=NOTABLE
    /ORDER=ANALYSIS.
  /ORDER=ANALYSIS.
