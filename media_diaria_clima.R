library(readr)
library(rlist)

#conversão da temperatura de kelvin para celsius
temp1999_2019= data.frame(read.csv("temperature1999_2019.csv", sep = ";"))
temperatura_sem_data<-temp1999_2019[1:(length(temp1999_2019)-2)]-273.15
temp1999_2019[1:24]=temperatura_sem_data

#chamando .csv
RH1999_2019= data.frame(read.csv("RH_1999_2019.csv", sep = ";"))
prec1999_2019= data.frame(read.csv("precip_1999_2019.csv", sep = ";", dec = ","))
wind1999_2019= data.frame(read.csv("Wind_1999_2019.csv", sep = ";"))

prec1999_2019[prec1999_2019<0]=0


#media de 1 dia, 24 linhas=1 dia
mean_days = function(dataframe_1day){
  hours_per_day <- 24
  n_rows = nrow(dataframe_1day)
  day = rep(1:ceiling(n_rows/hours_per_day),each=hours_per_day)[1:n_rows]
  days_list = split(dataframe_1day,day)
  
  
  means = data.frame()
  for(day in days_list){
    means = rbind(means, colMeans(day))
  }
  names(means) = names(dataframe_1day)
  return(means)
}

sum_days = function(dataframe_1day){
  hours_per_day <- 24
  n_rows = nrow(dataframe_1day)
  day = rep(1:ceiling(n_rows/hours_per_day),each=hours_per_day)[1:n_rows]
  days_list = split(dataframe_1day,day)

  sum = data.frame()
  for(day in days_list){
    sum = rbind(sum, colSums(day[,1:24]))
  }
  
  return(sum)
}

temp1999_2019_per_day=mean_days(temp1999_2019)
RH1999_2019_per_day=mean_days(RH1999_2019)
wind1999_2019_per_day=mean_days(wind1999_2019)
prec1999_2019_per_day=sum_days(prec1999_2019)
prec1999_2019_per_day=data.frame(prec1999_2019_per_day, wind1999_2019_per_day[,25:26])
names(prec1999_2019_per_day)=names(wind1999_2019_per_day)
prec1999_2019_per_day[prec1999_2019_per_day<0]=0

write.csv(temp1999_2019_per_day, "temp1999_2019_per_day.csv", row.names = FALSE)
write.csv(RH1999_2019_per_day, "RH1999_2019_per_day.csv", row.names = FALSE)
write.csv(wind1999_2019_per_day, "WS1999_2019_per_day.csv", row.names = FALSE)
write.csv(prec1999_2019_per_day, "prec1999_2019_per_day.csv", row.names = FALSE)
