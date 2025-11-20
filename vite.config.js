import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  base: '/JDFSKxitong-demo/', // 添加GitHub Pages基础路径
  plugins: [vue()],
  server: {
    port: 3000,
    open: true,
    host: true // 允许外网访问
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  }
})