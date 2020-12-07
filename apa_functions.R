APA_CAVERNAS = c(5,13,14,15,19,20,21,22)
APA_COCHA = c(5,6,7,8,9,10,11,12,13,14,16,17,18,19)
APA_PANDEIROS = c(13,17,18,19,20,23,24,25,26,27,28)
APA_NAMES = c("APACP","APACG","APARP")
KELVIN_TO_CELSIUS = -273.15


readDataFrameNoDates = function(filePath) {
  library(readr)
  originalFrame = data.frame(read_csv(filePath))
  frameWithoutDate<-originalFrame[1:(length(originalFrame)-3)]
  frameWithoutDate<-frameWithoutDate[order(sprintf("%*s", max(nchar(names(frameWithoutDate))), names(frameWithoutDate)))]
  return(frameWithoutDate)
}

readDataFrameWithDates = function(filePath) {
  library(readr)
  originalFrame = data.frame(read_csv(filePath))
  frameWithDate<-originalFrame[order(sprintf("%*s", max(nchar(names(originalFrame))), names(originalFrame)))]
  id = as.integer((as.numeric(rownames(originalFrame))-1)/24)+1
  frameWithDate = cbind(day=id, frameWithDate)
  return(frameWithDate)
}

splitApas = function(dataFrame, columns, conversion=0){
  return(dataFrame[, columns]+conversion)
}

splitInApas = function(dataframe, conversion=0){
  cavernas = splitApas(tempWithDates, APA_CAVERNAS, conversion)
  cocha = splitApas(tempWithDates, APA_COCHA, conversion)
  pandeiros = splitApas(tempWithDates, APA_PANDEIROS, conversion)
  returnList = list(cavernas, cocha, pandeiros)
  names(returnList) = APA_NAMES
  return(returnList)
}

splitFrameByPeriod = function(dataFrame, interval="day"){
  library(rlist)
  library(lubridate)
  startingDate = ymd_hms("2009-01-01 00:00:00")
  endingDate = ymd_hms("2018-12-31 00:00:00")+days(1)
  splittingFunction = days(1)
  switch(interval,
         "year"= {
           splittingFunction = years(1)
         },"month"={
           splittingFunction = months(1)
         })
  intervalAmount = interval(startingDate, endingDate)/splittingFunction
  
  n_rows = nrow(dataFrame)
  rowsPerInterval = n_rows/intervalAmount
  section = rep(1:ceiling(n_rows/rowsPerInterval),each=rowsPerInterval)[1:n_rows]
  frameList = split(dataFrame,section)
  return(frameList)
}

splitListByPeriod = function(listToSplit, interval="day"){
  library(rlist)
  library(lubridate)
  startingDate = ymd_hms("2009-01-01 00:00:00")
  endingDate = ymd_hms("2018-12-31 00:00:00")+days(1)
  splittingFunction = days(1)
  switch(interval,
         "year"= {
           splittingFunction = years(1)
         },"month"={
           splittingFunction = months(1)
         })
  while()
    
    n_rows = length(listToSplit)
  rowsPerInterval = n_rows/intervalAmount
  section = rep(1:ceiling(n_rows/rowsPerInterval),each=rowsPerInterval)[1:n_rows]
  frameList = split(listToSplit,section)
  return(frameList)
}

#aplica FUN em cada linha de cada dataframe
joinColumnsOfDataframeByFunction = function(listOfDataframes, FUN){
  library(rlist)
  listOfFrames = list()
  for(dataFrame in listOfDataframes){
    calculatedValue = FUN(dataFrame)
    listOfFrames = list.append(listOfFrames, calculatedValue)
  }
  return(listOfFrames)
}


calculateByRow = function(listOfValues, FUN){
  returnList = list()
  for(listOfValue in listOfValues) {
    splitted = splitListByPeriod(listOfValue, interval = "month")
    for(period in splitted){
      returnList = list.append(returnList, FUN(period))
    }
  }
  return(returnList)
}

tempWithDates = readDataFrameWithDates("ERA5_2m_temp_2009_2018_Brazil.csv")
listApas = splitInApas(tempWithDates, KELVIN_TO_CELSIUS)
aggregated = joinColumnsOfDataframeByFunction(listApas, rowMeans)
output = calculateByRow(aggregated, max)