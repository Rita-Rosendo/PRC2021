<template>
  <div class="w3-container">
    <h3 style="color: darkblue">Autor {{idA}}</h3>
    <table class="w3-table-all">
        <tr>
            <th>Predicado</th><th>Objecto</th>
        </tr>
        <tr v-for="(triplo,i) in dados"
            v-bind:key="i"
            >
          <td>{{triplo.p}}</td>
          <td v-if="triplo.p == 'write'" >
            <button class="w3-button w3-light-blue w3-padding-small" @click="goPub(triplo.o)"> {{triplo.o}}</button>
          </td>
          <td v-else>{{triplo.o}}</td>
        </tr>
    </table> 
  </div> 
</template>
<script>

import axios from 'axios';

export default {
    name: 'Author',

    props: ["idA", "mensagem"],

    data() {
      return {
            dados: null,
        };
    },

    created: function() {
      axios
        .get('http://localhost:7700/authors/:' + this.idA)
        .then(res => {
            this.dados = res.data;
        })
    },

    methods: {
      goPub: function(id) {
        this.$router.push('/pubs/' + id);
      }
    }
}
</script>

<style>
  h3 {
    margin-bottom: 5%;
  }
</style>