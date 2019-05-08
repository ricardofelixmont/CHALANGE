from pyspark.sql import SparkSession
from pyspark.sql import functions
from pyspark import SparkContext


spark = SparkSession.builder.appName('Processamento').getOrCreate()

print("Inicio do programa\n\n\n")

# 1 - Lendo o arquivo dolar e extraindo o valor...
dolar = spark.read.option("delimiter",";").option("header", True).csv("/home/ricardo/pySpark/dolar_2019-05-05.csv")
valor_dolar = dolar.select("Preço")
valor_dolar.show()

with open("/home/ricardo/pySpark/dolar_2019-05-05.csv") as f:
    # Valor do dolar em real...
    dolar_em_real = f.readlines()[1].split(";")[1]

# 2 - Ler o arquivo crypto em DataFrame
crypto = spark.read.option("delimiter",";").option("header", True).csv("/home/ricardo/pySpark/crypto_2019-05-05.csv")
crypto.show(5)

# 3 - Converter o valor e criar o dataFrame de Saída
#conv = crypto.select("#","Symbol","Name","Price (USD)", functions.format_number((crypto[2] * real),2).alias("priceReal"),"price (BTC)",functions.col("Chg (24H)").alias("change24H"),functions.col("Vol (24H)").alias("volume24h"),functions.col("date_time").alias("timestamp"))

conv = crypto.select("#","Symbol","Name","Price (USD)",(crypto[2] * dolar_em_real).alias("priceReal"),"price (BTC)",functions.col("Chg (24H)").alias("change24H"),functions.col("Vol (24H)").alias("volume24h"),functions.col("date_time").alias("timestamp"))

# 4 - tranformar arquivo de saída em rdd
#arquivo_saida = 
conv.write.json("/home/ricardo/pyspark/jason.json")

# 5 - Exibindo as colunas
#conv.show() 

print("Fim do programa\n\n\n")
