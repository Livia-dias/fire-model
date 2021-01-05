#separando por apas
#temp_APARP= temp1999_2019_per_day[,(c(13,19,14,20,9,15,21,23,16,22,24))]
#temp_APACG= temp1999_2019_per_day[,(c(6,12,7,13,3,8,14,1,4,9,15,2,5,10))]
#temp_APACP= temp1999_2019_per_day[,(c(9,15,10,16,11,17,18,1))]

RH_per_day= data.frame(read.csv("RH_1999_2019.csv", sep = ";"))

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

apaCP = monta_apa(temp1999_2019_per_day, RH1999_2019_per_day, 
                  prec1999_2019_per_day, wind1999_2019_per_day, c(9,15,10,16,11,17,18,1))

apaCG = monta_apa(temp1999_2019_per_day, RH1999_2019_per_day, 
                  prec1999_2019_per_day, wind1999_2019_per_day, c(6,12,7,13,3,8,14,1,4,9,15,2,5,10))

write.csv(apaRP,"clima_pandeiros.csv", row.names = FALSE)

write.csv(apaCP,"clima_cavernas.csv", row.names = FALSE)

write.csv(apaCG,"clima_cochagibao.csv", row.names = FALSE)
