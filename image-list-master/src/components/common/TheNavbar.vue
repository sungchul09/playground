<template>
  <div class="header">
    <a @click="mainPage">🖼️ IMAGE-LIST PAGE</a>
  </div>
</template>

<script>
export default {
  methods: {
    mainPage() {
      this.$router.replace("/");
      if (this.$route.name !== "imageInfo") {
        this.$router.go();
      }
    },
  },
};
</script>

<style scoped>
.header {
  color: var(--white-color);
  background-color: var(--blue-color);
  display: flex;
  padding: 8px;
  font-weight: bold;
  font-size: 20px;
  transition: transform 200ms ease-in-out;
}

/* .header .router-link-exact-active {
  color: #bcbcbc;
} */

.header a {
  color: var(--white-color);
  text-decoration: none;
  margin-right: 20px;
}

.header a:hover {
  text-decoration: underline;
  cursor: pointer;
}

@media screen and (max-width: 768px) {
  .header {
    transform: scale(1.2);
    transition: transform 200ms ease-in-out;
  }
  .header a {
    margin-left: 50px;
    font-size: 30px;
  }
}
</style>
