var express = require('express');
var router = express.Router();
var axios = require('axios');

var prefixes = `
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX noInferences: <ontotext.com/explicit>
    PREFIX skos: <w3.org/2004/02/skos/core#>
    PREFIX : <http://www.daml.org/2003/01/periodictable/PeriodicTable#>
`

var getLink = "http://localhost:7200/repositories/tpc4-PRC" + "?query=" 

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Tabela Periódica' });
});

router.get('/elemento/:id', function (req, res, next){
  
  var query = 'select distinct ?atomicNumber ?atomicWeight ?block ?casRegistryID ?classification ?color ?group ?name ?period ?standardState ?symbol where {' + req.params.id +' ?p ?o ; :atomicNumber ?atomicNumber ; :atomicWeight ?atomicWeight ; :block ?block ; :casRegistryID ?casRegistryID ; :classification ?classification ; :color ?color ; :group ?group ; :name ?name ; :period ?period ; :standardState ?standardState ; :symbol ?symbol .} '

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var elemento = dados.data.results.bindings.map(bind => {return {
            simbolo: bind.symbol.value,
            periodo: bind.period.value.split('#')[1],
            cor: bind.color.value,
            pesoAtomico: bind.atomicWeight.value,
            estadoStandard: bind.standardState.value.split('#')[1],
            casRegistryIDD: bind.casRegistryID.value,
            nome: bind.name.value,
            numeroAtomico: bind.atomicNumber.value,
            bloco: bind.block.value.split('#')[1],
            classificacao: bind.classification.value.split('#')[1],
            grupo: bind.group.value.split('#')[1]
          }});

          res.render('elemento', { elemento: elemento });
      })
      .catch(e => res.render('error', {error: e}))
})


router.get('/elementos', function (req, res, next){
  
  var query = `select ?s ?simb ?name ?anumber where { ?s rdf:type :Element ; :symbol ?simb ; :name ?name ; :atomicNumber ?anumber.} order by (?anumber)`

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        
        var elementos = dados.data.results.bindings.map(bind => {return {
              id: bind.s.value.split('#')[1],
              nome: bind.name.value,
              simb: bind.simb.value,
              numAtomico: bind.anumber.value
          }});
          
          res.render('elementos', {elementos: elementos});
      })
      .catch(e => res.render('error', {error: e}))
})


router.get('/grupos', function (req, res, next){
  
  var query = `select ?s ?name ?number where { ?s rdf:type :Group . optional {?s :name ?name} . optional {?s :number ?number} . } order by desc(?name)`

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var grupos = dados.data.results.bindings.map(bind => {return {
              id: bind.s.value.split('#')[1],
              nome: (bind.name) ? bind.name.value : "--",
              numero: (bind.number) ? bind.number.value : "--"
          }});
          
          res.render('grupos', {grupos: grupos});
      })
      .catch(e => res.render('error', {error: e}))
})

router.get('/periodos', function (req, res, next){
  
  var query = `select ?s ?number where { ?s rdf:type :Period . optional {?s :number ?number}} order by (?number)  `

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
     .then(dados => {
        var periodos = dados.data.results.bindings.map(bind => {return {
              id: bind.s.value.split('#')[1],
              numero: (bind.number) ? bind.number.value : "--"
          }});
          
          res.render('periodos', {periodos: periodos});
      })
      .catch(e => res.render('error', {error: e}))
})


module.exports = router;