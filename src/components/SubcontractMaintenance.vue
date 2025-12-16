<template>
  <div class="subcontract-maintenance">
    <!-- 查询筛选模块 -->
    <div class="card filter-card">
      <div class="filter-grid">
        <div class="filter-item">
          <label>分包商名称：</label>
          <input v-model="filters.name" type="text" placeholder="请输入分包商名称" />
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
          <label>服务类型：</label>
          <select v-model="filters.serviceType">
            <option value="">全部</option>
            <option v-for="type in options.serviceTypes" :key="type" :value="type">{{ type }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>资质等级：</label>
          <select v-model="filters.qualificationLevel">
            <option value="">全部</option>
            <option v-for="level in options.qualificationLevels" :key="level" :value="level">{{ level }}</option>
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
        <span class="btn-icon">+</span>新增分包商
      </button>
      <button class="btn btn-warning" @click="handleBatchEdit" :disabled="selectedRows.length === 0">
        <span class="btn-icon">✏</span>批量修改
      </button>
      <button class="btn btn-danger" @click="handleBatchDelete" :disabled="selectedRows.length === 0">
        <span class="btn-icon">✕</span>批量删除
      </button>
    </div>

    <!-- 数据表格 -->
    <div class="card table-card">
      <div class="table-header">
        <h3>分包商列表</h3>
        <span class="record-count">共 {{ tableData.length }} 条记录</span>
      </div>
      
      <div class="table-wrapper">
        <table class="data-table">
          <thead>
            <tr>
              <th class="checkbox-col">
                <input type="checkbox" v-model="selectAll" @change="handleSelectAll" />
              </th>
              <th>分包商名称</th>
              <th>联系人</th>
              <th>联系电话</th>
              <th>邮箱</th>
              <th>服务类型</th>
              <th>资质等级</th>
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
              <td>{{ row.serviceType }}</td>
              <td>{{ row.qualificationLevel }}</td>
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
              <label class="required">分包商名称：</label>
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
              <label class="required">服务类型：</label>
              <select v-model="formData.serviceType" required>
                <option value="">请选择</option>
                <option v-for="type in options.serviceTypes" :key="type" :value="type">{{ type }}</option>
              </select>
            </div>
            <div class="form-item">
              <label class="required">资质等级：</label>
              <select v-model="formData.qualificationLevel" required>
                <option value="">请选择</option>
                <option v-for="level in options.qualificationLevels" :key="level" :value="level">{{ level }}</option>
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
  name: 'SubcontractMaintenance',
  data() {
    return {
      filters: {
        name: '',
        contact: '',
        phone: '',
        serviceType: '',
        qualificationLevel: ''
      },
      options: {
        serviceTypes: ['运输', '仓储', '装卸', '包装', '配送', '综合'],
        qualificationLevels: ['一级', '二级', '三级', '四级', '特级']
      },
      tableData: [
        {
          id: 1,
          name: '华东物流有限公司',
          contact: '赵六',
          phone: '13600136001',
          email: 'zhaoliu@huadong.com',
          serviceType: '运输',
          qualificationLevel: '一级',
          status: 'active',
          createTime: '2024-01-10'
        },
        {
          id: 2,
          name: '华南仓储服务公司',
          contact: '钱七',
          phone: '13500135002',
          email: 'qianqi@huanan.com',
          serviceType: '仓储',
          qualificationLevel: '二级',
          status: 'active',
          createTime: '2024-01-25'
        },
        {
          id: 3,
          name: '华北配送中心',
          contact: '孙八',
          phone: '13400134003',
          email: 'sunba@huabei.com',
          serviceType: '配送',
          qualificationLevel: '一级',
          status: 'inactive',
          createTime: '2024-02-05'
        }
      ],
      selectedRows: [],
      selectAll: false,
      showModal: false,
      modalTitle: '新增分包商',
      isEdit: false,
      formData: {
        id: null,
        name: '',
        contact: '',
        phone: '',
        email: '',
        serviceType: '',
        qualificationLevel: '',
        address: '',
        remark: '',
        status: 'active'
      }
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
        serviceType: '',
        qualificationLevel: ''
      }
    },
    handleAdd() {
      this.modalTitle = '新增分包商'
      this.isEdit = false
      this.formData = {
        id: null,
        name: '',
        contact: '',
        phone: '',
        email: '',
        serviceType: '',
        qualificationLevel: '',
        address: '',
        remark: '',
        status: 'active'
      }
      this.showModal = true
    },
    handleEdit(row) {
      this.modalTitle = '编辑分包商'
      this.isEdit = true
      this.formData = { ...row }
      this.showModal = true
    },
    handleDelete(row) {
      if (confirm(`确定要删除分包商"${row.name}"吗？`)) {
        this.tableData = this.tableData.filter(item => item.id !== row.id)
        this.selectedRows = this.selectedRows.filter(id => id !== row.id)
        console.log('删除分包商:', row)
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
    }
  }
}
</script>

<style scoped>
.subcontract-maintenance {
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
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 15px;
}

.filter-item {
  display: flex;
  align-items: center;
}

.filter-item label {
  width: 80px;
  font-weight: 500;
  color: #333;
}

.filter-item input,
.filter-item select {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.filter-actions {
  grid-column: span 2;
  justify-content: flex-end;
  gap: 10px;
}

.action-card {
  display: flex;
  gap: 10px;
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
  text-align: left;
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
  width: 600px;
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
</style>
