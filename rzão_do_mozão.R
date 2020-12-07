#setando caminho do arquivo e lendo ele
setwd("C:\\Users\\Adams\\Desktop\\ERA5_2m_temp_2009_2018_Brazil")
frame_original = data.frame(read_csv("ERA5_2m_temp_2009_2018_Brazil.csv"))

#removendo as 3 últimas colunas
data_frame_sem_horario <- frame_original[1:(length(frame_original)-3)]
#convertendo pra celsius
data_frame_sem_horario <- data_frame_sem_horario - 273.15

####FAZER MEDIA POR PONTOS####

#separando por dia


chunk <- 24
n = nrow(data_frame_sem_horario)
r = rep(1:ceiling(n/chunk),each=chunk)[1:n]
d = split(data_frame_sem_horario,r)

#pegando os headers
cabeçalho = t(t(colnames(data_frame_sem_horario)))

#criando dataframe final
data_frame_final = data.frame(t(cabeçalho))
colnames(data_frame_final) = cabeçalho
data_frame_final = data_frame_final[-1,]

#iterando tudo e adicionando no dataframe
i=1
for(days in d){
  dayValues = c()
 
  for(point in days){
    dayValues = c(dayValues, max(point))
  }
  
  data_frame_temporario = data.frame(t(dayValues))
  nomeLinha = paste("Máxima do dia ", i)
  rownames(data_frame_temporario) = nomeLinha
  colnames(data_frame_temporario) = cabeçalho
  data_frame_final = rbind(data_frame_final, data_frame_temporario)
  i=i+1
}