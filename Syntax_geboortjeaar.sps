* Encoding: UTF-8.
* syntax voor cleaning variabele geboortejaar ELAN
 *willemijn van den Hout
 * 26-10-2023.. 



FREQUENCIES VARIABLES=iGeboortejaar
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=893281
    

Do IF iGeboortejaar<1902.
RECODE iGeboortejaar (ELSE=SYSMIS).
End if.
Execute.

FREQUENCIES VARIABLES=iGeboortejaar
  /FORMAT=NOTABLE
  /ORDER=ANALYSIS.
*n=971.
    
