<template>
  <div>
    <canvas ref="barChart" id="barChart" width="400" height="400"></canvas>
  </div>
</template>

<script>
export default {
  props: ['propsdata'],
  mounted() {
    const myChart = new this.$_Chart(this.$refs.barChart.getContext('2d'), {
      type: 'bar',
      data: {
        labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
        datasets: this.propsdata,
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
          },
        },
        onclick: function () {
          this.$emit('refresh:chart');
        },
      },
    });
  },
};
</script>

<style></style>
