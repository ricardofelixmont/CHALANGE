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


# Criando importando dash board no kibana
curl -X POST "http://localhost:5601/api/kibana/dashboards/import?exclude=index-pattern" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d'
{
  "version": "6.2.3",
  "objects": [
    {
      "id": "08ec0c80-730c-11e9-8a20-63d23bf24762",
      "type": "visualization",
      "updated_at": "2019-05-10T10:11:53.800Z",
      "version": 1,
      "attributes": {
        "title": "Crypto Moedas",
        "visState": "{\"title\":\"Crypto Moedas\",\"type\":\"line\",\"params\":{\"addLegend\":true,\"addTimeMarker\":false,\"addTooltip\":true,\"categoryAxes\":[{\"id\":\"CategoryAxis-1\",\"labels\":{\"show\":true,\"truncate\":100},\"position\":\"bottom\",\"scale\":{\"type\":\"linear\"},\"show\":true,\"style\":{},\"title\":{},\"type\":\"category\"}],\"grid\":{\"categoryLines\":false,\"style\":{\"color\":\"#eee\"}},\"legendPosition\":\"right\",\"seriesParams\":[{\"data\":{\"id\":\"1\",\"label\":\"Contagem\"},\"drawLinesBetweenPoints\":true,\"mode\":\"normal\",\"show\":\"true\",\"showCircles\":true,\"type\":\"line\",\"valueAxis\":\"ValueAxis-1\"},{\"data\":{\"id\":\"2\",\"label\":\"R$ (min)\"},\"drawLinesBetweenPoints\":true,\"mode\":\"normal\",\"show\":true,\"showCircles\":true,\"type\":\"line\",\"valueAxis\":\"ValueAxis-1\"},{\"data\":{\"id\":\"3\",\"label\":\"R$ (med)\"},\"drawLinesBetweenPoints\":true,\"mode\":\"normal\",\"show\":true,\"showCircles\":true,\"type\":\"line\",\"valueAxis\":\"ValueAxis-1\"},{\"data\":{\"id\":\"4\",\"label\":\"R$ (max)\"},\"drawLinesBetweenPoints\":true,\"mode\":\"normal\",\"show\":true,\"showCircles\":true,\"type\":\"line\",\"valueAxis\":\"ValueAxis-1\"},{\"data\":{\"id\":\"5\",\"label\":\"U$$ (min)\"},\"drawLinesBetweenPoints\":true,\"mode\":\"normal\",\"show\":true,\"showCircles\":true,\"type\":\"line\",\"valueAxis\":\"ValueAxis-1\"},{\"data\":{\"id\":\"6\",\"label\":\"U$$ (med)\"},\"drawLinesBetweenPoints\":true,\"mode\":\"normal\",\"show\":true,\"showCircles\":true,\"type\":\"line\",\"valueAxis\":\"ValueAxis-1\"},{\"data\":{\"id\":\"7\",\"label\":\"U$$ (max)\"},\"drawLinesBetweenPoints\":true,\"mode\":\"normal\",\"show\":true,\"showCircles\":true,\"type\":\"line\",\"valueAxis\":\"ValueAxis-1\"}],\"times\":[],\"type\":\"line\",\"valueAxes\":[{\"id\":\"ValueAxis-1\",\"labels\":{\"filter\":false,\"rotate\":0,\"show\":true,\"truncate\":100},\"name\":\"LeftAxis-1\",\"position\":\"left\",\"scale\":{\"mode\":\"normal\",\"type\":\"linear\"},\"show\":true,\"style\":{},\"title\":{\"text\":\"Contagem\"},\"type\":\"value\"}]},\"aggs\":[{\"id\":\"1\",\"enabled\":true,\"type\":\"count\",\"schema\":\"metric\",\"params\":{\"customLabel\":\"Contagem\"}},{\"id\":\"2\",\"enabled\":true,\"type\":\"min\",\"schema\":\"metric\",\"params\":{\"field\":\"priceReal\",\"customLabel\":\"R$ (min)\"}},{\"id\":\"3\",\"enabled\":true,\"type\":\"avg\",\"schema\":\"metric\",\"params\":{\"field\":\"priceReal\",\"customLabel\":\"R$ (med)\"}},{\"id\":\"4\",\"enabled\":true,\"type\":\"max\",\"schema\":\"metric\",\"params\":{\"field\":\"priceReal\",\"customLabel\":\"R$ (max)\"}},{\"id\":\"5\",\"enabled\":true,\"type\":\"min\",\"schema\":\"metric\",\"params\":{\"field\":\"Price (USD)\",\"customLabel\":\"U$$ (min)\"}},{\"id\":\"6\",\"enabled\":true,\"type\":\"avg\",\"schema\":\"metric\",\"params\":{\"field\":\"Price (USD)\",\"customLabel\":\"U$$ (med)\"}},{\"id\":\"7\",\"enabled\":true,\"type\":\"max\",\"schema\":\"metric\",\"params\":{\"field\":\"Price (USD)\",\"customLabel\":\"U$$ (max)\"}},{\"id\":\"9\",\"enabled\":true,\"type\":\"terms\",\"schema\":\"group\",\"params\":{\"field\":\"Symbol\",\"otherBucket\":false,\"otherBucketLabel\":\"Other\",\"missingBucket\":false,\"missingBucketLabel\":\"Missing\",\"size\":25,\"order\":\"desc\",\"orderBy\":\"4\"}}]}",
        "uiStateJSON": "{\"spy\":{\"mode\":{\"name\":\"table\"}}}",
        "description": "",
        "version": 1,
        "kibanaSavedObjectMeta": {
          "searchSourceJSON": "{\"index\":\"crypto-cotacao-'$data_ontem'\",\"filter\":[{\"$state\":{\"store\":\"appState\"},\"exists\":{\"field\":\"Symbol\"},\"meta\":{\"alias\":null,\"disabled\":false,\"index\":\"crypto-cotacao-'$data_ontem'\",\"key\":\"Symbol\",\"negate\":false,\"type\":\"exists\",\"value\":\"exists\"}}],\"query\":{\"language\":\"lucene\",\"query\":\"\"}}"
        }
      }
    },
    {
      "id": "crypto-cotacao-'$data_ontem'",
      "type": "index-pattern",
      "updated_at": "2019-05-10T19:00:51.056Z",
      "version": 21,
      "attributes": {
        "title": "crypto-cotacao-'$data_ontem'",
        "timeFieldName": "execution_time",
        "fields": "[{\"name\":\"Name\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":false,\"readFromDocValues\":false},{\"name\":\"Price (USD)\",\"type\":\"number\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":true,\"readFromDocValues\":true},{\"name\":\"Symbol\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":true,\"readFromDocValues\":true},{\"name\":\"_id\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":true,\"readFromDocValues\":false},{\"name\":\"_index\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":true,\"readFromDocValues\":false},{\"name\":\"_score\",\"type\":\"number\",\"count\":0,\"scripted\":false,\"searchable\":false,\"aggregatable\":false,\"readFromDocValues\":false},{\"name\":\"_source\",\"type\":\"_source\",\"count\":0,\"scripted\":false,\"searchable\":false,\"aggregatable\":false,\"readFromDocValues\":false},{\"name\":\"_type\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":true,\"readFromDocValues\":false},{\"name\":\"change24H\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":false,\"readFromDocValues\":false},{\"name\":\"code\",\"type\":\"number\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":true,\"readFromDocValues\":true},{\"name\":\"price (BTC)\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":false,\"readFromDocValues\":false},{\"name\":\"priceReal\",\"type\":\"number\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":true,\"readFromDocValues\":true},{\"name\":\"timestamp\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":false,\"readFromDocValues\":false},{\"name\":\"volume24h\",\"type\":\"string\",\"count\":0,\"scripted\":false,\"searchable\":true,\"aggregatable\":false,\"readFromDocValues\":false}]"
      }
    },
    {
      "id": "ba83c370-730c-11e9-8a20-63d23bf24762",
      "type": "dashboard",
      "updated_at": "2019-05-10T10:16:51.751Z",
      "version": 1,
      "attributes": {
        "title": "crypto-cotacao-'$data_ontem'",
        "hits": 0,
        "description": "",
        "panelsJSON": "[{\"panelIndex\":\"1\",\"gridData\":{\"x\":0,\"y\":0,\"w\":6,\"h\":3,\"i\":\"1\"},\"version\":\"6.2.3\",\"type\":\"visualization\",\"id\":\"08ec0c80-730c-11e9-8a20-63d23bf24762\"}]",
        "optionsJSON": "{\"darkTheme\":false,\"hidePanelTitles\":false,\"useMargins\":true}",
        "version": 1,
        "timeRestore": false,
        "kibanaSavedObjectMeta": {
          "searchSourceJSON": "{\"query\":{\"language\":\"lucene\",\"query\":\"\"},\"filter\":[],\"highlightAll\":true,\"version\":true}"
        }
      }
    }
  ]
}'

data_ontem=$(date -d "-1 days" "+%Y-%m-%d")
zip ~/ricardoFelix/processados_json/indexados/indexados.zip ~/ricardoFelix/processados_json/processado_$data_ontem.json
