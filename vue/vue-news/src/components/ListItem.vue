<template>
  <div>
    <h2>{{ title }}</h2>
    <ul class="news-list">
      <li class="post" v-for="item in listItems" :key="item.id">
        <!-- 포인트 영역 -->
        <div class="points">
          {{ item.points || 0 }}
        </div>
        <!-- 기타정보영역 -->
        <div>
          <!-- 타이틀 영역 -->
          <p class="news-title">
            <template v-if="item.domain">
              <a :href="item.domain">
                {{ item.title }}
              </a>
            </template>
            <template v-else>
              <router-link v-bind:to="`item/${item.id}`">
                {{ item.title }}
              </router-link>
            </template>
          </p>
          <small class="link-text">
            by
            <router-link
              v-if="item.user"
              class="link-text"
              v-bind:to="`/user/${item.user}`"
              >{{ item.user }}
              <a :href="item.url">
                {{ item.domain }}
              </a>
            </router-link>
          </small>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
let name = '';
export default {
  created() {
    // this.$store.dispatch('FETCH_NEWS');
    name = this.$route.name;
    console.log(name);
    if (name === 'news') {
      this.$store.dispatch('FETCH_NEWS');
    } else if (name === 'ask') {
      this.$store.dispatch('FETCH_ASK');
    } else if (name === 'jobs') {
      this.$store.dispatch('FETCH_JOBS');
    }
  },
  computed: {
    listItems() {
      if (name === 'news') {
        return this.$store.state.news;
      } else if (name === 'ask') {
        return this.$store.state.ask;
      } else if (name === 'jobs') {
        return this.$store.state.jobs;
      }
      return '';
    },
    title() {
      if (name === 'news') {
        return 'NEWS';
      } else if (name === 'ask') {
        return 'ASK';
      } else if (name === 'jobs') {
        return 'JOBS';
      }
      return '';
    },
  },
};
</script>

<style scoped>
.news-list {
  margin: 0;
  padding: 0;
}

.post {
  list-style: none;
  display: flex;
  align-items: center;
  border-bottom: 1px solid #eee;
}

.points {
  width: 80px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #41b883;
  font-weight: bold;
}

.news-title {
  margin: 0;
}

.link-text {
  color: #828282;
}
</style>
