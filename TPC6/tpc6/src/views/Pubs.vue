<template>
  <div class="w3-container">
    <h3 style="color: darkblue">Publicações:</h3>
    <table class="w3-table-all w3-centered">
      <thead>
        <tr>
          <th>Id</th>
          <th>Tipo</th>
          <th>Título</th>
          <th>Ano de Publicação</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="pub in pubs" 
            v-bind:key="pub.id"> 
          <button class="w3-button w3-light-blue w3-padding-small" @click="goPub(pub.id)"> {{pub.id}}</button>
          <td>{{pub.tipo}}</td>
          <td>{{pub.titulo}}</td>
          <td>{{pub.ano}}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>

import axios from 'axios';

export default {
    name: 'Pubs',

    data() {
      return {
            pubs: null,
        };
    },

    created: function() {
      axios
        .get('http://localhost:7700/pubs')
        .then(res => {
          this.pubs = res.data;
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