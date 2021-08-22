library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)
library(car)
library(multcomp)

#https://statsandr.com/blog/anova-in-r/

arquivo = read.csv("completo.csv",
                   header=TRUE, sep = ";",
                   colClasses = c("factor", "numeric","numeric","numeric","numeric", "factor"))
#RODANDO ANOVA
result = aov(CO ~ Localização, data = arquivo)
summary(result)

#PLOTANDO RESIDUOS
par(mfrow = c(1, 2)) # combine plots
hist(result$residuals)
qqPlot(result$residuals,id = FALSE)
par(1)
#TESTE DE SHAPIRO
shapiro.test(result$residuals)
#TESTE DE LEVENE
leveneTest(CO ~ Localização,data = arquivo)
#TUKEY TEST
plot(TukeyHSD(result))
