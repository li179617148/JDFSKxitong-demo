<template>
  <div class="staff-management">
    <div class="page-header">
      <h2>人员管理</h2>
      <div class="header-actions">
        <button class="btn btn-primary" @click="showAddModal = true">
          新增人员
        </button>
      </div>
    </div>

    <!-- 搜索筛选区域 -->
    <div class="search-section">
      <div class="search-row">
        <div class="search-item">
          <label>姓名：</label>
          <input type="text" v-model="searchForm.name" placeholder="请输入姓名">
        </div>
        <div class="search-item">
          <label>部门：</label>
          <select v-model="searchForm.department">
            <option value="">全部部门</option>
            <option v-for="dept in departments" :key="dept.id" :value="dept.id">
              {{ dept.name }}
            </option>
          </select>
        </div>
        <div class="search-item">
          <label>角色：</label>
          <select v-model="searchForm.role">
            <option value="">全部角色</option>
            <option v-for="role in roles" :key="role.id" :value="role.id">
              {{ role.name }}
            </option>
          </select>
        </div>
        <div class="search-item">
          <label>状态：</label>
          <select v-model="searchForm.status">
            <option value="">全部状态</option>
            <option value="active">在职</option>
            <option value="inactive">离职</option>
          </select>
        </div>
        <div class="search-actions">
          <button class="btn btn-primary" @click="searchStaff">查询</button>
          <button class="btn btn-secondary" @click="resetSearch">重置</button>
        </div>
      </div>
    </div>

    <!-- 数据表格 -->
    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>工号</th>
            <th>姓名</th>
            <th>性别</th>
            <th>联系电话</th>
            <th>邮箱</th>
            <th>部门</th>
            <th>角色</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="staff in staffList" :key="staff.id">
            <td>{{ staff.employeeId }}</td>
            <td>{{ staff.name }}</td>
            <td>{{ staff.gender === 'male' ? '男' : '女' }}</td>
            <td>{{ staff.phone }}</td>
            <td>{{ staff.email }}</td>
            <td>{{ getDepartmentName(staff.departmentId) }}</td>
            <td>{{ getRoleName(staff.roleId) }}</td>
            <td>
              <span :class="['status-badge', staff.status]">
                {{ staff.status === 'active' ? '在职' : '离职' }}
              </span>
            </td>
            <td>{{ formatDate(staff.createTime) }}</td>
            <td>
              <button class="btn btn-sm btn-primary" @click="editStaff(staff)">编辑</button>
              <button class="btn btn-sm btn-danger" @click="deleteStaff(staff.id)">删除</button>
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
          <h3>{{ showAddModal ? '新增人员' : '编辑人员' }}</h3>
          <button class="close-btn" @click="closeModal">×</button>
        </div>
        <div class="modal-body">
          <form class="staff-form">
            <div class="form-row">
              <div class="form-item">
                <label>工号：</label>
                <input type="text" v-model="staffForm.employeeId" required>
              </div>
              <div class="form-item">
                <label>姓名：</label>
                <input type="text" v-model="staffForm.name" required>
              </div>
            </div>
            <div class="form-row">
              <div class="form-item">
                <label>性别：</label>
                <select v-model="staffForm.gender" required>
                  <option value="male">男</option>
                  <option value="female">女</option>
                </select>
              </div>
              <div class="form-item">
                <label>联系电话：</label>
                <input type="tel" v-model="staffForm.phone" required>
              </div>
            </div>
            <div class="form-row">
              <div class="form-item">
                <label>邮箱：</label>
                <input type="email" v-model="staffForm.email" required>
              </div>
              <div class="form-item">
                <label>部门：</label>
                <select v-model="staffForm.departmentId" required>
                  <option value="">请选择部门</option>
                  <option v-for="dept in departments" :key="dept.id" :value="dept.id">
                    {{ dept.name }}
                  </option>
                </select>
              </div>
            </div>
            <div class="form-row">
              <div class="form-item">
                <label>角色：</label>
                <select v-model="staffForm.roleId" required>
                  <option value="">请选择角色</option>
                  <option v-for="role in roles" :key="role.id" :value="role.id">
                    {{ role.name }}
                  </option>
                </select>
              </div>
              <div class="form-item">
                <label>状态：</label>
                <select v-model="staffForm.status" required>
                  <option value="active">在职</option>
                  <option value="inactive">离职</option>
                </select>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeModal">取消</button>
          <button class="btn btn-primary" @click="saveStaff">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StaffManagement',
  data() {
    return {
      searchForm: {
        name: '',
        department: '',
        role: '',
        status: ''
      },
      staffForm: {
        id: null,
        employeeId: '',
        name: '',
        gender: 'male',
        phone: '',
        email: '',
        departmentId: '',
        roleId: '',
        status: 'active'
      },
      showAddModal: false,
      showEditModal: false,
      currentPage: 1,
      pageSize: 10,
      total: 0,
      staffList: [],
      departments: [
        { id: 1, name: '技术部' },
        { id: 2, name: '市场部' },
        { id: 3, name: '财务部' },
        { id: 4, name: '人事部' },
        { id: 5, name: '运营部' }
      ],
      roles: [
        { id: 1, name: '管理员' },
        { id: 2, name: '普通用户' },
        { id: 3, name: '部门经理' },
        { id: 4, name: '普通员工' }
      ]
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.total / this.pageSize)
    }
  },
  created() {
    this.loadStaffList()
  },
  methods: {
    loadStaffList() {
      // 模拟数据
      this.staffList = [
        {
          id: 1,
          employeeId: 'EMP001',
          name: '张三',
          gender: 'male',
          phone: '13800138001',
          email: 'zhangsan@example.com',
          departmentId: 1,
          roleId: 1,
          status: 'active',
          createTime: '2023-01-15 10:30:00'
        },
        {
          id: 2,
          employeeId: 'EMP002',
          name: '李四',
          gender: 'female',
          phone: '13800138002',
          email: 'lisi@example.com',
          departmentId: 2,
          roleId: 2,
          status: 'active',
          createTime: '2023-02-20 14:15:00'
        },
        {
          id: 3,
          employeeId: 'EMP003',
          name: '王五',
          gender: 'male',
          phone: '13800138003',
          email: 'wangwu@example.com',
          departmentId: 3,
          roleId: 3,
          status: 'inactive',
          createTime: '2023-03-10 09:45:00'
        }
      ]
      this.total = this.staffList.length
    },
    searchStaff() {
      // 搜索逻辑
      this.loadStaffList()
    },
    resetSearch() {
      this.searchForm = {
        name: '',
        department: '',
        role: '',
        status: ''
      }
      this.loadStaffList()
    },
    editStaff(staff) {
      this.staffForm = { ...staff }
      this.showEditModal = true
    },
    deleteStaff(id) {
      if (confirm('确定要删除该人员吗？')) {
        // 删除逻辑
        this.staffList = this.staffList.filter(item => item.id !== id)
        this.total = this.staffList.length
      }
    },
    saveStaff() {
      // 保存逻辑
      if (this.showAddModal) {
        const newStaff = {
          ...this.staffForm,
          id: Date.now(),
          createTime: new Date().toLocaleString()
        }
        this.staffList.unshift(newStaff)
        this.total = this.staffList.length
      } else {
        const index = this.staffList.findIndex(item => item.id === this.staffForm.id)
        if (index !== -1) {
          this.staffList[index] = { ...this.staffForm }
        }
      }
      this.closeModal()
    },
    closeModal() {
      this.showAddModal = false
      this.showEditModal = false
      this.staffForm = {
        id: null,
        employeeId: '',
        name: '',
        gender: 'male',
        phone: '',
        email: '',
        departmentId: '',
        roleId: '',
        status: 'active'
      }
    },
    getDepartmentName(deptId) {
      const dept = this.departments.find(item => item.id === deptId)
      return dept ? dept.name : ''
    },
    getRoleName(roleId) {
      const role = this.roles.find(item => item.id === roleId)
      return role ? role.name : ''
    },
    formatDate(dateStr) {
      return dateStr
    }
  }
}
</script>

<style scoped>
.staff-management {
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

.staff-form {
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

.form-item label {
  color: #666;
  font-size: 14px;
  font-weight: 500;
}

.form-item input,
.form-item select {
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