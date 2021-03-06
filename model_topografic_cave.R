#teste regress�o logistica com vari�veis topograficas

library(tibble)
library(glmnet)
library(coefplot)
library(MuMIn)
library(sjPlot)
library(performance)
library(dplyr)
library(pROC)
library(graphics)


APA = "cocha" #### LEMBRAR DE MUDAR PLOT_MODEL LINHA 88

if(APA == "cocha") {
  titulo_grafico_coef = "APA Cocha e Gib�o"
  titulo_grafico_pred = "APA Cocha e Gib�o"
  titulo_grafico_auc = "Regress�o Log�stica - APA Cocha e Gib�o"
  arquivo_apa_leitura = "modelo_ano\\APA Cocha\\modelo_topografic_ano_cocha.csv"
  arquivo_coef_saida = "modelo_ano\\APA Cocha\\resultados\\coeficientes_log_reg_cocha.csv"
  arquivo_prob_saida = "modelo_ano\\APA Cocha\\resultados\\probabilidade_log_reg_cocha.csv"
  sumario_apa = "modelo_ano\\APA Cocha\\resultados\\modelo_sumario_cocha.csv"
  sumario_apa_std = "modelo_ano\\APA Cocha\\resultados\\modelo_sumario_std_cocha.csv"
  acuracia_apa = "modelo_ano\\APA Cocha\\resultados\\modelo_acuracia_cocha.csv"
  sumario_aic = "modelo_ano\\APA Cocha\\resultados\\best_AIC_sumario_cocha.csv"
  sumario_aic_std = "modelo_ano\\APA Cocha\\resultados\\best_AIC_sumario_std_cocha.csv"
  raz�es_de_chances= "modelo_ano\\APA Cocha\\resultados\\odds_ratio_cocha.csv"
}
if(APA == "cavernas") {
  titulo_grafico_coef = "APA Cavernas do Perua�u"
  titulo_grafico_pred = "APA Cavernas do Perua�u"
  titulo_grafico_auc = "Regress�o Log�stica - APA Cavernas"
  arquivo_apa_leitura = "modelo_ano\\APA Cavernas\\modelo_topografic_ano_cave.csv"
  arquivo_coef_saida = "modelo_ano\\APA Cavernas\\resultados\\coeficientes_log_reg_cave.csv"
  arquivo_prob_saida = "modelo_ano\\APA Cavernas\\resultados\\probabilidade_log_reg_cave.csv"
  sumario_apa = "modelo_ano\\APA Cavernas\\resultados\\modelo_sumario_cave.csv"
  sumario_apa_std = "modelo_ano\\APA Cavernas\\resultados\\modelo_sumario_std_cave.csv"
  acuracia_apa = "modelo_ano\\APA Cavernas\\resultados\\modelo_acuracia_cave.csv"
  sumario_aic = "modelo_ano\\APA Cavernas\\resultados\\best_AIC_sumario_cave.csv"
  sumario_aic_std = "modelo_ano\\APA Cavernas\\resultados\\best_AIC_sumario_std_cave.csv"
  raz�es_de_chances= "modelo_ano\\APA Cavernas\\resultados\\odds_ratio_cave.csv"
}
if(APA == "pandeiros") {
  titulo_grafico_coef = "APA Pandeiros"
  titulo_grafico_pred = "APA Pandeiros"
  titulo_grafico_auc = "Regress�o Log�stica - APA Pandeiros"
  arquivo_apa_leitura = "modelo_ano\\APA Pandeiros\\modelo_topografic_ano_pand.csv"
  arquivo_coef_saida = "modelo_ano\\APA Pandeiros\\resultados\\coeficientes_log_reg_pand.csv"
  arquivo_prob_saida = "modelo_ano\\APA Pandeiros\\resultados\\probabilidade_log_reg_pand.csv"
  sumario_apa = "modelo_ano\\APA Pandeiros\\resultados\\modelo_sumario_pand.csv"
  sumario_apa_std = "modelo_ano\\APA Pandeiros\\resultados\\modelo_sumario_std_pand.csv"
  acuracia_apa = "modelo_ano\\APA Pandeiros\\resultados\\modelo_acuracia_pand.csv"
  sumario_aic = "modelo_ano\\APA Pandeiros\\resultados\\best_AIC_sumario_pand.csv"
  sumario_aic_std = "modelo_ano\\APA Pandeiros\\resultados\\best_AIC_sumario_std_pand.csv"
  raz�es_de_chances= "modelo_ano\\APA Pandeiros\\resultados\\odds_ratio_pand.csv"
}

cavernas_topografic=data.frame(read.csv(arquivo_apa_leitura,dec = ",", sep = ";"))

cavernas_topografic <- cavernas_topografic[,colSums(is.na(cavernas_topografic))<nrow(cavernas_topografic)]

cavernas_topografic=as.tibble(cavernas_topografic)

cavernas_topografic$HAS_FIRE=as.factor(cavernas_topografic$HAS_FIRE)
cavernas_topografic$LULC=as.factor(cavernas_topografic$LULC)

levels(cavernas_topografic$HAS_FIRE)=c("not-burned","burned") 
cavernas_topografic$HAS_FIRE=relevel(cavernas_topografic$HAS_FIRE, ref = "not-burned")

#Treino: 2015 pra tr�s (incluso 2015). Teste: 2016 pra frente (incluso 2016)
dados_treino_cave_map=cavernas_topografic[cavernas_topografic$Year<2016,]
dados_teste_cave_map=cavernas_topografic[cavernas_topografic$Year>=2016,]

dados_teste_cave_map=dados_teste_cave_map[1:(length(dados_teste_cave_map)-1)]
dados_treino_cave_map=dados_treino_cave_map[1:(length(dados_treino_cave_map)-1)]

colnames(dados_teste_cave_map)=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","Ocupations", "LULC")
colnames(dados_treino_cave_map)=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","Ocupations","LULC")

options(na.action = "na.fail") 

###STD
dados_treino_cave_map_std= dados_treino_cave_map
dados_treino_cave_map_std[2:8]=scale(dados_treino_cave_map_std[2:8])
model_map_std=glm(HAS_FIRE ~ .,data = dados_treino_cave_map_std,family = binomial(link = "logit"))

dd_std <- dredge(model_map_std)
model_AIC_std=get.models(dd_std,TRUE)[[1]]
best_AIC_model_std=model.avg(dd_std, subset = delta < 4)
write.csv(best_AIC_model_std$coefficients, sumario_aic_std)


sumario_model_std=summary(model_AIC_std)$coefficients
write.csv(sumario_model_std, sumario_apa_std)

view(sumario_model)

###STD

model_map=glm(HAS_FIRE ~ .,data = dados_treino_cave_map,family = binomial(link = "logit"))
dd <- dredge(model_map)
model_AIC=get.models(dd,TRUE)[[1]]

plot_model(model_AIC,type = "std", show.values = TRUE, title = titulo_grafico_coef, 
           #colors = "Accent",
            value.offset = .4, vline.color = "#c8dae8",
           #axis.labels = c("Dist�ncia de Habita��es","Declividade","Dist�ncia de Hidrografia","Altitude","Dist�ncia de Rodovias"), 
                           #,"�rea n�o vegetada",,,"Floresta Plantada","Lavoura Tempor�ria"),
           #41= Lavoura Tempor�ria; 12= Forma��o Campestre; 9= Floresta Plantada;
           #15= Pastagem; 25= �rea n�o vegetada; 4= Forma��o Sav�nica; 3= Forma��o Florestal
           #33= Rio
           sort.est = TRUE) + theme_sjplot2()
#APACP - Accent
#APACG - SEM NADA (comentar linha 62)
#APARP - system

sumario_model=summary(model_AIC)$coefficients
write.csv(sumario_model, sumario_apa)

prob_map=predict(model_AIC,dados_teste_cave_map,type="response")
reg_predict <- rep(0,nrow(dados_teste_cave_map))
reg_predict[prob_map>.5] <- 1



grafico_predicao <-ggplot(dados_teste_cave_map, aes(x=prob_map, y=reg_predict)) + geom_point() + 
  geom_smooth(method="glm", family="binomial", col="red") + xlab("Probabilidade Estimada %") + 
  ylab("Evento observado") + labs(title = titulo_grafico_pred) 
#+ labs(tag="a)")
##APA COCHA = red
##APA CAVERNAS = green
## APA PANDEIROS = dark orange
grafico_predicao

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

#OBTEN��O DAS RAZ�ES DE CHANCE COM IC 95% (usando log-likelihood)
exp(cbind(OR=coef(model_AIC), confint(model_AIC)))

#OBTEN��O DAS RAZ�ES DE CHANCE COM IC 95% (usando erro padr�o = SPSS)
odds_ratio=exp(cbind(OR =coef(model_AIC), confint.default(model_AIC)))
write.csv(odds_ratio, raz�es_de_chances)

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
plot(roc_model,print.auc = TRUE, legacy.axes = TRUE, grid=TRUE, 
         identity.col = "light blue", print.thres = TRUE,
         print.thres.col="red",print.thres.pattern=ifelse(roc_model$percent, "Limiar = %.2f", "%.3f"),
         #col="blue",
         main= titulo_grafico_auc,
         print.thres.adj=c(-1.55,19.2),
         xlab = "Taxa de Falso Positivo (Especificidade %)", ylab = "Taxa de Verdadeiro Positivo (Sensibilidade %)")

#dev.off()
