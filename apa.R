#APa Pandeiros --> pontos ---> 13,19,14,20,9,15,21,23,16,22,24
#APA Cochá  ---> pontos ---> 6,12,7,13,3,8,14,1,4,9,15,2,5,10
#APA Cavernas --->pontos ---> 9,15,10,16,11,17,18 1,
#passo1 ---> criar 3 data frames representando os pontos de cada apa / passo2 tirar a média das linhas de cada dataframe 

library(readr)
library(rlist)

#TESTE

KELVIN_OFFSET<--273.15
FILE_NAME<-"ERA5_TEMP.csv"

temperatura_original=data.frame(read_csv(FILE_NAME))
temperatura_pontos<-temperatura_original[1:(length(temperatura_original)-3)]
#criando data frame de temperatura_total from ERA5
temperatura_total<-temperatura_pontos+KELVIN_OFFSET
temperatura_total<-temperatura_total[order(sprintf("%*s", max(nchar(names(temperatura_total))), names(temperatura_total)))]
#separando as apas por pontos
temp_cavernas<-temperatura_total[,(c(9,15,10,16,11,17,18,1))]
temp_Cocha<-temperatura_total[,(c(6,12,7,13,3,8,14,1,4,9,15,2,5,10))]
temp_Pandeiros<-temperatura_total[,(c(13,19,14,20,9,15,21,23,16,22,24))]

#calculando a media das temperaturas por linha de cada apa
lista_temp<-list(temp_cavernas,temp_Cocha,temp_Pandeiros)#lista de dataframes das 3 apas
lista_nomes<-c("APACP","APACG","APARP")
apa_medias<-list()
for (apa_temp in lista_temp) {
  mean_linhas<-rowMeans(apa_temp)
  apa_medias<-list.append(apa_medias,mean_linhas)
}

names(apa_medias)<-lista_nomes #nomeando as listas geradas com as medias

temp_max_apas<-list()
for (apa_media in apa_medias) {
  teste_frame<-data.frame(apa_media)
  #separando por dia
  hours_per_day <- 24
  n_rows = nrow(teste_frame)
  day = rep(1:ceiling(n_rows/hours_per_day),each=hours_per_day)[1:n_rows]
  days_list = split(teste_frame,day)
  
  #pegando os headers
  headers = t(t(colnames(teste_frame)))
  
  #criando dataframe final
  data_frame_final = data.frame(t(headers))
  colnames(data_frame_final) = headers
  data_frame_final = data_frame_final[-1,]
  
  #iterando tudo e adicionando no dataframe
  i=1
  for(hours in days_list){
    dayValues = c()
    
    for(point in hours){
      dayValues = c(dayValues, max(point))
    }
    
    data_frame_temporario = data.frame(t(dayValues))
    nomeLinha = paste("Máxima do dia ", i)
    rownames(data_frame_temporario) = nomeLinha
    colnames(data_frame_temporario) = headers
    data_frame_final = rbind(data_frame_final, data_frame_temporario)
    i=i+1
  }
temp_max_apas<-list.append(temp_max_apas,data_frame_final)
}

names(temp_max_apas)<-lista_nomes
quantis<-list()
for (temp_max_apa_unic in temp_max_apas) {
for (lista_temperaturas in temp_max_apa_unic) {
quantis<-list.append(quantis,quantile(lista_temperaturas,c(.95)))
}
}

maxTemperature<-do.call("cbind",temp_max_apas)
names(maxTemperature)<-names(temp_max_apas)

write.csv(maxTemperature,"Max Temperature.csv", row.names = FALSE)