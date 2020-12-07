library(cffdrs)
data("test_fwi")
head(test_fwi)
fwi.out1<-fwi(test_fwi)

fwi.out1$LONG<-120
fwi.out1$LAT<-60


ponto1<-as.data.frame(fwi.out1)
ponto2<-as.data.frame(fwi.out1)
ponto3<-as.data.frame(fwi.out1)
ponto4<-as.data.frame(fwi.out1)

ponto4<-ponto4[,c(-1,-2,-6,-7,-8,-9,-11,-12,-13,-14,-15,-16)]
ponto2<-ponto2[,c(-1,-2,-6,-7,-8,-9,-11,-12,-13,-14,-15,-16)]
ponto3<-ponto3[,c(-1,-2,-6,-7,-8,-9,-11,-12,-13,-14,-15,-16)]

ano<-ponto1[,c(-1,-2,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16)]

FFMC1<-as.data.frame(ponto4[4])
names(FFMC1)[names(FFMC1) == "FFMC"] <- "ponto1"
FFMC2<-as.data.frame(ponto2[4])
names(FFMC2)[names(FFMC2) == "FFMC"] <- "ponto2"
FFMC3<-as.data.frame(ponto3[4])
names(FFMC3)[names(FFMC3) == "FFMC"] <- "ponto3"

apa<-cbind(ponto1,ponto2,ponto3)

FFMC<-cbind(FFMC1,FFMC2,FFMC3,ano)

