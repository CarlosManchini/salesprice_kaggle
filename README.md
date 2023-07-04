## Modelagem do preço de venda de imóveis dos Estados Unidos
##### Objetiva-se ajustar um modelo linear generalizado (MLG) para descrever o preço de venda de residências (em doláres) através da relação com variáveis independentes. Os dados foram obtidos do [Kaggle](https://www.kaggle.com/) de um escritório de impostos na cidade de Ames - Estados Unidos. Para validação do modelo proposto, da distribuição gama assumida para a variável resposta e da função de ligação identidade utilizada foram realizados testes estatísticos, análises de diagnóstico e influência. Os resultados demonstraram bom comportamento dos resíduos, adequação da função de ligação e boa qualidade no ajuste do modelo. 

### 1. Introdução
A análise de preços de imóveis mostra-se de grande utilidade para gerar informações relevantes que definem a tomada de decisão. Além disso, é importante conhecer o potencial de venda do imóvel. 
O principal questionamento "Como e o que considerar para avaliar o valor de um imóvel?" pode ser melhor compreendido e quantificável através de um modelo estatístico. É possível explicar a relação do preço do imóvel com alguns fatores e analisar os mais influentes. Por exemplo, queremos saber se localização e/ou tamanho de uma casa estão fortemente relacionados com o preço da mesma. Podemos considerar inúmeras variáveis em um modelo estatístico e por meio de uma seleção, verificar o que for estatisticamente significante.

Um modelo estatístico objetiva de maneira geral, a representação da realidade de forma simplificada. Estamos em busca de descrever algum fenômeno ou evento de interesse denominado variável resposta/dependente $Y$ em função de um conjunto de variáveis explicativas/independentes $X_i$,  seja para tomada de decisão, previsão ou explicação. Com isso, o efeito de $X_i$ sobre $Y$ pode ser expresso através de um modelo matemático. A escolha do modelo adequado se dá pela avaliação do modo como $X_i$ se relaciona com $Y$, da natureza dos dados, das variáveis, de pressuposições e de um diagnóstico confirmatório.

Quando a média de uma distribuição estatística não é constante, ou seja, quando o comportamento da variável de interesse é influenciada por outras variáveis, comumente utiliza-se modelos de regressão. Em particular, a regressão linear é amplamente utilizada sob condição de normalidade da variável resposta. O não cumprimento deste requisito, possibilita o uso de uma classe de modelos mais ampla e flexível, se $Y$ pertencer à família de distribuições exponencial: os modelos lineares generalizados (MLGs). 
Conforme Paula (2013), a flexibilidade dos MLGs se dá pela relação funcional entre a média de $Y$ e o preditor linear $\eta$ que pode ser arbitrado pela função de ligação garantindo que a média da variável não tenha valores fora do seu espaço paramétrico. Outra vantagem seria a diversidade de distribuições que estão inclusas à família exponencial como normal, binomial, exponencial, Poisson, gama e normal inversa, gerando mais opções para a distribuição da variável resposta.

### 2. Modelo Linear Generalizado

Os MLGs são compostos por:
1. Componente aleatório, representado por um conjunto de variáveis aleatórias independentes  $Y_1, ..., Y_n$, as quais provém de uma distribuição pertence à família exponencial na forma canônica com médias: $E(Y_i)= \mu_i$, ~ $i=1,2, ..., n$ ;
2. Componente sistemático, constituído da soma linear dos efeitos de variáveis independentes: $\eta_i= \mathbf{x_i^T \beta}$;
3. Função de ligação $g(\cdot)$, que relaciona os dois itens citados acima, ou seja, a média de $Y$ com $\eta_i$ o preditor linear: $g(\mu_i)=\eta_i$.

 
Portanto, consideramos uma estrutura de regressão para representar os MLGs:

$$ \eta_i = \sum^k_{j=1}  X_{ij} \beta_j = g(\mu_i),$$

em que $g(\cdot)$ é uma função de ligação, $\mathbf{\beta_j}$ são os parâmetros do modelo, $\mathbf{X_j}$ são as covariáveis e $\mathbf{\eta}$ é o preditor linear. É importante declarar que há vantagens se a função de ligação for escolhida de tal forma que $g(\mu_i)=\theta_i=\eta_i$, o preditor linear modela diretamente o parâmetro canônico $\theta_i$, e é chamada de função de ligação canônica.

A seleção de modelos é deve ser realizada de tal forma que o modelo seja simples e que explique bem a relação entre as variáveis explicativas e a resposta, ou seja, um modelo parcimonioso. As três principais escolhas para realizar um MLG são: A definição da distribuição da variável resposta $Y$ seguida pela matriz de regressores do modelo $X$ e por fim a escolha da função de ligação. Há procedimentos  que auxiliam a seleção de modelos de regressão por meio de critérios de seleção.

A estimação dos parâmetros do modelo pode ser realizada por vários métodos. Os estimadores de máxima verossimilhança são amplamente utilizados na literatura. Cordeiro e Demétrio (2013) reafirmam que o mesmo possui ótimas propriedades, como consistência e eficiência assintótica.
Quando não há uma solução fechada para os estimadores são considerados métodos numéricos como o de Newton-Raphson para obtenção da estimativa de máxima verossimilhança.

Após a seleção e estimação do modelo são realizados vários procedimentos para: verificar a adequabilidade de suposições como a distribuição assumida para $Y$ e a função de ligação, qualidade do ajuste em termos de variabilidade, encontrar observações influentes assim como discrepâncias entre o modelo ajustado e os dados. Esses processos pertencem a análise de diagnóstico e influência, 
onde é verificado possíveis afastamentos das suposições feitas para o modelo para garantir uma qualidade de ajuste.

### 3. Descrição dos dados

O banco de dados foi obtido diretamente do site [Kaggle](https://www.kaggle.com/), que coletou as informações de um escritório de impostos na cidade de Ames, Estados Unidos. Os dados contam com 79 variáveis e uma amostra de 1460 observações, ou seja, 1460 residências que foram avaliadas de 2006 a 2010 para cálculo dos valores das propriedades residenciais vendidas. A variável resposta em estudo é o preço de venda das casas (**SalePrice**). Realizamos uma modelagem em $Y$ com informações sobre diversos fatores das casas sendo candidatas a inclusão as seguintes variáveis explicativas:

* **LotArea**: Tamanho do lote em pés quadrados ou \textit{square feet}*;
* **OverallQual**: Classifica (1 a 10) o material e acabamento da casa;
* **YearBuilt}**: Ano de construção da casa;
* **BsmtQual**: Avalia a altura do porão entre
  + **Ex**: Excelente ($100+$ polegadas)
  + **Gd**: Bom (90-99 polegadas)
  + **Ta**: Típico (80-89 polegadas)
  + **Fa**: Razoável (70-79 polegadas
  + **Po**: Ruim ($<70$ polegadas)
* **BsmtFinSF1**: Área do porão finalizada;
* **GrLivArea**: Tamanho da área de lazer em pés quadrados;
* **OpenPorchSF**: Tamanho da área da varanda em pés quadrados;
* **Fireplaces**: Quantidade de lareiras;
* **GarageArea**: Área da garagem em pés quadrados;
* **FullBath**: Quantidade de banheiros;
* **KitchenQual**: Avalia a qualidade da cozinha entre
  + **Ex**: Excelente
  + **Gd**: Bom 
  + **Ta**: Típico
  + **Fa**: Razoável
  + **Po**: Ruim
* **Neighborhood**: Bairros de Ames;
* **OverallCond**: Classifica (1 a 10) a condição da casa;

O padrão das casas dos EUA se diferencia das casas brasileiras. Por exemplo, a grande maioria das casas americanas tem um porão (basement), ou melhor, um 1$^\circ$ andar no subsolo da casa, portanto é relevante considerar no modelo. 

Duas variáveis contidas no modelo são qualitativas, o que demandou o uso de variáveis
dummies. Conforme Montgomery e Runger (2010), quando uma variável qualitativa possui mais de dois valores, se faz necessário o uso de mais de uma variável Dummy, sendo que uma variável com $t$ níveis pode ser modelada com $t-1$ variáveis.

### 4. Metodologia

#### 4.1 Distruibuição
A variável resposta apresenta característica contínua limitada aos reais positivos e assimetria. A escolha da distribuição é feita com base na natureza dos dados e intervalo de variação. 
Inicialmente, testamos se a mesma provém de uma população que apresenta uma distribuição normal. Como método visual, realizou-se o Q-Q Plot (Figura 1) onde os quantis do conjunto de dados é comparado com os quantis teóricos normais. Pontos em linha reta indicam alta correlação entre o modelo teórico e os dados assumindo normalidade, fato não ocorrido nesta ocasião. 

<p align="center">
  <img src="fig1.PNG" alt="Figura1" width="800">
</p>

#### 4.2 Função de Ligação
  Em termos de função de ligação para distribuição gama há três usuais opções de uso: canônica (recíproca) $\eta=\mu^{-1} $, logarítmica $ \eta = log\mu$ e identidade $\eta=\mu$. A canônica traz propriedades estatísticas desejáveis para o modelo, principalmente no caso de amostra pequena. Porém, sendo ela uma função inversa e a variável resposta em estudo com predominância de valores altos, dificulta a interpretação dos parâmetros. Com isso, optou-se pelo uso da função de ligação identidade pois é adequada no sentido em que ambos, $\eta$ e $\mu$, podem assumir valores na reta real.
  
#### 4.3 Seleção do Modelo

 Utilizando os dados e variáveis explicativas candidatas explicitadas na seção anterior, construimos um modelo para o preço de vendas de casas. O propósito é encontrar um modelo que contenha o menor e melhor conjunto de regressores, pois o gasto de recursos e otimização para se trabalhar com o modelo deve ser baixo. A fim de procurar as variáveis mais significativas para o modelo, foi utilizado o procedimento *stepwise* para seleção de modelos de regressão.  Neste método, variáveis são adicionadas e descartadas a cada etapa ($H_0: \beta_j=0$) com base no critério de seleção AIC (Akaike, 1947).   A medida de Akaike considera a qualidade de ajuste e uma "penalização" para a inclusão de regressores. Segundo Paula (2013), a idéia básica é selecionar um modelo que seja parcimonioso, que esteja bem ajustado e tenha um número reduzido de parâmetros. O processo é interrompido quando encontra o menor AIC possível dentre todas possibilidades de modelos testados.
 
