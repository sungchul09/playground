<template>
  <div>
    <h2>Chart.js</h2>
    <fetch-data :url="`https://jsonplaceholder.typicode.com/users/1`"></fetch-data>
    <!-- <line-chart></line-chart> -->
  </div>
</template>

<script>
import FetchData from '../components/FetchData.vue';
export default {
  components: {
    FetchData,
  },
};
</script>
