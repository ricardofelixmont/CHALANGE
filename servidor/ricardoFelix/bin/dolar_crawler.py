#!/usr/bin/env python3.7

import requests
from datetime import datetime
import csv
import os

path = '/home/semantix/CHALANGE/servidor/'

# função para localizar e extrair o titulo da moeda 
def moeda(html):
    """
    paramatro: html -> conteúdo da página
    return: conteduo -> tipo de moeda
    """
    #verifica o titulo da moeda
    aux = html.find("instrumentH1inlineblock") + 30
    #coloca o titulo em um formato sem espaços
    tipo_moeda = html[aux:aux+31]
    return tipo_moeda

def cotacao(html):
    #localiza cotacao
    aux = html.find("lastInst pid-2103-last") + 30
    #retira os espacos do valor obtido
    cot = html[aux:aux+29].strip()

    return cot

def mudanca(html):
    #localiza mudanca
    aux = html.find("pid-2103-pc") + 30
    #retira os espaços da variavel
    mud = html[aux:aux+20].strip()

    return mud

def percentual(html):
    #localiza percentual
    aux = html.find("pid-2103-pcp") + 30
    #retira os espaços da variavel
    perc = html[aux:aux+10].strip()

    return perc

def data(r):
    #localiza a data e retira GMT
    aux = r.headers["date"][:-4]
    #formatação da data para atender o exercicio
    date = datetime.strptime(aux, '%a, %d %b %Y %H:%M:%S').strftime('%Y-%m-%d %H:%M:%S')

    return date

def gravar(saida):
    nome_arquivo = path + 'ricardoFelix/crawler_dolar/dolar_data.csv'
    #abertura do arquivo com append
    #Mudei a abertura do arquivo para um context manager.
    with open(nome_arquivo, 'a+') as f:
        writer = csv.writer(f, delimiter = ';')
        #verifica se o arquivo está vazio, e se estiver, escreve o cabeçalho.
        if os.stat(nome_arquivo).st_size == 0:
            writer.writerow(['Nome', 'Preço', 'Change', 'Percentual', 'Data'])
            writer.writerow(saida)

if __name__ == '__main__':
	
    r = requests.get(url="https://m.investing.com/currencies/usd-brl", headers={'User-Agent':'curl/7.52.1'})
    html = r.text
    saida = [moeda(html), cotacao(html), mudanca(html), percentual(html), data(r)]

    gravar(saida)
    print('Gravado com sucesso...')

