#teste regressão logistica com variáveis topograficas

library(tibble)

cavernas_topografic=data.frame(read.csv("model_topografic_cave.csv",dec = ",", sep = ";"))

cavernas_topografic$elev_cave[cavernas_topografic$elev_cave<0]=0
cavernas_topografic$hidro_dist[cavernas_topografic$hidro_dist<0]=0
cavernas_topografic$road_dista[cavernas_topografic$road_dista<0]=0
cavernas_topografic$censo_cave[cavernas_topografic$censo_cave<0]=0

cavernas_topografic=as.tibble(cavernas_topografic)

cavernas_topografic$HAS_FIRE=as.factor(cavernas_topografic$HAS_FIRE)
cavernas_topografic$Classe_cav=as.numeric(cavernas_topografic$Classe_cav)

levels(cavernas_topografic$HAS_FIRE)=c("not-burned","burned") 
cavernas_topografic$HAS_FIRE=relevel(cavernas_topografic$HAS_FIRE,"not-burned")
levels(cavernas_topografic$Classe_cav)=c("Água","Área com influência antrópica","Áreas naturais","Cerrado","Vegetação com influência fluvial") 

index_treino_cave_map=sample(1:nrow(cavernas_topografic), round(0.8*nrow(cavernas_topografic)))
dados_treino_cave_map=cavernas_topografic[index_treino_cave_map,]
dados_teste_cave_map=cavernas_topografic[-index_treino_cave_map,]

model_map=glm(HAS_FIRE~elev_cave+slope_cave+NDVI_cave+hidro_dist+road_dista+censo_cave+Classe_cav,data = dados_treino_cave_map,family = binomial())

summary(model_map)
sumario_model=summary.glm(model_map)$coefficients
write.csv(sumario_model, "modelo_sumario2.csv")

pred_map=predict(model_map,dados_teste_cave_map,type="response")
View(pred_map)

dados_teste_cave_map$Prob_fogo=pred_map

View(dados_teste_cave_map[,c("HAS_FIRE","Prob_fogo")])

table(dados_teste_cave_map$HAS_FIRE,dados_teste_cave_map$Prob_fogo>0.5)
