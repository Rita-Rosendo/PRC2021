var express = require('express');
var router = express.Router();
var axios = require('axios');

router.get(['/','/repositorios'], function(req, res, next){
  axios.get("http://localhost:7200/rest/repositories/")
       .then(dados => {
         res.render('repositorios', {repositorios: dados.data});
       }).catch(e => res.render('error', {error: e}))
})


router.get('/repositorios/:id', function(req, res, next){
  var prefixes = `
  PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
  PREFIX owl: <http://www.w3.org/2002/07/owl#>
  `
  var getLink = "http://localhost:7200/repositories/" + req.params.id + "?query="

  var query = `select * where{ ?s rdf:type owl:Class . }`

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
       .then(dados => {
         var repositoriosClasses = dados.data.results.bindings.map(bind => {return {
            id: req.params.id,
            prefixo: bind.s.value.split('#')[0],
            classe: bind.s.value.split('#')[1]
         }});

         res.render('classes', {classes: repositoriosClasses});
       
        }).catch(e => res.render('error', {error: e}))
})


router.get('/repositorios/:id/classes/:class', function(req, res, next){
  var prefixes = `
  PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
  PREFIX owl: <http://www.w3.org/2002/07/owl#>
  `
  prefixes += 'PREFIX : <' + req.query.pref + '#>'

  var getLink = "http://localhost:7200/repositories/" + req.params.id + "?query="

  var query = 'select * where{ ?s rdf:type :'+ req.params.class + '. }'

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
       .then(dados => {
         var individuos = dados.data.results.bindings.map(bind => {return {
            id: req.params.id,
            prefixo: req.query.pref,
            classe: req.params.class,
            individuo: bind.s.value.split('#')[1]
         }});

         res.render('individuos', {individuos: individuos});
       
        }).catch(e => res.render('error', {error: e}))
})

router.get('/repositorios/:id/classes/:class/individuos/:indv', function(req, res, next){
  var prefixes = `
  PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
  PREFIX owl: <http://www.w3.org/2002/07/owl#>
  `
  prefixes += 'PREFIX : <' + req.query.pref + '#>'

  var getLink = "http://localhost:7200/repositories/" + req.params.id + "?query="

  var query = 'select * where{ :'+ req.params.indv +' ?p ?o .}'

  var encoded = encodeURIComponent(prefixes + query)

  axios.get(getLink + encoded)
       .then(dados => {
         console.log(dados)
         var individuo = dados.data.results.bindings.map(bind => {return {
            p: bind.p.value.split('#')[1],
            o: (bind.o.value.split('#')[1]) ? bind.o.value.split('#')[1] : bind.o.value
         }});

         res.render('individuo', {individuo: individuo});
       
        }).catch(e => res.render('error', {error: e}))
})

module.exports = router;
