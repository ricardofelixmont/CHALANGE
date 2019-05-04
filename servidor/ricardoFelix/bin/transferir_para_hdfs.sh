#!bin/bash

##### CONSOLIDAÇÃO #####

# Teste do software
data=$(date +%d/%m/%Y)
touch ~/ricardoFelix/crawler_dolar/arquivo_$data
touch ~/ricardoFelix/crawler_crypto/arquivo_$data

### Transferencia Dolar ###
# Descobrindo qual é o arquivo mais recente
arquivo=$(ls -t ~/ricardoFelix/crawler_dolar |head -1)
echo "O arquivo mais recente é: $arquivo"

hdfs dfs -put ~/ricardoFelix/crawler_dolar/$arquivo /user/ricardoFelix/input
encho "Movendo para o HDFS"

echo "Guardando o arquivo mais recente em 'transferidos.zip'"
zip ~/ricardoFelix/crawler_dolar/transferidos/transferidos.zip ~/ricardoFelix/crawler_dolar/$arquivo


### Transferencia Crypto ###
# Mudar para consolidados
# armazenar todos em processados.zip
# armazenar os transferidos em transferidos.zip

# Descobrindo qual é o arquivo mais recente em ~/ricardoFelix/crawler_crypto
arquivo_crypto=$(ls -t ~/ricardoFelix/crawler_crypto | head -1) 
echo "O arquivo mais recente é: $arquivo_crypto"

# Adicionando o arquivo crypto mais recente em processados.zip
zip ~/ricardoFelix/crawler_crypto/processados/processados.zip ~/ricardoFelix/crawler_crypto/$arquivo_crypto

# Movendo o arquivo crypto para consolidados
mv ~/ricardoFelix/crawler_crypto/$arquivo_crypto ~/ricardoFelix/crawler_crypto/consolidados/

# Movendo o arquivo para o HDFS
hdfs dfs -put ~/ricardoFelix/crawler_crypto/consolidados/$arquivo_crypto /user/ricardoFelix/input

# Adicionando o arquivo enviado para o HDFS para transferidos.zip
zip ~/ricardoFelix/crawler_crypto/consolidados/transferidos/transferidos.zip ~/ricardoFelix/crawler_crypto/consolidados/$arquivo_crypto
