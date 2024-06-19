* Encoding: UTF-8.
*bmi project
Willemijn van den Hout
15-10-2023
syntax inschrijftarieven.

* eerst bekijken of er tussen aaneen lopende inschrijftariefen gaten vallen en hoeveel patienten zijn dat?.
temporary.
Select if ((MIN (ins_jul23 to ins_jan06)) AND (Max (ins_jul23 to ins_jan06))).
FREQUENCIES VARIABLES=PATNR
  /FORMAT= NOTABLE
    /ORDER=ANALYSIS.
execute.
*N=628724


*maanden januari.
DO IF (ins_jan23=1).
COMPUTE ins_jan23=DATE.DMY(01,01,2023).
VARIABLE LABELS ins_jan23.
FORMATS ins_jan23 (date11).
Variable width ins_jan23 (14).
End if.
Execute.

DO IF (ins_jan22=1).
COMPUTE ins_jan22=DATE.DMY(01,01,2022).
VARIABLE LABELS ins_jan22.
FORMATS ins_jan22 (date11).
Variable width ins_jan22 (14).
End if.
Execute.

DO IF (ins_jan22=1).
COMPUTE ins_jan22=DATE.DMY(01,01,2022).
VARIABLE LABELS ins_jan22.
FORMATS ins_jan22 (date11).
Variable width ins_jan22 (14).
End if.
Execute.

DO IF (ins_jan21=1).
COMPUTE ins_jan21=DATE.DMY(01,01,2021).
VARIABLE LABELS ins_jan21.
FORMATS ins_jan21 (date11).
Variable width ins_jan21 (14).
End if.
Execute.

DO IF (ins_jan20=1).
COMPUTE ins_jan20=DATE.DMY(01,01,2020).
VARIABLE LABELS ins_jan20.
FORMATS ins_jan20 (date11).
Variable width ins_jan20 (14).
End if.
Execute.

DO IF (ins_jan19=1).
COMPUTE ins_jan19=DATE.DMY(01,01,2019).
VARIABLE LABELS ins_jan19.
FORMATS ins_jan19 (date11).
Variable width ins_jan19 (14).
End if.
Execute.

DO IF (ins_jan18=1).
COMPUTE ins_jan18=DATE.DMY(01,01,2018).
VARIABLE LABELS ins_jan18.
FORMATS ins_jan18 (date11).
Variable width ins_jan18 (14).
End if.
Execute.

DO IF (ins_jan17=1).
COMPUTE ins_jan17=DATE.DMY(01,01,2017).
VARIABLE LABELS ins_jan17.
FORMATS ins_jan17 (date11).
Variable width ins_jan17 (14).
End if.
Execute.

DO IF (ins_jan16=1).
COMPUTE ins_jan16=DATE.DMY(01,01,2016).
VARIABLE LABELS ins_jan16.
FORMATS ins_jan16 (date11).
Variable width ins_jan16 (14).
End if.
Execute.

DO IF (ins_jan15=1).
COMPUTE ins_jan15=DATE.DMY(01,01,2015).
VARIABLE LABELS ins_jan15.
FORMATS ins_jan15 (date11).
Variable width ins_jan15 (14).
End if.
Execute.

DO IF (ins_jan14=1).
COMPUTE ins_jan14=DATE.DMY(01,01,2014).
VARIABLE LABELS ins_jan14.
FORMATS ins_jan14 (date11).
Variable width ins_jan14 (14).
End if.
Execute.

DO IF (ins_jan13=1).
COMPUTE ins_jan13=DATE.DMY(01,01,2013).
VARIABLE LABELS ins_jan13.
FORMATS ins_jan13 (date11).
Variable width ins_jan13 (14).
End if.
Execute.

DO IF (ins_jan12=1).
COMPUTE ins_jan12=DATE.DMY(01,01,2012).
VARIABLE LABELS ins_jan12.
FORMATS ins_jan12 (date11).
Variable width ins_jan12 (14).
End if.
Execute.

DO IF (ins_jan11=1).
COMPUTE ins_jan11=DATE.DMY(01,01,2011).
VARIABLE LABELS ins_jan11.
FORMATS ins_jan11 (date11).
Variable width ins_jan11 (14).
End if.
Execute.

DO IF (ins_jan10=1).
COMPUTE ins_jan10=DATE.DMY(01,01,2010).
VARIABLE LABELS ins_jan10.
FORMATS ins_jan10 (date11).
Variable width ins_jan10 (14).
End if.
Execute.


DO IF (ins_jan09=1).
COMPUTE ins_jan09=DATE.DMY(01,01,2009).
VARIABLE LABELS ins_jan09.
FORMATS ins_jan09 (date11).
Variable width ins_jan09 (14).
End if.
Execute.

DO IF (ins_jan08=1).
COMPUTE ins_jan08=DATE.DMY(01,01,2008).
VARIABLE LABELS ins_jan08.
FORMATS ins_jan08 (date11).
Variable width ins_jan08 (14).
End if.
Execute.

DO IF (ins_jan07=1).
COMPUTE ins_jan07=DATE.DMY(01,01,2007).
VARIABLE LABELS ins_jan07.
FORMATS ins_jan07 (date11).
Variable width ins_jan07 (14).
End if.
Execute.

DO IF (ins_jan06=1).
COMPUTE ins_jan06=DATE.DMY(01,01,2006).
VARIABLE LABELS ins_jan06.
FORMATS ins_jan06 (date11).
Variable width ins_jan06 (14).
End if.
Execute.

*maanden april.

DO IF (ins_apr23=1).
COMPUTE ins_apr23=DATE.DMY(01,04,2023).
VARIABLE LABELS ins_apr23.
FORMATS ins_apr23 (date11).
Variable width ins_apr23 (14).
End if.
Execute.

DO IF (ins_apr22=1).
COMPUTE ins_apr22=DATE.DMY(01,04,2022).
VARIABLE LABELS ins_apr22.
FORMATS ins_apr22 (date11).
Variable width ins_apr22 (14).
End if.
Execute.


DO IF (ins_apr21=1).
COMPUTE ins_apr21=DATE.DMY(01,04,2021).
VARIABLE LABELS ins_apr21.
FORMATS ins_apr21 (date11).
Variable width ins_apr21 (14).
End if.
Execute.

DO IF (ins_apr20=1).
COMPUTE ins_apr20=DATE.DMY(01,04,2020).
VARIABLE LABELS ins_apr20.
FORMATS ins_apr20 (date11).
Variable width ins_apr20 (14).
End if.
Execute.

DO IF (ins_apr19=1).
COMPUTE ins_apr19=DATE.DMY(01,04,2019).
VARIABLE LABELS ins_apr19.
FORMATS ins_apr19 (date11).
Variable width ins_apr19 (14).
End if.
Execute.

DO IF (ins_apr18=1).
COMPUTE ins_apr18=DATE.DMY(01,04,2018).
VARIABLE LABELS ins_apr18.
FORMATS ins_apr18 (date11).
Variable width ins_apr18 (14).
End if.
Execute.


DO IF (ins_apr17=1).
COMPUTE ins_apr17=DATE.DMY(01,04,2017).
VARIABLE LABELS ins_apr17.
FORMATS ins_apr17 (date11).
Variable width ins_apr17 (14).
End if.
Execute.

DO IF (ins_apr16=1).
COMPUTE ins_apr16=DATE.DMY(01,04,2016).
VARIABLE LABELS ins_apr16.
FORMATS ins_apr16 (date11).
Variable width ins_apr16 (14).
End if.
Execute.

DO IF (ins_apr15=1).
COMPUTE ins_apr15=DATE.DMY(01,04,2015).
VARIABLE LABELS ins_apr15.
FORMATS ins_apr15 (date11).
Variable width ins_apr15 (14).
End if.
Execute.

DO IF (ins_apr14=1).
COMPUTE ins_apr14=DATE.DMY(01,04,2014).
VARIABLE LABELS ins_apr14.
FORMATS ins_apr14 (date11).
Variable width ins_apr14 (14).
End if.
Execute.

DO IF (ins_apr13=1).
COMPUTE ins_apr13=DATE.DMY(01,04,2013).
VARIABLE LABELS ins_apr13.
FORMATS ins_apr13 (date11).
Variable width ins_apr13 (14).
End if.
Execute.

DO IF (ins_apr12=1).
COMPUTE ins_apr12=DATE.DMY(01,04,2012).
VARIABLE LABELS ins_apr12.
FORMATS ins_apr12 (date11).
Variable width ins_apr12 (14).
End if.
Execute.

DO IF (ins_apr11=1).
COMPUTE ins_apr11=DATE.DMY(01,04,2011).
VARIABLE LABELS ins_apr11.
FORMATS ins_apr11 (date11).
Variable width ins_apr11 (14).
End if.
Execute.

DO IF (ins_apr10=1).
COMPUTE ins_apr10=DATE.DMY(01,04,2010).
VARIABLE LABELS ins_apr10.
FORMATS ins_apr10 (date11).
Variable width ins_apr10 (14).
End if.
Execute.

DO IF (ins_apr09=1).
COMPUTE ins_apr09=DATE.DMY(01,04,2009).
VARIABLE LABELS ins_apr09.
FORMATS ins_apr09 (date11).
Variable width ins_apr09 (14).
End if.
Execute.


DO IF (ins_apr08=1).
COMPUTE ins_apr08=DATE.DMY(01,04,2008).
VARIABLE LABELS ins_apr08.
FORMATS ins_apr08 (date11).
Variable width ins_apr08 (14).
End if.
Execute.


DO IF (ins_apr07=1).
COMPUTE ins_apr07=DATE.DMY(01,04,2007).
VARIABLE LABELS ins_apr07.
FORMATS ins_apr07 (date11).
Variable width ins_apr07 (14).
End if.
Execute.

DO IF (ins_apr06=1).
COMPUTE ins_apr06=DATE.DMY(01,04,2006).
VARIABLE LABELS ins_apr06.
FORMATS ins_apr06 (date11).
Variable width ins_apr06 (14).
End if.
Execute.

*maanden juli.
DO IF (ins_jul23=1).
COMPUTE ins_jul23=DATE.DMY(01,07,2023).
VARIABLE LABELS ins_jul23.
FORMATS ins_jul23 (date11).
Variable width ins_jul23 (14).
End if.
Execute.

DO IF (ins_jul22=1).
COMPUTE ins_jul22=DATE.DMY(01,07,2022).
VARIABLE LABELS ins_jul22.
FORMATS ins_jul22 (date11).
Variable width ins_jul22 (14).
End if.
Execute.


DO IF (ins_jul21=1).
COMPUTE ins_jul21=DATE.DMY(01,07,2021).
VARIABLE LABELS ins_jul21.
FORMATS ins_jul21 (date11).
Variable width ins_jul21 (14).
End if.
Execute.

DO IF (ins_jul20=1).
COMPUTE ins_jul20=DATE.DMY(01,07,2020).
VARIABLE LABELS ins_jul20.
FORMATS ins_jul20 (date11).
Variable width ins_jul20 (14).
End if.
Execute.


DO IF (ins_jul19=1).
COMPUTE ins_jul19=DATE.DMY(01,07,2019).
VARIABLE LABELS ins_jul19.
FORMATS ins_jul19 (date11).
Variable width ins_jul19(14).
End if.
Execute.

DO IF (ins_jul18=1).
COMPUTE ins_jul18=DATE.DMY(01,07,2018).
VARIABLE LABELS ins_jul18.
FORMATS ins_jul18(date11).
Variable width ins_jul18 (14).
End if.
Execute.

DO IF (ins_jul17=1).
COMPUTE ins_jul17=DATE.DMY(01,07,2017).
VARIABLE LABELS ins_jul17.
FORMATS ins_jul17 (date11).
Variable width ins_jul17 (14).
End if.
Execute.

DO IF (ins_jul16=1).
COMPUTE ins_jul16=DATE.DMY(01,07,2016).
VARIABLE LABELS ins_jul16.
FORMATS ins_jul16 (date11).
Variable width ins_jul16(14).
End if.
Execute.

DO IF (ins_jul15=1).
COMPUTE ins_jul15=DATE.DMY(01,07,2015).
VARIABLE LABELS ins_jul15.
FORMATS ins_jul15 (date11).
Variable width ins_jul15 (14).
End if.
Execute.

DO IF (ins_jul14=1).
COMPUTE ins_jul14=DATE.DMY(01,07,2014).
VARIABLE LABELS ins_jul14.
FORMATS ins_jul14 (date11).
Variable width ins_jul14 (14).
End if.
Execute.

DO IF (ins_jul13=1).
COMPUTE ins_jul13=DATE.DMY(01,07,2013).
VARIABLE LABELS ins_jul13.
FORMATS ins_jul13 (date11).
Variable width ins_jul13 (14).
End if.
Execute.

DO IF (ins_jul12=1).
COMPUTE ins_jul12=DATE.DMY(01,07,2012).
VARIABLE LABELS ins_jul12.
FORMATS ins_jul12 (date11).
Variable width ins_jul12 (14).
End if.
Execute.

DO IF (ins_jul11=1).
COMPUTE ins_jul11=DATE.DMY(01,07,2011).
VARIABLE LABELS ins_jul11.
FORMATS ins_jul11 (date11).
Variable width ins_jul11 (14).
End if.
Execute.


DO IF (ins_jul10=1).
COMPUTE ins_jul10=DATE.DMY(01,07,2010).
VARIABLE LABELS ins_jul10.
FORMATS ins_jul10 (date11).
Variable width ins_jul10 (14).
End if.
Execute.

DO IF (ins_jul09=1).
COMPUTE ins_jul09=DATE.DMY(01,07,2009).
VARIABLE LABELS ins_jul09.
FORMATS ins_jul09(date11).
Variable width ins_jul09(14).
End if.
Execute.

DO IF (ins_jul08=1).
COMPUTE ins_jul08=DATE.DMY(01,07,2008).
VARIABLE LABELS ins_jul08.
FORMATS ins_jul08(date11).
Variable width ins_jul08(14).
End if.
Execute.


DO IF (ins_jul07=1).
COMPUTE ins_jul07=DATE.DMY(01,07,2007).
VARIABLE LABELS ins_jul07.
FORMATS ins_jul07 (date11).
Variable width ins_jul07 (14).
End if.
Execute.

DO IF (ins_jul06=1).
COMPUTE ins_jul06=DATE.DMY(01,07,2006).
VARIABLE LABELS ins_jul06.
FORMATS ins_jul06 (date11).
Variable width ins_jul06 (14).
End if.
Execute.

*maanden oktober.
DO IF (ins_okt22=1).
COMPUTE ins_okt22=DATE.DMY(01,10,2022).
VARIABLE LABELS ins_okt22.
FORMATS ins_okt22 (date11).
Variable width ins_okt22 (14).
End if.
Execute.

DO IF (ins_okt21=1).
COMPUTE ins_okt21=DATE.DMY(01,10,2021).
VARIABLE LABELS ins_okt21.
FORMATS ins_okt21 (date11).
Variable width ins_okt21 (14).
End if.
Execute.


DO IF (ins_okt20=1).
COMPUTE ins_okt20=DATE.DMY(01,10,2020).
VARIABLE LABELS ins_okt20.
FORMATS ins_okt20 (date11).
Variable width ins_okt20 (14).
End if.
Execute.


DO IF (ins_okt19=1).
COMPUTE ins_okt19=DATE.DMY(01,10,2019).
VARIABLE LABELS ins_okt19.
FORMATS ins_okt19 (date11).
Variable width ins_okt19 (14).
End if.
Execute.

DO IF (ins_okt18=1).
COMPUTE ins_okt18=DATE.DMY(01,10,2018).
VARIABLE LABELS ins_okt18.
FORMATS ins_okt18 (date11).
Variable width ins_okt18 (14).
End if.
Execute.


DO IF (ins_okt17=1).
COMPUTE ins_okt17=DATE.DMY(01,10,2017).
VARIABLE LABELS ins_okt17.
FORMATS ins_okt17 (date11).
Variable width ins_okt17 (14).
End if.
Execute.

DO IF (ins_okt16=1).
COMPUTE ins_okt16=DATE.DMY(01,10,2016).
VARIABLE LABELS ins_okt16.
FORMATS ins_okt16 (date11).
Variable width ins_okt16 (14).
End if.
Execute.

DO IF (ins_okt15=1).
COMPUTE ins_okt15=DATE.DMY(01,10,2015).
VARIABLE LABELS ins_okt15.
FORMATS ins_okt15 (date11).
Variable width ins_okt15 (14).
End if.
Execute.

DO IF (ins_okt14=1).
COMPUTE ins_okt14=DATE.DMY(01,10,2014).
VARIABLE LABELS ins_okt14.
FORMATS ins_okt14 (date11).
Variable width ins_okt14 (14).
End if.
Execute.

DO IF (ins_okt13=1).
COMPUTE ins_okt13=DATE.DMY(01,10,2013).
VARIABLE LABELS ins_okt13.
FORMATS ins_okt13 (date11).
Variable width ins_okt13 (14).
End if.
Execute.

DO IF (ins_okt12=1).
COMPUTE ins_okt12=DATE.DMY(01,10,2012).
VARIABLE LABELS ins_okt12.
FORMATS ins_okt12 (date11).
Variable width ins_okt12 (14).
End if.
Execute.

DO IF (ins_okt11=1).
COMPUTE ins_okt11=DATE.DMY(01,10,2011).
VARIABLE LABELS ins_okt11.
FORMATS ins_okt11 (date11).
Variable width ins_okt11 (14).
End if.
Execute.

DO IF (ins_okt10=1).
COMPUTE ins_okt10=DATE.DMY(01,10,2010).
VARIABLE LABELS ins_okt10.
FORMATS ins_okt10 (date11).
Variable width ins_okt10 (14).
End if.
Execute.

DO IF (ins_okt09=1).
COMPUTE ins_okt09=DATE.DMY(01,10,2009).
VARIABLE LABELS ins_okt09.
FORMATS ins_okt09 (date11).
Variable width ins_okt09 (14).
End if.
Execute.


DO IF (ins_okt08=1).
COMPUTE ins_okt08=DATE.DMY(01,10,2008).
VARIABLE LABELS ins_okt08.
FORMATS ins_okt08 (date11).
Variable width ins_okt08 (14).
End if.
Execute.


DO IF (ins_okt07=1).
COMPUTE ins_okt07=DATE.DMY(01,10,2007).
VARIABLE LABELS ins_okt07.
FORMATS ins_okt07 (date11).
Variable width ins_okt07 (14).
End if.
Execute.

DO IF (ins_okt06=1).
COMPUTE ins_okt06=DATE.DMY(01,10,2006).
VARIABLE LABELS ins_okt06.
FORMATS ins_okt06 (date11).
Variable width ins_okt06 (14).
End if.
Execute.

compute laatsteuitschrijftariefdatum= Max (ins_jul23 to ins_jan06).
Formats laatsteuitschrijftariefdatum (date11).
execute.

Compute eersteinschrijftariefdatum = MIN (ins_jul23 to ins_jan06).
Formats eersteinschrijftariefdatum (date11).
EXECUTE.


*indien missende inschrijftarieven in het midde, nieuwe variabele aanmaken voor de selectie van deze groep patienten.
VECTOR datum = ins_jul23 to ins_jan06.
COMPUTE datum_gevonden=0.
COMPUTE missende_datum= 0.
COMPUTE missing_between_tarieven= 0.
LOOP #i = 1 TO 71.
DO IF MISSING (datum(#i)) AND (datum_gevonden EQ 0).
        Compute missende_datum = 0.
ELSE IF MISSING (datum(#i)) AND (datum_gevonden EQ 1).
Compute  missende_datum = 1.
  ELSE IF (missende_datum EQ 1).
    Compute missing_between_tarieven= 1.
  ELSE IF (datum_gevonden EQ 0).
    Compute datum_gevonden= 1.
ELSE.
End If.
END LOOP.
Execute.

DELETE VARIABLES datum_gevonden missende_datum.
execute.


*missng between bevat nu geen missings, deze missings maken adv laatste uitschrijftarief.
Do If Missing (laatsteuitschrijftariefdatum).
RECODE missing_between_tarieven (ELSE=SYSMIS).
End if.
Execute.

FREQUENCIES VARIABLES=missing_between_tarieven laatsteuitschrijftariefdatum
  /ORDER=ANALYSIS.



