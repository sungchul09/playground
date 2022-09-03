import Vue from 'vue';
import VueRouter from 'vue-router';
import { store } from '@/store/index';

Vue.use(VueRouter);

const defaultValue = {
  page: 1,
  limit: 300,
};

export const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      redirect: (to) => {
        to.params.page = defaultValue.page;
        to.params.limit = defaultValue.limit;
        return {
          name: 'imageList',
        };
      },
    },
    {
      path: '/imageList/:page/:limit',
      name: 'imageList',
      component: () => import('@/views/ImageList.vue'),
    },
    {
      path: '/imageInfo/:id',
      name: 'imageInfo',
      component: () => import('@/views/ImageInfo.vue'),
    },
    {
      path: '*',
      component: () => import('@/views/NotFountPage.vue'),
    },
  ],
});

router.beforeEach((to, from, next) => {
  store.commit('startSpinner');
  next();
});

router.afterEach((to, from) => {
  setTimeout(() => {
    store.commit('endSpinner');
  }, 200);
  if (to.name === 'imageList') {
    store.commit('toggleBtnOn');
  } else if (to.name === 'imageInfo') {
    store.commit('toggleBtnOff');
  }
});
