<template>
  <div>
    <div>USER</div>
    <p v-for="user in this.userdata" :key="user">
      {{ user }}
    </p>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      userdata: [],
    };
  },
  created() {
    console.log(this.$route.params.id);
    axios
      .get(`https://api.hnpwa.com/v0/user/${this.$route.params.id}.json`)
      .then((resolve) => {
        console.log(resolve);
        this.userdata = resolve.data;
      })
      .catch((error) => {
        console.log(error);
      });
  },
};
</script>

<style></style>
