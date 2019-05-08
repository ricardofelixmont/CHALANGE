#!bin/bash

##### CONSOLIDAÇÃO #####

### Transferencia Dolar ###
# Descobrindo qual é o arquivo mais recente
data_ontem=$(date -d "-1 days" "+%Y-%m-%d")

echo "O arquivo mais recente é: dolar_$data_ontem.csv"

hdfs dfs -put ~/ricardoFelix/crawler_dolar/dolar_$data_ontem.csv /user/ricardoFelix/input
echo "Movendo para o HDFS"

#echo "Guardando o arquivo mais recente em 'transferidos.zip'"
zip ~/ricardoFelix/crawler_dolar/transferidos/transferidos.zip ~/ricardoFelix/crawler_dolar/dolar_$data_ontem.csv

### Transferencia Crypto ###
# Mudar para consolidados
# armazenar todos em processados.zip
# armazenar os transferidos em transferidos.zip

# Movendo o arquivo crypto_data para o diretório de consolidados
cp ~/ricardoFelix/crawler_crypto/crypto_$data_ontem.csv ~/ricardoFelix/crawler_crypto/consolidados/

# Movendo o arquivo crypto_data para o HDFS
hdfs dfs -put ~/ricardoFelix/crawler_crypto/consolidados/crypto_$data_ontem.csv /user/ricardoFelix/input

# Descobrindo qual é o arquivo mais recente em ~/ricardoFelix/crawler_crypto
echo "O arquivo mais recente é: dolar_$data_ontem.csv"

# Adicionando o arquivo crypto mais recente em processados.zip
zip ~/ricardoFelix/crawler_crypto/processados/processados.zip ~/ricardoFelix/crawler_crypto/crypto_$data_ontem.csv

# Adicionando o arquivo enviado para o HDFS para transferidos.zip
zip ~/ricardoFelix/crawler_crypto/consolidados/transferidos/transferidos.zip ~/ricardoFelix/crawler_crypto/consolidados/crypto_$data_ontem.csv
