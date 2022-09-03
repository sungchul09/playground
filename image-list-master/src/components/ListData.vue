<template>
  <div class="imageData">
    <ul v-for="(data, index) in propsdata" :key="index">
      <div class="data">
        <li class="data__image">
          <a :href="data.link" target="_blank">
            <img
              :src="data.download_url"
              alt="image_file"
              @error="imageError"
            />
          </a>
        </li>
        <li class="data__text">
          <span class="data__text__author">
            <a :href="data.url" target="_blank">{{ data.author }}</a>
          </span>
          <span class="data__text__id">
            <a :href="data.link" target="_blank">#{{ data.id }}</a>
          </span>
        </li>
        <li class="data__info">
          <router-link :to="`/imageInfo/${data.id}`">🔍 상세정보</router-link>
        </li>
      </div>
    </ul>
  </div>
</template>

<script>
export default {
  props: { propsdata: Array, propserror: String },
  methods: {
    imageError(e) {
      e.target.onerror = null;
      e.target.src = this.propserror;
    },
  },
};
</script>

<style scoped>
li,
ul {
  list-style: none;
  padding: 0;
}

.imageData {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: flex-start;
}

.imageData ul {
  margin-right: 20px;
}

.data {
  padding: 5px 0 20px 0;
  border-radius: 5%;
  width: 100%;

  box-shadow: 0 2px 4px 0 rgb(0 0 0 / 10%);
}

.data li {
  margin: 10px;
}

.data a {
}

.data img {
  border-radius: 5%;
  transition: all 150ms ease-in-out;
}

.data img:hover {
  border-radius: 5%;
  transform: translateY(-6px);
}

.data .data__img {
}

.data__text {
  padding: 0 5px;
  display: flex;
  justify-content: space-between;
}

.data__text__author a {
  text-decoration: none;
  color: black;
}

.data__text__author a:hover {
  color: var(--blue-color);
  font-weight: bold;
}

.data__text__id a {
  text-decoration: none;
  color: var(--grey-color);
}

.data__text__id a:hover {
  cursor: pointer;
  font-weight: bold;
  color: var(--blue-color);
}

.data .data__info {
  text-align: right;
}

.data .data__info a {
  text-decoration: none;
  color: var(--blue-color);
  width: 50px;
  padding: 5px 10px;
  text-align: center;
}

.data .data__info a:hover {
  cursor: pointer;
  color: var(--blue-color);
  border-radius: 8%;
  text-decoration: underline;
  transition: 150ms ease-in-out;
}
@media screen and (max-width: 1024px) {
  .imageData {
    justify-content: center;
  }
}
</style>