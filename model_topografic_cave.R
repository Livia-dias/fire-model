#teste regressão logistica com variáveis topograficas

library(tibble)
library(glmnet)
library(coefplot)

titulo_grafico_pred = "Logistic Regression - APARP"
arquivo_apa_leitura = "modelo_topográfico\\APA Pandeiros\\matrix_topografic_pand.csv"
arquivo_coef_saida = "modelo_topográfico\\APA Pandeiros\\resultados\\coeficientes_log_reg_pand.csv"
arquivo_prob_saida = "modelo_topográfico\\APA Pandeiros\\resultados\\probabilidade_log_reg_pand.csv"
sumario_apa = "modelo_topográfico\\APA Pandeiros\\resultados\\modelo_sumario_pand.csv"

cavernas_topografic=data.frame(read.csv(arquivo_apa_leitura,dec = ",", sep = ";"))

cavernas_topografic=as.tibble(cavernas_topografic)

cavernas_topografic$HAS_FIRE=as.factor(cavernas_topografic$HAS_FIRE)
cavernas_topografic$LULC=as.numeric(cavernas_topografic$LULC)

levels(cavernas_topografic$HAS_FIRE)=c("not-burned","burned") 
cavernas_topografic$HAS_FIRE=relevel(cavernas_topografic$HAS_FIRE,"not-burned")
levels(cavernas_topografic$LULC)=c("Água","Área com influência antrópica","Áreas naturais","Cerrado","Vegetação com influência fluvial") 

index_treino_cave_map=sample(1:nrow(cavernas_topografic), round(0.8*nrow(cavernas_topografic)))
dados_treino_cave_map=cavernas_topografic[index_treino_cave_map,]
dados_teste_cave_map=cavernas_topografic[-index_treino_cave_map,]
colnames(dados_teste_cave_map)=c("HAS_FIRE","Elevation","Slope","NDVI","Hydrography","Road","LULC","Pop_Density")
colnames(dados_treino_cave_map)=c("HAS_FIRE","Elevation","Slope","NDVI","Hydrography","Road","LULC","Pop_Density")



model_map=glm(HAS_FIRE ~ .,data = dados_treino_cave_map,family = binomial())
library(MuMIn)
options(na.action = "na.fail") 
dd <- dredge(model_map)
View(dd)
model.avg(dd, subset = delta < 4)
#par(mar = c(3,5,6,4))
#plot(dd, labAsExpr = TRUE)


summary(model_map)

sumario_model=summary.glm(model_map)$coefficients
#write.csv(sumario_model, sumario_apa)

prob_map=predict(model_map,dados_teste_cave_map,type="response")
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
tabelinha[1]/(tabelinha[1]+tabelinha[2])
