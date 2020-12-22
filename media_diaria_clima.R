library(readr)
library(rlist)

#conversão da temperatura de kelvin para celsius
temp1999_2019= data.frame(read.csv("temperature1999_2019.csv", sep = ";"))
temperatura_sem_data<-temp1999_2019[1:(length(temp1999_2019)-2)]-273.15
temp1999_2019[1:24]=temperatura_sem_data

#chamando .csv
RH1999_2019= data.frame(read.csv("RH_1999_2019.csv", sep = ";"))
prec1999_2019= data.frame(read.csv("precip_1999_2019.csv", sep = ";", dec = ","))
wind1999_2019= data.frame(read.csv("Wind_1999_2019.csv", sep = ";"))


print(prec1999_2019[38689,1])                     
which(!grepl('^[0-9]',prec1999_2019[[1]]))

#media de 1 dia, 24 linhas=1 dia
mean_days = function(dataframe_1day){
  hours_per_day <- 24
  n_rows = nrow(dataframe_1day)
  day = rep(1:ceiling(n_rows/hours_per_day),each=hours_per_day)[1:n_rows]
  days_list = split(dataframe_1day,day)
  
  
  means = data.frame()
  for(day in days_list){
    means = rbind(means, colMeans(day))
  }
  names(means) = names(dataframe_1day)
  return(means)
}

temp1999_2019_per_day=mean_days(temp1999_2019)
RH1999_2019_per_day=mean_days(RH1999_2019)
prec1999_2019_per_day=mean_days(prec1999_2019)
wind1999_2019_per_day=mean_days(wind1999_2019)

#separando por apas
#temp_APARP= temp1999_2019_per_day[,(c(13,19,14,20,9,15,21,23,16,22,24))]
#temp_APACG= temp1999_2019_per_day[,(c(6,12,7,13,3,8,14,1,4,9,15,2,5,10))]
#temp_APACP= temp1999_2019_per_day[,(c(9,15,10,16,11,17,18,1))]

monta_apa = function(dataframe_temp, dataframe_rh, dataframe_prec, dataframe_wind, colunas){
  temp_APA= dataframe_temp[,colunas]
  rh_APA=dataframe_rh[,colunas]
  prec_APA=dataframe_prec[,colunas]
  wind_APA=dataframe_wind[,colunas]
  
  media_temp=rowMeans(temp_APA)
  media_RH=rowMeans(rh_APA)
  media_prec=rowMeans(prec_APA)
  media_wind=rowMeans(wind_APA)
  
  apa_clima= data.frame("temperature"=media_temp,"Relative Humidity"=media_RH,
                        "precipitation"=media_prec,"Wind speed"=media_wind, 
                        "Month"=dataframe_temp$month, "Year"=dataframe_temp$year)
  return(apa_clima)
  }

apaRP = monta_apa(temp1999_2019_per_day, RH1999_2019_per_day, 
          prec1999_2019_per_day, wind1999_2019_per_day, c(13,19,14,20,9,15,21,23,16,22,24))
View(apaRP)

apaCP = monta_apa(temp1999_2019_per_day, RH1999_2019_per_day, 
                  prec1999_2019_per_day, wind1999_2019_per_day, c(9,15,10,16,11,17,18,1))

apaCG = monta_apa(temp1999_2019_per_day, RH1999_2019_per_day, 
                  prec1999_2019_per_day, wind1999_2019_per_day, c(6,12,7,13,3,8,14,1,4,9,15,2,5,10))

write.csv(apaRP,"clima_cavernas.csv", row.names = FALSE)
