data_ontem=$(date -d "-1 days" "+%Y-%m-%d")

# Extraindo arquivo do HDFS para o linux FS
hdfs dfs -get /user/ricardoFelix/output/processado_$data_ontem ~/ricardoFelix/processados_json


# Movendo crypto_data.csv e dolar_data.csv para processados...
hdfs dfs -mv /user/ricardoFelix/input/crypto_$data_ontem.csv /user/ricardoFelix/input/processados/
hdfs dfs -mv /user/ricardoFelix/input/dolar_$data_ontem.csv /user/ricardoFelix/input/processados/

# Movendo o arquivo processado para o diretório transferidos...
hdfs dfs -mv /user/ricardoFelix/output/processado_$data_ontem /user/ricardoFelix/output/transferidos
