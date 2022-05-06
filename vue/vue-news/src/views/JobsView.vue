<template>
  <div>
    <h1>JOBS</h1>
    <div v-for="value in jobsdata" :key="value.id">
      {{ value.id }} {{ value.title }} {{ value.points }}
    </div>
  </div>
</template>

<script>
import { fetchJobsList } from '../api/index.js';
export default {
  data() {
    return {
      jobsdata: [],
    };
  },
  created() {
    fetchJobsList()
      .then((response) => {
        this.jobsdata = response.data;
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
</script>

<style></style>
