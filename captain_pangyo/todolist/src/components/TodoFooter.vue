<template>
  <div class="clearAllContainer">
    <span class="clearAllbtn" v-on:click="clearTodo">Clear All</span>
  </div>
</template>

<script>
export default {
  methods: {
    clearTodo: function () {
      this.$store.commit("claerAllItems");
    },
  },
};
</script>

<style scoped>
.clearAllContainer {
  width: 8.5rem;
  height: 50px;
  line-height: 50px;
  background-color: white;
  border-radius: 5px;
  margin: 0 auto;
}

.clearAllbtn {
  color: #e20303;
  font-weight: bold;
  display: block;
}
</style>