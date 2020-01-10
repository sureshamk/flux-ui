import Vue from 'vue';
import App from './App.vue';
Vue.prototype.base_api =  window.BASE_API || '/'
Vue.config.productionTip = false;

new Vue({
  render: h => h(App),
}).$mount('#app');
