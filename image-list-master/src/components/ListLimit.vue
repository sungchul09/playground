<template>
  <div class="limit">
    <p>📕 페이지 항목 :</p>
    <select v-model="limit" @change="changeUrl">
      <option selected>10</option>
      <option>20</option>
      <option>50</option>
      <option>75</option>
      <option>100</option>
      <option>300</option>
    </select>
  </div>
</template>

<script>
export default {
  created() {
    this.limit = this.$route.params.limit;
  },
  data() {
    return {
      limit: 300,
    };
  },
  methods: {
    changeUrl() {
      const page = this.$route.params.page;
      this.$route.params.limit = this.limit;
      this.$router.push(`/imageList/${page}/${this.limit}`);
      this.$router.go();
    },
  },
};
</script>

<style scoped>
.limit {
  display: flex;
  align-items: baseline;
}

.limit p {
  margin-right: 10px;
  font-size: 20px;
}

.limit select {
  font-size: 15px;
  font-weight: bold;
  text-align: center;
  width: 90px;
  font-size: 20px;
}
</style>
