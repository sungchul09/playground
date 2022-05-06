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
import { fetchAskList } from '../api/index.js';
export default {
  data() {
    return {
      askdata: [],
    };
  },
  created() {
    fetchAskList()
      .then((response) => {
        this.askdata = response.data;
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
</script>

<style></style>
