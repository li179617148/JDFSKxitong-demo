<template>
  <div class="subcontract-logistics-test">
    <h2>包件物流维护测试页面</h2>
    <p>这是一个测试页面，用于验证路由是否正常工作。</p>
    
    <div class="test-data">
      <h3>测试数据</h3>
      <p>批次号：{{ testData.batchNumber }}</p>
      <p>序号：{{ testData.sequence }}</p>
      <p>项目名称：{{ testData.projectName }}</p>
      <p>包件名称：{{ testData.packageName }}</p>
    </div>

    <div class="actions">
      <button @click="goBack" class="btn btn-primary">返回首页</button>
      <button @click="testAlert" class="btn btn-secondary">测试弹窗</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'SubcontractLogisticsTest',
  data() {
    return {
      testData: {
        batchNumber: 'TEST-2024-001',
        sequence: 1,
        projectName: '测试项目',
        packageName: '测试包件'
      }
    }
  },
  methods: {
    goBack() {
      this.$router.push('/home')
    },
    testAlert() {
      alert('路由正常工作！')
    }
  }
}
</script>

<style scoped>
.subcontract-logistics-test {
  padding: 20px;
  background: white;
  border-radius: 8px;
  margin: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.test-data {
  margin: 20px 0;
  padding: 15px;
  background: #f5f5f5;
  border-radius: 4px;
}

.actions {
  display: flex;
  gap: 10px;
  margin-top: 20px;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-secondary {
  background: #f0f0f0;
  color: #333;
}
</style>