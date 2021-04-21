#teste regressão logistica com variáveis topograficas

library(tibble)
library(glmnet)
library(coefplot)

titulo_grafico_coef = "Logistic Regression - APACG"
titulo_grafico_pred = "Logistic Regression - APACG"
arquivo_apa_leitura = "modelo_ano\\APA Cocha\\modelo_topografic_ano_cocha.csv"
arquivo_coef_saida = "modelo_ano\\APA Cocha\\resultados\\coeficientes_log_reg_cocha.csv"
arquivo_prob_saida = "modelo_ano\\APA Cocha\\resultados\\probabilidade_log_reg_cocha.csv"
sumario_apa = "modelo_ano\\APA Cocha\\resultados\\modelo_sumario_cocha.csv"
acuracia_apa = "modelo_ano\\APA Cocha\\resultados\\modelo_acuracia_cocha.csv"
sumario_aic = "modelo_ano\\APA Cocha\\resultados\\best_AIC_sumario_cocha.csv"
  
cavernas_topografic=data.frame(read.csv(arquivo_apa_leitura,dec = ",", sep = ";"))

cavernas_topografic=as.tibble(cavernas_topografic)

cavernas_topografic$HAS_FIRE=as.factor(cavernas_topografic$HAS_FIRE)
cavernas_topografic$LULC=as.factor(cavernas_topografic$LULC)

levels(cavernas_topografic$HAS_FIRE)=c("not-burned","burned") 
cavernas_topografic$HAS_FIRE=relevel(cavernas_topografic$HAS_FIRE,"not-burned")

dados_treino_cave_map=cavernas_topografic[cavernas_topografic$Year<2016,]
dados_teste_cave_map=cavernas_topografic[cavernas_topografic$Year>=2016,]

dados_teste_cave_map=dados_teste_cave_map[1:(length(dados_teste_cave_map)-1)]
dados_treino_cave_map=dados_treino_cave_map[1:(length(dados_treino_cave_map)-1)]

colnames(dados_teste_cave_map)=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","LULC")
colnames(dados_treino_cave_map)=c("HAS_FIRE","Elevation","Slope","NDVI","Road","Hydrography","Pop_dens","LULC")



model_map=glm(HAS_FIRE ~ .,data = dados_treino_cave_map,family = binomial())
library(MuMIn)
options(na.action = "na.fail") 
dd <- dredge(model_map)
model_AIC=get.models(dd,1)[[1]]
best_AIC_model=model.avg(dd, subset = delta < 4)
write.csv(best_AIC_model$coefficients, sumario_aic)

library(sjPlot)
plot_model(model_map,type = "std", show.values = TRUE, title = titulo_grafico_coef, 
           #axis.labels = c("1","2","3","4","5","6","7"),
           sort.est = TRUE, vline.color = "red")

sumario_model=summary(best_AIC_model)$coefficients
write.csv(sumario_model, sumario_apa)

prob_map=predict(model_AIC,dados_teste_cave_map,type="response")
reg_predict <- rep(0,nrow(dados_teste_cave_map))
reg_predict[prob_map>.5] <- 1


grafico_predicao <-ggplot(dados_teste_cave_map, aes(x=prob_map, y=reg_predict)) + geom_point() + 
  geom_smooth(method="glm", family="binomial", col="red") + xlab("Probability") + 
  ylab("Predicted") + labs(title = titulo_grafico_pred) 
#+ labs(tag="a)")
grafico_predicao

true_ocurrences=ifelse(dados_teste_cave_map$HAS_FIRE=="burned",1,0)
grafico_predicao <-ggplot(dados_teste_cave_map, aes(x=prob_map, y=true_ocurrences)) + geom_point() + 
  geom_smooth(method="glm", family="binomial", col="red") + xlab("Probability") + 
  ylab("Predicted") + labs(title = "True Occurrences")
#+ labs(tag="a)")
grafico_predicao

dados_teste_cave_map$Prob_fogo=prob_map


tabelinha = table(dados_teste_cave_map$HAS_FIRE,dados_teste_cave_map$Prob_fogo>0.5)
write.csv(tabelinha, acuracia_apa)
tabelinha[1]/(tabelinha[1]+tabelinha[2])
