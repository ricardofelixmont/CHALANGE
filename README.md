# CHALANGE

Visão Geral
Os dados iniciais a serem capturados são referentes a cotações de:
1. criptomoedas do link (https://m.investing.com/crypto/) com os seguintes campos: code, name,
priceUSD, change24H, change7D, symbol, priceBTC, marketCap, volume24H, totalVolume, e
timestamp;
2. dólar (em relação ao Real) do link (https://m.investing.com/currencies/usd-brl) com os seguintes
campos: currency, value, change, perc, e timestamp.
A captura (1) deve ocorrer a cada 20min, e a cada dia deve ser feita uma consolidação destas informações
num único arquivo.
A captura (2) deve ocorrer juntamente com esta consolidação e mantida num arquivo próprio.


Estes dois arquivos devem ser enviados ao HDFS para processamento (o volume é baixo para utilização
porém ainda assim serve para esta avaliação), onde seus conteúdos serão cruzados para conversão das
cotações em dólar para a nossa moeda Real (R$), resultando num arquivo, no formato JSON, cujo nome
contém a data do dia anterior, e com os seguintes campos: code, symbol, name, priceUSD, priceReal,
priceBTC, change24h, volume24h, timestamp.
Após a finalização deste processamento, o json deve ser extraído do HDFS e carregado no Elasticsearch num
índice contendo a mesma data dos dados. Por último, deve ser disponibilizado um dashboard no kibana
exibindo as moedas e seus valores mínimos, máximos, médios, e fechamento do dia, assim como um gráfico
em linha.
