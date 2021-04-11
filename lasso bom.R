#load required library
library(glmnet)
library(coefplot)

titulo_grafico_pred = "Lasso Regression - APARP"
arquivo_apa_leitura = "modelo_topográfico\\APA Pandeiros\\matrix_topografic_pand.csv"
arquivo_coef_saida = "modelo_topográfico\\APA Pandeiros\\resultados\\coeficientes_lasso_pand.csv"
arquivo_prob_saida = "modelo_topográfico\\APA Pandeiros\\resultados\\probabilidade_lasso_pand.csv"
anotacoes_da_apa = "modelo_topográfico\\APA Pandeiros\\resultados\\anotacoes.csv"

anotacoes = data.frame(matrix(ncol=2, nrow=0))
colnames(anotacoes) = c("chave","valor")


cavernas_topografic=data.frame(read.csv(arquivo_apa_leitura,dec = ",", sep = ";"))

treino_cave_lasso=sample(1:nrow(cavernas_topografic), round(0.8*nrow(cavernas_topografic)))
dados_treino_cave_lasso=cavernas_topografic[treino_cave_lasso,]
dados_teste_cave_lasso=cavernas_topografic[-treino_cave_lasso,]

#convert training data to matrix format
x <- model.matrix(HAS_FIRE~.,dados_treino_cave_lasso)
#convert class to numerical variable
y <- ifelse(dados_treino_cave_lasso$HAS_FIRE==1,1,0)
#perform grid search to find optimal value of lambda
#family= binomial => logistic regression, alpha=1 => lasso
# check docs to explore other type.measure options
cv.out <- cv.glmnet(x,y,alpha=1,family="binomial")
#plot result
plot(cv.out)


#min value of lambda
lambda_min <- cv.out$lambda.min
anotacoes[nrow(anotacoes) + 1,] = c("lambda_min",lambda_min)
#best value of lambda
lambda_1se <- cv.out$lambda.1se
anotacoes[nrow(anotacoes) + 1,] = c("lambda_1se",lambda_1se)
anotacoes[nrow(anotacoes) + 1,] = c("exp(lambda_1se)",exp(lambda_1se))
#regression coefficients
coeficients=coef(cv.out,s=lambda_1se)
coefplot(cv.out, lambda=lambda_1se, sort="magnitude")
coefpath(cv.out)

write.csv(as.data.frame(as.matrix(coeficients)),file = arquivo_coef_saida)

#get test data
x_test <- model.matrix(HAS_FIRE~.,dados_teste_cave_lasso)
#predict class, type="class"
lasso_prob <- predict(cv.out,newx = x_test,s=lambda_1se,type="response")
#translate probabilities to predictions
lasso_predict <- rep(0,nrow(dados_teste_cave_lasso))
lasso_predict[lasso_prob>.5] <- 1


results_cave_lasso=cbind(lasso_predict,lasso_prob)
colnames(results_cave_lasso)=c("lasso_predict","lasso_prob")
rownames(results_cave_lasso)=c()
write.csv(results_cave_lasso,file = arquivo_prob_saida,row.names = FALSE)
#confusion matrix
table(pred=lasso_predict,true=dados_teste_cave_lasso$HAS_FIRE)
#accuracy
porcentagem_acerto = mean(lasso_predict==dados_teste_cave_lasso$HAS_FIRE)
anotacoes[nrow(anotacoes) + 1,] = c("porcentagem_acerto",porcentagem_acerto)

#grafico
data_cave=cbind.data.frame(dados_teste_cave_lasso$HAS_FIRE,lasso_prob,lasso_predict)
names(data_cave)=c("HAS_FIRE","lasso_prob","lasso_predict")

grafico_predicao <-ggplot(data_cave, aes(x=lasso_prob, y=lasso_predict)) + geom_point() + 
  geom_smooth(method="glm", family="binomial", col="red") + xlab("Probability") + 
  ylab("Predicted") + labs(title = titulo_grafico_pred) 
  #+ labs(tag="a)")
grafico_predicao

grafico_has_fire <-ggplot(data_cave, aes(x=lasso_prob, y=dados_teste_cave_lasso$HAS_FIRE)) + geom_point() + 
  geom_smooth(method="glm", family="binomial", col="red") + xlab("Probability") + 
  ylab("Predicted") + labs(title = "True Occurrences") 
#+ labs(tag="a)")
grafico_has_fire

write.csv(anotacoes, file=anotacoes_da_apa)
