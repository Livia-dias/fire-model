#load required library
library(glmnet)

cavernas_topografic=data.frame(read.csv("modelo_topografico_cavernas.csv",dec = ",", sep = ";"))

treino_cave_lasso=sample(1:nrow(cave_map_lasso), round(0.8*nrow(cave_map_lasso)))
dados_treino_cave_lasso=cave_map_lasso[treino_cave_lasso,]
dados_teste_cave_lasso=cave_map_lasso[-treino_cave_lasso,]

#convert training data to matrix format
x <- model.matrix(HAS_FIRE~.,dados_treino_cave_lasso)
#convert class to numerical variable
y <- ifelse(dados_treino_cave_lasso$HAS_FIRE==1,1,0)
#perform grid search to find optimal value of lambda
#family= binomial => logistic regression, alpha=1 => lasso
# check docs to explore other type.measure options
cv.out <- cv.glmnet(x,y,alpha=1)
#plot result
plot(cv.out)

#min value of lambda
lambda_min <- cv.out$lambda.min
#best value of lambda
lambda_1se <- cv.out$lambda.1se
#regression coefficients
coef(cv.out,s=lambda_1se)

#get test data
x_test <- model.matrix(HAS_FIRE~.,dados_teste_cave_lasso)
#predict class, type="class"
lasso_prob <- predict(cv.out,newx = x_test,s=lambda_1se,type="response")
#translate probabilities to predictions
lasso_predict <- rep(0,nrow(dados_teste_cave_lasso))
lasso_predict[lasso_prob>.5] <- 1
#confusion matrix
table(pred=lasso_predict,true=dados_teste_cave_lasso$HAS_FIRE)
#accuracy
mean(lasso_predict==dados_teste_cave_lasso$HAS_FIRE)
