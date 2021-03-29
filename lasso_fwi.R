
library(glmnet)
cavernas_fwi=data.frame(read.csv("cave_lasso_fwi.csv",dec = ",", sep = ";"))

treino_cave_fwi=sample(1:nrow(cavernas_fwi), round(0.8*nrow(cavernas_fwi)))
dados_treino_cave_fwi=cavernas_fwi[treino_cave_fwi,]
dados_teste_cave_fwi=cavernas_fwi[-treino_cave_fwi,]

#convert training data to matrix format
x <- model.matrix(HAS_FIRE~.,dados_treino_cave_fwi)
#convert class to numerical variable
y <- ifelse(dados_treino_cave_fwi$HAS_FIRE==1,1,0)
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
x_test <- model.matrix(HAS_FIRE~.,dados_teste_cave_fwi)
#predict class, type="class"
fwi_prob <- predict(cv.out,newx = x_test,s=lambda_1se,type="response")
#translate probabilities to predictions
fwi_predict <- rep(0,nrow(dados_teste_cave_fwi))
fwi_predict[lasso_prob>.5] <- 1
#confusion matrix
table(pred=fwi_predict,true=dados_teste_cave_fwi$HAS_FIRE)
#accuracy
mean(fwi_predict==dados_teste_cave_fwi$HAS_FIRE)
