<template>
  <div class="price-maintenance">

    <!-- 新增/编辑弹窗 -->
    <div class="modal" v-if="showModal">
      <div class="modal-content" style="width: 800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>{{ isEdit ? '编辑价格' : '新增价格' }}</h3>
          <div class="header-actions">
            <button class="btn-primary" @click="handleSave">保存</button>
            <button class="btn-primary" @click="handleSubmit" v-if="!isEdit">提交审批</button>
            <button class="btn-secondary" @click="closeModal">取消</button>
          </div>
        </div>
        <div class="modal-body">
          <form class="price-form">
            <div class="form-grid" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; width: 100%; margin-bottom: 20px;">
              <div class="form-item">
                <label class="required">项目名称：</label>
                <input type="text" v-model="formData.projectName" placeholder="请输入项目名称" required>
              </div>
              <div class="form-item">
                <label class="required">规格型号：</label>
                <input type="text" v-model="formData.specification" placeholder="请输入规格型号" required>
              </div>
              <div class="form-item">
                <label class="required">单位：</label>
                <select v-model="formData.unit" required>
                  <option value="">请选择单位</option>
                  <option value="吨">吨</option>
                  <option value="千克">千克</option>
                  <option value="立方米">立方米</option>
                  <option value="平方米">平方米</option>
                  <option value="米">米</option>
                  <option value="台">台</option>
                  <option value="套">套</option>
                  <option value="件">件</option>
                </select>
              </div>
              <div class="form-item">
                <label class="required">价格（元）：</label>
                <input type="number" v-model="formData.price" placeholder="请输入价格" required>
              </div>
              <div class="form-item full-width">
                <label>价格说明：</label>
                <textarea v-model="formData.priceDescription" placeholder="请输入价格说明" rows="3"></textarea>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- 表格区域 -->
    <div class="table-area">
      <div class="table-header" style="display: flex; justify-content: space-between; align-items: center;">
        <h3>审批列表</h3>
        <button class="btn-primary" @click="handleShowPriceAdd">新增</button>
      </div>
      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>序号</th>
              <th>填报日期</th>
              <th>提交人</th>
              <th>提交时间</th>
              <th>当前审批人</th>
              <th>审批状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in paginatedList" :key="item.id">
              <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
              <td>{{ item.submitDate }}</td>
              <td>{{ item.submitter }}</td>
              <td>{{ item.submitTime }}</td>
              <td>{{ item.currentApprover }}</td>
              <td>
                {{ getApprovalStatusText(item.approvalStatus) }}
              </td>
              <td>
                <button class="btn-success btn-sm" @click="handleView(item)">查看</button>
                <!-- 暂存和已退回状态显示删除按钮 -->
                <button class="btn-primary btn-sm" @click="handleDelete(item.id)" v-if="['draft', 'returned'].includes(item.approvalStatus)">删除</button>
                <!-- 审批中状态显示撤回按钮 -->
                <button class="btn-primary btn-sm" @click="handleWithdraw(item)" v-if="item.approvalStatus === 'pending'">撤回</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <button class="btn-primary" @click="prevPage" :disabled="currentPage === 1">上一页</button>
        <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
        <button class="btn-primary" @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
      </div>
    </div>

    <!-- 价格新增内嵌页面 -->
    <div v-if="showPriceAdd" class="price-add-embedded">
      <PriceAdd @close="handlePriceAddClose" />
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
import PriceAdd from './PriceAdd.vue'

export default {
  name: 'PriceMaintenance',
  components: {
    PriceAdd
  },
  data() {
    return {
      showPriceAdd: false,
      formData: {
        id: null,
        projectName: '',
        specification: '',
        unit: '',
        price: '',
        priceDescription: ''
      },
      showModal: false,
      isEdit: false,
      currentPage: 1,
      pageSize: 10,
      totalItems: 5,
      priceList: [
        {
          id: 1,
          submitDate: '2024-01-15',
          submitter: '张三',
          submitTime: '2024-01-15 09:30',
          currentApprover: '李经理',
          approvalStatus: 'draft'
        },
        {
          id: 2,
          submitDate: '2024-01-14',
          submitter: '李四',
          submitTime: '2024-01-14 14:20',
          currentApprover: '王主管',
          approvalStatus: 'approved'
        },
        {
          id: 3,
          submitDate: '2024-01-13',
          submitter: '王五',
          submitTime: '2024-01-13 11:15',
          currentApprover: '赵总监',
          approvalStatus: 'pending'
        },
        {
          id: 4,
          submitDate: '2024-01-12',
          submitter: '赵六',
          submitTime: '2024-01-12 16:45',
          currentApprover: '钱经理',
          approvalStatus: 'returned'
        },
        {
          id: 5,
          submitDate: '2024-01-11',
          submitter: '钱七',
          submitTime: '2024-01-11 10:00',
          currentApprover: '孙主管',
          approvalStatus: 'draft'
        }
      ]
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.priceList.length / this.pageSize)
    },
    paginatedList() {
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return this.priceList.slice(start, end)
    }
  },
  methods: {
    handleAdd() {
      this.formData = {
        id: null,
        projectName: '',
        specification: '',
        unit: '',
        price: '',
        priceDescription: ''
      }
      this.isEdit = false
      this.showModal = true
    },
    
    handleShowPriceAdd() {
      // 直接显示新增页面
      this.showPriceAdd = true
    },
    
    handlePriceAddClose() {
      this.showPriceAdd = false
      // 这里可以添加返回到审批列表页面的逻辑
      // 由于新增页面是在主页面菜单栏右侧显示，关闭后自然就回到了价格维护页面
    },
    
    handleEdit(item) {
      this.formData = { ...item }
      this.isEdit = true
      this.showModal = true
    },
    
    handleView(item) {
      console.log('查看审批：', item)
      // 这里可以添加查看详情的逻辑
    },
    
    handleApprove(item) {
      console.log('审批申请：', item)
      // 这里可以添加审批逻辑
      alert('打开审批弹窗')
    },
    
    handleDelete(id) {
      if (confirm('确定要删除这条价格记录吗？')) {
        this.priceList = this.priceList.filter(item => item.id !== id)
        this.totalItems = this.priceList.length
      }
    },
    
    handleSave() {
      if (!this.formData.projectName || !this.formData.specification || !this.formData.unit || !this.formData.price) {
        alert('请填写完整的价格信息')
        return
      }
      
      if (this.isEdit) {
        // 编辑模式
        const index = this.priceList.findIndex(item => item.id === this.formData.id)
        if (index !== -1) {
          this.priceList[index] = { ...this.formData }
        }
      } else {
        // 新增模式
        const newId = Math.max(...this.priceList.map(item => item.id)) + 1
        this.priceList.push({
          ...this.formData,
          id: newId,
          status: 'draft',
          updateDate: new Date().toISOString().split('T')[0],
          operator: '当前用户'
        })
        this.totalItems = this.priceList.length
      }
      
      this.closeModal()
    },
    
    handleSubmit() {
      if (!this.formData.projectName || !this.formData.specification || !this.formData.unit || !this.formData.price) {
        alert('请填写完整的价格信息')
        return
      }
      
      // 提交审批逻辑
      const newId = Math.max(...this.priceList.map(item => item.id)) + 1
      this.priceList.push({
        ...this.formData,
        id: newId,
        status: 'pending',
        updateDate: new Date().toISOString().split('T')[0],
        operator: '当前用户'
      })
      this.totalItems = this.priceList.length
      this.closeModal()
      alert('价格信息已提交审批')
    },
    
    closeModal() {
      this.showModal = false
      this.isEdit = false
    },
    
    getApprovalStatusClass(status) {
      const statusMap = {
        'pending': 'status-pending',
        'approved': 'status-approved',
        'rejected': 'status-rejected',
        'returned': 'status-returned'
      }
      return statusMap[status] || ''
    },
    
    getApprovalStatusText(status) {
      const statusMap = {
        'draft': '暂存',
        'pending': '审批中',
        'approved': '已审批',
        'returned': '已退回'
      }
      return statusMap[status] || status
    },
    
    handleWithdraw(item) {
      if (confirm('确定要撤回这条审批申请吗？')) {
        // 将状态从pending改为draft
        const index = this.priceList.findIndex(i => i.id === item.id)
        if (index !== -1) {
          this.priceList[index].approvalStatus = 'draft'
          alert('审批申请已撤回')
        }
      }
    },
    
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--
      }
    },
    
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
      }
    },
    
    formatDate(date) {
      return date
    }
  }
}
</script>

<style scoped>
.price-maintenance {
  padding: 20px;
  background-color: #f5f5f5;
  min-height: 100vh;
}

.search-area {
  background: white;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.search-form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 15px;
}

.form-item {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.form-item.full-width {
  grid-column: 1 / -1;
}

.form-item label {
  font-weight: 500;
  color: white;
  font-size: 14px;
  background-color: #409eff;
  padding: 6px 12px;
  border-radius: 4px;
  margin-bottom: 5px;
  display: inline-block;
}

.form-item label.required::after {
  content: ' *';
  color: #f56c6c;
}

.form-item input,
.form-item select,
.form-item textarea {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.form-item textarea {
  resize: vertical;
  min-height: 80px;
}

.button-group {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.btn-primary {
  padding: 8px 16px;
  background: #409eff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-primary:hover {
  background: #66b1ff;
}

.table-area {
  background: white;
  padding: 30px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  margin-top: 20px;
}

.table-header {
  margin-bottom: 25px;
}

.table-header h3 {
  margin: 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.table-container {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 16px;
}

.data-table th,
.data-table td {
  padding: 16px;
  text-align: center;
  border-bottom: 1px solid #ebeef5;
  vertical-align: middle;
}

.data-table th {
  background-color: #409eff;
  font-weight: 600;
  color: white;
  font-size: 16px;
}

.data-table tr:hover {
  background-color: #f5f7fa;
}

.btn-sm {
  padding: 8px 12px;
  font-size: 14px;
  margin-right: 8px;
  border-radius: 4px;
}

.btn-success {
  background: #409eff;
  color: white;
  border: none;
  cursor: pointer;
}

.btn-success:hover {
  background: #66b1ff;
}

.btn-danger {
  background: #f56c6c;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}

.btn-danger:hover {
  background: #f78989;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  margin-top: 20px;
}

.pagination button {
  padding: 6px 12px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 4px;
  cursor: pointer;
}

.pagination button:disabled {
  cursor: not-allowed;
  opacity: 0.6;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 8px;
  padding: 0;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  padding: 24px 32px;
  border-bottom: 1px solid #e8e8e8;
  background: #fafafa;
  border-radius: 8px 8px 0 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h3 {
  margin: 0;
  color: #333;
  font-size: 20px;
  font-weight: 700;
}

.header-actions {
  display: flex;
  gap: 12px;
  align-items: center;
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

.modal-body {
  padding: 20px;
}


.status-draft {
  color: #909399;
}

.status-pending {
  color: #e6a23c;
}

.status-approved {
  color: #67c23a;
}

.status-rejected {
  color: #f56c6c;
}

.status-returned {
  color: #909399;
}

/* 价格新增内嵌页面样式 */
.price-add-embedded {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: white;
  z-index: 1000;
  overflow-y: auto;
}

.price-add-embedded .price-add {
  padding: 20px;
  background: #f5f5f5;
  min-height: 100vh;
}

.price-add-embedded .page-header {
  background: white;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.price-add-embedded .page-header h2 {
  margin: 0;
  color: #333;
  font-size: 20px;
  font-weight: 600;
}

.price-add-embedded .header-actions {
  display: flex;
  gap: 10px;
}

.price-add-embedded .btn-close {
  padding: 8px 16px;
  background: #909399;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.price-add-embedded .btn-close:hover {
  background: #a6a9ad;
}
</style>