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


lista_fwi=list()
for (nome_do_ponto in nomes_dos_pontos) {
  temp=temp1999_2019_per_day[nome_do_ponto]
  rh=RH1999_2019_per_day[nome_do_ponto]
  ws=wind1999_2019_per_day[nome_do_ponto]
  prec=prec1999_2019_per_day[nome_do_ponto]
  
  nomes_dos_pontos=names(temp1999_2019_per_day)
  nomes_dos_pontos=nomes_dos_pontos[1:24]
  day=dados_cavernas$day
  mon=dados_cavernas$Month
  yr=dados_cavernas$Year
  
  ponto=data.frame(temp,rh,ws,prec,day,mon,yr,"lat"=metadata[2,nome_do_ponto],"long"=metadata[1,nome_do_ponto])
  names(ponto)=c("temp","rh","ws","prec","day","mon","yr","lat","long")
  fwi=fwi(ponto,init=data.frame(ffmc=85,dmc=6,dc=15,lat=55)) 
  lista_fwi=list.append(lista_fwi,fwi)
 }

lista_ffmc=list()
for (fwi in lista_fwi) {
    lista_ffmc=list.append(lista_ffmc,fwi$FFMC) 
}

lista_ffmc=list.append(lista_ffmc,day)
lista_ffmc=list.append(lista_ffmc,mon)
lista_ffmc=list.append(lista_ffmc,yr)

ffmc=data.frame(lista_ffmc)
names(ffmc)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")

