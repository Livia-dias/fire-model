#teste regressão logistica com variáveis topograficas

library(tibble)
library(glmnet)
library(coefplot)
library(MuMIn)
library(sjPlot)
library(performance)
library(dplyr)
library(pROC)
library(graphics)
library(rlist)


APA = "cocha"
currentTest = "FWI"
    
if(APA == "cocha") {
  COLOR_ODDS_RATIO="Set1"
  COLOR_AUC="red"
  
  titulo_grafico_coef = "APA Cocha e Gibão"
  titulo_grafico_pred = "APA Cocha e Gibão"
  titulo_grafico_auc = " Curva ROC - APA Cocha e Gibão"
  
  if(currentTest=="FWI")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_com_FWI_cocha.csv"
  if(currentTest=="Clima")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_com_clima_cocha.csv"
  if(currentTest=="Topografico")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_cocha.csv"
  
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
  titulo_grafico_coef = "APA Cavernas do Peruaçu"
  titulo_grafico_pred = "APA Cavernas do Peruaçu"
  titulo_grafico_auc = "Curva ROC - APA Cavernas"
  
  COLOR_ODDS_RATIO="Accent"
  COLOR_AUC="green"
  
  if(currentTest=="FWI")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_com_FWI_cavernas.csv"
  if(currentTest=="Clima")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_com_clima_cavernas.csv"
  if(currentTest=="Topografico")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_cavernas.csv"
  
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
  titulo_grafico_coef = "APA Pandeiros"
  titulo_grafico_pred = "APA Pandeiros"
  titulo_grafico_auc = "Curva ROC - APA Pandeiros"
  
  COLOR_ODDS_RATIO="system"
  COLOR_AUC="dark orange"
  
  if(currentTest=="FWI")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_com_FWI_pand.csv"
  if(currentTest=="Clima")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_com_clima_pand.csv"
  if(currentTest=="Topografico")
    arquivo_apa_leitura = "MODELO_TODOS_SATÉLITES\\APA Cocha\\modelo_TODOS_pand.csv"
  
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

colnames(dados_teste_cave_map)=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","Ocupations", "LULC", "Temperature", 
                                 "RH", "Precipitation", "Wind Speed", "FMC", "DMC", "DC")
colnames(dados_treino_cave_map)=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","Ocupations","LULC", "Temperature", 
                                  "RH", "Precipitation", "Wind Speed", "FMC", "DMC", "DC")

options(na.action = "na.fail") 

###STD
dados_treino_cave_map_std= dados_treino_cave_map
dados_treino_cave_map_std[2:8]=scale(dados_treino_cave_map_std[2:8])
dados_treino_cave_map_std[10:16]=scale(dados_treino_cave_map_std[10:16])
model_map_std=glm(HAS_FIRE ~ .,data = dados_treino_cave_map_std,family = binomial(link = "logit"))

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
#odds_ratio_graph = plot_model(model_AIC,type = "std", show.values = TRUE, title = titulo_grafico_coef, 
           #colors = COLOR_ODDS_RATIO,
           #value.offset = .4, vline.color = "#000000",
           #axis.labels = c("Distância de Habitações","Declividade","Distância de Hidrografia","Altitude","Distância de Rodovias"), 
           #,"Área não vegetada",,,"Floresta Plantada","Lavoura Temporária"),
           #41= Lavoura Temporária; 12= Formação Campestre; 9= Floresta Plantada;
           #15= Pastagem; 25= Área não vegetada; 4= Formação Savânica; 3= Formação Florestal
           #33= Rio
           #sort.est = TRUE) + theme_sjplot2() 
#odds_ratio_graph
#+ scale_y_continuous(limits = c(-1,20), expand = c(0,0), oob = function(x, ...) x)

#APACP - Accent
#APACG - SEM NADA (comentar linha 62)
#APARP - system

sumario_model=summary(model_AIC)$coefficients
write.csv(sumario_model, sumario_apa)

prob_map=predict(model_AIC,dados_teste_cave_map,type="response")
reg_predict <- rep(0,nrow(dados_teste_cave_map))
reg_predict[prob_map>.5] <- 1



#grafico_predicao <-ggplot(dados_teste_cave_map, aes(x=prob_map, y=reg_predict)) + geom_point() + 
 # geom_smooth(method="glm", family="binomial", col="red") + xlab("Probabilidade Estimada %") + 
  #ylab("Evento observado") + labs(title = titulo_grafico_pred) 
#+ labs(tag="a)")
##APA COCHA = red
##APA CAVERNAS = green
## APA PANDEIROS = dark orange
#grafico_predicao

#true_ocurrences=ifelse(dados_teste_cave_map$HAS_FIRE=="burned",1,0)
#grafico_predicao <-ggplot(dados_teste_cave_map, aes(x=prob_map, y=true_ocurrences)) + geom_point() + 
#geom_smooth(method="glm", family="binomial", col="red") + xlab("Probability") + 
#ylab("Predicted") + labs(title = "True Occurrences")
#+ labs(tag="a)")
#grafico_predicao

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
#jpeg(file="test.jpeg", bg="transparent")
auc_ratio_plot = plot(roc_model,print.auc = TRUE, legacy.axes = TRUE, grid=TRUE, 
     identity.col = "blue", print.thres = FALSE,
     #print.thres.col=COLOR_AUC, print.thres.pattern=ifelse(roc_model$percent, "Limiar = %.2f", "%.3f"),
     main= titulo_grafico_auc,
     print.thres.adj=c(-3.25,26.5),
     xlab = "Taxa de Falso Positivo (Especificidade %)", ylab = "Taxa de Verdadeiro Positivo (Sensibilidade %)")
auc_ratio_plot

dados_teste_cave_map["HasFire_Predict"]=pred_roc_cave["HAS_FIRE"]
write.csv(dados_teste_cave_map, arquivo_saida_predicoes)

#res=resid(model_AIC)
#plot(dados_teste_cave_map$HasFire_Predict, res)
#xlab = "Taxa de Falso Positivo (Especificidade %)" ylab = "Taxa de Verdadeiro Positivo (Sensibilidade %)")
abline(0,0)

qqnorm(res)
qqline(res)

plot(density(res))

#dev.off()