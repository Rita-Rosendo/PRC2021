<template>
  <div class="w3-container">
    <h3 style="color: darkblue">Publicação {{idp}}</h3>
    <table class="w3-table-all">
        <tr>
            <th>Sujeito</th><th>Predicado</th><th>Objecto</th>
        </tr>
        <tr v-for="(triplo,i) in dados" :key="i">
            <td>{{idp}}</td><td>{{triplo.p}}</td><td>{{triplo.o}}</td>
        </tr>
    </table> 
  </div> 
</template>
<script>

import axios from 'axios';

export default {
    name: 'Pub',

    props: ["idp", "mensagem"],

    data() {
      return {
            dados: null,
        };
    },

    created: function() {
      axios
        .get('http://localhost:7700/pubs/:' + this.idp)
        .then(res => {
            this.dados = res.data;
        })
    }
}
</script>

<style>
  h3 {
    margin-bottom: 5%;
  }
</style>