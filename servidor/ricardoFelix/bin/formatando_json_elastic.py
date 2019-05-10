from datetime import date, timedelta

caminho = '/home/semantix'
data_ontem = date.today() - timedelta(1)
nome_arquivo = caminho + '/ricardoFelix/processados_json/processado_' + str(data_ontem) + '.json'
with open(nome_arquivo, 'r') as f:
    read = f.readlines()

novo_json = ''
for linha in read:
    novo_json += '{ "index":{} }\n'+linha
novo_json += '\n'

with open(nome_arquivo, 'w') as f:
    f.write(novo_json)
