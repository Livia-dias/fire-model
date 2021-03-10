library(glmnet)
library(tibble)


has_fire_cavernas=data.frame(read.csv("cavernas_model-clima.csv", sep = ","))
cavernas_topografic=data.frame(read.csv("model_topografic_cave.csv",dec = ",", sep = ";"))
cavernas_topografic=as.tibble(cavernas_topografic)

cavernas_topografic$HAS_FIRE=as.factor(cavernas_topografic$HAS_FIRE)
cavernas_topografic$Classe_cav=as.numeric(cavernas_topografic$Classe_cav)

levels(cavernas_topografic$HAS_FIRE)=c("not-burnt","burnt") 
cavernas_topografic$HAS_FIRE=relevel(cavernas_topografic$HAS_FIRE,"not-burnt")
levels(cavernas_topografic$Classe_cav)=c("Água","Área com influência antrópica","Áreas naturais","Vegetação sem influência fluvial","Vegetação com influência fluvial")




lasso_cave=glmnet(as.matrix(dados_treino_cave_map[,5:11]),dados_treino_cave_map$HAS_FIRE, family = "binomial", relax = TRUE)
print(lasso_cave)

plot(lasso_cave, xvar = "dev", label = TRUE)
coef(lasso_cave, s=0.01)
pred_GLMNET = predict(lasso_cave, newx = as.matrix(dados_teste_cave_map[,5:11]), type="response")
#View(pred_GLMNET)

dados_teste_cave_map$Prob_fogo=pred_GLMNET[[2]]

#View(dados_teste_cave_map[,c("HAS_FIRE","Prob_fogo")])

table(dados_teste_cave_map$HAS_FIRE,dados_teste_cave_map$Prob_fogo>0.5)

