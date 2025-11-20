<template>
  <div class="test-container">
    <h2>经营范围悬停显示功能测试</h2>
    <div class="test-section">
      <h3>测试用例：长文本复选框</h3>
      <div class="checkbox-group">
        <label v-for="option in testOptions" :key="option.value" class="checkbox-item" :title="option.label">
          <input type="checkbox" :value="option.value" v-model="selectedOptions">
          <span>{{ option.label }}</span>
        </label>
      </div>
    </div>
    
    <div class="test-section">
      <h3>当前选中的选项：</h3>
      <ul>
        <li v-for="option in selectedLabels" :key="option">{{ option }}</li>
      </ul>
    </div>
    
    <div class="test-section">
      <h3>测试说明：</h3>
      <ol>
        <li>将鼠标悬停在任意复选框标签上</li>
        <li>应该显示完整的文本内容</li>
        <li>长文本应该被截断并显示省略号</li>
        <li>悬停时应该显示黑色背景的tooltip</li>
      </ol>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BusinessScopeTooltipTest',
  data() {
    return {
      selectedOptions: [],
      testOptions: [
        { value: '建筑材料销售', label: '建筑材料销售（如钢材、水泥、电缆）' },
        { value: '机电设备销售', label: '机电设备销售（如空调、电梯、水泵）' },
        { value: '特种设备安装', label: '电梯、锅炉、起重机械等特种设备安装' },
        { value: '智能化系统安装', label: '智能化系统安装' },
        { value: '管道工程安装', label: '管道工程安装' }
      ]
    }
  },
  computed: {
    selectedLabels() {
      return this.selectedOptions.map(value => 
        this.testOptions.find(option => option.value === value)?.label || value
      )
    }
  }
}
</script>

<style scoped>
.test-container {
  padding: 20px;
  max-width: 800px;
  margin: 0 auto;
}

.test-section {
  margin-bottom: 30px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
  border: 1px solid #e8e8e8;
}

.test-section h3 {
  margin-top: 0;
  color: #1890ff;
}

.checkbox-group {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 5px;
}

.checkbox-item {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 3px 5px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 3px;
  background: #fafafa;
  border: 1px solid #e8e8e8;
  position: relative;
  overflow: visible;
  width: 180px;
  box-sizing: border-box;
}

.checkbox-item:hover {
  background: #e6f7ff;
  border-color: #40a9ff;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.15);
}

.checkbox-item input[type="checkbox"] {
  width: 14px;
  height: 14px;
  margin: 0;
  cursor: pointer;
  flex-shrink: 0;
}

.checkbox-item span {
  font-size: 12px;
  color: #2c3e50;
  line-height: 1.3;
  cursor: pointer;
  user-select: none;
  font-weight: 400;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 110px;
  display: inline-block;
}

/* Tooltip样式 - 与PartnerManagement组件相同 */
.checkbox-item[title]:hover::after {
  content: attr(title);
  position: absolute;
  top: -35px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 6px 10px;
  border-radius: 4px;
  font-size: 12px;
  white-space: nowrap;
  z-index: 1000;
  opacity: 0;
  animation: tooltipFadeIn 0.3s ease forwards;
  pointer-events: none;
}

.checkbox-item[title]:hover::before {
  content: '';
  position: absolute;
  top: -8px;
  left: 50%;
  transform: translateX(-50%);
  border: 4px solid transparent;
  border-top-color: rgba(0, 0, 0, 0.8);
  z-index: 1001;
  opacity: 0;
  animation: tooltipFadeIn 0.3s ease forwards;
}

@keyframes tooltipFadeIn {
  to {
    opacity: 1;
  }
}

ol {
  line-height: 1.8;
}

ul {
  line-height: 1.6;
}
</style>