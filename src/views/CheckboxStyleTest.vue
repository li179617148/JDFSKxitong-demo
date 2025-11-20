<template>
  <div class="checkbox-test">
    <h2>经营范围复选框样式统一测试</h2>
    
    <div class="test-section">
      <h3>设备与材料供应</h3>
      <div class="checkbox-group">
        <label class="checkbox-item">
          <input type="checkbox" value="construction-equipment">
          <span>建筑工程设备</span>
        </label>
        <label class="checkbox-item">
          <input type="checkbox" value="electrical-equipment">
          <span>电气工程设备</span>
        </label>
        <label class="checkbox-item">
          <input type="checkbox" value="mechanical-equipment">
          <span>机械设备</span>
        </label>
        <label class="checkbox-item">
          <input type="checkbox" value="decoration-materials">
          <span>装修材料</span>
        </label>
      </div>
    </div>

    <div class="test-section">
      <h3>专业安装服务</h3>
      <div class="checkbox-group">
        <label class="checkbox-item">
          <input type="checkbox" value="electrical-installation">
          <span>电气安装</span>
        </label>
        <label class="checkbox-item">
          <input type="checkbox" value="plumbing-installation">
          <span>管道安装</span>
        </label>
        <label class="checkbox-item">
          <input type="checkbox" value="hvac-installation">
          <span>暖通空调安装</span>
        </label>
        <label class="checkbox-item">
          <input type="checkbox" value="fire-protection">
          <span>消防系统安装</span>
        </label>
      </div>
    </div>

    <div class="test-info">
      <h4>样式标准：</h4>
      <ul>
        <li>复选框尺寸：16px × 16px</li>
        <li>边框颜色：#1890ff（蓝色主题）</li>
        <li>选中状态：背景#1890ff，边框#1890ff</li>
        <li>文字样式：14px，#2c3e50，微软雅黑</li>
        <li>间距：复选框与文字8px，组内项12px</li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CheckboxStyleTest'
}
</script>

<style scoped>
.checkbox-test {
  padding: 40px;
  background: #f0f2f5;
  min-height: 100vh;
}

.test-section {
  background: white;
  padding: 30px;
  margin-bottom: 30px;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(24, 144, 255, 0.1);
}

.test-section h3 {
  color: #1890ff;
  font-size: 18px;
  margin-bottom: 20px;
  font-weight: 600;
}

.test-info {
  background: white;
  padding: 30px;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(24, 144, 255, 0.1);
}

.test-info h4 {
  color: #2c3e50;
  font-size: 16px;
  margin-bottom: 15px;
}

.test-info ul {
  list-style: none;
  padding: 0;
}

.test-info li {
  padding: 8px 0;
  color: #666;
  font-size: 14px;
}

.test-info li::before {
  content: "✓";
  color: #1890ff;
  font-weight: bold;
  margin-right: 10px;
}

/* 复用PartnerManagement中的样式 */
.checkbox-group {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  align-items: flex-start;
}

.checkbox-item {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 6px;
  background: #fafafa;
  margin: 2px;
  flex: 0 0 220px;
  width: 220px;
  position: relative;
  box-sizing: border-box;
  overflow: hidden;
  border: 1px solid #e8e8e8;
}

.checkbox-item:hover {
  background: #e6f7ff;
  border-color: #40a9ff;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.15);
}

.checkbox-item input[type="checkbox"] {
  width: 16px;
  height: 16px;
  margin: 0;
  cursor: pointer;
  flex-shrink: 0;
  position: relative;
  display: inline-block;
  visibility: visible;
  opacity: 1;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  z-index: 2;
  border: 2px solid #1890ff;
  border-radius: 2px;
  background: white;
  transition: all 0.3s ease;
}

.checkbox-item input[type="checkbox"]:hover {
  border-color: #40a9ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.2);
}

.checkbox-item input[type="checkbox"]:checked {
  background: #1890ff;
  border-color: #1890ff;
}

.checkbox-item input[type="checkbox"]:checked::after {
  content: "";
  position: absolute;
  left: 4px;
  top: 1px;
  width: 5px;
  height: 10px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.checkbox-item span {
  font-size: 14px;
  color: #2c3e50;
  line-height: 1.5;
  cursor: pointer;
  user-select: none;
  font-weight: 400;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-family: 'Microsoft YaHei', '思源黑体', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.checkbox-item input[type="checkbox"]:checked + span {
  color: #1890ff;
  font-weight: 600;
}

.checkbox-item:has(input[type="checkbox"]:checked) {
  background: linear-gradient(135deg, #e6f7ff 0%, #f0f7ff 100%);
  border: 2px solid #1890ff;
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
}

/* 确保所有复选框统一标准 - 完美正方形 */
.checkbox-item input[type="checkbox"]::-webkit-inner-spin-button,
.checkbox-item input[type="checkbox"]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.checkbox-item input[type="checkbox"]::-ms-check {
  width: 16px;
  height: 16px;
  border: 2px solid #1890ff;
  background: white;
  border-radius: 2px;
  box-sizing: border-box;
}

.checkbox-item input[type="checkbox"]:checked::-ms-check {
  background: #1890ff;
  border-color: #1890ff;
  color: white;
}

/* 添加统一的焦点样式 */
.checkbox-item input[type="checkbox"]:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.2);
}

/* 确保在不同浏览器中显示一致 - 完美正方形 */
.checkbox-item input[type="checkbox"] {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  width: 16px;
  height: 16px;
  min-width: 16px;
  min-height: 16px;
  max-width: 16px;
  max-height: 16px;
  box-sizing: border-box !important;
  padding: 0 !important;
  margin: 0 !important;
  line-height: 16px !important;
  vertical-align: middle !important;
}

/* 防止浏览器默认样式影响 */
.checkbox-item input[type="checkbox"]:before,
.checkbox-item input[type="checkbox"]:after {
  content: none !important;
  display: none !important;
}

/* 确保Firefox中显示为正方形 */
@-moz-document url-prefix() {
  .checkbox-item input[type="checkbox"] {
    width: 16px !important;
    height: 16px !important;
    min-width: 16px !important;
    min-height: 16px !important;
    max-width: 16px !important;
    max-height: 16px !important;
  }
}
</style>