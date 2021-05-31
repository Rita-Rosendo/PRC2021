#!/usr/bin/python3
import json

fileAtletas = open("atletas.ttl","w")
#fileModalidades = open("modalidades.ttl","w")
#fileClubes = open("clubes.ttl","w")


with open('emd.json') as f:
    data = json.load(f)

for i in data:
    fileAtletas.write('###  http://www.semanticweb.org/aninhas/ontologies/gestaoEMDs#a' + (i['_id'])+'\n')
    fileAtletas.write(':a' + str(i['_id']) + ' rdf:type owl:NamedIndividual ,\n')
    fileAtletas.write('\t\t\t:Atleta ;\n')
    fileAtletas.write(':temClube :'+ i['clube'].replace(" ","_") +' ;\n')

    #fileClubes.write('###  http://www.semanticweb.org/aninhas/ontologies/gestaoEMDs#' + i['clube'].replace(" ","_") + '\n')
    #fileClubes.write(':' + i['clube'].replace(" ","_") + ' rdf:type owl:NamedIndividual ,\n')
    #fileClubes.write('\t\t\t:Clube.\n\n')

    fileAtletas.write(':temModalidade :'+ i['modalidade'].replace(" ","_") +' ;\n')

    #fileModalidades.write('###  http://www.semanticweb.org/aninhas/ontologies/gestaoEMDs#' + i['modalidade'].replace(" ","_") + '\n')
    #fileModalidades.write(':' + i['modalidade'].replace(" ","_") + ' rdf:type owl:NamedIndividual ,\n')
    #fileModalidades.write('\t\t\t:Modalidade.\n\n')

    if(i['nome']):
        fileAtletas.write(':primeiroNome "'+ i['nome']['primeiro'] +'" ;\n')
        fileAtletas.write(':segundoNome "'+ i['nome']['último'] +'" ;\n')

    fileAtletas.write(':_id "'+ i['_id'] +'" ;\n')
    fileAtletas.write(':dataEMD "'+ i['dataEMD'] +'" ;\n')
    fileAtletas.write(':email "'+ i['email'] +'" ;\n')
    if(str(i['federado']) == 'False'):
        fileAtletas.write(':federado "False" ;\n')
    elif(str(i['federado']) == 'True'):
        fileAtletas.write(':federado "True" ;\n')
    fileAtletas.write(':genero "'+ i['género'] +'" ;\n')
    fileAtletas.write(':idade '+ str(i['idade']) +' ;\n')
    fileAtletas.write(':index '+ str(i['index']) +' ;\n')
    fileAtletas.write(':morada "'+ i['morada'] +'" ;\n')
    if(str(i['resultado']) == 'True'):
        fileAtletas.write(':resultado "True" .\n\n')
    elif(str(i['resultado']) == 'False'):
        fileAtletas.write(':resultado "False" .\n\n')

fileAtletas.close()
#fileClubes.close()
#fileModalidades.close()