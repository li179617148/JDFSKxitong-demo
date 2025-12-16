<template>
  <div class="forwarder-maintenance">
    <!-- 查询筛选模块 -->
    <div class="card filter-card">
      <div class="filter-grid">
        <div class="filter-item">
          <label>货代商名称：</label>
          <input v-model="filters.name" type="text" placeholder="请输入货代商名称" />
        </div>
        <div class="filter-item">
          <label>联系人：</label>
          <input v-model="filters.contact" type="text" placeholder="请输入联系人" />
        </div>
        <div class="filter-item">
          <label>联系电话：</label>
          <input v-model="filters.phone" type="text" placeholder="请输入联系电话" />
        </div>
        <div class="filter-item">
          <label>服务区域：</label>
          <select v-model="filters.serviceArea">
            <option value="">全部</option>
            <option v-for="area in options.serviceAreas" :key="area" :value="area">{{ area }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>状态：</label>
          <select v-model="filters.status">
            <option value="">全部</option>
            <option value="active">启用</option>
            <option value="inactive">停用</option>
          </select>
        </div>
        <div class="filter-item filter-actions">
          <button class="btn btn-primary" @click="handleSearch">查询</button>
          <button class="btn btn-secondary" @click="handleReset">重置</button>
        </div>
      </div>
    </div>

    <!-- 操作按钮区域 -->
    <div class="card action-card">
      <button class="btn btn-success" @click="handleAdd">
        <span class="btn-icon">+</span>新增
      </button>
      <button class="btn btn-warning" @click="handleDownloadTemplate">
        <span class="btn-icon">↓</span>下载模板
      </button>
      <button class="btn btn-info" @click="handleImport">
        <span class="btn-icon">↓</span>导入
      </button>
      <button class="btn btn-danger" @click="handleBatchDelete" :disabled="selectedRows.length === 0">
        <span class="btn-icon">✕</span>批量删除
      </button>
    </div>

    <!-- 文件导入弹窗 -->
    <div v-if="showImportModal" class="modal-overlay" @click="handleImportModalClose">
      <div class="modal-content import-modal" @click.stop>
        <div class="modal-header">
          <h3>导入货代商信息</h3>
          <button class="modal-close" @click="handleImportModalClose">×</button>
        </div>
        <div class="modal-body">
          <div class="import-section">
            <div class="upload-area" @drop="handleDrop" @dragover.prevent @dragenter.prevent>
              <div class="upload-content">
                <div class="upload-icon">📁</div>
                <div class="upload-text">拖拽文件到此处，或</div>
                <button class="btn btn-primary" @click="triggerFileInput">选择文件</button>
                <div class="upload-hint">支持 .xlsx, .xls 格式文件</div>
              </div>
              <input 
                ref="fileInput" 
                type="file" 
                accept=".xlsx,.xls" 
                @change="handleFileSelect" 
                style="display: none;"
              />
            </div>
            
            <div v-if="importFile" class="selected-file">
              <div class="file-info">
                <span class="file-name">📄 {{ importFile.name }}</span>
                <span class="file-size">({{ formatFileSize(importFile.size) }})</span>
              </div>
              <button class="btn btn-danger btn-small" @click="clearSelectedFile">移除</button>
            </div>

            <div class="import-rules">
              <h4>导入规则：</h4>
              <ul>
                <li>请使用提供的模板格式</li>
                <li>货代商名称、联系人、联系电话为必填项</li>
                <li>状态字段请填入：active(启用) 或 inactive(停用)</li>
                <li>服务类型请填入：海运、空运、陆运、多式联运</li>
                <li>服务区域请填入：国内、国际、东南亚、欧美、全球</li>
              </ul>
            </div>

            <div v-if="importErrors.length > 0" class="import-errors">
              <h4>导入错误：</h4>
              <div class="error-list">
                <div v-for="(error, index) in importErrors" :key="index" class="error-item">
                  第{{ error.row }}行: {{ error.message }}
                </div>
              </div>
            </div>

            <div v-if="importSuccess" class="import-success">
              <div class="success-icon">✅</div>
              <div class="success-text">导入成功！共导入 {{ importSuccessCount }} 条记录</div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="handleImportModalClose">取消</button>
          <button class="btn btn-primary" @click="handleImportSubmit" :disabled="!importFile || importErrors.length > 0">
            开始导入
          </button>
        </div>
      </div>
    </div>

    <!-- 数据表格 -->
    <div class="card table-card">
      <div class="table-header">
        <h3>货代信息列表</h3>
        <span class="record-count">共 {{ tableData.length }} 条记录</span>
      </div>
      
      <div class="table-wrapper">
        <table class="data-table">
          <thead>
            <tr>
              <th class="checkbox-col">
                <input type="checkbox" v-model="selectAll" @change="handleSelectAll" />
              </th>
              <th>货代商名称</th>
              <th>联系人</th>
              <th>联系电话</th>
              <th>邮箱</th>
              <th>服务区域</th>
              <th>服务类型</th>
              <th>状态</th>
              <th>创建时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, index) in tableData" :key="row.id">
              <td class="checkbox-col">
                <input type="checkbox" v-model="selectedRows" :value="row.id" />
              </td>
              <td>{{ row.name }}</td>
              <td>{{ row.contact }}</td>
              <td>{{ row.phone }}</td>
              <td>{{ row.email }}</td>
              <td>{{ row.serviceArea }}</td>
              <td>{{ row.serviceType }}</td>
              <td>
                <span class="status-tag" :class="row.status">
                  {{ row.status === 'active' ? '启用' : '停用' }}
                </span>
              </td>
              <td>{{ row.createTime }}</td>
              <td class="action-col">
                <button class="btn-text btn-text-primary" @click="handleEdit(row)">编辑</button>
                <button class="btn-text btn-text-danger" @click="handleDelete(row)">删除</button>
              </td>
            </tr>
            <tr v-if="tableData.length === 0">
              <td colspan="10" class="empty-data">暂无数据</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 新增/编辑弹窗 -->
    <div v-if="showModal" class="modal-overlay" @click="handleModalClose">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ modalTitle }}</h3>
          <button class="modal-close" @click="handleModalClose">×</button>
        </div>
        <div class="modal-body">
          <form class="form-grid">
            <div class="form-item">
              <label class="required">货代商名称：</label>
              <input v-model="formData.name" type="text" required />
            </div>
            <div class="form-item">
              <label class="required">联系人：</label>
              <input v-model="formData.contact" type="text" required />
            </div>
            <div class="form-item">
              <label class="required">联系电话：</label>
              <input v-model="formData.phone" type="text" required />
            </div>
            <div class="form-item">
              <label>邮箱：</label>
              <input v-model="formData.email" type="email" />
            </div>
            <div class="form-item">
              <label class="required">服务区域：</label>
              <select v-model="formData.serviceArea" required>
                <option value="">请选择</option>
                <option v-for="area in options.serviceAreas" :key="area" :value="area">{{ area }}</option>
              </select>
            </div>
            <div class="form-item">
              <label class="required">服务类型：</label>
              <select v-model="formData.serviceType" required>
                <option value="">请选择</option>
                <option value="海运">海运</option>
                <option value="空运">空运</option>
                <option value="陆运">陆运</option>
                <option value="多式联运">多式联运</option>
              </select>
            </div>
            <div class="form-item">
              <label>地址：</label>
              <input v-model="formData.address" type="text" />
            </div>
            <div class="form-item">
              <label>备注：</label>
              <textarea v-model="formData.remark" rows="3"></textarea>
            </div>
            <div class="form-item">
              <label class="required">状态：</label>
              <select v-model="formData.status" required>
                <option value="active">启用</option>
                <option value="inactive">停用</option>
              </select>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="handleModalClose">取消</button>
          <button class="btn btn-primary" @click="handleSubmit">确定</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ForwarderMaintenance',
  data() {
    return {
      filters: {
        name: '',
        contact: '',
        phone: '',
        serviceArea: '',
        status: ''
      },
      options: {
        serviceAreas: ['国内', '国际', '东南亚', '欧美', '全球']
      },
      tableData: [
        {
          id: 1,
          name: '中外运物流有限公司',
          contact: '张三',
          phone: '13800138001',
          email: 'zhangsan@sinotrans.com',
          serviceArea: '全球',
          serviceType: '多式联运',
          status: 'active',
          createTime: '2024-01-15'
        },
        {
          id: 2,
          name: '顺丰速运',
          contact: '李四',
          phone: '13900139002',
          email: 'lisi@sf-express.com',
          serviceArea: '国内',
          serviceType: '陆运',
          status: 'active',
          createTime: '2024-01-20'
        },
        {
          id: 3,
          name: 'DHL国际快递',
          contact: '王五',
          phone: '13700137003',
          email: 'wangwu@dhl.com',
          serviceArea: '国际',
          serviceType: '空运',
          status: 'active',
          createTime: '2024-02-01'
        }
      ],
      selectedRows: [],
      selectAll: false,
      showModal: false,
      modalTitle: '新增货代信息',
      isEdit: false,
      formData: {
        id: null,
        name: '',
        contact: '',
        phone: '',
        email: '',
        serviceArea: '',
        serviceType: '',
        address: '',
        remark: '',
        status: 'active'
      },
      // 导入相关数据
      showImportModal: false,
      importFile: null,
      importErrors: [],
      importSuccess: false,
      importSuccessCount: 0
    }
  },
  watch: {
    selectedRows(newVal) {
      this.selectAll = newVal.length === this.tableData.length && this.tableData.length > 0
    }
  },
  methods: {
    handleSearch() {
      console.log('查询条件:', this.filters)
      // 这里实现查询逻辑
    },
    handleReset() {
      this.filters = {
        name: '',
        contact: '',
        phone: '',
        serviceArea: '',
        status: ''
      }
    },
    handleAdd() {
      this.modalTitle = '新增货代信息'
      this.isEdit = false
      this.formData = {
        id: null,
        name: '',
        contact: '',
        phone: '',
        email: '',
        serviceArea: '',
        serviceType: '',
        address: '',
        remark: '',
        status: 'active'
      }
      this.showModal = true
    },
    handleEdit(row) {
      this.modalTitle = '编辑货代'
      this.isEdit = true
      this.formData = { ...row }
      this.showModal = true
    },
    handleDelete(row) {
      if (confirm(`确定要删除货代"${row.name}"吗？`)) {
        this.tableData = this.tableData.filter(item => item.id !== row.id)
        this.selectedRows = this.selectedRows.filter(id => id !== row.id)
        console.log('删除货代:', row)
      }
    },
    handleBatchEdit() {
      alert(`批量修改 ${this.selectedRows.length} 条记录`)
    },
    handleBatchDelete() {
      if (confirm(`确定要删除选中的 ${this.selectedRows.length} 条记录吗？`)) {
        this.tableData = this.tableData.filter(item => !this.selectedRows.includes(item.id))
        this.selectedRows = []
      }
    },
    handleSelectAll() {
      if (this.selectAll) {
        this.selectedRows = this.tableData.map(item => item.id)
      } else {
        this.selectedRows = []
      }
    },
    handleModalClose() {
      this.showModal = false
    },
    handleSubmit() {
      if (!this.formData.name || !this.formData.contact || !this.formData.phone) {
        alert('请填写必填项！')
        return
      }
      
      if (this.isEdit) {
        const index = this.tableData.findIndex(item => item.id === this.formData.id)
        if (index !== -1) {
          this.tableData.splice(index, 1, { ...this.formData })
        }
      } else {
        const newId = Math.max(...this.tableData.map(item => item.id)) + 1
        this.tableData.push({
          ...this.formData,
          id: newId,
          createTime: new Date().toISOString().split('T')[0]
        })
      }
      
      this.showModal = false
      alert(this.isEdit ? '修改成功！' : '新增成功！')
    },

    // 导入相关方法
    handleDownloadTemplate() {
      // 生成Excel模板数据
      const templateData = [
        {
          '货代商名称': '中外运物流有限公司',
          '联系人': '张三',
          '联系电话': '13800138001',
          '邮箱': 'zhangsan@sinotrans.com',
          '服务区域': '全球',
          '服务类型': '多式联运',
          '地址': '北京市朝阳区某某路123号',
          '备注': '主要承接国际货运业务',
          '状态': 'active'
        },
        {
          '货代商名称': '顺丰速运',
          '联系人': '李四',
          '联系电话': '13900139002',
          '邮箱': 'lisi@sf-express.com',
          '服务区域': '国内',
          '服务类型': '陆运',
          '地址': '深圳市南山区某某大道456号',
          '备注': '国内快递业务',
          '状态': 'active'
        }
      ]

      // 创建CSV格式的模板（简单实现，实际项目中可使用xlsx库）
      const headers = ['货代商名称', '联系人', '联系电话', '邮箱', '服务区域', '服务类型', '地址', '备注', '状态']
      const csvContent = [
        headers.join(','),
        ...templateData.map(row => headers.map(header => `"${row[header] || ''}"`).join(','))
      ].join('\n')

      // 下载文件
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
      const link = document.createElement('a')
      if (link.download !== undefined) {
        const url = URL.createObjectURL(blob)
        link.setAttribute('href', url)
        link.setAttribute('download', '货代商信息导入模板.csv')
        link.style.visibility = 'hidden'
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
      }
    },

    handleImport() {
      this.showImportModal = true
      this.resetImportState()
    },

    handleImportModalClose() {
      this.showImportModal = false
      this.resetImportState()
    },

    resetImportState() {
      this.importFile = null
      this.importErrors = []
      this.importSuccess = false
      this.importSuccessCount = 0
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = ''
      }
    },

    triggerFileInput() {
      this.$refs.fileInput.click()
    },

    handleFileSelect(event) {
      const file = event.target.files[0]
      if (file) {
        this.processFile(file)
      }
    },

    handleDrop(event) {
      event.preventDefault()
      const file = event.dataTransfer.files[0]
      if (file && (file.type.includes('sheet') || file.name.endsWith('.xlsx') || file.name.endsWith('.xls'))) {
        this.processFile(file)
      } else {
        alert('请选择Excel文件（.xlsx或.xls格式）')
      }
    },

    processFile(file) {
      this.importFile = file
      this.importErrors = []
      this.importSuccess = false
      
      // 这里应该解析Excel文件，现在用模拟数据
      setTimeout(() => {
        // 模拟解析结果
        this.importErrors = []
        this.importSuccess = true
        this.importSuccessCount = 2
      }, 1000)
    },

    clearSelectedFile() {
      this.importFile = null
      this.importErrors = []
      this.importSuccess = false
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = ''
      }
    },

    async handleImportSubmit() {
      if (!this.importFile) {
        alert('请选择要导入的文件')
        return
      }

      if (this.importErrors.length > 0) {
        alert('请先修复导入错误')
        return
      }

      try {
        // 模拟导入数据处理
        const importedData = [
          {
            id: Math.max(...this.tableData.map(item => item.id)) + 1,
            name: '新导入货代商1',
            contact: '联系人1',
            phone: '13800138003',
            email: 'test1@example.com',
            serviceArea: '国内',
            serviceType: '陆运',
            status: 'active',
            createTime: new Date().toISOString().split('T')[0]
          },
          {
            id: Math.max(...this.tableData.map(item => item.id)) + 2,
            name: '新导入货代商2',
            contact: '联系人2',
            phone: '13800138004',
            email: 'test2@example.com',
            serviceArea: '国际',
            serviceType: '海运',
            status: 'active',
            createTime: new Date().toISOString().split('T')[0]
          }
        ]

        // 添加到表格数据
        this.tableData = [...this.tableData, ...importedData]
        
        this.showImportModal = false
        this.resetImportState()
        alert(`成功导入 ${importedData.length} 条记录！`)
        
      } catch (error) {
        console.error('导入失败:', error)
        alert('导入失败，请检查文件格式')
      }
    },

    formatFileSize(bytes) {
      if (bytes === 0) return '0 Bytes'
      const k = 1024
      const sizes = ['Bytes', 'KB', 'MB', 'GB']
      const i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
    }
  }
}
</script>

<style scoped>
.forwarder-maintenance {
  padding: 20px;
}

.card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.filter-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  align-items: center;
}

.filter-item {
  display: flex;
  align-items: center;
  min-width: 0;
}

.filter-item label {
  width: 100px;
  font-weight: 500;
  color: #333;
  font-size: 14px;
  flex-shrink: 0;
  white-space: nowrap;
}

.filter-item input,
.filter-item select {
  flex: 1;
  min-width: 0;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.filter-actions {
  grid-column: span 2;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.action-card {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  flex-wrap: wrap;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.table-header h3 {
  margin: 0;
  color: #333;
}

.record-count {
  color: #666;
  font-size: 14px;
}

.table-wrapper {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th,
.data-table td {
  padding: 12px;
  text-align: center;
  border-bottom: 1px solid #eee;
}

.data-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
}

.checkbox-col {
  width: 40px;
  text-align: center;
}

.action-col {
  display: flex;
  justify-content: center;
  gap: 10px;
}

.status-tag {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.status-tag.active {
  background: #e6f7e6;
  color: #52c41a;
}

.status-tag.inactive {
  background: #fff2e6;
  color: #fa8c16;
}

.empty-data {
  text-align: center;
  color: #999;
  padding: 40px !important;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 8px;
  width: 800px;
  max-width: 90vw;
  max-height: 90vh;
  overflow: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
}

.modal-header h3 {
  margin: 0;
  color: #333;
}

.modal-close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #999;
}

.modal-body {
  padding: 20px;
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 15px;
}

.form-item {
  display: flex;
  flex-direction: column;
}

.form-item label {
  margin-bottom: 8px;
  font-weight: 500;
  color: #333;
}

.form-item label.required::before {
  content: '* ';
  color: #f5222d;
}

.form-item input,
.form-item select,
.form-item textarea {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.form-item textarea {
  resize: vertical;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid #eee;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.btn-primary {
  background: #3b82f6;
  color: white;
}

.btn-primary:hover {
  background: #2563eb;
}

.btn-secondary {
  background: #f0f0f0;
  color: #333;
}

.btn-secondary:hover {
  background: #e0e0e0;
}

.btn-success {
  background: #10b981;
  color: white;
}

.btn-success:hover {
  background: #059669;
}

.btn-warning {
  background: #f59e0b;
  color: white;
}

.btn-warning:hover {
  background: #d97706;
}

.btn-warning:disabled {
  background: #d1d5db;
  color: #9ca3af;
  cursor: not-allowed;
}

.btn-danger {
  background: #ef4444;
  color: white;
}

.btn-danger:hover {
  background: #dc2626;
}

.btn-danger:disabled {
  background: #d1d5db;
  color: #9ca3af;
  cursor: not-allowed;
}

.btn-text {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 14px;
  padding: 4px 8px;
}

.btn-text-primary {
  color: #3b82f6;
}

.btn-text-primary:hover {
  color: #2563eb;
}

.btn-text-danger {
  color: #ef4444;
}

.btn-text-danger:hover {
  color: #dc2626;
}

.btn-icon {
  font-weight: bold;
}

/* 导入功能样式 */
.import-modal {
  width: 600px;
}

.import-section {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.upload-area {
  border: 2px dashed #d9d9d9;
  border-radius: 8px;
  padding: 40px 20px;
  text-align: center;
  transition: border-color 0.3s;
  cursor: pointer;
}

.upload-area:hover {
  border-color: #3b82f6;
}

.upload-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

.upload-icon {
  font-size: 48px;
  color: #d9d9d9;
}

.upload-text {
  font-size: 16px;
  color: #666;
}

.upload-hint {
  font-size: 12px;
  color: #999;
  margin-top: 10px;
}

.selected-file {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px;
  background: #f5f5f5;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
}

.file-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.file-name {
  font-weight: 500;
  color: #333;
}

.file-size {
  color: #666;
  font-size: 14px;
}

.btn-small {
  padding: 4px 8px;
  font-size: 12px;
}

.import-rules {
  background: #f0f8ff;
  border: 1px solid #b3d9ff;
  border-radius: 6px;
  padding: 15px;
}

.import-rules h4 {
  margin: 0 0 10px 0;
  color: #1890ff;
  font-size: 14px;
}

.import-rules ul {
  margin: 0;
  padding-left: 20px;
  color: #666;
  font-size: 13px;
}

.import-rules li {
  margin-bottom: 5px;
}

.import-errors {
  background: #fff2f0;
  border: 1px solid #ffccc7;
  border-radius: 6px;
  padding: 15px;
}

.import-errors h4 {
  margin: 0 0 10px 0;
  color: #f5222d;
  font-size: 14px;
}

.error-list {
  max-height: 200px;
  overflow-y: auto;
}

.error-item {
  padding: 5px 0;
  color: #f5222d;
  font-size: 13px;
  border-bottom: 1px solid #ffccc7;
}

.error-item:last-child {
  border-bottom: none;
}

.import-success {
  display: flex;
  align-items: center;
  gap: 10px;
  background: #f6ffed;
  border: 1px solid #b7eb8f;
  border-radius: 6px;
  padding: 15px;
}

.success-icon {
  font-size: 24px;
  color: #52c41a;
}

.success-text {
  color: #52c41a;
  font-weight: 500;
}

.btn-info {
  background: #17a2b8;
  color: white;
}

.btn-info:hover {
  background: #138496;
}

.btn-info:disabled {
  background: #d1d5db;
  color: #9ca3af;
  cursor: not-allowed;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .action-card {
    justify-content: center;
    flex-direction: column;
    gap: 8px;
  }
  
  .action-card .btn {
    width: 100%;
    max-width: 200px;
    justify-content: center;
  }
  
  .import-modal {
    width: 95vw;
    margin: 10px;
  }
  
  .selected-file {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .file-info {
    width: 100%;
    justify-content: space-between;
  }
}
</style>
