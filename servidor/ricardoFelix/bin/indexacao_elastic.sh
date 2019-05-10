# tratando o arquivo json para indexação
data_ontem=$(date -d "-1 days" "+%Y-%m-%d")
mv ~/ricardoFelix/processados_json/processado_$data_ontem/*.json ~/ricardoFelix/processados_json/processado_$data_ontem.json
rm -r ~/ricardoFelix/processados_json/processado_$data_ontem/

# criando índice no elastic search...
curl -X PUT "localhost:9200/cotacao-crypto-$data_ontem" -H 'Content-Type: application/json' -d'
{
    "settings" : {
        "number_of_shards" : 1,
        "number_of_replicas" : 0
    },
    "mappings" : {
      "doc":{
        "properties" : {
            "code": {"type": "integer"},
            "Symbol": {"type": "keyword"},
            "Name": {"type": "text"},
            "Price (USD)": {"type": "float"},
            "priceReal": {"type": "float"},
            "price (BTC)": {"type": "text"},
            "change24H": {"type": "text"},
            "volume24h": {"type": "text"},
            "timestamp": {"type": "text"}
            
        }
    }
}
}
'
echo "Indice Criado"
# Criando alias para esse indice no elastic...
curl -X POST "localhost:9200/_aliases" -H 'Content-Type: application/json' -d'
{
    "actions" : [
        { "add" : { "index" : "cotacao-crypto-'$data_ontem'", "alias" : "cotacao-cripto" } }
    ]
}
'


# Adicionar linhas com { "index":{} } no documento json
python3 ~/ricardoFelix/bin/formatando_json_elastic.py


caminho=$(pwd)
echo "Alias Criado"
# Inserindo Json no Elastic:
curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/cotacao-crypto-$data_ontem/doc/_bulk --data-binary "@$caminho/ricardoFelix/processados_json/processado_$data_ontem.json"; echo

echo "Conteudo Json Inserido"

# Criando Pattern
curl -XPOST "http://localhost:9200/.kibana/doc/index-pattern:cotacao-crypto-"$data_ontem"" -H 'Content-Type: application/json' -d'
{
  "type" : "index-pattern",
  "index-pattern" : {
    "title": "cotacao-crypto-'$data_ontem'",
    "timeFieldName": "execution_time"
  }
}'
