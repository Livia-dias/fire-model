library("Hmisc")

cavernas_mapa=data.frame(read.csv("model_topografic_cave.csv",dec = ",",sep = ";"))
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}

cavernas_mapa_sem_data = cavernas_mapa[,5:11]
which(is.na(cavernas_mapa_sem_data))
cavernas_mapa_sem_data[cavernas_mapa_sem_data<0]=0
res2<-rcorr(as.matrix(cavernas_mapa_sem_data))
View(flattenCorrMatrix(res2$r, res2$P))


library(corrplot)

corrplot(cor(cavernas_mapa_sem_data), method = "number", tl.col="black",
         col=colorRampPalette(c("black","black"))(200), cl.pos = "n")


corrplot(res2$r, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)


#relacoes insignificantes sao deixadas em branco
corrplot(res2$r, type="upper", order="hclust", 
         p.mat = res2$P, sig.level = 0.01, insig = "blank")


library("metan")

maize <- cavernas_mapa_sem_data
numeric_var <- maize %>% select_numeric_cols()
datacor <- maize %>% select_cols(elev_cave, slope_cave, NDVI_cave, hidro_dist, road_dista, censo_cave, Classe_cav)

pairs(datacor)
corr <- corr_coef(datacor)
print(corr)

corr_plot(datacor)

maize %>%
corr_plot(elev_cave,slope_cave,NDVI_cave,hidro_dist,road_dista,censo_cave,Classe_cav,
         shape.point = 19,
         size.point = 2,
         alpha.point = 0.5,
         alpha.diag = 0,
         pan.spacing = 0,
         col.sign = "gray",
         alpha.sign = 0.3,
         axis.labels = TRUE,
         progress = FALSE)
