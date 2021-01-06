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

gerar_fwi = function(nomes_dos_pontos, temp_per_day, rh_per_day, wind_per_day, prec_per_day, metadata, dados_diarios) {
  lista_fwi=list()
  for (nome_do_ponto in nomes_dos_pontos) {
    temp=temp_per_day[nome_do_ponto]
    rh=rh_per_day[nome_do_ponto]
    ws=wind_per_day[nome_do_ponto]
    prec=prec_per_day[nome_do_ponto]
    
    day=dados_diarios$day
    mon=dados_diarios$Month
    yr=dados_diarios$Year
    
    ponto=data.frame(temp,rh,ws,prec,day,mon,yr,"lat"=metadata[2,nome_do_ponto],"long"=metadata[1,nome_do_ponto])
    names(ponto)=c("temp","rh","ws","prec","day","mon","yr","lat","long")
    fwi=fwi(ponto,init=data.frame(ffmc=85,dmc=6,dc=15,lat=metadata[2,nome_do_ponto])) 
    lista_fwi=list.append(lista_fwi,fwi)
  }
  return(lista_fwi)
}


lista_fwi = gerar_fwi(names(metadata[2:25]), temp1999_2019_per_day, RH1999_2019_per_day, wind1999_2019_per_day, prec1999_2019_per_day, metadata, dados_cavernas)

gerar_var = function(coluna, lista_fwi, day, mon, yr){
  lista_var = list()
  for (fwi in lista_fwi) {
    lista_var=list.append(lista_var,fwi[,coluna]) 
  }
  lista_var=list.append(lista_var,day)
  lista_var=list.append(lista_var,mon)
  lista_var=list.append(lista_var,yr)
  
  variavel=data.frame(lista_var)
  names(variavel)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")
}
gerar_var("FFMC", lista_fwi, day, mon, yr)

#-------------------------------------------------gerando FFMC---------------------------------------------------
lista_ffmc=list()
for (fwi in lista_fwi) {
    lista_ffmc=list.append(lista_ffmc,fwi$FFMC) 
}

lista_ffmc=list.append(lista_ffmc,day)
lista_ffmc=list.append(lista_ffmc,mon)
lista_ffmc=list.append(lista_ffmc,yr)

ffmc=data.frame(lista_ffmc)
names(ffmc)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")

#-------------------------------------------------gerando DMC---------------------------------------------------
lista_dmc=list()
for (fwi in lista_fwi) {
  lista_dmc=list.append(lista_dmc,fwi$DMC) 
}

lista_dmc=list.append(lista_dmc,day)
lista_dmc=list.append(lista_dmc,mon)
lista_dmc=list.append(lista_dmc,yr)

dmc=data.frame(lista_dmc)
names(dmc)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")

#-------------------------------------------------gerando DC---------------------------------------------------
lista_dc=list()
for (fwi in lista_fwi) {
  lista_dc=list.append(lista_dc,fwi$DC) 
}

lista_dc=list.append(lista_dc,day)
lista_dc=list.append(lista_dc,mon)
lista_dc=list.append(lista_dc,yr)

dc=data.frame(lista_dc)
names(dc)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")

#-------------------------------------------------gerando FWI-valores---------------------------------------------------
lista_fwi_valores=list()
for (fwi in lista_fwi) {
  lista_fwi_valores=list.append(lista_fwi_valores,fwi$FWI) 
}

lista_fwi_valores=list.append(lista_fwi_valores,day)
lista_fwi_valores=list.append(lista_fwi_valores,mon)
lista_fwi_valores=list.append(lista_fwi_valores,yr)

fwi_values=data.frame(lista_fwi_valores)
names(fwi_values)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")


#-------------------------------------------------gerando ISI---------------------------------------------------
lista_isi=list()
for (fwi in lista_fwi) {
  lista_isi=list.append(lista_isi,fwi$ISI) 
}

lista_isi=list.append(lista_isi,day)
lista_isi=list.append(lista_isi,mon)
lista_isi=list.append(lista_isi,yr)

isi=data.frame(lista_isi)
names(isi)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")


#-------------------------------------------------gerando BUI---------------------------------------------------
lista_bui=list()
for (fwi in lista_fwi) {
  lista_bui=list.append(lista_bui,fwi$BUI) 
}

lista_bui=list.append(lista_bui,day)
lista_bui=list.append(lista_bui,mon)
lista_bui=list.append(lista_bui,yr)

bui=data.frame(lista_bui)
names(bui)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")


#-------------------------------------------------gerando DSR---------------------------------------------------
lista_dsr=list()
for (fwi in lista_fwi) {
  lista_dsr=list.append(lista_dsr,fwi$DSR) 
}

lista_dsr=list.append(lista_dsr,day)
lista_dsr=list.append(lista_dsr,mon)
lista_dsr=list.append(lista_dsr,yr)

dsr=data.frame(lista_dsr)
names(dsr)=c("X1","X2","X3","X4","X5","X6","X7","X8","X9","X10","X11","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23","X24","day","mon","yr")

write.csv(ffmc, "ffmc-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(dmc, "dmc-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(dc, "dc-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(fwi_values, "fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(isi, "isi-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(bui, "bui-fwi1999_2019_per_day.csv", row.names = FALSE)
write.csv(dsr, "dsr-fwi1999_2019_per_day.csv", row.names = FALSE)