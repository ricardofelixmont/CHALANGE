import os

string = os.path.abspath("novo.txt")
print(string)


caminho = '/home/semantix/CHALANGE/documentos_softwares/testando_caminhos_relativos/novo.txt'
with open(caminho, 'r') as f:
    read = f.readlines()
    print(read)
    print('sucesso')
