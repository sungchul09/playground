<template>
  <div>
    <h1>JOBS</h1>
    <p v-for="job in jobdata" :key="job.id">
      <a :href="job.url"> {{ job.title }} </a>
      <small>{{ job.time_ago }}, {{ job.domain }}</small>
    </p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
export default {
  computed: {
    ...mapGetters({ jobdata: 'fetchedJobs' }),
  },
  created() {
    this.$store.dispatch('FETCH_JOBS');
  },
};
</script>

<style></style>
