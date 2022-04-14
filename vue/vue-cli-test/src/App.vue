<template>
  <div>
    {{ message | capitalize }}
  </div>
</template>

<script>
import axios from "axios";

export default {
  data: function () {
    return {
      username: "",
      password: "",
      message: "asdf",
    };
  },
  methods: {
    submitForm: function () {
      console.log(this.username, this.password);
      let url = "https://jsonplaceholder.typicode.com/users";
      let data = {
        username: this.username,
        password: this.password,
      };
      axios
        .post(url, data)
        .then(function (response) {
          console.log(response);
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    filters: {
      capitalize: function (data) {
        return data.toUpperCase();
      },
    },
  },
};
</script>

<style>
</style>