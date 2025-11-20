<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h1>资源管理系统</h1>
        <p>欢迎登录</p>
      </div>
      <form class="login-form" @submit.prevent="handleLogin">
        <div class="form-group">
          <input 
            type="text" 
            v-model="username" 
            placeholder="用户名" 
            required
          >
        </div>
        <div class="form-group">
          <input 
            type="password" 
            v-model="password" 
            placeholder="密码" 
            required
          >
        </div>
        <button type="submit" class="btn-primary btn-block">登录</button>
      </form>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'Login',
  data() {
    return {
      username: '',
      password: ''
    }
  },
  methods: {
    handleLogin() {
      // 模拟登录成功，直接跳转到价格查询页面
      this.$router.push('/home?menu=material')
    }
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  padding-top: 220px;
  background: linear-gradient(135deg, #1890ff 0%, #096dd9 100%);
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.login-box {
  background: white;
  padding: 50px;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  width: 480px;
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-header h1 {
  color: #1890ff;
  font-size: 32px;
  margin-bottom: 15px;
  font-weight: 600;
}

.login-header p {
  color: #666;
  font-size: 16px;
  margin-bottom: 5px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group input {
  width: 100%;
  padding: 16px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 16px;
  transition: border-color 0.3s;
}

.form-group input:focus {
  outline: none;
  border-color: #1890ff;
}

/* 移除自定义登录按钮样式，使用全局按钮样式 */
.btn-block {
  width: 100%;
}
</style>