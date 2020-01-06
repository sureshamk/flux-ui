import Vue from 'vue';
import App from './App.vue';
import { ClientTable } from 'vue-tables-2';
Vue.prototype.base_api =  window.BASE_API || '/'
Vue.config.productionTip = false;
// eslint-disable-next-line no-undef
Vue.use(ClientTable, {
  theme: 'bootstrap4'
  // theme: 'bulma'
});
import VueSweetalert2 from 'vue-sweetalert2';

// If you don't need the styles, do not connect
import 'sweetalert2/dist/sweetalert2.min.css';

Vue.use(VueSweetalert2);
new Vue({
  render: h => h(App),
}).$mount('#app');
