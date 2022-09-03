<template>
  <div class="footer">
    <p>👔 Created by sc.yun</p>
  </div>
</template>

<script>
export default {};
</script>

<style scoped>
p {
  margin: 0;
  padding: 0;
}
.footer {
  color: var(--white-color);
  background-color: var(--blue-color);
  font-weight: bold;
  font-size: 20px;
  text-align: right;
  line-height: 150px;
  width: 100%;
}

.footer p {
  margin-right: 30px;
}

@media screen and (max-width: 768px) {
  .footer p {
    margin: 0;
    text-align: center;
  }
}
</style>

