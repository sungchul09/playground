<template>
  <div id="app">
    <tool-bar class="toolbar"></tool-bar>
    <transition name="page"> <router-view></router-view> </transition>
    <Spinner :loading="this.$store.state.loadingStatus"></Spinner>
  </div>
</template>

<script>
import ToolBar from './components/ToolBar.vue';
import Spinner from './components/Spinner.vue';

export default {
  components: {
    ToolBar,
    Spinner,
  },
};
</script>

<style>
body {
  padding: 0;
  margin: 0;
}

a {
  color: #34495e;
  text-decoration: none;
}

a.router-link-exact-active {
  text-decoration: underline;
}

a:hover {
  color: #42b883;
  text-decoration: underline;
}

/* Router Transition */
.page-enter-active,
.page-leave-active {
  transition: opacity 0.5s;
}

.page-enter,
.page-leave-to {
  opacity: 0;
}
</style>
