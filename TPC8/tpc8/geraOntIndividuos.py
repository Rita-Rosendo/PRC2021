#!/usr/bin/python3
import json

fileCidades = open("Cidades.ttl",'w')

fileLigacoes = open("Ligacoes.ttl","w")

with open('mapa_virtual.json') as fp:
    ficheiro = json.load(fp)

for c in ficheiro['cidades']:
   fileCidades.write("###  http://www.semanticweb.org/aninhas/ontologies/mapaVirtual#" + c['id'] + "\n")
   fileCidades.write(":" + c['id'] + " rdf:type owl:NamedIndividual ,\n")
   fileCidades.write("\t\t\t:Cidade ;\n")
   fileCidades.write('\t:descrição "' + c['descrição'] + '" ;\n')
   fileCidades.write('\t:distrito "' + c['distrito'] + '" ;\n')
   fileCidades.write('\t:nome "' + c['nome'] + '" ;\n')
   fileCidades.write('\t:população ' + c['população'] + ' .\n\n')

for l in ficheiro['ligações']:
   fileLigacoes.write("###  http://www.semanticweb.org/aninhas/ontologies/mapaVirtual#" + l['id'] + "\n")
   fileLigacoes.write(":" + l['id'] + " rdf:type owl:NamedIndividual ,\n")
   fileLigacoes.write("\t\t\t:Ligação ;\n")
   fileLigacoes.write('\t:temDestino :' + l['destino'] + ' ;\n')
   fileLigacoes.write('\t:temOrigem :' + l['origem'] + ' ;\n')
   fileLigacoes.write('\t:distância ' + str(l['distância']) + ' .\n\n')

fileCidades.close()
fileLigacoes.close()


