<template>
  <!--   <div class="lds-facebook" v-if="loading">
    <div></div>
    <div></div>
    <div></div>
  </div> -->
  <div class="spinner-container" v-if="loading">
    <div class="spinner"></div>
  </div>
</template>
<script>
export default {
  props: {
    loading: {
      type: Boolean,
      required: true,
    },
  },
};
</script>
<style>
/* .lds-facebook {
  position: absolute;
  top: 45%;
  left: 45%;
}
.lds-facebook div {
  display: inline-block;
  position: relative;
  left: 6px;
  width: 23px;
  background: black;
  border-radius: 15%;
  animation: lds-facebook 1.2s cubic-bezier(0, 0.5, 0.5, 1) infinite;
}
.lds-facebook div:nth-child(1) {
  left: 6px;
  animation-delay: -0.24s;
}
.lds-facebook div:nth-child(2) {
  left: 26px;
  animation-delay: -0.12s;
}
.lds-facebook div:nth-child(3) {
  left: 45px;
  animation-delay: 0;
}
@keyframes lds-facebook {
  0% {
    top: 6px;
    height: 100px;
  }
  50%,
  100% {
    top: 19px;
    height: 50px;
  }
} */

.spinner-container {
  position: absolute;
  top: 35%;
  left: 45%;
}

.spinner {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  border: 5px solid var(--white-color);
  border-bottom: 5px solid var(--grey-color);
  animation: spin 1s linear infinite;
  position: relative;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>
