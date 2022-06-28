export default {
    mounted() {
        this.$store.state.loadingStatus = false;
    }
    // created() {
    //     this.$store.state.loadingStatus = true;
    //     this.$store.dispatch('FETCH_LIST', this.$route.name)
    //         .then(() => {
    //             this.$store.state.loadingStatus = false;
    //         })
    //         .catch((error) => {
    //             console.log(error);
    //         })
    // }
}