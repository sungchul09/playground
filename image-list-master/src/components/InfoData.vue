<template>
  <div class="imageInfo">
    <div class="image">
      <a :href="propsdata.url" target="_blank">
        <img
          :src="propsdata.download_url"
          alt="image_file"
          @error="imageError"
        />
      </a>
    </div>
    <div class="info">
      <div class="info__author">
        {{ propsdata.author }}
      </div>
      <dl>
        <dt>id</dt>
        <dd>{{ propsdata.id }}</dd>
        <dt>width</dt>
        <dd>{{ propsdata.width }}</dd>
        <dt>height</dt>
        <dd>{{ propsdata.height }}</dd>
        <dt>url</dt>
        <dd>
          <a :href="propsdata.url" target="_blank">{{ propsdata.url }}</a>
        </dd>
        <dt>download</dt>
        <dd>
          <a :href="propsdata.link" target="_blank">{{ propsdata.link }}</a>
        </dd>
      </dl>
    </div>
  </div>
</template>

<script>
export default {
  props: { propsdata: Object, propserror: String },
  methods: {
    imageError(e) {
      e.target.onerror = null;
      e.target.src = this.propserror;
    },
  },
};
</script>

<style scoped>
li {
  list-style: none;
}

.imageInfo {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 200px;
}

.image {
  text-align: center;
  background-color: var(--black-color);
  font-size: 0;
  width: 100%;
}

.image a {
}

.image img {
  max-height: 900px;
  max-width: 1000px;
}

.info {
  padding: 0;
  margin: 5% 0 0 0;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.info .info__author {
  font-size: 40px;
  font-weight: bold;
}

.info dl {
  margin-top: 100px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  font-size: 20px;
}

.info dt {
  margin-right: 10px;
  color: var(--grey-color);
  font-size: 20px;
}

.info dt:after {
  content: "";
  display: block;
  width: 25%;
  border-bottom: 1px solid var(--grey-color);
}

.info dd {
  margin: 0 40px 10% 0;
}

@media screen and (max-width: 768px) {
  .image img {
    max-height: 800px;
    max-width: 800px;
    height: 100%;
    width: 100%;
  }
  .infoAndBtn {
    margin: 0;
    align-items: center;
  }

  .info dl {
    flex-direction: column;
    justify-content: center;
  }
  .info dt {
    margin-top: 30px;
  }
}
</style>