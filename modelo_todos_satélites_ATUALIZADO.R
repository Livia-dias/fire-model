#teste regressão logistica com variáveis topograficas

library(boot)
library(tibble)
library(glmnet)
library(coefplot)
library(MuMIn)
library(sjPlot)
library(performance)
library(dplyr)
library(pROC)
library(graphics)
library(caret)
library(rlist)
APA = "pandeiros"
currentTest = "Topografico"

if(currentTest == "Topografico"){
  nomes_colunas=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","Ocupations", "LULC")
  range_colunas = c()
}
if(currentTest == "FWI"){
  nomes_colunas=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","Ocupations", "LULC", "Temperature", 
                  "RH", "Precipitation", "Wind Speed", "FMC", "DMC", "DC")
  range_colunas = c(10:16)
}
if(currentTest == "Clima"){
  nomes_colunas=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","Ocupations", "LULC", "Temperature", 
                  "RH", "Precipitation", "Wind Speed")
  range_colunas = c(10:13)
}

if(APA == "cocha") {
 
  
  titulo_residuo_vs_fitted = "APA Cocha e Gibão" 
  titulo_predito_vs_residuo = "APA Cocha e Gibão"
  titulo_grafico_coef = "APA Cocha e Gibão"
  titulo_grafico_pred = "APA Cocha e Gibão"
  titulo_grafico_auc = " Curva ROC - APA Cocha e Gibão"
  
  if(currentTest=="FWI"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_com_FWI_cocha.csv"
  }
    
  if(currentTest=="Clima"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_com_clima_cocha.csv"
  }
    
  if(currentTest=="Topografico"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_cocha.csv"
  }
  
  arquivo_saida_predicoes=sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\predicoes_cocha.csv", currentTest)
  arquivo_coef_saida = sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\coeficientes_log_reg_cocha.csv", currentTest)
  arquivo_prob_saida = sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\probabilidade_log_reg_cocha.csv", currentTest)
  sumario_apa = sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\modelo_sumario_cocha.csv", currentTest)
  sumario_apa_std = sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\modelo_sumario_std_cocha.csv", currentTest)
  acuracia_apa = sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\modelo_acuracia_cocha.csv", currentTest)
  sumario_aic = sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\best_AIC_sumario_cocha.csv", currentTest)
  sumario_aic_std = sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\best_AIC_sumario_std_cocha.csv", currentTest)
  razões_de_chances= sprintf("MODELO_TODOS_SATÉLITES\\APA Cocha\\resultados\\%s\\odds_ratio_cocha.csv", currentTest)
}
if(APA == "cavernas") {
  titulo_residuo_vs_fitted = "APA Cavernas do Peruaçu" 
  titulo_predito_vs_residuo = "APA Cavernas do Peruaçu"
  titulo_grafico_coef = "APA Cavernas do Peruaçu"
  titulo_grafico_pred = "APA Cavernas do Peruaçu"
  titulo_grafico_auc = "Curva ROC - APA Cavernas"
  

  if(currentTest=="FWI"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cavernas\\modelo_TODOS_com_FWI_cavernas.csv"
  }
    
  if(currentTest=="Clima"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cavernas\\modelo_TODOS_com_clima_cavernas.csv"
  }
  if(currentTest=="Topografico"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cavernas\\modelo_TODOS_cavernas.csv"
  }
  
  arquivo_saida_predicoes=sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\predicoes_cavernas.csv", currentTest)
  arquivo_coef_saida = sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\coeficientes_log_reg_cave.csv", currentTest)
  arquivo_prob_saida = sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\probabilidade_log_reg_cave.csv", currentTest)
  sumario_apa = sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\modelo_sumario_cave.csv", currentTest)
  sumario_apa_std = sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\modelo_sumario_std_cave.csv", currentTest)
  acuracia_apa = sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\modelo_acuracia_cave.csv", currentTest)
  sumario_aic = sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\best_AIC_sumario_cave.csv", currentTest)
  sumario_aic_std = sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\best_AIC_sumario_std_cave.csv", currentTest)
  razões_de_chances= sprintf("MODELO_TODOS_SATÉLITES\\APA Cavernas\\resultados\\%s\\odds_ratio_cave.csv", currentTest)
}
if(APA == "pandeiros") {
  titulo_residuo_vs_fitted = "APA Rio Pandeiros" 
  titulo_predito_vs_residuo = "APA Rio Pandeiros"
  titulo_grafico_coef = "APA Rio Pandeiros"
  titulo_grafico_pred = "APA Rio Pandeiros"
  titulo_grafico_auc = "Curva ROC - APA Rio Pandeiros"
  
 
  if(currentTest=="FWI"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Pandeiros\\modelo_TODOS_com_FWI_pand.csv"
  }
  if(currentTest=="Clima"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Pandeiros\\modelo_TODOS_com_clima_pand.csv"
    }
  if(currentTest=="Topografico"){
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Pandeiros\\modelo_TODOS_pand.csv"
  
  }
  
  arquivo_saida_predicoes=sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\predicoes_pandeiros.csv", currentTest)
  arquivo_coef_saida = sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\coeficientes_log_reg_pand.csv", currentTest)
  arquivo_prob_saida = sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\probabilidade_log_reg_pand.csv", currentTest)
  sumario_apa = sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\modelo_sumario_pand.csv", currentTest)
  sumario_apa_std = sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\modelo_sumario_std_pand.csv", currentTest)
  acuracia_apa = sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\modelo_acuracia_pand.csv", currentTest)
  sumario_aic = sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\best_AIC_sumario_pand.csv", currentTest)
  sumario_aic_std = sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\best_AIC_sumario_std_pand.csv", currentTest)
  razões_de_chances= sprintf("MODELO_TODOS_SATÉLITES\\APA Pandeiros\\resultados\\%s\\odds_ratio_pand.csv", currentTest)
}

cavernas_topografic=data.frame(read.csv(arquivo_apa_leitura,dec = ",", sep = ";"))

cavernas_topografic <- cavernas_topografic[,colSums(is.na(cavernas_topografic))<nrow(cavernas_topografic)]

cavernas_topografic=as.tibble(cavernas_topografic)

cavernas_topografic$HAS_FIRE=as.factor(cavernas_topografic$HAS_FIRE)
cavernas_topografic$LULC=as.factor(cavernas_topografic$LULC)

levels(cavernas_topografic$HAS_FIRE)=c("not-burned","burned") 
cavernas_topografic$HAS_FIRE=relevel(cavernas_topografic$HAS_FIRE, ref = "not-burned")

#Treino: 2015 pra trás (incluso 2015). Teste: 2016 pra frente (incluso 2016)
dados_treino_cave_map=cavernas_topografic[cavernas_topografic$year<2016,]
dados_teste_cave_map=cavernas_topografic[cavernas_topografic$year>=2016,]

dados_teste_cave_map=dados_teste_cave_map[1:(length(dados_teste_cave_map)-1)]
dados_treino_cave_map=dados_treino_cave_map[1:(length(dados_treino_cave_map)-1)]

colnames(dados_teste_cave_map)=nomes_colunas
colnames(dados_treino_cave_map)=nomes_colunas

options(na.action = "na.fail") 

###STD
dados_treino_cave_map_std= dados_treino_cave_map
dados_treino_cave_map_std[2:8]=scale(dados_treino_cave_map_std[2:8])
dados_treino_cave_map_std[range_colunas]=scale(dados_treino_cave_map_std[range_colunas])

#dados_teste_cave_map$Elevation=NULL
#dados_treino_cave_map$Elevation=NULL
#dados_teste_cave_map$Pop_dens=NULL
#dados_treino_cave_map$Pop_dens=NULL

train.control <- glm.control(epsilon = 1e-8, maxit =25 , trace = FALSE)

model_map_std=glm(HAS_FIRE ~ .,data = dados_treino_cave_map_std,family = binomial(link = "logit"), control = train.control)
dd_std <- dredge(model_map_std)
model_AIC_std=get.models(dd_std,subset = delta < 4)[[1]]
best_AIC_model_std=model.avg(dd_std, subset = delta < 4)
write.csv(best_AIC_model_std$coefficients, sumario_aic_std)
best_AIC_model_std=NULL

sumario_model_std=summary(model_AIC_std)$coefficients
write.csv(sumario_model_std, sumario_apa_std)
###STD

model_map=glm(HAS_FIRE ~ .,data = dados_treino_cave_map,family = binomial(link = "logit"))
dd <- dredge(model_map)
model_AIC=get.models(dd,TRUE, subset = delta < 4)[[1]]

sumario_model=summary(model_AIC)$coefficients
write.csv(sumario_model, sumario_apa)

prob_map=predict(model_AIC,dados_teste_cave_map,type="response")
reg_predict <- rep(0,nrow(dados_teste_cave_map))
reg_predict[prob_map>.5] <- 1


dados_teste_cave_map$Prob_fogo=prob_map


tabelinha = table(dados_teste_cave_map$HAS_FIRE,dados_teste_cave_map$Prob_fogo>0.5)
write.csv(tabelinha, acuracia_apa)
tabelinha[1]/(tabelinha[1]+tabelinha[2])

r2(model_AIC)

rmse(model_AIC, normalized=TRUE)
#OBTENÇÃO DAS RAZÕES DE CHANCE COM IC 95% (usando log-likelihood)
exp(cbind(OR=coef(model_AIC), confint(model_AIC)))

#OBTENÇÃO DAS RAZÕES DE CHANCE COM IC 95% (usando erro padrão = SPSS)
odds_ratio=exp(cbind(OR =coef(model_AIC), confint.default(model_AIC)))
write.csv(odds_ratio, razões_de_chances)

vp= tabelinha [1,1];vp
fn=tabelinha [2,1];fn
fp=tabelinha [1,2];fp
vn=tabelinha [2,2];vn

Taxa_de_Falso_Positivo = vn/(vn+fp)

Taxa_de_Verdadeiro_Positivo = vp/(vp+fn)

pred_roc_cave= dplyr::tibble(prob_map, 
                             "HAS_FIRE" = as.factor(as.numeric(dados_teste_cave_map$HAS_FIRE)-1))%>% arrange(desc(prob_map))

roc_model= pROC::roc(pred_roc_cave$HAS_FIRE,pred_roc_cave$prob_map, percent = TRUE)

par(pty = "s")
auc_ratio_plot = plot(roc_model,print.auc = TRUE, legacy.axes = TRUE, grid=TRUE, 
                      identity.col = "blue", print.thres = FALSE,
                      #print.thres.col=COLOR_AUC, print.thres.pattern=ifelse(roc_model$percent, "Limiar = %.2f", "%.3f"),
                      main= titulo_grafico_auc,
                      print.thres.adj=c(-3.25,26.5),
                      xlab = "Taxa de Falso Positivo (Especificidade %)", ylab = "Taxa de Verdadeiro Positivo (Sensibilidade %)")
auc_ratio_plot

dados_teste_cave_map["HasFire_Predict"]=pred_roc_cave["HAS_FIRE"]
write.csv(dados_teste_cave_map, arquivo_saida_predicoes)
plot(fitted.values(model_AIC), residuals.glm(model_AIC),
     main = titulo_residuo_vs_fitted,
     xlab = "Valores Observados Ajustados", ylab = "Resíduais")
abline(0,0)


residuos_prob=(as.numeric(dados_teste_cave_map$HAS_FIRE)-1)-prob_map
plot(dados_teste_cave_map$HasFire_Predict, residuos_prob,
     main = titulo_predito_vs_residuo,
     xlab = "Previstos", ylab = "Resíduais")

set.seed(123)
kfold = cv.glm(dados_teste_cave_map, model_AIC, K=10) #Kfold=10
kfold_loocv = cv.glm(dados_teste_cave_map, model_AIC, K=nrow(dados_teste_cave_map)) #KFold LOOCV
kfold
kfold_loocv

fileName = sprintf("%s-%s.RData", APA, currentTest)
save.image(sprintf("C:\\R\\fire-model\\workspaces\\%s",fileName))
