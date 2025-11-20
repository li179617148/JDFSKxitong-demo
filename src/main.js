import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import './assets/styles/common.css'
import './assets/styles/table-styles.css'
import './assets/styles/button-styles.css'

const app = createApp(App)
app.use(router)
app.mount('#app')