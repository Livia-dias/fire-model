#separando por apas
#temp_APARP= temp1999_2019_per_day[,(c(13,19,14,20,9,15,21,23,16,22,24))]
#temp_APACG= temp1999_2019_per_day[,(c(6,12,7,13,3,8,14,1,4,9,15,2,5,10))]
#temp_APACP= temp1999_2019_per_day[,(c(9,15,10,16,11,17,18,1))]

source("FWI.R")

monta_apa = function(dataframe_temp, dataframe_rh, dataframe_prec, dataframe_wind, dataframe_ffmc,dataframe_dmc,
                     dataframe_dc,dataframe_fwi,dataframe_isi,dataframe_bui,dataframe_dsr,colunas){
  temp_APA= dataframe_temp[,colunas]
  rh_APA=dataframe_rh[,colunas]
  prec_APA=dataframe_prec[,colunas]
  wind_APA=dataframe_wind[,colunas]
  ffmc_APA=dataframe_ffmc[,colunas]
  dmc_APA=dataframe_dmc[,colunas]
  dc_APA=dataframe_dc[,colunas]
  fwi_APA=dataframe_fwi[,colunas]
  isi_APA=dataframe_isi[,colunas]
  bui_APA=dataframe_bui[,colunas]
  dsr_APA=dataframe_dsr[,colunas]
  
  media_temp=rowMeans(temp_APA)
  media_RH=rowMeans(rh_APA)
  media_prec=rowMeans(prec_APA)
  media_wind=rowMeans(wind_APA)
  media_ffmc=rowMeans(ffmc_APA)
  media_dmc=rowMeans(dmc_APA)
  media_dc=rowMeans(dc_APA)
  media_fwi=rowMeans(fwi_APA)
  media_isi=rowMeans(isi_APA)
  media_bui=rowMeans(bui_APA)
  media_dsr=rowMeans(dsr_APA)
  
  apa_clima_fwi= data.frame("Temperature"=media_temp,"Relative Humidity"=media_RH,
                        "Precipitation"=media_prec,"Wind speed"=media_wind,"Fine Fuel Moisture Code"=media_ffmc,
                        "Duff Moisture Code"=media_dmc,"Drought Code"=media_dc,"Fire Weather Index"=media_fwi,
                        "Initial Spread Index"=media_isi,"Buildup Index"=media_bui,"Daily Severity Rating"=media_dsr,
                        "Day"=dias$day,"Month"=dias$mon, "Year"=dias$yr) #usar parâmetro da função para dia-mes-ano
  return(apa_clima_fwi)
}

apaRP = monta_apa(temp1999_2019_per_day, RH1999_2019_per_day, 
                  prec1999_2019_per_day, wind1999_2019_per_day,
                  FFMC,DMC,DC,FWI,ISI,BUI,DSR, c(13,19,14,20,9,15,21,23,16,22,24))

apaCP = monta_apa(temp1999_2019_per_day, RH1999_2019_per_day, 
                  prec1999_2019_per_day, wind1999_2019_per_day, 
                  FFMC,DMC,DC,FWI,ISI,BUI,DSR, c(9,15,10,16,11,17,18,1))

apaCG = monta_apa(temp1999_2019_per_day, RH1999_2019_per_day, 
                  prec1999_2019_per_day, wind1999_2019_per_day, 
                  FFMC,DMC,DC,FWI,ISI,BUI,DSR, c(6,12,7,13,3,8,14,1,4,9,15,2,5,10))

write.csv(apaRP,"clima_fwi_pandeiros.csv", row.names = FALSE)

write.csv(apaCP,"clima_fwi_cavernas.csv", row.names = FALSE)

write.csv(apaCG,"clima_fwi_cochagibao.csv", row.names = FALSE)
