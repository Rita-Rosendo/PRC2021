<template>
  <div class="w3-container">
    <h3 style="color: darkblue">Autores:</h3>
    <table class="w3-table-all w3-centered">
      <thead>
        <tr>
          <th>Id</th>
          <th>Nome</th>
          <th>Nº de Publicações</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="author in authors" 
            v-bind:key="author.id"> 
          <td>{{author.id}}</td>
          <td>{{author.nome}}</td>
          <button class="w3-button w3-light-blue w3-padding-small" @click="goListPubs(author.id)"> {{author.publicacoes.split(",").length}}</button>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>

import axios from 'axios';

export default {
    name: 'Authors',

    data() {
      return {
            authors: null,
        };
    },

    created: function() {
      axios
        .get('http://localhost:7700/authors')
        .then(res => {
          this.authors = res.data;
        })
    },

    methods: {
      goListPubs: function(id){
        this.$router.push('/authors/' + id);
      }
    }
}
</script>

<style>
  h3 {
    margin-bottom: 5%;
  }
</style>