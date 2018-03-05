import * as Vue from 'vue';
import * as App from './App.vue';
import store from './store';
import './plugins/shell.ts';
// import * as iView from 'iview';
// import locale from 'iview/dist/locale/en-US';

// import './less/iview-custom.less';
import * as Vuetify from 'vuetify';

Vue.use(Vuetify, {
  theme: {
    primary: "#F4511E",
    secondary: "#FF7043",
    accent: "#E65100",
    error: "#f44336",
    warning: "#ffeb3b",
    info: "#2196f3",
    success: "#4caf50"
  }
});
// Vue.use(iView, { locale });

Vue.config.productionTip = false;

new Vue({
  store,
  render: (h) => h(App),
}).$mount('#app');
