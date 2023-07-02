y<-read.csv("sample_submission.csv",sep=",",h=T)

covs<-read.csv("XXXXtest.csv",sep = ",",h=T)

data<-data.frame(y,covs)
dataS<-data.frame(y,covs[,-1])
attach(dataS)

newdata<-data.frame(SalePrice,LotArea,OverallQual,YearBuilt,BsmtQual,BsmtFinSF1,
                    GrLivArea,Fireplaces,GarageArea,FullBath,KitchenQual,Neighborhood,OpenPorchSF,OverallCond,TotalBsmtSF) #,,CentralAir,LotFrontage,

dataa<-na.exclude(newdata)
attach(dataa)

#escolha da distribuição é feita com base na natureza dos dados e pelo seu intervalo de variação
# avaliando a variavel dependente dados continuos limitados aos reais positivos e a 

#método visual para verificacao de normalidade é o qqplot
#assimetria a direita.
library(ggpubr)
ggqqplot(SalePrice, xlab = "Theoretical Quantiles", ylab="Sample Quantiles")

#NORMALIDADE again
#teste de KS para comprovar a nao normalidade dos dados.
a<-mean(SalePrice) ; b<-sd(SalePrice)
x<-rnorm(length(SalePrice),mean=a,sd=b)
ks.test(x,SalePrice)

#incluir o shapiro
shapiro.test(SalePrice)
# hipótese nula destes testes é que "a distribuição da amostra é normal". Se o teste for significativo , a distribuição não é normal.

fit1<-glm(SalePrice~.,data=dataa,family = Gamma) ; summary(fit1)

library(hnp)
library(varhandle)
porao<-to.dummy(dataa$BsmtQual," ")
poraoEX<-porao[,1]
poraoFA<-porao[,2]
poraoGD<-porao[,3]
poraoTA<-porao[,4]

kitchen<-to.dummy(dataa$KitchenQual," ")
kitEX<-kitchen[,1]
kitFA<-kitchen[,2]
kitGD<-kitchen[,3]
kitTA<-kitchen[,4]

# air<-to.dummy(dataa$CentralAir," ")
# airY<-air[,1]
# airN<-air[,2]

bairros<-to.dummy(dataa$Neighborhood," ")
bairroNorthAmes<-bairros[,13]

source("pseudo_R2_cont.r")

fit2<-glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoFA+poraoGD+TotalBsmtSF+
            BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+
            TotalBsmtSF+FullBath+kitEX+kitFA+kitGD+OpenPorchSF+OverallCond+bairros[,19]+bairros[,6]+bairros[,13], data=dataa,family = Gamma(link = "identity")) ; summary(fit2) ; pseudo_R2(fit2) ; hnp(fit2,halfnormal = F,conf = 0.9) ;

stepfit2<-glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoGD+
                BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+
                FullBath+kitEX+kitFA+kitGD+OpenPorchSF+OverallCond+bairros[,13], data=dataa,family=Gamma(link="identity")) ; summary(stepfit2) ; hnp(stepfit2,halfnormal = F,conf = 0.9) ; pseudo_R2(stepfit2)
#

fit3<-glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoFA+poraoGD+
            BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+GarageCars+X1stFlrSF+LotFrontage+
            TotalBsmtSF+FullBath+kitEX+kitFA+kitGD+OpenPorchSF+OverallCond, data=dataa,family = Gamma(link = "log")) ; summary(fit3) ; hnp(fit3,halfnormal = F,conf = 0.9) ; pseudo_R2(fit3)

stepfit3<-glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoGD+
                BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+X1stFlrSF+LotFrontage+
                FullBath+kitFA+kitGD, data=dataa,family = Gamma(link = "identity")) ; summary(stepfit3) ; hnp(stepfit3,halfnormal = F,conf = 0.9) ; pseudo_R2(stepfit3)

######################################################################################
#teste RESET
eta.hat<-(stepfit2$linear.predictors)^2
verfify.linkA <- glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoGD+
                   BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+
                   FullBath+kitGD+bairros[,13]+bairros[,16]+eta.hat, data=dataa,family = Gamma(link = "identity"))
summary(verfify.linkA) #eta.hat nao significativo = modelo corretamente especificado

###

finally <- glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoGD+
                       BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+
                       FullBath+kitGD+bairroNorthAmes+bairros[,16], data=dataa,family = Gamma(link = "identity"))
summary(finally) ; pseudo_R2(finally) ; hnp(finally,halfnormal=F,conf=0.90)
######################################################################################

n<-length(SalePrice)
# verificacao do ajuste do modelo
D = deviance(finally) # desvio
gl = n - finally$rank # graus de liberdade
pvalor = 1-pchisq(D,gl) # nivel descritivo
pvalor
# se o nivel descritivo for maior que alfa entao o modelo esta adequado
##teste do desvio diz q teste esta OK!


#ANALISE DE DIAGNOSTICO
# residuos
td = resid(finally,type="deviance") # residuos componente do desvio (melhor)
abline(plot(td), lty=c(2,2,3), h=c(-2,2,0))# residuos comp desvio vs indices 
abline(plot(fitted(finally),td) , lty=c(2,2,3), h=c(-2,2,0))# resid comp desvio vs ajustado (bom grafico, tem que estar entre as linhas)
identify(fitted(finally),td,n=5)

# Alavancagem
# alavancagem vs valores ajustados
plot(fitted(finally),hatvalues(finally),ylab=expression("Alavancagem"),pch=20,xlab = expression("Valores Ajustados"))
identify(fitted(finally),hatvalues(finally), n=5) # identifica 3 valores no grafico

# distancia de Cook
# cook vs valores ajustados
plot(fitted(finally),cooks.distance(finally),ylab="Distancia de Cook",xlab = expression("Valores Ajustados"),pch=20)
identify(fitted(finally),cooks.distance(finally), n=4) # identifica 3 valores no grafico


# DFFIT
limite<-3*sqrt(finally$rank / n)
abline(plot(dffits(finally),ylab=expression("DFFITS"),xlab = expression("Observation"),pch=20), h=limite,lty=2)
identify(dffits(finally), n=4) # identifica 3 valores no grafico


#RETIRANDO OUTLIERS

DATAA<-dataa[c(-894,-765,-647,-1057),]
attach(DATAA)

porao<-to.dummy(DATAA$BsmtQual," ")
poraoEX<-porao[,1]
poraoFA<-porao[,2]
poraoGD<-porao[,3]
poraoTA<-porao[,4]

kitchen<-to.dummy(DATAA$KitchenQual," ")
kitEX<-kitchen[,1]
kitFA<-kitchen[,2]
kitGD<-kitchen[,3]
kitTA<-kitchen[,4]

bairros<-to.dummy(DATAA$Neighborhood," ")
bairroNorthAmes<-bairros[,13]
bairroNridgHt<-bairros[,16]
#bairroCrawfor<-bairros[,7]

stepfuckfit2<-glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoGD+
                BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+
                FullBath+kitEX+kitFA+kitGD+OpenPorchSF+OverallCond+bairroNorthAmes, data=DATAA,family=Gamma(link="identity")) ; summary(stepfuckfit2) ; hnp(stepfuckfit2,halfnormal = F,conf = 0.9) ; pseudo_R2(stepfuckfit2)

####################################################################################
FITzera<-glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoGD+
      BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+
      FullBath+kitGD+bairroNorthAmes+bairros[,16],data=DATAA,family = Gamma(link = "identity")) #(link = "inverse")
summary(FITzera) ; pseudo_R2(FITzera) ; hnp(FITzera,halfnormal=F,conf = 0.90)
####################################################################################
source("envelope_gama.r")
envelope.gama(FITzera)

#RESET
eta.hat<-(stepfuckfit2$linear.predictors)^2
VERIF<-glm(SalePrice~LotArea+OverallQual+YearBuilt+poraoEX+poraoGD+
             BsmtFinSF1+GrLivArea+Fireplaces+GarageArea+
             FullBath+kitGD+bairroNorthAmes+bairros[,16]+eta.hat,data=DATAA,family = Gamma(link = "identity"))
summary(VERIF) ; resettest(FITzera)


n<-length(SalePrice)
# verificacao do ajuste do modelo
D = deviance(FITzera) # desvio
gl = n - FITzera # graus de liberdade
pvalor = 1-pchisq(D,gl) # nivel descritivo
pvalor
# se o nivel descritivo > alfa entao o modelo esta adequado
##teste do desvio diz q teste esta OK!


#ANALISE DE DIAGNOSTICO
# residuos
td = resid(FITzera,type="deviance") # residuos componente do desvio (melhor)
abline(plot(td), lty=c(2,2,3), h=c(-2,2,0))# residuos comp desvio vs indices 
abline(plot(fitted(FITzera),td) , lty=c(2,2,3), h=c(-2,2,0))# resid comp desvio vs ajustado 
identify(fitted(FITzera),td,n=5)

# Alavancagem
# alavancagem vs valores ajustados
plot(fitted(FITzera),hatvalues(FITzera),ylab="Alavancagem")
identify(fitted(FITzera),hatvalues(FITzera), n=5) # identifica 3 valores no grafico

# DFFIT
limite<-3*sqrt(FITzera$rank / n)
abline(plot(dffits(FITzera),ylab=expression("DFFITS"),xlab = expression("Observation"),pch=20), h=limite,lty=2)

# distancia de Cook
# cook vs valores ajustados
plot(fitted(FITzera),cooks.distance(FITzera),ylab="Distancia de Cook")
identify(fitted(FITzera),cooks.distance(FITzera), n=4) # identifica 3 valores no grafico


#Modelo mais simples, melhor CxB
s1mple<-glm(SalePrice~LotArea+OverallQual+GrLivArea+Fireplaces+BsmtFinSF1+FullBath+GarageArea, #yearbuilt, poraoGD+bsmtfinsf1
               family = Gamma(link="identity"),data=DATAA)
summary(s1mple) ; pseudo_R2(s1mple)  #hnp(s1mple, halfnormal=F, conf=0.99)


 eta.hat<-(s1mple$linear.predictors)^2
 VERIF<-glm(SalePrice~LotArea+GrLivArea+Fireplaces+OverallQual+BsmtFinSF1+GarageArea+FullBath+eta.hat, #yearbuilt, poraoGD+bsmtfinsf1
            family = Gamma(link="identity"),data=DATAA)
 summary(VERIF) ; 


library(aod)
wald.test(b=coef(s1mple),Sigma=vcov(s1mple),Terms = 1) #1:8

library(lmtest)
resettest(s1mple)


# verificacao do ajuste do modelo
D = deviance(s1mple) # desvio
gl = length(SalePrice) - s1mple$rank # graus de liberdade
pvalor = 1-pchisq(D,gl) # nivel descritivo
pvalor
# se o nivel descritivo( PVALOR) for maior que alfa entao o modelo esta adequado
##teste do desvio diz q teste esta OK!
