<template>
  <div class="department-management">
    <div class="page-header">
      <h2>部门管理</h2>
      <div class="header-actions">
        <button class="btn btn-primary" @click="showAddModal = true">
          新增部门
        </button>
      </div>
    </div>

    <!-- 搜索筛选区域 -->
    <div class="search-section">
      <div class="search-row">
        <div class="search-item">
          <label>部门名称：</label>
          <input type="text" v-model="searchForm.name" placeholder="请输入部门名称">
        </div>
        <div class="search-item">
          <label>上级部门：</label>
          <select v-model="searchForm.parentId">
            <option value="">全部部门</option>
            <option v-for="dept in parentDepartments" :key="dept.id" :value="dept.id">
              {{ dept.name }}
            </option>
          </select>
        </div>
        <div class="search-item">
          <label>状态：</label>
          <select v-model="searchForm.status">
            <option value="">全部状态</option>
            <option value="active">启用</option>
            <option value="inactive">禁用</option>
          </select>
        </div>
        <div class="search-actions">
          <button class="btn btn-primary" @click="searchDepartments">查询</button>
          <button class="btn btn-secondary" @click="resetSearch">重置</button>
        </div>
      </div>
    </div>

    <!-- 数据表格 -->
    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>部门编码</th>
            <th>部门名称</th>
            <th>上级部门</th>
            <th>负责人</th>
            <th>联系电话</th>
            <th>部门人数</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="dept in departmentList" :key="dept.id">
            <td>{{ dept.code }}</td>
            <td>{{ dept.name }}</td>
            <td>{{ getParentDepartmentName(dept.parentId) }}</td>
            <td>{{ dept.manager }}</td>
            <td>{{ dept.phone }}</td>
            <td>{{ dept.staffCount }}</td>
            <td>
              <span :class="['status-badge', dept.status]">
                {{ dept.status === 'active' ? '启用' : '禁用' }}
              </span>
            </td>
            <td>{{ formatDate(dept.createTime) }}</td>
            <td>
              <button class="btn btn-sm btn-primary" @click="editDepartment(dept)">编辑</button>
              <button class="btn btn-sm btn-danger" @click="deleteDepartment(dept.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 分页 -->
    <div class="pagination">
      <button class="btn btn-secondary" :disabled="currentPage <= 1" @click="currentPage--">上一页</button>
      <span class="page-info">第 {{ currentPage }} 页，共 {{ totalPages }} 页</span>
      <button class="btn btn-secondary" :disabled="currentPage >= totalPages" @click="currentPage++">下一页</button>
    </div>

    <!-- 新增/编辑弹窗 -->
    <div class="modal-overlay" v-if="showAddModal || showEditModal" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ showAddModal ? '新增部门' : '编辑部门' }}</h3>
          <button class="close-btn" @click="closeModal">×</button>
        </div>
        <div class="modal-body">
          <form class="department-form">
            <div class="form-row">
              <div class="form-item">
                <label>部门编码：</label>
                <input type="text" v-model="departmentForm.code" required>
              </div>
              <div class="form-item">
                <label>部门名称：</label>
                <input type="text" v-model="departmentForm.name" required>
              </div>
            </div>
            <div class="form-row">
              <div class="form-item">
                <label>上级部门：</label>
                <select v-model="departmentForm.parentId">
                  <option value="">无上级部门</option>
                  <option v-for="dept in availableParentDepartments" :key="dept.id" :value="dept.id">
                    {{ dept.name }}
                  </option>
                </select>
              </div>
              <div class="form-item">
                <label>负责人：</label>
                <input type="text" v-model="departmentForm.manager">
              </div>
            </div>
            <div class="form-row">
              <div class="form-item">
                <label>联系电话：</label>
                <input type="tel" v-model="departmentForm.phone">
              </div>
              <div class="form-item">
                <label>状态：</label>
                <select v-model="departmentForm.status" required>
                  <option value="active">启用</option>
                  <option value="inactive">禁用</option>
                </select>
              </div>
            </div>
            <div class="form-row">
              <div class="form-item full-width">
                <label>部门描述：</label>
                <textarea v-model="departmentForm.description" rows="3"></textarea>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeModal">取消</button>
          <button class="btn btn-primary" @click="saveDepartment">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DepartmentManagement',
  data() {
    return {
      searchForm: {
        name: '',
        parentId: '',
        status: ''
      },
      departmentForm: {
        id: null,
        code: '',
        name: '',
        parentId: '',
        manager: '',
        phone: '',
        status: 'active',
        description: ''
      },
      showAddModal: false,
      showEditModal: false,
      currentPage: 1,
      pageSize: 10,
      total: 0,
      departmentList: [],
      parentDepartments: []
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.total / this.pageSize)
    },
    availableParentDepartments() {
      // 在编辑时，排除当前部门和其子部门作为上级部门选项
      if (this.showEditModal && this.departmentForm.id) {
        return this.departmentList.filter(dept => 
          dept.id !== this.departmentForm.id && 
          !this.isChildDepartment(dept.id, this.departmentForm.id)
        )
      }
      return this.departmentList
    }
  },
  created() {
    this.loadDepartmentList()
  },
  methods: {
    loadDepartmentList() {
      // 模拟数据
      this.departmentList = [
        {
          id: 1,
          code: 'DEPT001',
          name: '总经理办公室',
          parentId: null,
          manager: '张总',
          phone: '021-12345678',
          staffCount: 5,
          status: 'active',
          description: '公司最高管理层',
          createTime: '2023-01-01 09:00:00'
        },
        {
          id: 2,
          code: 'DEPT002',
          name: '技术部',
          parentId: 1,
          manager: '李经理',
          phone: '021-12345679',
          staffCount: 25,
          status: 'active',
          description: '负责技术研发',
          createTime: '2023-01-02 10:00:00'
        },
        {
          id: 3,
          code: 'DEPT003',
          name: '市场部',
          parentId: 1,
          manager: '王经理',
          phone: '021-12345680',
          staffCount: 15,
          status: 'active',
          description: '负责市场推广',
          createTime: '2023-01-03 11:00:00'
        },
        {
          id: 4,
          code: 'DEPT004',
          name: '财务部',
          parentId: 1,
          manager: '赵经理',
          phone: '021-12345681',
          staffCount: 10,
          status: 'active',
          description: '负责财务管理',
          createTime: '2023-01-04 12:00:00'
        },
        {
          id: 5,
          code: 'DEPT005',
          name: '人事部',
          parentId: 1,
          manager: '钱经理',
          phone: '021-12345682',
          staffCount: 8,
          status: 'active',
          description: '负责人力资源管理',
          createTime: '2023-01-05 13:00:00'
        }
      ]
      this.total = this.departmentList.length
      this.parentDepartments = this.departmentList.filter(dept => !dept.parentId)
    },
    isChildDepartment(childId, parentId) {
      // 检查是否为子部门（避免循环引用）
      const child = this.departmentList.find(dept => dept.id === childId)
      if (!child) return false
      
      if (child.parentId === parentId) return true
      if (!child.parentId) return false
      
      return this.isChildDepartment(child.parentId, parentId)
    },
    searchDepartments() {
      // 搜索逻辑
      this.loadDepartmentList()
    },
    resetSearch() {
      this.searchForm = {
        name: '',
        parentId: '',
        status: ''
      }
      this.loadDepartmentList()
    },
    editDepartment(dept) {
      this.departmentForm = { ...dept }
      this.showEditModal = true
    },
    deleteDepartment(id) {
      if (confirm('确定要删除该部门吗？删除后该部门下的所有人员将需要重新分配部门。')) {
        // 删除逻辑
        this.departmentList = this.departmentList.filter(item => item.id !== id)
        this.total = this.departmentList.length
      }
    },
    saveDepartment() {
      // 保存逻辑
      if (this.showAddModal) {
        const newDept = {
          ...this.departmentForm,
          id: Date.now(),
          staffCount: 0,
          createTime: new Date().toLocaleString()
        }
        this.departmentList.unshift(newDept)
        this.total = this.departmentList.length
      } else {
        const index = this.departmentList.findIndex(item => item.id === this.departmentForm.id)
        if (index !== -1) {
          this.departmentList[index] = { ...this.departmentForm }
        }
      }
      this.closeModal()
    },
    closeModal() {
      this.showAddModal = false
      this.showEditModal = false
      this.departmentForm = {
        id: null,
        code: '',
        name: '',
        parentId: '',
        manager: '',
        phone: '',
        status: 'active',
        description: ''
      }
    },
    getParentDepartmentName(parentId) {
      if (!parentId) return '无'
      const parent = this.departmentList.find(item => item.id === parentId)
      return parent ? parent.name : ''
    },
    formatDate(dateStr) {
      return dateStr
    }
  }
}
</script>

<style scoped>
.department-management {
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #e8e8e8;
}

.page-header h2 {
  margin: 0;
  color: #333;
  font-size: 20px;
  font-weight: 600;
}

.search-section {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 6px;
  margin-bottom: 20px;
}

.search-row {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  align-items: end;
}

.search-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.search-item label {
  white-space: nowrap;
  color: #666;
  font-size: 14px;
}

.search-item input,
.search-item select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  width: 150px;
}

.search-actions {
  display: flex;
  gap: 10px;
  margin-left: auto;
}

.table-container {
  overflow-x: auto;
  margin-bottom: 20px;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
}

.data-table th,
.data-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #e8e8e8;
}

.data-table th {
  background: #f8f9fa;
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

.data-table td {
  font-size: 14px;
  color: #666;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.status-badge.active {
  background: #e6f7ff;
  color: #1890ff;
}

.status-badge.inactive {
  background: #fff1f0;
  color: #ff4d4f;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
}

.page-info {
  color: #666;
  font-size: 14px;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: #fff;
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
  border-bottom: 1px solid #e8e8e8;
}

.modal-header h3 {
  margin: 0;
  color: #333;
  font-size: 18px;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #999;
}

.close-btn:hover {
  color: #666;
}

.modal-body {
  padding: 20px;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid #e8e8e8;
}

.department-form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-row {
  display: flex;
  gap: 20px;
}

.form-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.form-item.full-width {
  flex: 1 1 100%;
}

.form-item label {
  color: #666;
  font-size: 14px;
  font-weight: 500;
}

.form-item input,
.form-item select,
.form-item textarea {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s;
}

.btn-primary {
  background: #1890ff;
  color: #fff;
}

.btn-primary:hover {
  background: #40a9ff;
}

.btn-secondary {
  background: #f5f5f5;
  color: #666;
}

.btn-secondary:hover {
  background: #e6e6e6;
}

.btn-danger {
  background: #ff4d4f;
  color: #fff;
}

.btn-danger:hover {
  background: #ff7875;
}

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>