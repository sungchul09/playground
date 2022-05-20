<template>
  <div>
    <section>
      <!-- 질문 상세 정보 -->
      <user-profile :info="item">
        <div slot="username">{{ item.user }}</div>
        <template slot="time">{{ item.time_ago }}</template>
      </user-profile>
      <h2>{{ item.title }}</h2>
    </section>
    <section>
      <!-- 질문 댓글 -->
      <div v-html="item.content"></div>
    </section>
  </div>
</template>

<script>
import UserProfile from '../components/UserProfile.vue';
import { mapGetters } from 'vuex';
export default {
  components: { UserProfile },
  computed: {
    ...mapGetters({ item: 'fetchedItem' }),
  },
  created() {
    const itemId = this.$route.params.id;
    this.$store.dispatch('FETCH_ITEM', itemId);
  },
};
</script>

<style scoped>
.user-container {
  display: flex;
  align-items: center;
}
.fa-user {
  font-size: 2.5rem;
}

.time {
  font-size: 0.7rem;
}

.user-description {
  padding: 8px;
}
</style>
