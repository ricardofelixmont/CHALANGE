import os

''' Criando arvore de diretórios. '''

import configparser

# Descobrindo o caminho do arquivo 'programa.ini'
path_ini = os.path.abspath("programa.ini")
lista_ini = path_ini.split("/")[:3]
arquivo = ''
for c in lista_ini:
    arquivo += c +'/'

# Acessando o caminho do arquivo 'p.ini'
conf_file = arquivo + 'CHALANGE/servidor/ricardoFelix/bin/config.ini'
config = configparser.ConfigParser()
config.read(conf_file, encoding='utf8')

path = config.get('path', 'path_name') # Variavel path contem o caminho


# Criando Raiz

os.system("mkdir -p " + path +"ricardoFelix/")

os.system("mkdir -p " + path + "ricardoFelix/bin")

os.system("mkdir -p " + path + "ricardoFelix/crawler_crypto")
os.system("mkdir -p " + path + "ricardoFelix/crawler_crypto/processados")
os.system("mkdir -p " + path + "ricardoFelix/crawler_crypto/consolidados")
os.system("mkdir -p " + path + "ricardoFelix/crawler_crypto/consolidados/transferidos")

os.system("mkdir -p " + path + "ricardoFelix/crawler_dolar")
os.system("mkdir -p " + path + "ricardoFelix/crawler_dolar/transferidos")

os.system("mkdir -p " + path + "ricardoFelix/processados_json")
os.system("mkdir -p " + path + "ricardoFelix/processados_json/indexados")
