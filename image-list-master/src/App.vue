<template>
  <div id="app">
    <the-navbar></the-navbar>
    <router-view></router-view>
    <spinner :loading="$store.state.loadingStatus"></spinner>
    <fix-button :toggleBtn="$store.state.toggleBtn"></fix-button>
    <the-footer></the-footer>
  </div>
</template>

<script>
import TheNavbar from '@/components/common/TheNavbar';
import Spinner from '@/components/Spinner';
import FixButton from '@/components/common/FixButton';
import TheFooter from '@/components/common/TheFooter';
export default {
  components: {
    TheNavbar,
    Spinner,
    FixButton,
    TheFooter,
  },
};
</script>

<style>
:root {
  --black-color: #000000;
  --white-color: #efefef;
  --blue-color: #0064e6;
  --grey-color: #9399af;
}

* {
  box-sizing: border-box;
}

body {
  padding: 0;
  margin: 0;
}
</style>
