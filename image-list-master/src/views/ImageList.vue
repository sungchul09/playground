<template>
  <div class="imageList">
    <list-limit></list-limit>
    <list-data :propsdata="imageList" :propserror="errorSrc"></list-data>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import ListLimit from "@/components/ListLimit";
import ListData from "@/components/ListData";

export default {
  components: {
    ListLimit,
    ListData,
  },
  computed: {
    ...mapGetters({ imageList: "getImageList" }),
  },
  created() {
    window.scrollTo(0, 0);
    const page = this.$route.params.page;
    const limit = this.$route.params.limit;
    this.$store.dispatch("FETCH_IMAGELIST", { page, limit });
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
.imageList {
  margin: 0px 15%;
  display: flex;
  flex-direction: column;
  align-items: baseline;
}

@media screen and (max-width: 1024px) {
  .imageList {
    flex-direction: column;
    align-items: center;
  }
}
</style>
