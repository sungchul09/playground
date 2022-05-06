<template>
  <div>
    <h1>ASK</h1>
    <div>
      <div v-for="value in askdata" :key="value.id">
        {{ value.id }} {{ value.title }} {{ value.points }}
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
export default {
  computed: {
    ...mapGetters({
      askdata: 'fetchedAsk',
    }),
  },
  created() {
    this.$store.dispatch('FETCH_ASK');
  },
};
</script>

<style></style>
