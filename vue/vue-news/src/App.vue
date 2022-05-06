<template>
  <div id="app">
    <tool-bar class="toolbar"></tool-bar>
    <router-view></router-view>
  </div>
</template>

<script>
import ToolBar from './components/ToolBar.vue';
export default {
  components: {
    ToolBar,
  },
};
</script>

<style>
body {
  padding: 0;
  margin: 0;
}

#app {
  display: flex;
  flex-direction: row;
}

#app .toolbar {
  width: 200px;
}
</style>
