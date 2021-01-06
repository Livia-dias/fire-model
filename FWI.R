#calculando FWI
#carregar 4 arquivos: temp, rh, ws, prec
#extrair coluna de um ponto dos 4 arquivos e colocar em 4 variáveis
#extrair mes, dia, ano do mesmo ponto de um dos arquivos e colocar em outras variáveis
#gerar um data frame com todas as variáveis + lat e long do ponto
library(cffdrs)
library(rlist)
source("media_diaria_clima.R")

dados_cavernas= data.frame(read.csv("cavernas_model-clima.csv", sep = ","))
metadata=data.frame(read.csv("PONTOS.csv", sep=";"))
dias = data.frame("day"=dados_cavernas$day, "mon"=dados_cavernas$Month, "yr"=dados_cavernas$Year)

gerar_fwi = function(nomes_dos_pontos, temp_per_day, rh_per_day, wind_per_day, prec_per_day, metadata, dataframe_dias) {
  lista_fwi=list()
  for (nome_do_ponto in nomes_dos_pontos) { #nomes_dos_pontos = X1, X2... até X24 / nome_do_ponto = x1, depois X2...
    temp=temp_per_day[nome_do_ponto]
    rh=rh_per_day[nome_do_ponto]
    ws=wind_per_day[nome_do_ponto]
    prec=prec_per_day[nome_do_ponto]
    
    ponto=data.frame(temp,rh,ws,prec,dataframe_dias,"lat"=metadata[2,nome_do_ponto],"long"=metadata[1,nome_do_ponto])
    names(ponto)=c("temp","rh","ws","prec","day","mon","yr","lat","long")
    fwi=fwi(ponto,init=data.frame(ffmc=85,dmc=6,dc=15,lat=metadata[2,nome_do_ponto])) 
    lista_fwi=list.append(lista_fwi,fwi)
  }
  return(lista_fwi)
}


lista_fwi = gerar_fwi(names(metadata[2:25]), temp1999_2019_per_day, RH1999_2019_per_day, wind1999_2019_per_day, prec1999_2019_per_day, metadata, dias)

gerar_var = function(coluna, lista_fwi, dias){
  lista_var = list()
  for (fwi in lista_fwi) {
    lista_var=list.append(lista_var,fwi[,coluna]) 
  }
  
  variavel=data.frame(lista_var, dias)
  names(variavel)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")
  
  return(variavel)
}

FFMC = gerar_var("FFMC", lista_fwi, dias)
DMC = gerar_var("DMC", lista_fwi, dias)
DC = gerar_var("DC", lista_fwi, dias)
FWI = gerar_var("FWI", lista_fwi, dias)
ISI = gerar_var("ISI", lista_fwi, dias)
BUI = gerar_var("BUI", lista_fwi, dias)
DSR = gerar_var("DSR", lista_fwi, dias)

write.csv(FFMC, "ffmc-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(DMC, "dmc-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(DC, "dc-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(FWI, "fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(ISI, "isi-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(BUI, "bui-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(DSR, "dsr-fwi1999_2019_per_day.csv", row.names = FALSE)