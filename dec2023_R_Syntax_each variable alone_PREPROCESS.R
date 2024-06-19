lab<-rbind(LAB1,LAB2,LAB3,LAB4)

#load("I:/ONDERZOEK/PROJECTEN/ELAN-DWH/20220922 - Obesity in Primary Care - Willemijn van den Hout - Ticket#466793/Data_Sep_2023/final data_sep2023/R-data/BMI_Data_sep2023-18.RData")
library(tidyverse)
library(data.table)

install.packages("data.table")
library(data.table)

LAB1 <- fread("I:/ONDERZOEK/PROJECTEN/ELAN-DWH/20220922 - Obesity in Primary Care - Willemijn van den Hout - Ticket#466793/Data_Sep_2023/original_data/LAB1.csv")
LAB2 <- fread("I:/ONDERZOEK/PROJECTEN/ELAN-DWH/20220922 - Obesity in Primary Care - Willemijn van den Hout - Ticket#466793/Data_Sep_2023/original_data/LAB2.csv")
LAB3 <- fread("I:/ONDERZOEK/PROJECTEN/ELAN-DWH/20220922 - Obesity in Primary Care - Willemijn van den Hout - Ticket#466793/Data_Sep_2023/original_data/LAB3.csv")
LAB4 <- fread("I:/ONDERZOEK/PROJECTEN/ELAN-DWH/20220922 - Obesity in Primary Care - Willemijn van den Hout - Ticket#466793/Data_Sep_2023/original_data/LAB4.csv")

library(data.table)
LAB1$Resultaatdatum <- as.numeric(LAB1$Resultaatdatum)
LAB2$Resultaatdatum <- as.numeric(LAB2$Resultaatdatum)
LAB3$Resultaatdatum <- as.numeric(LAB3$Resultaatdatum)
LAB4$Resultaatdatum <- as.numeric(LAB4$Resultaatdatum)

library(dplyr)


LAB<-rbind(LAB1,LAB2,LAB3,LAB4)

LAB=data.table(LAB)
table(LAB$dWCIANummer)
BMI<-LAB[LAB$dWCIANummer== "1272"]
BMI=data.table(BMI)
BMI<-BMI%>%arrange(iResultaatnummer)
#BMI<-sapply(BMI,gsub,pattern=",",replacement=".")
BMI=data.table(BMI)

#BMI$iResultaatnummer=as.numeric(BMI$iResultaatnummer)
sum(is.na(BMI$iResultaatnummer))

BMI[,bmi:=iResultaatnummer]

BMI$BMI_date<-format(as.Date(BMI$Bepalingdatum, format="%Y%m%d"))
BMI$BMI_date=ifelse(is.na(BMI$BMI_date),BMI$Bepalingdatum, BMI$BMI_date)
BMI=data.table(BMI)

BMI$BMI_date=as.Date(BMI$BMI_date)

BMI=select(BMI,PATNR, bmi, BMI_date)
BMI=BMI[!is.na(bmi)]

####weight
weight1<-LAB[LAB$dWCIANummer== "357"]
weight2<-LAB[LAB$dWCIANummer== "2408"]


weight=rbind(weight1,weight2)

weight=data.table(weight)
weight<-weight%>%arrange(iResultaatnummer)
#weight<-sapply(weight,gsub,pattern=",",replacement=".")
weight=data.table(weight)

#weight$iResultaatnummer=as.numeric(weight$iResultaatnummer)
sum(is.na(weight$iResultaatnummer))

weight[,weight:=iResultaatnummer]
sum(is.na(weight$weight))

weight$weight_date<-format(as.Date(weight$Bepalingdatum, format="%Y%m%d"))
weight$weight_date=ifelse(is.na(weight$weight_date),weight$Bepalingdatum, weight$weight_date)
weight=data.table(weight)

weight$weight_date=as.Date(weight$weight_date)

weight=select(weight,PATNR, weight, weight_date)
weight=weight[!is.na(weight)]
summary(weight$weight)

##height
LAB=data.table(LAB)
height<-LAB[LAB$dWCIANummer== "560"]

height=data.table(height)
height<-height%>%arrange(iResultaatnummer)
#height<-sapply(height,gsub,pattern=",",replacement=".")
height=data.table(height)

#height$iResultaatnummer=as.numeric(height$iResultaatnummer)
sum(is.na(height$iResultaatnummer))

height[,height:=iResultaatnummer]
sum(is.na(height$height))

height$height_date<-format(as.Date(height$Bepalingdatum, format="%Y%m%d"))
height$height_date=ifelse(is.na(height$height_date),height$Bepalingdatum, height$height_date)
height=data.table(height)

height$height_date=as.Date(height$height_date)

height=select(height,PATNR, height, height_date, Eenheid)
height=height[!is.na(height)]
summary(height$height)

height_weight<-merge(height,weight, by="PATNR", all=TRUE, allow.cartesian=TRUE)
height_weight[,height_m:=height/100]
height_weight[,BMI2:=weight/(height_m*height_m)]
height_weight[,BMI2_2:=BMI2]
BMI2<-select(height_weight, PATNR, BMI2_2, weight_date)

BMI_HW<-rename(BMI2, bmi=BMI2_2)
BMI_HW<-rename(BMI_HW, BMI_date=weight_date)

BMI_all<-rbind(BMI,BMI_HW)

#waist circumference
LAB=data.table(LAB)
waist_circumference<-LAB[LAB$dWCIANummer== "1872"]

waist_circumference=data.table(waist_circumference)
waist_circumference<-waist_circumference%>%arrange(iResultaatnummer)
#waist_circumference<-sapply(waist_circumference,gsub,pattern=",",replacement=".")
waist_circumference=data.table(waist_circumference)

#waist_circumference$iResultaatnummer=as.numeric(waist_circumference$iResultaatnummer)
sum(is.na(waist_circumference$iResultaatnummer))

waist_circumference[,waist_circumference:=iResultaatnummer]
sum(is.na(waist_circumference$waist_circumference))


waist_circumference$waist_circumference_date<-format(as.Date(waist_circumference$Bepalingdatum, format="%Y%m%d"))
waist_circumference$waist_circumference_date=ifelse(is.na(waist_circumference$waist_circumference_date),waist_circumference$Bepalingdatum, waist_circumference$waist_circumference_date)
waist_circumference=data.table(waist_circumference)

waist_circumference$waist_circumference_date=as.Date(waist_circumference$waist_circumference_date)

waist_circumference=select(waist_circumference,PATNR, waist_circumference, waist_circumference_date)
waist_circumference=waist_circumference[!is.na(waist_circumference)]
summary(waist_circumference$waist_circumference)


###birthdate
names(PAT)
Birth_year<-select(PAT,PATNR,iGeboortejaar)
Birth_year=data.table(Birth_year)
Birth_year$PATNR=as.character(Birth_year$PATNR)
BMI_all<-merge(BMI_all, Birth_year, by="PATNR", all=TRUE,allow.cartesian=TRUE )


##subscription 

suscription_date<-select(PAT,PATNR,dinschrijfdatum)
suscription_date=data.table(suscription_date)
suscription_date$PATNR=as.character(suscription_date$PATNR)
suscription_date$suscription_date<-substring(suscription_date$dinschrijfdatum,1,10)
suscription_date$subscription_date<-format(as.Date(suscription_date$suscription_date, format="%Y-%m-%d"))
suscription_date<-select(suscription_date, PATNR,subscription_date)
BMI_all<-merge(BMI_all, suscription_date, by="PATNR", all=TRUE,allow.cartesian=TRUE )


##end follow_up
end_followup_date<-select(PAT,PATNR,duitschrijfdatum)
end_followup_date=data.table(end_followup_date)
end_followup_date$PATNR=as.character(end_followup_date$PATNR)
end_followup_date$end_followup_date<-substring(end_followup_date$duitschrijfdatum,1,10)
end_followup_date$end_followup_date<-format(as.Date(end_followup_date$end_followup_date, format="%Y-%m-%d"))

end_followup_date<-select(end_followup_date, PATNR,end_followup_date)
BMI_all<-merge(BMI_all, end_followup_date, by="PATNR", all=TRUE,allow.cartesian=TRUE )


###death year
names(PAT)
death_year<-select(PAT,PATNR,iOverlijdensjaar)
death_year=data.table(death_year)
death_year$PATNR=as.character(death_year$PATNR)
BMI_all<-merge(BMI_all, death_year, by="PATNR", all=TRUE,allow.cartesian=TRUE )


names(PAT)



###cleaning episodes 
#Dm2
Eps<-data.table(Eps)
Eps$PATNR=as.character(Eps$PATNR)
Eps$dBegindatum<-substring(Eps$dBegindatum,1,10)
Eps$date<-format(as.Date(Eps$dBegindatum, format="%Y-%m-%d"))
Eps$date<-as.Date(Eps$date)
Eps<-select(Eps,PATNR,dICPC, date)
table(Eps$dICPC)

##DM2=T90.02
dm2<-Eps[dICPC=="T90.02"]
dm2<-dm2%>%arrange(PATNR, date)

dm2<-rename(dm2,T90.02_date=date)
dm2<-rename(dm2,T90.02=dICPC)


##DM1=T90.01
dm1<-Eps[dICPC=="T90.01"]
dm1<-dm1%>%arrange(PATNR, date)
dm1<-rename(dm1,T90.01_date=date)
dm1<-rename(dm1,T90.01=dICPC)


##DM=T90
dm<-Eps[dICPC=="T90"]
dm<-dm%>%arrange(PATNR, date)
dm<-rename(dm,T90_date=date)
dm<-rename(dm,T90=dICPC)

##weight_gain=T07
weight_gain<-Eps[dICPC=="T07"]
weight_gain<-weight_gain%>%arrange(PATNR, date)
weight_gain<-rename(weight_gain,T07_date=date)
weight_gain<-rename(weight_gain,T07=dICPC)

##obesity=T82
obesity<-Eps[dICPC=="T82"]
obesity<-obesity%>%arrange(PATNR, date)
obesity<-rename(obesity,T82_date=date)
obesity<-rename(obesity,T82=dICPC)


##overweight=T83
overweight<-Eps[dICPC=="T83"]
overweight<-overweight%>%arrange(PATNR, date)
overweight<-rename(overweight,T83_date=date)
overweight<-rename(overweight,T83=dICPC)


##bulimia=T06,T06.01,T06.02
bulimia1<-Eps[dICPC=="T06"]
bulimia2<-Eps[dICPC=="T06.01"]
bulimia3<-Eps[dICPC=="T06.02"]
bulimia<-rbind(bulimia1,bulimia2,bulimia3)


bulimia<-bulimia%>%arrange(PATNR, date)
bulimia<-rename(bulimia,Bulimia_date=date)
bulimia<-rename(bulimia,Bulimia=dICPC)

##Eating disorder=T05
eating_disorder<-Eps[dICPC=="T05"]

eating_disorder<-eating_disorder%>%arrange(PATNR, date)
eating_disorder<-rename(eating_disorder,T05_date=date)
eating_disorder<-rename(eating_disorder,T05=dICPC)

###excessive eating 
excessive_eating<-Eps[dICPC=="T02"]

excessive_eating<-excessive_eating%>%arrange(PATNR, date)
excessive_eating<-rename(excessive_eating,T02_date=date)
excessive_eating<-rename(excessive_eating,T02=dICPC)

###hypertantion 

hypertantion1<-Eps[dICPC=="K86"]
hypertantion2<-Eps[dICPC=="K87"]
hypertantion3<-Eps[dICPC=="K85"]
hypertantion<-rbind(hypertantion1,hypertantion2,hypertantion3)


hypertantion<-hypertantion%>%arrange(PATNR, date)
hypertantion<-rename(hypertantion,hypertantion_date=date)
hypertantion<-rename(hypertantion,hypertantion=dICPC)

####COPD
copd1<-Eps[dICPC=="R95"]
copd2<-Eps[dICPC=="R91.01"]
copd3<-Eps[dICPC=="R91.02"]
copd4<-Eps[dICPC=="R91"]

copd<-rbind(copd1,copd2,copd3,copd4)


copd<-copd%>%arrange(PATNR, date)
copd<-rename(copd,copd_date=date)
copd<-rename(copd,copd=dICPC)

###depression
depression1<-Eps[dICPC=="P76"]
depression2<-Eps[dICPC=="P76.01"]
depression3<-Eps[dICPC=="P76.02"]
depression4<-Eps[dICPC=="P03"]

depression<-rbind(depression1,depression2,depression3,depression4)


depression<-depression%>%arrange(PATNR, date)
depression<-rename(depression,depression_date=date)
depression<-rename(depression,depression=dICPC)



###fixing dates
names(PAT)


PAT$Extractiedatum<-substring(PAT$Extractiedatum,1,10)
PAT$Extractiedatum<-format(as.Date(PAT$Extractiedatum, format="%Y-%m-%d"))

PAT$StartDate<-substring(PAT$StartDate,1,10)
PAT$StartDate<-format(as.Date(PAT$StartDate, format="%Y-%m-%d"))

PAT$dinschrijfdatum<-substring(PAT$dinschrijfdatum,1,10)
PAT$dinschrijfdatum<-format(as.Date(PAT$dinschrijfdatum, format="%Y-%m-%d"))

PAT$duitschrijfdatum<-substring(PAT$duitschrijfdatum,1,10)
PAT$duitschrijfdatum<-format(as.Date(PAT$duitschrijfdatum, format="%Y-%m-%d"))

##waist circumfernce

##waist_circumference
LAB=data.table(LAB)
waist_circumference<-LAB[LAB$dWCIANummer== "1872"]

waist_circumference=data.table(waist_circumference)
waist_circumference<-waist_circumference%>%arrange(iResultaatnummer)
#waist_circumference<-sapply(waist_circumference,gsub,pattern=",",replacement=".")
waist_circumference=data.table(waist_circumference)

waist_circumference$iResultaatnummer=as.numeric(waist_circumference$iResultaatnummer)
sum(is.na(waist_circumference$iResultaatnummer))

waist_circumference[,waist_circumference:=iResultaatnummer]
sum(is.na(waist_circumference$waist_circumference))

waist_circumference$waist_circumference_date<-format(as.Date(waist_circumference$Bepalingdatum, format="%Y%m%d"))
waist_circumference$waist_circumference_date=ifelse(is.na(waist_circumference$waist_circumference_date),waist_circumference$Bepalingdatum, waist_circumference$waist_circumference_date)
waist_circumference=data.table(waist_circumference)

waist_circumference$waist_circumference_date=as.Date(waist_circumference$waist_circumference_date)
waist_circumference=data.table(waist_circumference)
waist_circumference=select(waist_circumference,PATNR, waist_circumference, waist_circumference_date)
waist_circumference=waist_circumference[!is.na(waist_circumference)]
summary(waist_circumference$waist_circumference)







##Extract to SPSS


write.table(BMI_all,"BMI_all.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(waist_circumference,"waist_circumference.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(PAT,"PAT.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(BMI_HW,"BMI_HW.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(BMI,"BMI.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(height,"height.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(weight,"weight.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(bulimia,"bulimia.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(copd,"copd.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(depression,"depression.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(dm,"dm.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(dm1,"dm1.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(dm2,"dm2.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(eating_disorder,"eating_disorder.dat",quote = F,sep="\t",row.names = F,col.names = T)

write.table(hypertantion,"hypertantion.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(obesity,"obesity.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(overweight,"overweight.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(waist_circumference,"waist_circumference.dat",quote = F,sep="\t",row.names = F,col.names = T)
write.table(weight_gain,"weight_gain.dat",quote = F,sep="\t",row.names = F,col.names = T)



