<template>
  <div class="price-add">
    <div class="page-header">
      <h2>价格维护新增</h2>
      <div class="header-actions">
        <button class="btn-primary" @click="handleSubmit">提交</button>
        <button class="btn-primary" @click="handleSave">保存</button>
        <button class="btn-secondary" @click="handleCancel">取消</button>
      </div>
    </div>

    <!-- 填报信息区域 -->
    <div class="form-section report-info-section">
      <h3 class="section-title">填报信息</h3>
      <div class="report-info-row">
        <div class="form-item inline">
          <label>填报日期：</label>
          <input type="date" v-model="formData.reportDate" disabled>
        </div>
        <div class="form-item inline">
          <label>填报人：</label>
          <input type="text" v-model="formData.reporter" disabled>
        </div>
      </div>
    </div>

    <!-- 价格维护表单区域 -->
    <div class="form-section">
      <h3 class="section-title">价格维护</h3>
      
      <!-- 完整价格信息表格 -->
      <div class="price-table-section">
        <div class="table-header">
          <h4>价格信息清单</h4>
          <button class="btn-primary" @click="addEquipmentRow">添加装备</button>
        </div>
        
        <div class="table-container">
          <table class="equipment-table">
            <thead>
              <tr>
                <th>序号</th>
                <th>一级分类</th>
                <th>二级分类</th>
                <th>三级分类</th>
                <th>四级分类</th>
                <th>装备名称</th>
                <th>物资装备编码</th>
                <th>单位</th>
                <th>型号</th>
                <th>规格</th>
                <th>出厂价EXW（元）</th>
                <th>国内港口车板交货价（元）</th>
                <th>价格采集时间</th>
                <th>币种</th>
                <th>数据来源</th>
                <th>项目名称</th>
                <th>合作方名称</th>
                <th>附件</th>
                <th>操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in formData.equipmentList" :key="index">
                <td>{{ index + 1 }}</td>
                <td>
                  <select v-model="item.level1Category" @change="handleLevel1Change(index)">
                    <option value="">请选择</option>
                    <option v-for="cat in categoryOptions.level1" :key="cat.value" :value="cat.value">
                      {{ cat.label }}
                    </option>
                  </select>
                </td>
                <td>
                  <select v-model="item.level2Category" @change="handleLevel2Change(index)" :disabled="!item.level1Category">
                    <option value="">请选择</option>
                    <option v-for="cat in item.level2Options" :key="cat.value" :value="cat.value">
                      {{ cat.label }}
                    </option>
                  </select>
                </td>
                <td>
                  <select v-model="item.level3Category" @change="handleLevel3Change(index)" :disabled="!item.level2Category">
                    <option value="">请选择</option>
                    <option v-for="cat in item.level3Options" :key="cat.value" :value="cat.value">
                      {{ cat.label }}
                    </option>
                  </select>
                </td>
                <td>
                  <select v-model="item.level4Category" :disabled="!item.level3Category">
                    <option value="">请选择</option>
                    <option v-for="cat in item.level4Options" :key="cat.value" :value="cat.value">
                      {{ cat.label }}
                    </option>
                  </select>
                </td>
                <td>
                  <select v-model="item.equipmentName" @change="handleEquipmentChange(index)">
                    <option value="">请选择</option>
                    <option v-for="eq in equipmentOptions" :key="eq.value" :value="eq.value">
                      {{ eq.label }}
                    </option>
                  </select>
                </td>
                <td>
                  <input type="text" v-model="item.equipmentCode" placeholder="请输入编码">
                </td>
                <td>
                  <input type="text" v-model="item.unit" placeholder="" readonly>
                </td>
                <td>
                  <input type="text" v-model="item.model" placeholder="" readonly>
                </td>
                <td>
                  <input type="text" v-model="item.specification" placeholder="" readonly>
                </td>
                <td>
                  <input type="number" v-model="item.exwPrice" placeholder="请输入出厂价" step="0.01" min="0">
                </td>
                <td>
                  <input type="number" v-model="item.deliveryPrice" placeholder="请输入交货价" step="0.01" min="0">
                </td>
                <td>
                  <input type="date" v-model="item.collectionTime">
                </td>
                <td>
                  <select v-model="item.currency">
                    <option value="CNY">人民币(CNY)</option>
                    <option value="USD">美元(USD)</option>
                    <option value="EUR">欧元(EUR)</option>
                    <option value="JPY">日元(JPY)</option>
                  </select>
                </td>
                <td>
                  <select v-model="item.dataSource">
                    <option value="日常询价">日常询价</option>
                    <option value="实际采购价格">实际采购价格</option>
                    <option value="投标价格">投标价格</option>
                  </select>
                </td>
                <td>
                  <select v-model="item.projectName">
                    <option value="">请选择项目名称</option>
                    <option v-for="project in projectOptions" :key="project.id" :value="project.name">
                      {{ project.name }}
                    </option>
                  </select>
                </td>
                <td>
                  <select v-model="item.partnerName">
                    <option value="">请选择合作方名称</option>
                    <option v-for="partner in partnerOptions" :key="partner.id" :value="partner.name">
                      {{ partner.name }}
                    </option>
                  </select>
                </td>
                <td>
                  <div class="attachment-cell">
                    <input type="file" multiple @change="handleFileUpload($event, index)" :ref="`fileInput${index}`" class="file-input">
                    <div class="file-list" v-if="item.attachments && item.attachments.length > 0">
                      <div class="file-item" v-for="(file, fileIndex) in item.attachments" :key="fileIndex">
                        <span>{{ file.name }}</span>
                        <button class="btn-danger btn-xs" @click="removeFile(index, fileIndex)">删除</button>
                      </div>
                    </div>
                  </div>
                </td>
                <td>
                  <button class="btn-danger btn-sm" @click="removeEquipmentRow(index)">删除</button>
                </td>
              </tr>
              <tr v-if="formData.equipmentList.length === 0">
                <td colspan="19" class="empty-row">暂无装备数据，请点击"添加装备"按钮添加</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PriceAdd',
  data() {
    return {
      formData: {
        reportDate: this.getCurrentDate(),
        reporter: '张三',
        equipmentList: []
      },
      categoryOptions: {
        level1: [
          { value: 'civil', label: '土建工程' },
          { value: 'mechanical', label: '机械设备' },
          { value: 'electrical', label: '电气设备' },
          { value: 'material', label: '材料' }
        ]
      },
      equipmentOptions: [],
      projectOptions: [],
      partnerOptions: []
    }
  },
  created() {
    // 页面加载时获取项目和合作方数据
    this.loadProjectData();
    this.loadPartnerData();
    // 默认添加一行装备数据
    this.addEquipmentRow();
  },
  methods: {
    // 获取当前日期
    getCurrentDate() {
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0');
      const day = String(now.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    },
    
    // 添加装备行
    addEquipmentRow() {
      const newEquipment = {
        collectionTime: new Date().toISOString().split('T')[0], // 默认当前日期
        currency: 'CNY', // 默认人民币
        dataSource: '日常询价', // 默认数据来源
        projectName: '',
        partnerName: '',
        level1Category: '',
        level2Category: '',
        level3Category: '',
        level4Category: '',
        equipmentName: '',
        equipmentCode: '',
        unit: '',
        model: '',
        specification: '',
        exwPrice: '',
        deliveryPrice: '',
        attachments: [], // 每个装备都有自己的附件列表
        level2Options: [],
        level3Options: [],
        level4Options: []
      }
      this.formData.equipmentList.push(newEquipment)
    },
    
    // 删除装备行
    removeEquipmentRow(index) {
      this.formData.equipmentList.splice(index, 1)
    },
    
    // 分类变更处理
    handleLevel1Change(index) {
      // 根据一级分类加载二级分类
      const equipment = this.formData.equipmentList[index]
      equipment.level2Category = ''
      equipment.level3Category = ''
      equipment.level4Category = ''
      
      // 模拟异步加载二级分类数据
      setTimeout(() => {
        equipment.level2Options = this.getLevel2Categories(equipment.level1Category)
      }, 300)
    },
    
    handleLevel2Change(index) {
      // 根据二级分类加载三级分类
      const equipment = this.formData.equipmentList[index]
      equipment.level3Category = ''
      equipment.level4Category = ''
      
      // 模拟异步加载三级分类数据
      setTimeout(() => {
        equipment.level3Options = this.getLevel3Categories(equipment.level2Category)
      }, 300)
    },
    
    handleLevel3Change(index) {
      // 根据三级分类加载四级分类
      const equipment = this.formData.equipmentList[index]
      equipment.level4Category = ''
      
      // 模拟异步加载四级分类数据
      setTimeout(() => {
        equipment.level4Options = this.getLevel4Categories(equipment.level3Category)
      }, 300)
    },
    
    // 装备变更处理
    handleEquipmentChange(index) {
      const equipment = this.formData.equipmentList[index]
      // 根据装备名称自动填充单位、型号、规格等信息
      const selectedEquipment = this.equipmentOptions.find(eq => eq.value === equipment.equipmentName)
      if (selectedEquipment) {
        equipment.unit = selectedEquipment.unit || ''
        equipment.model = selectedEquipment.model || ''
        equipment.specification = selectedEquipment.specification || ''
      }
    },
    
    // 获取二级分类数据
    getLevel2Categories(level1Category) {
      if (level1Category === '建筑工程') {
        return [
          { value: '地基工程', label: '地基工程' },
          { value: '主体结构', label: '主体结构' }
        ]
      } else if (level1Category === '装饰装修') {
        return [
          { value: '室内装修', label: '室内装修' },
          { value: '外墙装饰', label: '外墙装饰' }
        ]
      } else if (level1Category === '安装工程') {
        return [
          { value: '电气安装', label: '电气安装' },
          { value: '管道安装', label: '管道安装' }
        ]
      }
      return []
    },
    
    // 获取三级分类数据
    getLevel3Categories(level2Category) {
      if (level2Category === '地基工程') {
        return [
          { value: '桩基工程', label: '桩基工程' },
          { value: '基坑支护', label: '基坑支护' }
        ]
      } else if (level2Category === '主体结构') {
        return [
          { value: '钢筋工程', label: '钢筋工程' },
          { value: '模板工程', label: '模板工程' }
        ]
      }
      return []
    },
    
    // 获取四级分类数据
    getLevel4Categories(level3Category) {
      if (level3Category === '桩基工程') {
        return [
          { value: '钻孔灌注桩', label: '钻孔灌注桩' },
          { value: '预制桩', label: '预制桩' }
        ]
      } else if (level3Category === '基坑支护') {
        return [
          { value: '土钉墙', label: '土钉墙' },
          { value: '地下连续墙', label: '地下连续墙' }
        ]
      }
      return []
    },
    
    handleFileUpload(event, rowIndex) {
      const files = event.target.files;
      for (let i = 0; i < files.length; i++) {
        this.formData.equipmentList[rowIndex].attachments.push(files[i]);
      }
      // 清空文件输入框
      event.target.value = '';
    },
    
    removeFile(rowIndex, fileIndex) {
      this.formData.equipmentList[rowIndex].attachments.splice(fileIndex, 1);
    },
    
    // 表单提交
    handleSubmit() {
      // 验证表单
      if (!this.validateForm()) {
        return;
      }
      
      // 构造提交数据
      const submitData = {
        ...this.formData,
        submitTime: new Date().toISOString(),
        status: '待审批'
      };
      
      // 这里应该调用API提交数据
      console.log('提交数据:', submitData);
      
      // 提交成功后的处理
      this.$message.success('价格信息提交成功，等待审批');
      this.$router.push('/price-maintenance');
    },
    
    // 保存草稿
    handleSave() {
      // 构造保存数据
      const saveData = {
        ...this.formData,
        saveTime: new Date().toISOString(),
        status: '草稿'
      };
      
      // 这里应该调用API保存数据
      console.log('保存草稿:', saveData);
      
      // 保存成功后的处理
      this.$message.success('价格信息已保存为草稿');
    },
    
    // 取消操作
    handleCancel() {
      if (confirm('确定要取消吗？所有未保存的数据将会丢失。')) {
        this.handleClose();
      }
    },
    
    handleClose() {
      // 通过事件通知父组件切换到价格维护菜单
      this.$emit('close');
    },
    
    // 表单验证
    validateForm() {
      // 检查装备列表是否为空
      if (this.formData.equipmentList.length === 0) {
        this.$message.error('请至少添加一个装备');
        return false;
      }
      
      // 检查每个装备的必填字段
      for (let i = 0; i < this.formData.equipmentList.length; i++) {
        const equipment = this.formData.equipmentList[i];
        const equipmentRequiredFields = [
          'collectionTime', 'currency', 'dataSource', 'projectName', 'partnerName',
          'level1Category', 'level2Category', 'level3Category', 'level4Category',
          'equipmentName', 'equipmentCode', 'exwPrice', 'deliveryPrice'
        ];
        
        for (const field of equipmentRequiredFields) {
          if (!equipment[field]) {
            this.$message.error(`第${i+1}行装备请填写${this.getFieldLabel(field)}`);
            return false;
          }
        }
        
        // 检查价格是否为负数
        if (parseFloat(equipment.exwPrice) < 0 || parseFloat(equipment.deliveryPrice) < 0) {
          this.$message.error(`第${i+1}行装备价格不能为负数`);
          return false;
        }
      }
      
      return true;
    },
    
    // 获取字段标签
    getFieldLabel(field) {
      const labelMap = {
        collectionTime: '价格采集时间',
        projectName: '项目名称',
        partnerName: '合作方名称',
        level1Category: '一级分类',
        level2Category: '二级分类',
        level3Category: '三级分类',
        level4Category: '四级分类',
        equipmentName: '装备名称',
        equipmentCode: '物资装备编码',
        exwPrice: '出厂价EXW',
        deliveryPrice: '国内港口车板交货价'
      };
      return labelMap[field] || field;
    },
    
    // 模拟从后端加载项目数据
    loadProjectData() {
      // 实际项目中这里会调用后端API获取项目数据
      // 模拟异步加载
      setTimeout(() => {
        this.projectOptions = [
          { id: 1, name: '北京地铁10号线项目' },
          { id: 2, name: '上海浦东机场扩建项目' },
          { id: 3, name: '深圳湾科技园区建设项目' },
          { id: 4, name: '广州城市轨道交通项目' },
          { id: 5, name: '成都天府国际机场项目' }
        ];
      }, 500);
    },
    
    // 模拟从后端加载合作方数据
    loadPartnerData() {
      // 实际项目中这里会调用后端API获取合作方数据
      // 模拟异步加载
      setTimeout(() => {
        this.partnerOptions = [
          { id: 1, name: '中铁建集团' },
          { id: 2, name: '中交集团' },
          { id: 3, name: '中建集团' },
          { id: 4, name: '中国中铁' },
          { id: 5, name: '中国铁建' }
        ];
      }, 500);
    }
  }
}
</script>

<style scoped>
.price-add {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding: 20px;
  background: #fafafa;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.page-header h2 {
  margin: 0;
  color: #333;
  font-size: 20px;
  font-weight: 700;
}

.header-actions {
  display: flex;
  gap: 12px;
}

.header-actions .btn-primary {
  padding: 8px 16px;
  font-size: 14px;
  background: #1890ff;
  border: 1px solid #1890ff;
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
}

.header-actions .btn-primary:hover {
  background: #40a9ff;
  border-color: #40a9ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(24, 144, 255, 0.3);
}

.header-actions .btn-secondary {
  padding: 8px 16px;
  font-size: 14px;
  background: #fff;
  border: 1px solid #d9d9d9;
  color: #333;
  font-weight: 600;
  transition: all 0.3s ease;
}

.header-actions .btn-secondary:hover {
  background: #f0f0f0;
  border-color: #1890ff;
  color: #1890ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.form-section {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  padding: 20px;
  margin-bottom: 20px;
}

.section-title {
  margin: 0 0 20px 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
  border-bottom: 2px solid #409eff;
  padding-bottom: 10px;
}

.common-info {
  margin-bottom: 30px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 4px;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.form-item {
  display: flex;
  flex-direction: column;
}

.form-item.full-width {
  grid-column: 1 / -1;
}

.form-item label {
  font-weight: 500;
  color: #333;
  font-size: 14px;
  margin-bottom: 5px;
}

.form-item label.required::after {
  content: ' *';
  color: #f56c6c;
}

.form-item input,
.form-item select,
.form-item textarea {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-item input:disabled,
.form-item select:disabled {
  background-color: #f5f7fa;
  cursor: not-allowed;
}

.attachment-area {
  border: 1px dashed #ddd;
  border-radius: 4px;
  padding: 20px;
  text-align: center;
}

.file-list {
  margin-top: 10px;
  text-align: left;
}

.file-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 5px 0;
  border-bottom: 1px solid #eee;
}

/* 表格样式 */
.equipment-table-section {
  margin-top: 24px;
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 0 10px;
}

.table-header h4 {
  margin: 0;
  font-size: 18px;
  color: #333;
  font-weight: 600;
}

.table-header .btn-primary {
  background: linear-gradient(135deg, #409eff, #66b1ff);
  border: none;
  border-radius: 6px;
  padding: 10px 20px;
  font-size: 14px;
  font-weight: 500;
  box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);
  transition: all 0.3s ease;
}

.table-header .btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.table-container {
  overflow-x: auto;
  overflow-y: hidden;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  background: white;
  max-height: 500px;
  min-height: 400px;
}

/* 始终显示滚动条 */
.table-container::-webkit-scrollbar {
  height: 8px;
}

.table-container::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.table-container::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}

.table-container::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

.equipment-table {
  min-width: 1800px; /* 设置最小宽度以确保所有列都能显示 */
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.equipment-table th {
  background-color: #409eff;
  color: white;
  font-weight: bold;
  text-align: center;
  padding: 14px 8px;
  border: 1px solid #409eff;
  white-space: nowrap;
  position: sticky;
  top: 0;
  z-index: 1;
  font-size: 14px;
  box-shadow: 0 2px 4px rgba(64, 158, 255, 0.3);
}

.equipment-table td {
  padding: 10px 8px;
  border: 1px solid #ebeef5;
  text-align: center;
  white-space: nowrap; /* 防止单元格内容换行 */
  background-color: white;
  transition: background-color 0.3s ease;
}

.equipment-table tr:hover td {
  background-color: #f0f7ff;
}

.equipment-table input,
.equipment-table select {
  width: 100%;
  padding: 5px;
  border: 1px solid #dcdfe6;
  border-radius: 3px;
  font-size: 13px;
}

.equipment-table input:focus,
.equipment-table select:focus {
  border-color: #409eff;
  outline: none;
}

.equipment-table input[readonly] {
  background-color: #f5f7fa;
  cursor: not-allowed;
}

.empty-row {
  text-align: center;
  color: #909399;
  font-style: italic;
}

/* 调整列宽 */
.equipment-table th:nth-child(1),
.equipment-table td:nth-child(1) { /* 序号列 */
  width: 60px;
  min-width: 60px;
}

.equipment-table th:nth-child(2),
.equipment-table td:nth-child(2) { /* 一级分类列 */
  width: 120px;
  min-width: 120px;
}

.equipment-table th:nth-child(3),
.equipment-table td:nth-child(3) { /* 二级分类列 */
  width: 120px;
  min-width: 120px;
}

.equipment-table th:nth-child(4),
.equipment-table td:nth-child(4) { /* 三级分类列 */
  width: 120px;
  min-width: 120px;
}

.equipment-table th:nth-child(5),
.equipment-table td:nth-child(5) { /* 四级分类列 */
  width: 120px;
  min-width: 120px;
}

.equipment-table th:nth-child(6),
.equipment-table td:nth-child(6) { /* 装备名称列 */
  width: 180px;
  min-width: 180px;
}

.equipment-table th:nth-child(7),
.equipment-table td:nth-child(7) { /* 物资装备编码列 */
  width: 150px;
  min-width: 150px;
}

.equipment-table th:nth-child(8),
.equipment-table td:nth-child(8) { /* 单位列 */
  width: 80px;
  min-width: 80px;
}

.equipment-table th:nth-child(9),
.equipment-table td:nth-child(9) { /* 型号列 */
  width: 120px;
  min-width: 120px;
}

.equipment-table th:nth-child(10),
.equipment-table td:nth-child(10) { /* 规格列 */
  width: 150px;
  min-width: 150px;
}

.equipment-table th:nth-child(11),
.equipment-table td:nth-child(11) { /* 出厂价EXW列 */
  width: 120px;
  min-width: 120px;
}

.equipment-table th:nth-child(12),
.equipment-table td:nth-child(12) { /* 国内港口车板交货价列 */
  width: 120px;
  min-width: 120px;
}

.equipment-table th:nth-child(13),
.equipment-table td:nth-child(13) { /* 价格采集时间列 */
  width: 150px;
  min-width: 150px;
}

.equipment-table th:nth-child(14),
.equipment-table td:nth-child(14) { /* 币种列 */
  width: 100px;
  min-width: 100px;
}

.equipment-table th:nth-child(15),
.equipment-table td:nth-child(15) { /* 数据来源列 */
  width: 150px;
  min-width: 150px;
}

.equipment-table th:nth-child(16),
.equipment-table td:nth-child(16) { /* 项目名称列 */
  width: 200px;
  min-width: 200px;
}

.equipment-table th:nth-child(17),
.equipment-table td:nth-child(17) { /* 合作方名称列 */
  width: 200px;
  min-width: 200px;
}

.equipment-table th:nth-child(18),
.equipment-table td:nth-child(18) { /* 附件列 */
  width: 200px;
  min-width: 200px;
}

.equipment-table th:nth-child(19),
.equipment-table td:nth-child(19) { /* 操作列 */
  width: 100px;
  min-width: 100px;
}

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
}

.btn-secondary {
  padding: 8px 16px;
  background: #67c23a;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-secondary:hover {
  background: #85ce61;
}

.btn-primary {
  background-color: #409eff;
  color: white;
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-primary:hover {
  background-color: #66b1ff;
}

.btn-danger {
  background-color: #f56c6c;
  color: white;
}

.btn-danger:hover {
  background-color: #f78989;
}

.btn-close {
  padding: 8px 16px;
  background: #909399;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-close:hover {
  background: #a6a9ad;
}

/* 填报信息区域样式 */
.report-info-section {
  /* 确保填报信息区域不受其他样式影响 */
}

.report-info-section .report-info-row {
  display: flex !important;
  flex-direction: row !important;
  gap: 20px !important;
  align-items: center !important;
  margin-bottom: 20px !important;
}

.report-info-section .form-item.inline {
  display: flex !important;
  flex-direction: row !important;
  align-items: center !important;
  gap: 10px !important;
  margin-bottom: 0 !important;
}

.report-info-section .form-item.inline label {
  margin-bottom: 0 !important;
  white-space: nowrap !important;
  flex-shrink: 0 !important;
}

.report-info-section .form-item.inline input {
  width: auto !important;
  min-width: 150px !important;
  flex-shrink: 0 !important;
}
</style>