#gera intervalo de valores a partir de min e max de uma coluna, incrementando pelo valor de "interval"
#Exemplo: get_interval(col, 10) irá incrementar o minimo de 10 em 10 até atingir o máximo, e irá devolver o intervalo gerado
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
#Exemplo: get_interval_from_quantity(col, 10) irá gerar 10 intervalos entre o min e o máx da coluna
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
  
  #gerando categorias de cada variável:
  #temperatura: incrementando de 2 em 2 graus de min até o max da coluna
  #rh: gerando 10 intervalos iguais entre o min e o max
  #velocidade do vento: incrementando de 2 em 2 m/s de min até o max da coluna
  #precipitação: incrementando de 10 em 10 milimetros de min até o max da coluna
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





