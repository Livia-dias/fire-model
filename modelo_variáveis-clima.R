#teste regress�o log�stica com vari�veis clim�ticas e focos de inc�ndios




#gera intervalo de valores a partir de min e max de uma coluna, incrementando pelo valor de "interval"
#Exemplo: get_interval(col, 10) ir� incrementar o minimo de 10 em 10 at� atingir o m�ximo, e ir� devolver o intervalo gerado
get_interval = function(column, interval){
  
  minimum = floor(min(column))
  maximum = ceiling(max(column))
  
  final_list = c()
  current = minimum
  while(current < maximum){
    final_list = c(final_list, current)
    current = current + interval
  }
  final_list = c(final_list, current)
  return(final_list)
}

#gera intervalo de valores a partir de min e max de uma coluna, com a quantidade de valores definidos em "quantity".
#Exemplo: get_interval_from_quantity(col, 10) ir� gerar 10 intervalos entre o min e o m�x da coluna
get_interval_from_quantity = function(column, quantity) {
  minimum = floor(min(column))
  maximum = ceiling(max(column))
  
  final_list = c()
  increment = (maximum - minimum)/quantity
  current = minimum
  while(current < maximum){
    final_list = c(final_list, current)
    current = current + increment
  }
  final_list = c(final_list, current)
  return(final_list)
  
}

create_data = function(dataframe) {
  library(tibble)
  library(data.table)
  library(Publish)
  
  data_tibble = as_tibble(dataframe)
  
  #gerando categorias de cada vari�vel:
  #temperatura: incrementando de 2 em 2 graus de min at� o max da coluna
  #rh: gerando 10 intervalos iguais entre o min e o max
  #velocidade do vento: incrementando de 2 em 2 m/s de min at� o max da coluna
  #precipita��o: incrementando de 10 em 10 milimetros de min at� o max da coluna
  setDT(data_tibble)
  temp_cat = cut(data_tibble$temperature,
                 get_interval_from_quantity(data_tibble$temperature, 10),
                 include.lowest=TRUE)
  rh_cat = cut(data_tibble$Relative.Humidity,
               get_interval_from_quantity(data_tibble$Relative.Humidity, 10),
               include.lowest=TRUE)
  ws_cat = cut(data_tibble$Wind.speed,
               get_interval_from_quantity(data_tibble$Wind.speed, 10),
               include.lowest=TRUE)
  prec_cat = cut(data_tibble$precipitation,
                 get_interval_from_quantity(data_tibble$precipitation, 10),
                 include.lowest=TRUE)
  dados_out = data.frame(data_tibble, temp_cat,rh_cat,ws_cat,prec_cat)
  
  return(dados_out)
}

dados_cavernas= data.frame(read.csv("cavernas_model-clima.csv", sep = ","))
cavernas_categorizado= create_data(dados_cavernas)

dados_pandeiros= data.frame(read.csv("pandeiros_model-clima.csv", sep = ","))
pandeiros_categorizado= create_data(dados_pandeiros)

dados_cocha= data.frame(read.csv("cocha_model-clima.csv", sep = ","))
cocha_categorizado= create_data(dados_cocha)

#arrumando valores e fatores


tibble_variaveis= function(apa_categorizada){
  data_tibble = as_tibble(apa_categorizada) 
  data_tibble$HAS_FIRE=as.factor(data_tibble$HAS_FIRE)
  data_tibble$Focuses_qnt=as.numeric(data_tibble$Focuses_qnt)
  levels(data_tibble$HAS_FIRE)=c("not-burned","burned") 
  data_tibble$HAS_FIRE=relevel(data_tibble$HAS_FIRE, "not-burned")
  
  return(data_tibble)
}

#apa cavernas - amostras
tibble_cavernas=tibble_variaveis(cavernas_categorizado)



#criando index de treino e dados de treino e teste
index_treino_cavernas=sample(1:nrow(tibble_cavernas), round(0.8*nrow(tibble_cavernas)))
dados_treino_cavernas=tibble_cavernas[index_treino_cavernas,]
dados_teste_cavernas=tibble_cavernas[-index_treino_cavernas,]

table(dados_treino_cavernas$HAS_FIRE,dados_treino_cavernas$rh_cat)
table(dados_treino_cavernas$HAS_FIRE,dados_treino_cavernas$temp_cat)
table(dados_treino_cavernas$HAS_FIRE,dados_treino_cavernas$ws_cat)
table(dados_treino_cavernas$HAS_FIRE,dados_treino_cavernas$prec_cat)


#apa cocha - amostras
tibble_cocha=tibble_variaveis(cocha_categorizado)

index_treino_cocha=sample(1:nrow(tibble_cocha), round(0.8*nrow(tibble_cocha)))
dados_treino_cocha=tibble_cocha[index_treino_cocha,]
dados_teste_cocha=tibble_cocha[-index_treino_cocha,]



#apa pandeiros - amostras
tibble_pandeiros=tibble_variaveis(pandeiros_categorizado)

index_treino_pandeiros=sample(1:nrow(tibble_pandeiros), round(0.8*nrow(tibble_pandeiros)))
dados_treino_pandeiros=tibble_pandeiros[index_treino_pandeiros,]
dados_teste_pandeiros=tibble_pandeiros[-index_treino_pandeiros,]



#rodando o modelo regress�o logistica
#vari�veis categ�ricas

model1=glm(HAS_FIRE~temp_cat+rh_cat+prec_cat+ws_cat,data = dados_treino_cavernas,family = binomial())

summary(model1)

odds_teste=exp(coef(model1))

#vari�veis num�ricas amostra de treino
#modelo com precipita��o
model2=glm(HAS_FIRE~temperature+Relative.Humidity+precipitation+Wind.speed,data = dados_treino_cavernas,family = binomial())

summary(model2)

#modelo sem precipita��o
model_cavernas=glm(HAS_FIRE~temperature+Relative.Humidity+Wind.speed,data = dados_treino_cavernas,family = binomial())

summary(model_cavernas)

#vari�veis num�ricas amostra de teste-cavernas - rodando o modelo

pred.Teste=predict(model_cavernas,dados_teste_cavernas,type = "response")
View(pred.Teste)

dados_teste_cavernas$Prob_fogo=pred.Teste

View(dados_teste_cavernas[,c("HAS_FIRE","Prob_fogo")])

#rodando modelo para apa cocha
model_cocha=glm(HAS_FIRE~-1+temperature+Relative.Humidity+Wind.speed,data = dados_treino_cocha,family = binomial())

summary(model_cocha)

pred.Cocha=predict(model_cocha,dados_teste_cocha,type = "response")
View(pred.Cocha)

dados_teste_cocha$Prob_fogo=pred.Cocha

View(dados_teste_cocha[,c("HAS_FIRE","Prob_fogo")])

table(dados_teste_cocha$HAS_FIRE,dados_teste_cocha$Prob_fogo>0.5)

#rodando modelo para apa pandeiros
model_pandeiros=glm(HAS_FIRE~-1+temperature+Relative.Humidity+Wind.speed,data = dados_treino_pandeiros,family = binomial())

summary(model_pandeiros)

pred.Pandeiros=predict(model_pandeiros,dados_teste_pandeiros,type = "response")
View(pred.Pandeiros)

dados_teste_pandeiros$Prob_fogo=pred.Pandeiros

View(dados_teste_pandeiros[,c("HAS_FIRE","Prob_fogo")])

table(dados_teste_pandeiros$HAS_FIRE,dados_teste_pandeiros$Prob_fogo>0.5)



