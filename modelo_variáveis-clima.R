#teste regressão logística com variáveis climáticas e focos de incêndios

library(tibble)

dados_cavernas= data.frame(read.csv("cavernas_model-clima.csv", sep = ","))

dados_cavernas = as_tibble(dados_cavernas)

dados_cavernas$HAS_FIRE=as.factor(dados_cavernas$HAS_FIRE)

dados_cavernas$Focuses_qnt=as.numeric(dados_cavernas$Focuses_qnt)

dados_cavernas$HAS_FIRE=relevel(dados_cavernas$HAS_FIRE, "false")

#categorizando as variáveis numérias para torná-las fatores

library(data.table)
library(Publish)

dados_cavernas_categorizado=dados_cavernas[, temperature:=cut(temperature,9,include.lowest = TRUE)]
dados_cavernas_categorizado=dados_cavernas[,table(temperature)]

#criando amostras de treino e teste

index_treino_cave=sample(1:nrow(dados_cavernas), round(0.8*nrow(dados_cavernas)))

dados_treino_cave=dados_cavernas[index_treino_cave,]
dados_teste_cave=dados_cavernas[-index_treino_cave,]

t=table(dados_treino_cave$HAS_FIRE,dados_treino_cave$temperature)


barplot(t,xlab = "Mes", ylab = "Quantidade de focos", legend = rownames(t))

Queimou=dados_treino_cave[dados_treino_cave$HAS_FIRE=="true",]
Não_queimou=dados_treino_cave[dados_treino_cave$HAS_FIRE=="false",]

View(Queimou)

mean(Queimou$temperature)
mean(Queimou$Relative.Humidity)
mean(Queimou$precipitation)
mean(Queimou$Wind.speed)

mean(Não_queimou$temperature)
mean(Não_queimou$Relative.Humidity)
mean(Não_queimou$precipitation)
mean(Não_queimou$Wind.speed)



