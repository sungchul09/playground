<template>
  <div>
    <h1>NEWS</h1>
    <p v-for="item in newsdata" :key="item.id">
      <a :href="item.url">{{ item.id }} {{ item.title }} </a>
      <small
        >{{ item.time_ago }} by
        <router-link v-bind:to="`/user/${item.user}`"
          >{{ item.user }}
        </router-link>
      </small>
    </p>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
export default {
  computed: {
    ...mapGetters({ newsdata: 'fetchedNews' }),
  },
  created() {
    this.$store.dispatch('FETCH_NEWS');
  },
};
</script>

<style></style>
