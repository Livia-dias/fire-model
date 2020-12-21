library(readr)
library(rlist)

#conversão da temperatura de kelvin para celsius
temp1999_2019= data.frame(read.csv("temperature1999_2019.csv", sep = ";"))
temperatura_sem_data<-temp1999_2019[1:(length(temp1999_2019)-2)]-273.15
temp1999_2019[1:24]=temperatura_sem_data

#media de 1 dia, 24 linhas=1 dia

hours_per_day <- 24
n_rows = nrow(temp1999_2019)
day = rep(1:ceiling(n_rows/hours_per_day),each=hours_per_day)[1:n_rows]
days_list = split(temp1999_2019,day)

mean()