Vue.use(VueRouter);

export const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: () => import('../views/dashboard.vue'),
    },
    {
      path: '/in/empin',
      component: () => import('../views/Inbound/EmpIn.vue'),
    },
    {
      path: '/out/empout',
      component: () => import('../views/Outbound/EmpOut.vue'),
    },
    {
      path: '/stock/find',
      component: () => import('../views/Stock/FindStock.vue'),
    },
  ],
});
