<template>
  <div>
    <h1>JOBS</h1>
    <div v-for="value in this.$store.state.jobs" :key="value.id">
      {{ value.id }} {{ value.title }} {{ value.points }}
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      jobsdata: [],
    };
  },
  created() {
    this.$store.dispatch('FETCH_JOBS');
  },
};
</script>

<style></style>
