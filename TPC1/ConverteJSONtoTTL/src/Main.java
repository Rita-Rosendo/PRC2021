import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import java.io.FileReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class Main{

    public static void main(String[] args) throws Exception{
        try {
            File myFile = new File("uc.ttl");
            if(myFile.createNewFile()){
                System.out.println("File created: " + myFile.getName());
            }
            else {
                System.out.println("File already exists.");
            }
        } catch (IOException e){
            System.out.println("An error occurred.");
            e.printStackTrace();
        }

        try {
            FileWriter myWriter = new FileWriter("uc.ttl");
            myWriter.write("@prefix : <http://www.semanticweb.org/aninhas/ontologies/uc#> .\n" +
                    "@prefix owl: <http://www.w3.org/2002/07/owl#> .\n" +
                    "@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n" +
                    "@prefix xml: <http://www.w3.org/XML/1998/namespace> .\n" +
                    "@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .\n" +
                    "@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n" +
                    "@base <http://www.semanticweb.org/aninhas/ontologies/uc> .\n" +
                    "\n" +
                    "<http://www.semanticweb.org/aninhas/ontologies/uc> rdf:type owl:Ontology .\n" +
                    "\n" +
                    "#################################################################\n" +
                    "#    Object Properties\n" +
                    "#################################################################\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#ensina\n" +
                    ":ensina rdf:type owl:ObjectProperty ;\n" +
                    "        owl:inverseOf :éEnsinadaPor ;\n" +
                    "        rdfs:domain :Professor ;\n" +
                    "        rdfs:range :UnidadeCurricular .\n" +
                    "\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#frequenta\n" +
                    ":frequenta rdf:type owl:ObjectProperty ;\n" +
                    "           rdfs:domain :Aluno ;\n" +
                    "           rdfs:range :UnidadeCurricular .\n" +
                    "\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#éEnsinadaPor\n" +
                    ":éEnsinadaPor rdf:type owl:ObjectProperty .\n" +
                    "\n" +
                    "\n" +
                    "#################################################################\n" +
                    "#    Data properties\n" +
                    "#################################################################\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#anoLetivo\n" +
                    ":anoLetivo rdf:type owl:DatatypeProperty .\n" +
                    "\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#designação\n" +
                    ":designação rdf:type owl:DatatypeProperty .\n" +
                    "\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#nome\n" +
                    ":nome rdf:type owl:DatatypeProperty .\n" +
                    "\n" +
                    "\n" +
                    "#################################################################\n" +
                    "#    Classes\n" +
                    "#################################################################\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#Aluno\n" +
                    ":Aluno rdf:type owl:Class ;\n" +
                    "       rdfs:subClassOf [ rdf:type owl:Restriction ;\n" +
                    "                         owl:onProperty :frequenta ;\n" +
                    "                         owl:someValuesFrom :UnidadeCurricular\n" +
                    "                       ] .\n" +
                    "\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#Professor\n" +
                    ":Professor rdf:type owl:Class ;\n" +
                    "           rdfs:subClassOf [ rdf:type owl:Restriction ;\n" +
                    "                             owl:onProperty :ensina ;\n" +
                    "                             owl:someValuesFrom :UnidadeCurricular\n" +
                    "                           ] .\n" +
                    "\n" +
                    "\n" +
                    "###  http://www.semanticweb.org/aninhas/ontologies/uc#UnidadeCurricular\n" +
                    ":UnidadeCurricular rdf:type owl:Class .\n" +
                    "\n" +
                    "\n" +
                    "#################################################################\n" +
                    "#    Individuals\n" +
                    "#################################################################\n");

            Object obj = new JSONParser().parse(new FileReader("dataset.json"));
            JSONObject jo = (JSONObject) obj;

            JSONArray unidadesC = (JSONArray) jo.get("ucs");
            JSONArray docentes = (JSONArray) jo.get("docentes");
            JSONArray alunos = (JSONArray) jo.get("alunos");

            for(Object o : unidadesC){
                JSONObject uc = (JSONObject) o;

                String id = (String) uc.get("id");
                String desig = (String) uc.get("designação");
                String anoL = (String) uc.get("anoLetivo");
                myWriter.write("###  http://www.semanticweb.org/aninhas/ontologies/uc#" + id + "\n"+
                        ":"+id+" rdf:type owl:NamedIndividual ,\n" +
                        "                  :UnidadeCurricular ;\n" +
                        "         :anoLetivo \"" + anoL+"\" ;\n" +
                        "         :designação \"" +desig+ "\" .\n\n\n");
            }

            for(Object o : docentes){
                JSONObject docs = (JSONObject) o;

                String id = (String) docs.get("id");
                String nome = (String) docs.get("nome");
                String ensina = (String) docs.get("ensina");
                myWriter.write("###  http://www.semanticweb.org/aninhas/ontologies/uc#"+id+"\n" +
                        ":"+id+" rdf:type owl:NamedIndividual ,\n" +
                        "              :Professor ;\n" +
                        "     :ensina :"+ensina+" ;\n" +
                        "     :nome \""+nome+"\" .\n\n\n");
            }

            for(Object o : alunos){
                JSONObject als = (JSONObject) o;

                String id = (String) als.get("id");
                String frequenta = (String) als.get("frequenta");
                String nome = (String) als.get("nome");
                myWriter.write("###  http://www.semanticweb.org/aninhas/ontologies/uc#"+id+"\n" +
                        ":"+id+" rdf:type owl:NamedIndividual ;\n" +
                        "          :frequenta :"+frequenta+" ,\n" +
                        "          :nome \""+nome+"\" .\n\n\n");
            }
            myWriter.write("###  Generated by the OWL API (version 4.5.9.2019-02-01T07:24:44Z) https://github.com/owlcs/owlapi");
            myWriter.close();
            System.out.println("Successfully wrote to the file");

        } catch (IOException e){
            System.out.println("An error occurred while trying to write to the file.");
            e.printStackTrace();
        }
    }
}