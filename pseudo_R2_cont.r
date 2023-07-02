## Funcao que calcula o pseudo R^2 de Nagelkerke (1991).
## Trata-se de uma medida de qualidade de ajuste para modelos mais gerais.
## Essa medida eh uma generalizacao do R^2 (coeficiente de determinacao)
## do modelo de regressao linear normal para modelos gerais.
##
## Escrito por: Fabio M. Bayer

pseudo_R2<-function(model)
{
  y<-(model$model)[,1]
  n<-length(y)
  
  null<-glm(y~+1,family=model$family)
  l_fit<- logLik(model)[1]
  l_null<-logLik(null)[1]
  
  R2<- 1-exp((-2/n)*(l_fit-l_null))
  
  #maxR2<-1-exp(2*l_null/n)
  
  #R2<-R2/maxR2
    
  print(c("pseudo R2 =",round(R2,3)),quote=F)
  
  #return(R2)
  
}


