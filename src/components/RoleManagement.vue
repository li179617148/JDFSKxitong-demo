<template>
  <div class="role-management">
    <div class="page-header">
      <h2>角色管理</h2>
      <div class="header-actions">
        <button class="btn btn-primary" @click="showAddModal = true">
          新增角色
        </button>
      </div>
    </div>

    <!-- 搜索筛选区域 -->
    <div class="search-section">
      <div class="search-row">
        <div class="search-item">
          <label>角色名称：</label>
          <input type="text" v-model="searchForm.name" placeholder="请输入角色名称">
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
          <button class="btn btn-primary" @click="searchRoles">查询</button>
          <button class="btn btn-secondary" @click="resetSearch">重置</button>
        </div>
      </div>
    </div>

    <!-- 数据表格 -->
    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>角色编码</th>
            <th>角色名称</th>
            <th>角色描述</th>
            <th>用户数量</th>
            <th>状态</th>
            <th>创建时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="role in roleList" :key="role.id">
            <td>{{ role.code }}</td>
            <td>{{ role.name }}</td>
            <td>{{ role.description }}</td>
            <td>{{ role.userCount }}</td>
            <td>
              <span :class="['status-badge', role.status]">
                {{ role.status === 'active' ? '启用' : '禁用' }}
              </span>
            </td>
            <td>{{ formatDate(role.createTime) }}</td>
            <td>
              <button class="btn btn-sm btn-primary" @click="editRole(role)">编辑</button>
              <button class="btn btn-sm btn-info" @click="viewPermissions(role)">权限</button>
              <button class="btn btn-sm btn-danger" @click="deleteRole(role.id)">删除</button>
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
          <h3>{{ showAddModal ? '新增角色' : '编辑角色' }}</h3>
          <button class="close-btn" @click="closeModal">×</button>
        </div>
        <div class="modal-body">
          <form class="role-form">
            <div class="form-row">
              <div class="form-item">
                <label>角色编码：</label>
                <input type="text" v-model="roleForm.code" required>
              </div>
              <div class="form-item">
                <label>角色名称：</label>
                <input type="text" v-model="roleForm.name" required>
              </div>
            </div>
            <div class="form-row">
              <div class="form-item">
                <label>状态：</label>
                <select v-model="roleForm.status" required>
                  <option value="active">启用</option>
                  <option value="inactive">禁用</option>
                </select>
              </div>
            </div>
            <div class="form-row">
              <div class="form-item full-width">
                <label>角色描述：</label>
                <textarea v-model="roleForm.description" rows="3"></textarea>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closeModal">取消</button>
          <button class="btn btn-primary" @click="saveRole">保存</button>
        </div>
      </div>
    </div>

    <!-- 权限配置弹窗 -->
    <div class="modal-overlay" v-if="showPermissionModal" @click="closePermissionModal">
      <div class="modal-content large" @click.stop>
        <div class="modal-header">
          <h3>权限配置 - {{ currentRole.name }}</h3>
          <button class="close-btn" @click="closePermissionModal">×</button>
        </div>
        <div class="modal-body">
          <div class="permission-section">
            <h4>菜单权限</h4>
            <div class="permission-tree">
              <div v-for="module in permissionModules" :key="module.id" class="permission-module">
                <div class="module-header">
                  <input 
                    type="checkbox" 
                    :id="`module-${module.id}`"
                    v-model="module.checked"
                    @change="toggleModule(module)"
                  >
                  <label :for="`module-${module.id}`" class="module-label">{{ module.name }}</label>
                </div>
                <div class="module-permissions" v-if="module.checked">
                  <div v-for="permission in module.permissions" :key="permission.id" class="permission-item">
                    <input 
                      type="checkbox" 
                      :id="`permission-${permission.id}`"
                      v-model="permission.checked"
                    >
                    <label :for="`permission-${permission.id}`">{{ permission.name }}</label>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="closePermissionModal">取消</button>
          <button class="btn btn-primary" @click="savePermissions">保存权限</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'RoleManagement',
  data() {
    return {
      searchForm: {
        name: '',
        status: ''
      },
      roleForm: {
        id: null,
        code: '',
        name: '',
        status: 'active',
        description: ''
      },
      showAddModal: false,
      showEditModal: false,
      showPermissionModal: false,
      currentPage: 1,
      pageSize: 10,
      total: 0,
      roleList: [],
      currentRole: {},
      permissionModules: [
        {
          id: 1,
          name: '价格库管理',
          checked: false,
          permissions: [
            { id: 11, name: '价格查询', checked: false },
            { id: 12, name: '价格维护', checked: false },
            { id: 13, name: '分类维护', checked: false },
            { id: 14, name: '审批页面', checked: false }
          ]
        },
        {
          id: 2,
          name: '合作方管理',
          checked: false,
          permissions: [
            { id: 21, name: '合作方维护', checked: false },
            { id: 22, name: '合作方评价', checked: false },
            { id: 23, name: '合作方维护审批', checked: false },
            { id: 24, name: '合作方评价审批', checked: false }
          ]
        },
        {
          id: 3,
          name: '项目管理',
          checked: false,
          permissions: [
            { id: 31, name: '项目维护', checked: false },
            { id: 32, name: '项目维护审批', checked: false }
          ]
        },
        {
          id: 4,
          name: '专家库管理',
          checked: false,
          permissions: [
            { id: 41, name: '专家库维护', checked: false },
            { id: 42, name: '专家库维护审批', checked: false }
          ]
        },
        {
          id: 5,
          name: '物流监控管理',
          checked: false,
          permissions: [
            { id: 51, name: '物流监控', checked: false },
            { id: 52, name: '物流监控填报', checked: false }
          ]
        },
        {
          id: 6,
          name: '系统管理',
          checked: false,
          permissions: [
            { id: 61, name: '人员管理', checked: false },
            { id: 62, name: '部门管理', checked: false },
            { id: 63, name: '角色管理', checked: false }
          ]
        }
      ]
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.total / this.pageSize)
    }
  },
  created() {
    this.loadRoleList()
  },
  methods: {
    loadRoleList() {
      // 模拟数据
      this.roleList = [
        {
          id: 1,
          code: 'ROLE_ADMIN',
          name: '系统管理员',
          description: '系统管理员，拥有所有权限',
          userCount: 2,
          status: 'active',
          createTime: '2023-01-01 09:00:00'
        },
        {
          id: 2,
          code: 'ROLE_MANAGER',
          name: '部门经理',
          description: '部门经理，拥有部门内管理权限',
          userCount: 5,
          status: 'active',
          createTime: '2023-01-02 10:00:00'
        },
        {
          id: 3,
          code: 'ROLE_USER',
          name: '普通用户',
          description: '普通用户，拥有基本查询权限',
          userCount: 20,
          status: 'active',
          createTime: '2023-01-03 11:00:00'
        },
        {
          id: 4,
          code: 'ROLE_AUDITOR',
          name: '审计员',
          description: '审计员，拥有审批权限',
          userCount: 3,
          status: 'active',
          createTime: '2023-01-04 12:00:00'
        }
      ]
      this.total = this.roleList.length
    },
    searchRoles() {
      // 搜索逻辑
      this.loadRoleList()
    },
    resetSearch() {
      this.searchForm = {
        name: '',
        status: ''
      }
      this.loadRoleList()
    },
    editRole(role) {
      this.roleForm = { ...role }
      this.showEditModal = true
    },
    deleteRole(id) {
      if (confirm('确定要删除该角色吗？删除后该角色下的所有用户将需要重新分配角色。')) {
        // 删除逻辑
        this.roleList = this.roleList.filter(item => item.id !== id)
        this.total = this.roleList.length
      }
    },
    saveRole() {
      // 保存逻辑
      if (this.showAddModal) {
        const newRole = {
          ...this.roleForm,
          id: Date.now(),
          userCount: 0,
          createTime: new Date().toLocaleString()
        }
        this.roleList.unshift(newRole)
        this.total = this.roleList.length
      } else {
        const index = this.roleList.findIndex(item => item.id === this.roleForm.id)
        if (index !== -1) {
          this.roleList[index] = { ...this.roleForm }
        }
      }
      this.closeModal()
    },
    closeModal() {
      this.showAddModal = false
      this.showEditModal = false
      this.roleForm = {
        id: null,
        code: '',
        name: '',
        status: 'active',
        description: ''
      }
    },
    viewPermissions(role) {
      this.currentRole = role
      // 重置权限状态
      this.resetPermissionStates()
      // 模拟加载角色权限
      this.loadRolePermissions(role.id)
      this.showPermissionModal = true
    },
    resetPermissionStates() {
      this.permissionModules.forEach(module => {
        module.checked = false
        module.permissions.forEach(permission => {
          permission.checked = false
        })
      })
    },
    loadRolePermissions(roleId) {
      // 模拟加载角色权限
      if (roleId === 1) {
        // 管理员拥有所有权限
        this.permissionModules.forEach(module => {
          module.checked = true
          module.permissions.forEach(permission => {
            permission.checked = true
          })
        })
      } else if (roleId === 2) {
        // 部门经理拥有部分权限
        this.permissionModules[0].checked = true
        this.permissionModules[0].permissions.forEach(p => p.checked = true)
        this.permissionModules[1].checked = true
        this.permissionModules[1].permissions.forEach(p => p.checked = true)
      }
    },
    toggleModule(module) {
      if (!module.checked) {
        module.permissions.forEach(permission => {
          permission.checked = false
        })
      }
    },
    closePermissionModal() {
      this.showPermissionModal = false
      this.currentRole = {}
    },
    savePermissions() {
      // 保存权限逻辑
      alert('权限保存成功')
      this.closePermissionModal()
    },
    formatDate(dateStr) {
      return dateStr
    }
  }
}
</script>

<style scoped>
.role-management {
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

.modal-content.large {
  width: 800px;
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

.role-form {
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

.permission-section h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
  font-weight: 600;
}

.permission-tree {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  padding: 15px;
}

.permission-module {
  margin-bottom: 15px;
}

.permission-module:last-child {
  margin-bottom: 0;
}

.module-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
}

.module-label {
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

.module-permissions {
  margin-left: 24px;
  border-left: 1px solid #e8e8e8;
  padding-left: 15px;
}

.permission-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.permission-item label {
  color: #666;
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

.btn-info {
  background: #17a2b8;
  color: #fff;
}

.btn-info:hover {
  background: #138496;
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