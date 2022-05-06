<template>
  <div class="header">
    <router-link class="href" to="/news">news</router-link>
    <router-link class="href" to="/jobs">jobs</router-link>
    <router-link class="href" to="/ask">ask</router-link>
  </div>
</template>

<script>
export default {};
</script>

<style scoped>
.header {
  font-size: 50px;
  font-weight: bold;
  color: rgb(220, 20, 20);
  background-color: rgb(24, 61, 124);
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.header .router-link-exact-active {
  background-color: rgb(255, 247, 0);
  color: black;
}

.header a {
  text-decoration: none;
  color: white;
}

.header a:hover {
  color: black;
}

a {
  padding: 10px;
}
</style>
