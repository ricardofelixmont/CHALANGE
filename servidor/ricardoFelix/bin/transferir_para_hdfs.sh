#!bin/bash

# Descobrindo qual é o arquivo mais recente
arquivo=$(ls -t ~/ricardoFelix/crawler_dolar |head -1)
echo "O arquivo mais recente é: $arquivo"

# hdfs dfs -put ~/ricardoFelix/crawler_dolar/$arquivo /user/ricardoFelix/input
encho "Movendo para o HDFS"

echo "Guardando o arquivo mais recente em 'transferidos.zip'"
zip ~/ricardoFelix/crawler_dolar/transferidos/transferidos.zip ~/ricardoFelix/crawler_dolar/$arquivo
