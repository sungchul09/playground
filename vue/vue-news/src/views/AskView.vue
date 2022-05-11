<template>
  <div>
    <h1>ASK</h1>
    <p v-for="item in askdata" :key="item.id">
      <a :href="item.url">{{ item.id }} {{ item.title }} </a>
      <small>{{ item.time_ago }} by {{ item.user }}</small>
    </p>
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
