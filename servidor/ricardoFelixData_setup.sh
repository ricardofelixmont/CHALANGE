#!/bin/bash

# Criação de Arvore de diretórios no Linux FS
echo "Criando arvore de diretórios..."
mkdir -p ricardoFelix/
mkdir -p ricardoFelix/bin
mkdir -p ricardoFelix/crawler_crypto/processados
mkdir -p ricardoFelix/crawler_crypto/consolidados
mkdir -p ricardoFelix/crawler_crypto/consolidados/transferidos
mkdir -p ricardoFelix/crawler_dolar
mkdir -p ricardoFelix/crawler_dolar/transferidos
mkdir -p ricardoFelix/processados_json
mkdir -p ricardoFelix/processados_json/indexados


# Criação da Arvore de diretórios no HDFS
hdfs dfs -mkdir /user/ricardoFelix/
hdfs dfs -mkdir /user/ricardoFelix/input/
hdfs dfs -mkdir /user/ricardoFelix/input/processados/
hdfs dfs -mkdir /user/ricardoFelix/output/
hdfs dfs -mkdir /user/ricardoFelix/output/transferidos


# Download dos crawlers
echo "Baixando arquivos necessários..."
wget -c -P ~/ricardoFelix/bin https://raw.githubusercontent.com/ricardofelixmont/CHALANGE/master/servidor/ricardoFelix/bin/crypto_crawler.py
wget -c -P ~/ricardoFelix/bin https://raw.githubusercontent.com/ricardofelixmont/CHALANGE/master/servidor/ricardoFelix/bin/dolar_crawler.py
wget -c -P ~/ricardoFelix/bin https://raw.githubusercontent.com/ricardofelixmont/CHALANGE/master/servidor/ricardoFelix/bin/transferir_para_hdfs.sh
wget -c -P ~/ricardoFelix/bin https://raw.githubusercontent.com/ricardofelixmont/CHALANGE/master/servidor/ricardoFelix/bin/processamento_spark.py

# Modificando caminhos dos arquivos para a máquina atual...
caminho=$(pwd)

sed -i "s|caminho_basico|${caminho}|" ~/ricardoFelix/bin/crypto_crawler.py
sed -i "s|caminho_basico|${caminho}|" ~/ricardoFelix/bin/dolar_crawler.py


# Agendando crontab para iniciar os crawlers...
(crontab -l ; echo "*/20 * * * * python3 ~/ricardoFelix/bin/crypto_crawler.py")| crontab -
(crontab -l ; echo "59 23 * * * python3 ~/ricardoFelix/bin/dolar_crawler.py")| crontab -
(crontab -l ; echo "00 00 * * * bash ~/ricardoFelix/bin/transferir_para_hdfs.sh")| crontab -
(crontab -l ; echo "05 00 * * * spark-submit ~/ricardoFelix/bin/processamento_spark.py")| crontab -


# Trazendo o arquivo processado do HDFS...
(crontab -l ; echo "07 00 * * * bash ~/ricardoFelix/bin/extrair_hdfs.sh")| crontab -

# Próximos passos:
# Fazer download das dependências do Bs4
# 1 - Mover crypto_data.csv e crypto_dolar.csv para processados no hdfs
# 2 - dar hdfs dfs -get no diretorio processado_data.json para o file system do linux
# 3 - mover processado_data.json para transferidos no hdfs
