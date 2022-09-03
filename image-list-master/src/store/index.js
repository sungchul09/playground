import Vue from 'vue';
import Vuex from 'vuex';
import { fetchImageList, fetchImageInfo } from '@/api/index';

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
    imageList: [],
    imageInfo: {},
    loadingStatus: false,
    toggleBtn: true,
  },
  getters: {
    getImageList(state) {
      return state.imageList;
    },
    getImageInfo(state) {
      return state.imageInfo;
    },
  },
  mutations: {
    // 이미지 데이터
    SET_IMAGELIST: function (state, data) {
      data.map((v) => {
        v.download_url = `${process.env.VUE_APP_API_URL}id/${v.id}/250`;
        v.link = `${process.env.VUE_APP_API_URL}id/${v.id}/${v.width}/${v.height}`;
      });
      state.imageList = data;
    },
    SET_IMAGEINFO: function (state, data) {
      data.link = `${process.env.VUE_APP_API_URL}id/${data.id}/${data.width}/${data.height}`;
      state.imageInfo = data;
    },
    // Spinner
    startSpinner(state) {
      state.loadingStatus = true;
    },
    endSpinner(state) {
      state.loadingStatus = false;
    },
    // 고정버튼
    toggleBtnOn(state) {
      state.toggleBtn = true;
    },
    toggleBtnOff(state) {
      state.toggleBtn = false;
    },
  },
  actions: {
    async FETCH_IMAGELIST({ commit }, { page, limit }) {
      const response = await fetchImageList(page, limit);
      commit('SET_IMAGELIST', response.data);
      return response;
    },
    async FETCH_IMAGEINFO({ commit }, id) {
      const response = await fetchImageInfo(id);
      commit('SET_IMAGEINFO', response.data);
      return response;
    },
  },
});
