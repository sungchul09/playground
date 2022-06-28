import {
    fetchList,
    fetchUserInfo,
    fetchCommentItem,
    fetchJobsList,
    fetchAskList,
} from '../api/index.js';

export default {
    FETCH_USER({ commit }, name) {
        return fetchUserInfo(name)
            .then(({ data }) => {
                commit('SET_USER', data);
            })
            .catch((error) => {
                console.log(error);
            });
    },
    FETCH_ITEM({ commit }, id) {
        return fetchCommentItem(id)
            .then(({ data }) => {
                commit('SET_ITEM', data);
            })
            .catch((error) => {
                console.log(error);
            });
    },
    async FETCH_LIST(context, pageName) {
        const response = fetchList(pageName);
        context.commit('SET_LIST', response.data);
        return response;
    },
    async FETCH_NEWS(context) {
        const response = await fetchNewsList();
        context.commit('SET_NEWS', response.data);
        return response;
    },
async FETCH_JOBS(context) {
        const response = await fetchJobsList();
        context.commit('SET_JOBS', response.data);
        return response;
    },
    async FETCH_ASK(context) {
        const response = await fetchAskList();
        context.commit('SET_ASK', response.data);
        return response;
    },
};
