<template>
  <info-data :propsdata="imageInfo" :propserror="errorSrc"></info-data>
</template>

<script>
import { mapGetters } from "vuex";
import InfoData from "@/components/InfoData";

export default {
  components: {
    InfoData,
  },
  computed: {
    ...mapGetters({ imageInfo: "getImageInfo" }),
  },
  created() {
    window.scrollTo(0, 0);
    this.$store.commit("SET_IMAGEINFO", {});
    this.$store.dispatch("FETCH_IMAGEINFO", this.$route.params.id);
  },
  data() {
    return {
      errorSrc:
        "https://images.unsplash.com/photo-1594322436404-5a0526db4d13?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=250&q=250",
    };
  },
};
</script>

<style scoped>
</style>
