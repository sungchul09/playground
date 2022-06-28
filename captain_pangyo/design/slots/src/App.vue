<template>
  <div>
    <ul>
      <check-box v-model="checked"></check-box>
    </ul>
  </div>
</template>

<script>
import CheckBox from './components/Checkboxes.vue';

export default {
  components: {
    CheckBox,
  },
  data() {
    return {
      items: ['아이템1', '아이템2', '아이템3', '아이템4', '아이템5'],
      checked: false,
    };
  },
};
</script>

<style></style>
