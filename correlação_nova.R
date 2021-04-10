library(corrplot)
library("Hmisc")

arquivo_apa_leitura = "modelo_topográfico\\APA Cavernas\\matrix_topografic_cave.csv"

cavernas_mapa=data.frame(read.csv(arquivo_apa_leitura,dec = ",", sep = ";"))


flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}

cavernas_mapa_sem_fogo = cavernas_mapa[,2:8]
cavernas_mapa_sem_fogo[cavernas_mapa_sem_fogo<0]=0
res2<-rcorr(as.matrix(cavernas_mapa_sem_fogo))



corrplot(cor(cavernas_mapa_sem_fogo), method = "number", tl.col="black",
         col=colorRampPalette(c("black","black"))(200), cl.pos = "n")