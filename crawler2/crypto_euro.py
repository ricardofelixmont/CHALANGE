from bs4 import BeautifulSoup
from datetime import datetime
import requests
import csv
import os

class ScrapEuro:

    def page(self):
        """
        Download the page
        """
        p = requests.get('https://m.investing.com/currencies/eur-brl',headers={'User-Agent':'curl/7.52.1'})
        return p
        # teste
    def html(self,p):
        self.page = p
        soup = BeautifulSoup(self.page.content, 'html.parser')
        return soup

    def scrap_name(self,soup):
        s = soup
        self.scrap = s.find('div', {'class' : 'cryptoCurrentDataMain'})
        name = self.scrap.find('h1', {'class' : 'instrumentH1inlineblock'})
        return name.string.strip()

    def scrap_value(self,soup):
        s = soup
        self.scrap = s.find('div', {'class' : 'quotesBoxTop'})
        value = self.scrap.find('span', {'class' : 'lastInst pid-1617-last'})
        return value.string.strip()

    def scrap_change(self,soup):
        s = soup
        self.scrap = s.find('div', {'class' : 'quotesBoxTop'})
        self.span = self.scrap.find('span', {'class' : 'quotesChange'})
        change = self.span.find('i', {'class' : 'redFont pid-1617-pc'})
        return change.string.strip()

    def scrap_percent(self,soup):
        s = soup
        self.scrap = s.find('div', {'class' : 'quotesBoxTop'})
        self.span = self.scrap.find('span', {'class' : 'quotesChange'})
        percent = self.span.find('i', {'class' :'parentheses redFont pid-1617-pcp'})
        return percent.string.strip()

    def scrap_date(self, p):
        self.s = p
        date = datetime.strptime(self.s.headers["Date"][:-4],'%a, %d %b %Y %H:%M:%S')
        return date

if __name__ == '__main__':

    scrap = ScrapEuro()
    url = scrap.page()
    html = scrap.html(url)

    with open('crypto_euro.csv','a+') as csvfile:
        f_size = os.path.getsize('crypto_euro.csv')
        if f_size == 0:
            csvwriter = csv.writer(csvfile, delimiter=';')
            csvwriter.writerow(['Moeda','Cotação','Mudança','Percental','Tima_stamp'])
            csvwriter.writerow([scrap.scrap_name(html),scrap.scrap_value(html),scrap.scrap_change(html),scrap.scrap_percent(html),scrap.scrap_date(url)])
        else:
            csvwriter = csv.writer(csvfile, delimiter=';')
            csvwriter.writerow([scrap.scrap_name(html),scrap.scrap_value(html),scrap.scrap_change(html),scrap.scrap_percent(html),scrap.scrap_date(url)])

        print('sucesso')
