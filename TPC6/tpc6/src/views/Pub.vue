<template>
    <ConsultaPub :idp="$route.params.idPub" mensagem="Teste" />
</template>

<script>
import ConsultaPub from '@/components/ConsultaPub.vue';

export default {
    components: {
        ConsultaPub
    }
};
</script>
