* Encoding: UTF-8.
*BMI-ELAN project*
*willemijn van den hout*
*bewerkt op 11-12-2023*
  
 *bmi combinatie bestand openzetten waarbij het bestand nog niet in rijhen per patien staat maar onder elkaar per bmi. 
    
    *het bestand met alle bmis mergen met de pat file met varaiableen van
     begin onze onderzoeksperiode en einde ionderzokespeirode, de pat file moet  moet al gerund zijn t/m einde van de flow chart met de syntax analyse pat file 
     en dus de juiste patienten bevatten van onzen onderzoekspopulatie.

DATASET ACTIVATE DataSet1.
GET FILE='I:\ONDERZOEK\PROJECTEN\ELAN-DWH\20220922 - Obesity in Primary Care - Willemijn van den '+
    'Hout - Ticket#466793\Data_Oct12_each variable by itself\Each_variable_all\Files voor '+
    'analyse\NIEUWE\PAT file\PATendatums_icpcszonderbegindatum_naflowchart.sav'.
DATASET NAME DataSet2.
DATASET ACTIVATE DataSet1.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet2.
SORT CASES BY PATNR.
DATASET ACTIVATE DataSet1.
MATCH FILES /FILE=*
  /TABLE='DataSet2'
  /RENAME (Overgewicht_date_first T83_overweightnum_first Obesity_date_first T82_obesitasnum_first 
    hypertension_date_first hypertensie_num_first Eatingdisorder_date_first Eatingdisorder_num_first 
    Diabetes_date_first diabetesT90_num_first Diabetestype1_date_first diabetestype1_num_first 
    Diabetestype2_date_first diabetestype2_num_first depression_date_first Depression_num_first 
    copd_date_first copd_num_first waist_circumference_date_first waist_circumference_first 
    combinatieinschrijfdatumentarief_jaar combinatieuitschrijfdatumentarief_jaar 
    laatsteuitschrijftariefdatum eersteinschrijftariefdatum missing_between_tarieven 
    combinatieinschrijfdatumentarief combinatieuitschrijfdatumentarief StartDate EndDate PRAKNR 
    dPostcodecijfers dCategoriePatient dinschrijfdatum duitschrijfdatum overlijdensdatum Extractiedatum 
    = d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 d25 d26 
    d27 d28 d29 d30 d31 d32 d33 d34 d35) 
  /BY PATNR
  /DROP= d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20 d21 d22 d23 d24 
    d25 d26 d27 d28 d29 d30 d31 d32 d33 d34 d35.
EXECUTE.

FREQUENCIES VARIABLES=bmi BMIheightweight2 bmiall
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*bmiall: 1798052.

* de bmis die niet in de onderzoeksperiode vallen eruit halen.

Temporary.
select if missing (eindeonderzoeksperiode_date) OR missing (beginonderzoeksperiode_date).
FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=9671 cases.

FILTER OFF.
USE ALL.
select if NOT missing (eindeonderzoeksperiode_date) AND NOT missing (beginonderzoeksperiode_date).
EXECUTE.

FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1.788.381.

*alleen de bmis selecteren die zijn gemeten in onze onderzoeksperiode (afhankelijkj van in en uitschrijftarief en leeftijd etc).

Temporary.
select if bmidatumall>eindeonderzoeksperiode_date.
list PATNR eindeonderzoeksperiode_date bmidatumall.
*4643.

Temporary.
select if bmidatumall<beginonderzoeksperiode_date.
  FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*230183.


Temporary.
select if bmidatumall>=beginonderzoeksperiode_date AND bmidatumall<=eindeonderzoeksperiode_date.
  FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1553555.

USE ALL.
select if bmidatumall>=beginonderzoeksperiode_date AND bmidatumall<=eindeonderzoeksperiode_date.
EXECUTE.

  FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=1553555.


*categorie waarin bmi is gemeten bereken.
COMPUTE bmidatumall_jaar=XDATE.YEAR(bmidatumall).
VARIABLE LABELS  bmidatumall_jaar.
VARIABLE LEVEL  bmidatumall_jaar(SCALE).
FORMATS  bmidatumall_jaar(F8.0).
VARIABLE WIDTH  bmidatumall_jaar(8).
EXECUTE.


Delete variables BMIdatumall_jaar.

Delete variables Systeem to Systeem_samengevoegdpromedico.

RECODE bmiall (SYSMIS=SYSMIS) (30.0000 thru Highest=3) (25.000 thru 30.000=2) (Lowest thru 25.0000=1)  INTO BMIcategorieen.
execute.
`
*------------------------------------------------------------------------------------*.
*bestand met rijen maken.
SORT CASES BY PATNR bmidatumall.
CASESTOVARS
  /ID=PATNR
  /GROUPBY=VARIABLE.
*n=194.857 ptn.

FREQUENCIES VARIABLES=PATNR
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=194.857 ptn.
 

compute bmiavailable =1.
execute.

Value labels bmiavailable 0 'nee' 1 'ja'.


*even 
compute bmilab_onderzoeksperiode).
RENAME VARIABLES (bmi.1= bmilabeerste_onderzoeksperiode).
 Rename variables (BMI_date.1=BMIlabeerste_date_onderzoeksperiode).
 Rename variables (BMIheightweight2.1=BMIlheightweighteerste_onderzoeksperiode).
 Rename variables (weight_date2.1=BMIheightweighteerste_date_onderzoeksperiode).
 Rename variables (bmiall.1=BMIalleerste_onderzoeksperiode).
 Rename variables (bmidatumall.1=BMIalleerste_date_onderzoeksperiode).


*nu van alle bmis categorieen maken.

VECTOR Vars = BMIcategorieen.1 TO BMIcategorieen.293.
COMPUTE NormaalBMIgemeten = 0.

LOOP #i = 1 TO 293.
 DO  IF ((Vars(#i)) =1). 
    Compute NormaalBMIgemeten = 1.
End if.
END LOOP.
execute.

VECTOR Vars = BMIcategorieen.1 TO BMIcategorieen.293.
COMPUTE OvergewichtBMIgemeten = 0.

LOOP #i = 1 TO 293.
 DO  IF ((Vars(#i)) =2). 
    Compute OvergewichtBMIgemeten = 1.
End if.
END LOOP.
execute.


VECTOR Vars = BMIcategorieen.1 TO BMIcategorieen.293.
COMPUTE ObesitasBMIgemeten = 0.

LOOP #i = 1 TO 293.
 DO  IF ((Vars(#i)) =3). 
    Compute ObesitasBMIgemeten = 1.
End if.
END LOOP.
execute.


Formats  NormaalBMIgemeten to ObesitasBMIgemeten (f8.0).

value labels NormaalBMIgemeten 0 'geen normaal BMI gemeten' 1 'Wel BMI gemeten <25kg/m2'.
value labels OvergewichtBMIgemeten 0 'geen overgewicht gemeten' 1 'Wel overgewicht gemeten 25-30 kg/m2'.
value labels ObesitasBMIgemeten 0 'geen obesitas gemeten' 1 'Wel obesitas gemeten >30kg/m2'.


DELETE VARIABLES BMIcategorieen.1 to BMIcategorieen.293.
