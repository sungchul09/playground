<template>
  <div>
    <h1>ASK</h1>
    <div>
      <div v-for="value in newsdata" :key="value.id">
        {{ value.id }} {{ value.title }} {{ value.points }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      newsdata: [],
    };
  },
  created() {
    this.$store.dispatch('FETCH_NEWS');
  },
};
</script>

<style></style>
