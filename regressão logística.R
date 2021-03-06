#teste regress�o log�stica com vari�veis clim�ticas e focos de inc�ndios

#chamando csv

cavernas_clima_fwi=data.frame(read.csv("clima_fwi_cavernas.csv", sep = ","))
cocha_clima_fwi=data.frame(read.csv("clima_fwi_cochagibao.csv", sep = ","))
pandeiros_clima_fwi=data.frame(read.csv("clima_fwi_pandeiros.csv", sep = ","))
has_fire_cavernas=data.frame(read.csv("cavernas_model-clima.csv", sep = ","))
has_fire_cocha=data.frame(read.csv("cocha_model-clima.csv", sep = ","))
has_fire_pandeiros=data.frame(read.csv("pandeiros_model-clima.csv", sep = ","))

cavernas_clima_fwi=data.frame(cavernas_clima_fwi,"HAS_FIRE"=has_fire_cavernas$HAS_FIRE)
cavernas_clima_fwi$HAS_FIRE=has_fire_cavernas$HAS_FIRE
write.csv(cavernas_clima_fwi,"cavernas_lasso_fwi.csv",sep =";",dec = ",")
cocha_clima_fwi=data.frame(cocha_clima_fwi,"HAS_FIRE"=has_fire_cocha$HAS_FIRE)
pandeiros_clima_fwi=data.frame(pandeiros_clima_fwi,"HAS_FIRE"=has_fire_pandeiros$HAS_FIRE)


  library(tibble)
  library(data.table)
  library(Publish)
  
  
#arrumando valores e fatores


tibble_variaveis= function(apa){
  data_tibble = as_tibble(apa) 
  data_tibble$HAS_FIRE=as.factor(data_tibble$HAS_FIRE)
  levels(data_tibble$HAS_FIRE)=c("not-burned","burned") 
  data_tibble$HAS_FIRE=relevel(data_tibble$HAS_FIRE, "not-burned")
  
  return(data_tibble)
}

#apa cavernas - amostras
tibble_cavernas=tibble_variaveis(cavernas_clima_fwi)



#criando index de treino e dados de treino e teste
index_treino_cavernas=sample(1:nrow(tibble_cavernas), round(0.8*nrow(tibble_cavernas)))
dados_treino_cavernas=tibble_cavernas[index_treino_cavernas,]
dados_teste_cavernas=tibble_cavernas[-index_treino_cavernas,]


#apa cocha - amostras
tibble_cocha=tibble_variaveis(cocha_clima_fwi)

index_treino_cocha=sample(1:nrow(tibble_cocha), round(0.8*nrow(tibble_cocha)))
dados_treino_cocha=tibble_cocha[index_treino_cocha,]
dados_teste_cocha=tibble_cocha[-index_treino_cocha,]



#apa pandeiros - amostras
tibble_pandeiros=tibble_variaveis(pandeiros_clima_fwi)

index_treino_pandeiros=sample(1:nrow(tibble_pandeiros), round(0.8*nrow(tibble_pandeiros)))
dados_treino_pandeiros=tibble_pandeiros[index_treino_pandeiros,]
dados_teste_pandeiros=tibble_pandeiros[-index_treino_pandeiros,]



#rodando o modelo regress�o logistica
#vari�veis categ�ricas ---------------- N�O DEU CERTO---------------

model1=glm(HAS_FIRE~temp_cat+rh_cat+prec_cat+ws_cat,data = dados_treino_cavernas,family = binomial())

summary(model1)

odds_teste=exp(coef(model1))

#vari�veis num�ricas, APENAS CLIMAS - amostra de treino
#modelo com precipita��o
model2=glm(HAS_FIRE~Temperature+Relative.Humidity+Precipitation+Wind.speed,data = dados_treino_cavernas,family = binomial())

summary(model2)
sumario_model2=summary.glm(model2)$coefficients
write.csv(sumario_model2, "modelo_sumario_clima2.csv")

pred.Teste=predict(model2,dados_teste_cavernas,type = "response")

dados_teste_cavernas$Prob_fogo=pred.Teste

View(dados_teste_cavernas[,c("HAS_FIRE","Prob_fogo")])

table(dados_teste_cavernas$HAS_FIRE,dados_teste_cavernas$Prob_fogo>0.5)

#modelo sem precipita��o
model4=glm(HAS_FIRE~Temperature+Relative.Humidity+Wind.speed,data = dados_treino_cavernas,family = binomial())

summary(model4)

#vari�veis num�ricas, clima = fwi - amostra de treino

model3=glm(HAS_FIRE~Temperature+Relative.Humidity+Precipitation+Wind.speed+Fine.Fuel.Moisture.Code+Duff.Moisture.Code+
             Drought.Code,data= dados_treino_cavernas,family=binomial())

summary(model3)

#vari�veis num�ricas, clima = fwi, SEM FFMC - amostra de treino

model_cavernas=glm(HAS_FIRE~Temperature+Relative.Humidity+Precipitation+Duff.Moisture.Code+
             Drought.Code,data= dados_treino_cavernas,family=binomial())

summary(model_cavernas)
sumario_model1=summary.glm(model_cavernas)$coefficients
write.csv(sumario_model1, "modelo_sumario_clima1.csv")

#vari�veis num�ricas amostra de teste-cavernas - rodando o modelo

pred.Teste=predict(model_cavernas,dados_teste_cavernas,type = "response")
View(pred.Teste)

dados_teste_cavernas$Prob_fogo=pred.Teste

View(dados_teste_cavernas[,c("HAS_FIRE","Prob_fogo")])

table(dados_teste_cavernas$HAS_FIRE,dados_teste_cavernas$Prob_fogo>0.5)
#rodando modelo para apa cocha
model_cocha=glm(HAS_FIRE~Temperature+Relative.Humidity+Precipitation+Wind.speed+
                  Drought.Code,data = dados_treino_cocha,family = binomial())


summary(model_cocha)

summary(model_cocha)
sumario_model5=summary.glm(model_cocha)$coefficients
write.csv(sumario_model5, "modelo_sumario_clima5.csv")

pred.Cocha=predict(model_cocha,dados_teste_cocha,type = "response")
View(pred.Cocha)

dados_teste_cocha$Prob_fogo=pred.Cocha

View(dados_teste_cocha[,c("HAS_FIRE","Prob_fogo")])

table(dados_teste_cocha$HAS_FIRE,dados_teste_cocha$Prob_fogo>0.5)

#rodando modelo para apa pandeiros
model_pandeiros=glm(HAS_FIRE~Temperature+Relative.Humidity+Precipitation+Drought.Code,data = dados_treino_pandeiros,family = binomial())

summary(model_pandeiros)
sumario_model7=summary.glm(model_pandeiros)$coefficients
write.csv(sumario_model7, "modelo_sumario_clima3.csv")

pred.Pandeiros=predict(model_pandeiros,dados_teste_pandeiros,type = "response")
View(pred.Pandeiros)

dados_teste_pandeiros$Prob_fogo=pred.Pandeiros

View(dados_teste_pandeiros[,c("HAS_FIRE","Prob_fogo")])

table(dados_teste_pandeiros$HAS_FIRE,dados_teste_pandeiros$Prob_fogo>0.5)
