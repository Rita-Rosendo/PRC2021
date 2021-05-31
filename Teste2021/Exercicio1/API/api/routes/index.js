var express = require('express');
var router = express.Router();
var axios = require('axios');

var prefixes = ` 
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX xml: <http://www.w3.org/XML/1998/namespace>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX : <http://www.semanticweb.org/aninhas/ontologies/gestaoEMDs#>
`

var getLink = "http://localhost:7200/repositories/EMD?query=" 

/*
GET /api/emd - Devolve a lista de EMD apenas com os campos:
 "id", "nome", "data" e "resultado";
*/
router.get('/api/emd', function (req, res, next){
  
  var query = `
  select ?idAtleta ?primeiroNome ?ultimoNome ?data ?resultado where { 
    ?atleta rdf:type :Atleta;
           :dataEMD ?data;
           :primeiroNome ?primeiroNome;
           :segundoNome ?ultimoNome;
           :resultado ?resultado.
    BIND (strafter(str(?atleta),"#a") as ?idAtleta).  
  }
  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var emds = dados.data.results.bindings.map(bind => {return {
              id: bind.idAtleta.value,
              primeiroNome: bind.primeiroNome.value,
              ultimoNome: bind.ultimoNome.value,
              data: bind.data.value,
              resultado : bind.resultado.value
          }});
          res.status(200).jsonp(emds);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })

})


/*
GET /api/emd/:id - Devolve a informação completa de um EMD;
*/
router.get('/api/emd/:id', function (req, res, next){
  
  var query = `
  select ?dataEMD ?email ?federado ?genero ?idade  ?index ?morada ?primeiroNome ?ultimoNome ?data ?resultado ?clube ?mod
   where { 
    :`+req.params.id+` :primeiroNome ?primeiroNome;
           :segundoNome ?ultimoNome;
           :dataEMD ?data;
           :email ?email;
           :genero ?genero;
           :index ?index;
           :morada ?morada;           
           :federado ?federado;
           :resultado ?resultado;
           :idade ?idade;
           :temModalidade ?mod;
           :temClube ?clube.
  }
  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var emds = dados.data.results.bindings.map(bind => {return {
          primeiroNome : bind.primeiroNome.value,
          segundoNome : bind.ultimoNome.value,
          dataEMD : bind.data.value,
          email : bind.email.value,
          genero : bind.genero.value,
          index : bind.index.value,
          morada : bind.morada.value,
          federado : bind.federado.value,
          resultado : bind.resultado.value,
          idade : bind.idade.value,
          modalidade : bind.mod.value.split("#")[1],
          clube : bind.clube.value.split("#")[1]
          }});
          res.status(200).jsonp(emds);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })

})

/*
GET /api/modalidades - Devolve a lista de modalidades, sem repetições;
*/
router.get('/api/modalidades', function (req, res, next){
  
  var query = `
  select distinct ?mod where { 
    ?mod rdf:type :Modalidade.
  }
  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var emds = dados.data.results.bindings.map(bind => {return {
          mod : bind.mod.value.split("#")[1]
          }});
          res.status(200).jsonp(emds);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })

})

/*
GET /api/emd?res=OK - Devolve a lista de EMD com resultado "true";
*/
router.get('/api/emd?res=OK ', function (req, res, next){
  
  var query = `
  select ?atleta where { 
    ?atleta rdf:type :Atleta;
            :resultado ?res.
    filter (regex(str(?res),"true")).
  }
  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var emds = dados.data.results.bindings.map(bind => {return {
          emds : bind.atleta.value.split("#")[1]
          }});
          res.status(200).jsonp(emds);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })

})

/*
GET /api/modalidades/:id - Devolve a lista de EMD referentes à modalidade 
passada como parâmetro;
*/

router.get('/api/modalidades/:id', function (req, res, next){
  
  var query = `
  select ?atleta where { 
    ?atleta rdf:type :Atleta;
            :temModalidade :`+req.params.id+`.
  }
  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var emds = dados.data.results.bindings.map(bind => {return {
          emds : bind.atleta.value.split("#")[1]
          }});
          res.status(200).jsonp(emds);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })

})

/*
GET /api/atletas?gen=F - Devolve uma lista ordenada alfabeticamente com os 
nomes dos atletas de género feminino;
*/

router.get('/api/atletas?gen=F', function (req, res, next){
  
  var query = `
  select ?atleta ?fn ?ln where { 
    ?atleta rdf:type :Atleta;
            :genero ?gen;
            :primeiroNome ?fn;
            :segundoNome ?ln;
    filter regex(?gen,"F").
  }
order by (?fn)
  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var emds = dados.data.results.bindings.map(bind => {return {
          atleta : bind.atleta.value.split("#")[1],
          primeiroNome: bind.fn.value,
          ultimoNome: bind.ln.value
          }});
          res.status(200).jsonp(emds);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })

})

/*
GET /api/atletas?clube=X - Devolve uma lista ordenada alfabeticamente com 
os nomes dos atletas do clube X.
*/

router.get('/api/atletas?clube=X', function (req, res, next){
  
  var query = `
  select ?atleta ?fn ?ln where { 
    ?atleta rdf:type :Atleta;
            :primeiroNome ?fn;
            :segundoNome ?ln;
            :temClube :`+req.query.clube+`.
  }
order by (?fn)
  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var emds = dados.data.results.bindings.map(bind => {return {
          atleta : bind.atleta.value.split("#")[1],
          primeiroNome: bind.fn.value,
          ultimoNome: bind.ln.value
          }});
          res.status(200).jsonp(emds);
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })

})

module.exports = router;