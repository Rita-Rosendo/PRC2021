var express = require('express');
var router = express.Router();
var axios = require('axios');

var prefixes = ` 
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX xml: <http://www.w3.org/XML/1998/namespace>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX : <http://www.semanticweb.org/aninhas/ontologies/pubs#>
    PREFIX pubs: <http://www.semanticweb.org/aninhas/ontologies/pubs#>
`

var getLink = "http://epl.di.uminho.pt:8738/api/rdf4j/query/A84475-TP5?query=";

router.get('/pubs', function (req, res, next){
  
  var query = `
  select ?s (SAMPLE(?type) as ?tipo) (SAMPLE(?title) as ?titulo) (SAMPLE(?year) as ?ano)
  where {
    ?s a :Bibliography ;
       rdf:type ?type ;
       :title ?title ;
       :year ?year .
    FILTER (?type!= owl:NamedIndividual) .
     FILTER (?type!= pubs:Bibliography) .
  }
  group by (?s)
  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {

        var pubs = dados.data.results.bindings.map(bind => {return {
              id: bind.s.value.split('#')[1],
              tipo: ( (bind.tipo.value.split('#')[1] != 'Bibliography') || (bind.tipo.value.split('#')[1] != 'NamedIndividual') ) ? bind.tipo.value.split('#')[1] : '-------' ,
              titulo: bind.titulo.value,
              ano: bind.ano.value
          }});
          res.status(200).jsonp(pubs);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })

})

router.get('/pubs/:id', function (req, res, next){
  var query = 'select * where { pubs'+req.params.id+' ?p ?o .} '


  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var pubsElem = dados.data.results.bindings.map(bind => {return {
              p: bind.p.value.split('#')[1],
              o: (bind.o.type == 'literal') ? bind.o.value : bind.o.value.split('#')[1]
        }});
          res.status(200).jsonp(pubsElem);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })
})


router.get('/authors', function (req, res, next){

  var query = `select (SAMPLE(?s) as ?id) (SAMPLE(?name) as ?nome) (group_concat(?o;SEPARATOR="  ,  ") as ?publicacoes)
  where {
      ?s a :Author .
      ?s :name ?name.
      ?s pubs:write ?o .
  } 
  group by ?name`
  
  var encoded = encodeURIComponent(prefixes + query)
  axios.get(getLink + encoded)
     .then(dados => {
        var authors =  dados.data.results.bindings.map(bind => {return {
              id: bind.id.value.split('#')[1],
              nome: bind.nome.value,
              publicacoes: bind.publicacoes.value
        }});
          res.status(200).jsonp(authors);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })
})

router.get('/authors/:id', function (req, res, next){
  var query = 'select * where { pubs'+req.params.id+' ?p ?o .} '

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var authors = dados.data.results.bindings.map(bind => {return {
              p: bind.p.value.split('#')[1],
              o: (bind.o.type == 'literal') ? bind.o.value : bind.o.value.split('#')[1]
        }});
          res.status(200).jsonp(authors);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })
})


router.post('/authors', function (req, res, next) {
  var query =  'insert data {' +req.body.id+ ' rdf:type :Author . '+req.body.id+' pubs:name "'+req.body.name+'".}'
  var encoded = encodeURIComponent(prefixes + query)

  axios({
    method: 'post',
    url: 'http://epl.di.uminho.pt:8738/api/rdf4j/update/A84475-TP5',
    headers: {
      "Content-Type": 'application/x-www-form-urlencoded',
    },
    data: {
      query: encoded
    }
  })
  .then(response => {
    res.status(200).jsonp(response);
  })
  .catch(err => {
    res.status(500).jsonp(err);
  })
  
})


module.exports = router;