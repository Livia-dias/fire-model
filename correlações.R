library(caret)
library(tibble)

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

predictions <- model_map %>% predict(dados_teste_cave_map)
data.frame( R2 = R2(predictions, as.numeric(dados_teste_cave_map$HAS_FIRE)),
            RMSE = RMSE(predictions, as.numeric(dados_teste_cave_map$HAS_FIRE)),
            MAE = MAE(predictions, as.numeric(dados_teste_cave_map$HAS_FIRE)))

RMSE(predictions, as.numeric(dados_teste_cave_map$HAS_FIRE))/mean(as.numeric(dados_teste_cave_map$HAS_FIRE))


set.seed(123)
# Define training control
train.control <- trainControl(method = "LOOCV")
# Train the model
dados_teste_cave_map[is.na(dados_teste_cave_map)] = 0
model_las <- train(HAS_FIRE ~., data = teste_pra_deletar_depois, method = "lm",
               trControl = train.control)
# Summarize the results
print(model_las)
write.csv(teste_pra_deletar_depois, "tabela_com_os_bagulho_pra_renomear_depois.csv", sep=",", dec=".")