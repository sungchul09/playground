<template>
  <div class="btn">
    <div class="toggleOnBtn" v-if="toggleBtn">
      <div class="scrollBtn">
        <span @click="scrollUp">☝️</span>
      </div>
      <div class="pageBtn">
        <span @click="prevBtn">prev</span>
        <span @click="nextBtn">next</span>
      </div>
    </div>
    <div class="backBtn" v-else>
      <span @click="backBtn">BACK</span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    toggleBtn: {
      type: Boolean,
      required: true,
    },
  },
  methods: {
    scrollUp() {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    prevBtn() {
      if (this.$route.params.page <= 1) {
        alert('첫 페이지입니다.');
        return;
      }
      this.$router.push(`/imageList/${--this.$route.params.page}/${this.$route.params.limit}`);
      this.$router.go();
    },
    nextBtn() {
      this.$router.push(`/imageList/${++this.$route.params.page}/${this.$route.params.limit}`);
      this.$router.go();
    },
    backBtn() {
      this.$router.go(-1);
    },
  },
};
</script>

<style scoped>
a {
  text-decoration: none;
}

.btn,
.scrollBtn,
.pageBtn,
.backBtn {
  position: sticky;
  bottom: 5%;
  left: 95%;
  width: 20px;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  margin-bottom: 5%;
}

span {
  color: var(--blue-color);
  background-color: var(--white-color);
  border: 1px solid var(--blue-color);
  width: 70px;
  height: 70px;
  line-height: 70px;
  font-size: 20px;
  text-align: center;
  border-radius: 50%;
  margin: 20px 50px 0 0;
  transition: 300ms ease-in-out;
}

span:hover {
  cursor: pointer;
  border: 1px solid var(--blue-color);
  background-color: var(--blue-color);
  color: var(--white-color);
  transition: 150ms ease-in-out;
}

span a {
  width: 50px;
  height: 50px;
}
@media screen and (max-width: 1024px) {
  span {
    width: 60px;
    height: 60px;
    line-height: 60px;
    font-size: 17px;
    transition: 300ms ease-in-out;
  }
}

@media screen and (max-width: 768px) {
  span {
    width: 50px;
    height: 50px;
    line-height: 50px;
    font-size: 15px;
    transition: 300ms ease-in-out;
  }
}
</style>
