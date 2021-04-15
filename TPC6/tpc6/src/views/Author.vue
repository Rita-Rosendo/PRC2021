<template>
    <ConsultaAuthor :idA="$route.params.idAuthor" mensagem="Teste" />
</template>

<script>
import ConsultaAuthor from '@/components/ConsultaAuthor.vue';

export default {
    components: {
        ConsultaAuthor
    }
};
</script>
