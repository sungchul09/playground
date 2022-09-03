import ListView from './ListView.vue';

export default function createListView(name) {
  return {
    name: name,
    created() {
      this.$store.state.loadingStatus = true;
      setTimeout(() => {
        this.$store
          .dispatch('FETCH_LIST', this.$route.name)
          .then(() => {
            console.log('fetched');
            this.$store.state.loadingStatus = false;
          })
          .catch((error) => {
            console.log(error);
          });
      }, 1000);
    },
    render(createELement) {
      return createELement(ListView);
    },
  };
}
