data("test_fwi")
head(test_fwi)
fwi.out1<-fwi(test_fwi)

fwi.out1$LONG<-80
fwi.out1$LAT<-30

pontoA<-as.data.frame(fwi.out1)
pontoB<-as.data.frame(fwi.out1)
pontoC<-as.data.frame(fwi.out1)
Data<-pontoA[,3:5]

FMC1<-data.frame(Data)
DMC1<-data.frame(Data)
DC1<-data.frame(Data)

lista<-list(pontoA,pontoB,pontoC)

for (ponto in lista) {
  FMC<-ponto['FFMC']
  FMC1<-cbind(FMC,FMC1)
  DMC<-ponto['DMC']
  DMC1<-cbind(DMC,DMC1)
  DC<-ponto['DC']
  DC1<-cbind(DC,DC1)
}
binomial()