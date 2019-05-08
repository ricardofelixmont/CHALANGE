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
mkdir -p ricardoFelix/logs


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
wget -c -P ~/ricardoFelix/bin https://raw.githubusercontent.com/ricardofelixmont/CHALANGE/master/servidor/ricardoFelix/bin/extrair_hdfs.sh
wget -c -P ~/ricardoFelix/bin https://raw.githubusercontent.com/ricardofelixmont/CHALANGE/master/servidor/ricardoFelix/bin/formatando_json_elastic.py
# Modificando caminhos dos arquivos para a máquina atual...
caminho=$(pwd)

sed -i "s|caminho_basico|${caminho}|" ~/ricardoFelix/bin/formatando_json_elastic.py
sed -i "s|caminho_basico|${caminho}|" ~/ricardoFelix/bin/crypto_crawler.py
sed -i "s|caminho_basico|${caminho}|" ~/ricardoFelix/bin/dolar_crawler.py


# Agendando crontab para iniciar os crawlers...
(crontab -l ; echo "*/20 * * * * python3 ~/ricardoFelix/bin/crypto_crawler.py >> ~/ricardoFelix/logs/log_crypto_crawler.log 2>&1")| crontab -
(crontab -l ; echo "59 23 * * * python3 ~/ricardoFelix/bin/dolar_crawler.py >> ~/ricardoFelix/logs/log_dolar_crawler.log 2>&1")| crontab -
(crontab -l ; echo "00 00 * * * bash ~/ricardoFelix/bin/transferir_para_hdfs.sh >> ~/ricardoFelix/logs/log_transf_hdfs.log 2>&1")| crontab -

# Processamento com pySpark...
(crontab -l ; echo "02 00 * * * spark-submit ~/ricardoFelix/bin/processamento_spark.py >> ~/ricardoFelix/logs/log_process_spark.log 2>&1")| crontab - 

# Trazendo o arquivo processado do HDFS...
(crontab -l ; echo "05 00 * * * bash ~/ricardoFelix/bin/extrair_hdfs.sh >> ~/ricardoFelix/logs/log_extrair_hdfs.log 2>&1")| crontab -

# Indexando dados no Elastic
(crontab -l ; echo "07 00 * * * bash ~/ricardoFelix/bin/formatando_json_elastic.py >> ~/ricardoFelix/logs/log_formatando_json.log 2>&1")| crontab -

