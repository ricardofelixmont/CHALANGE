from pyspark.sql import SparkSession
from pyspark.sql import functions
from pyspark import SparkContext
from datetime import date, timedelta

spark = SparkSession.builder.appName('Processamento').getOrCreate()
spark.conf.set("spark.sql.crossJoin.enabled", "true")
print("Inicio do programa\n\n\n")

# caminho com nome dos arquivos que serão processados no HDFS:
# Dolar:
data_ontem = str(date.today() - timedelta(1))
nome_dolar_arquivo = 'dolar_' + data_ontem + '.csv'
# Crypto:
nome_crypto_arquivo = 'crypto_' + data_ontem + '.csv'

caminho_dolar_arquivo = '/user/hive/warehouse/' + nome_dolar_arquivo
caminho_crypto_arquivo = '/user/hive/warehouse/' + nome_crypto_arquivo
caminho_saida_json = ''

# 1 - Lendo o arquivo dolar e extraindo o valor...
dolar = spark.read.option("delimiter",";").option("header", True).csv(caminho_dolar_arquivo)
valor_dolar = dolar[1]
print(valor_dolar)

#print(dolar_em_real)
# 2 - Ler o arquivo crypto em DataFrame
crypto = spark.read.option("delimiter",";").option("header", True).csv(caminho_crypto_arquivo)
crypto.show(5)

# Testando operacoes com colunas
#novo = crypto.join(dolar).select("Price (USD)", "Preco", (crypto[2] * valor_dolar).alias("product"))
#novo.show()

# 3 - Converter o valor e criar o dataFrame de Saida
#conv = crypto.select("#","Symbol","Name","Price (USD)", functions.format_number((crypto[2] * real),2).alias("priceReal"),"price (BTC)",functions.col("Chg (24H)").alias("change24H"),functions.col("Vol (24H)").alias("volume24h"),functions.col("date_time").alias("timestamp"))

conv = crypto.join(dolar).select(functions.col("#").alias("code"),"Symbol","Name","Price (USD)",(crypto[2] * valor_dolar).alias("priceReal"),"price (BTC)",functions.col("Chg (24H)").alias("change24H"),functions.col("Vol (24H)").alias("volume24h"),functions.col("date_time").alias("timestamp"))

# 4 - tranformar arquivo de saida em rdd
#arquivo_saida = 

conv.write.json("/user/hive/warehouse/json_data_2")

# 5 - Exibindo as colunas
#conv.show() 

print("Fim do programa\n\n\n")
