<template>
  <div class="button-test-container">
    <h2>按钮样式统一测试页面</h2>
    <p>以下所有按钮（除了重置和关闭按钮）都应该显示为蓝色：</p>
    
    <div class="button-group">
      <h3>主要操作按钮</h3>
      <button class="btn-primary">主要按钮</button>
      <button class="btn-success">成功按钮（查看）</button>
      <button class="btn-warning">警告按钮（撤回）</button>
      <button class="btn-info">信息按钮（导入）</button>
      <button class="btn-secondary">重置按钮（保持灰色）</button>
      <button class="btn-danger">删除按钮（现为蓝色）</button>
    </div>
    
    <div class="button-group">
      <h3>表格操作按钮</h3>
      <div class="data-table">
        <table>
          <tbody>
            <tr>
              <td>
                <button class="btn-primary">编辑</button>
                <button class="btn-success">查看（蓝色）</button>
                <button class="btn-warning">撤回（蓝色）</button>
                <button class="btn-info">导入</button>
                <button class="btn-secondary">重置</button>
                <button class="btn-danger">删除（蓝色）</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    
    <div class="button-group">
      <h3>不同尺寸的按钮</h3>
      <button class="btn-primary btn-sm">小按钮</button>
      <button class="btn-success btn-sm">查看（小）</button>
      <button class="btn-primary">默认按钮</button>
      <button class="btn-success">查看（默认）</button>
      <button class="btn-warning">撤回（默认）</button>
      <button class="btn-danger">删除（默认）</button>
      <button class="btn-primary btn-lg">大按钮</button>
      <button class="btn-success btn-lg">查看（大）</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ButtonStyleTest'
}
</script>

<style scoped>
.button-test-container {
  padding: 40px;
  background: #f5f5f5;
  min-height: 100vh;
}

.button-group {
  margin: 30px 0;
  padding: 20px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.button-group h3 {
  margin-bottom: 15px;
  color: #333;
}

.button-group button {
  margin: 5px;
}

.data-table {
  background: white;
  padding: 20px;
  border-radius: 8px;
}

.data-table table {
  width: 100%;
}

.data-table td {
  padding: 15px;
  text-align: center;
}
</style>