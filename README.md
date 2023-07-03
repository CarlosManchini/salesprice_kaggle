## Modelagem do preço de venda de imóveis dos Estados Unidos
##### Objetiva-se ajustar um modelo linear generalizado (MLG) para descrever o preço de venda de residências (em doláres) através da relação com variáveis independentes. Os dados foram obtidos de um escritório de impostos na cidade de Ames - Estados Unidos. Para validação do modelo proposto, da distribuição gama assumida para a variável resposta e da função de ligação identidade utilizada foram realizados testes estatísticos, análises de diagnóstico e influência. Os resultados demonstraram bom comportamento dos resíduos, adequação da função de ligação e boa qualidade no ajuste do modelo. 

### 1. Introdução
A análise de preços de imóveis mostra-se de grande utilidade para gerar informações relevantes que definem a tomada de decisão. Além disso, é importante conhecer o potencial de venda do imóvel. 
O principal questionamento "Como e o que considerar para avaliar o valor de um imóvel?" pode ser melhor compreendido e quantificável através de um modelo estatístico. É possível explicar a relação do preço do imóvel com alguns fatores e analisar os mais influentes. Por exemplo, queremos saber se localização e/ou tamanho de uma casa estão fortemente relacionados com o preço da mesma. Podemos considerar inúmeras variáveis em um modelo estatístico e por meio de uma seleção, verificar o que for estatisticamente significante.

Um modelo estatístico objetiva de maneira geral, a representação da realidade de forma simplificada. Estamos em busca de descrever algum fenômeno ou evento de interesse denominado variável resposta/dependente $Y$ em função de um conjunto de variáveis explicativas/independentes $X_i$,  seja para tomada de decisão, previsão ou explicação. Com isso, o efeito de $X_i$ sobre $Y$ pode ser expresso através de um modelo matemático. A escolha do modelo adequado se dá pela avaliação do modo como $X_i$ se relaciona com $Y$, da natureza dos dados, das variáveis, de pressuposições e de um diagnóstico confirmatório.

Quando a média de uma distribuição estatística não é constante, ou seja, quando o comportamento da variável de interesse é influenciada por outras variáveis, comumente utiliza-se modelos de regressão. Em particular, a regressão linear é amplamente utilizada sob condição de normalidade da variável resposta. O não cumprimento deste requisito, possibilita o uso de uma classe de modelos mais ampla e flexível, se $Y$ pertencer à família de distribuições exponencial: os modelos lineares generalizados (MLGs). 
A flexibilidade dos MLGs se dá pela relação funcional entre a média de $Y$ e o preditor linear $\eta$ que pode ser arbitrado pela função de ligação garantindo que a média da variável não tenha valores fora do seu espaço paramétrico. Outra vantagem seria a diversidade de distribuições que estão inclusas à família exponencial como normal, binomial, exponencial, Poisson, gama e normal inversa, gerando mais opções para a distribuição da variável resposta.

### 2. Modelo Linear Generalizado


Uma etapa fundamental em uma modelagem de dados é a análise de diagnóstico e qualidade de ajuste do modelo. Verificamos possíveis afastamentos das suposições feitas para o modelo, ou seja, a adequação da distribuição proposta para a variável resposta ou da função de ligação. Com a análise de influência procura-se potenciais valores discrepantes presentes nos dados. 


