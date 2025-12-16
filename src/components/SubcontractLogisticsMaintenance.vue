<template>
  <div class="subcontract-logistics-maintenance">
    <!-- 查询筛选模块 -->
    <div class="card filter-card">
      <div class="filter-grid">
        <div class="filter-item">
          <label>项目名称：</label>
          <select v-model="filters.projectName">
            <option value="">全部</option>
            <option value="项目1">项目1</option>
            <option value="项目2">项目2</option>
            <option value="项目3">项目3</option>
            <option value="项目4">项目4</option>
            <option value="项目5">项目5</option>
          </select>
        </div>
        <div class="filter-item">
          <label>包件名称：</label>
          <input v-model="filters.packageName" type="text" placeholder="请输入包件名称" />
        </div>
        <div class="filter-item">
          <label>批次号：</label>
          <input v-model="filters.batchNumber" type="text" placeholder="请输入批次号" />
        </div>
        <div class="filter-item">
          <label>货代商：</label>
          <select v-model="filters.forwarderId">
            <option value="">全部</option>
            <option v-for="forwarder in forwarderList" :key="forwarder.id" :value="forwarder.id">
              {{ forwarder.name }}
            </option>
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
        <span class="btn-icon">+</span>新增记录
      </button>
      <button class="btn btn-danger" @click="handleBatchDelete" :disabled="selectedRows.length === 0">
        <span class="btn-icon">✕</span>批量删除
      </button>
      <button class="btn btn-info" @click="handleExport">
        <span class="btn-icon">↑</span>导出
      </button>
    </div>

    <!-- 数据表格 -->
    <div class="card table-card">
      <div class="table-header">
        <h3>包件物流维护信息</h3>
        <span class="record-count">共 {{ tableData.length }} 条记录</span>
      </div>
      
      <div class="table-wrapper">
        <table class="data-table">
          <thead>
            <tr>
              <th class="checkbox-col">
                <input type="checkbox" v-model="selectAll" @change="handleSelectAll" />
              </th>
              <th>所辖项目</th>
              <th>包件名称</th>
              <th>序号</th>
              <th>批次号</th>
              <th>货代商</th>
              <th>制造完成时间</th>
              <th>工厂交货时间</th>
              <th>国内起运时间（计划）</th>
              <th>国内起运时间（实际）</th>
              <th class="calculated-field">起运延误天数</th>
              <th>运抵中转港时间</th>
              <th>运抵目的港时间</th>
              <th>运抵项目现场时间（计划）</th>
              <th>运抵项目现场时间（实际）</th>
              <th class="calculated-field">实际运输时间</th>
              <th>备注</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, index) in tableData" :key="row.id">
              <td class="checkbox-col">
                <input type="checkbox" v-model="selectedRows" :value="row.id" @change="handleSelectAll" />
              </td>
              <td>{{ row.projectName }}</td>
              <td>{{ row.packageName }}</td>
              <td>{{ row.sequence }}</td>
              <td>{{ row.batchNumber }}</td>
              <td>{{ getForwarderName(row.forwarderId) }}</td>
              <td>{{ row.manufacturingCompleteTime }}</td>
              <td>{{ row.factoryDeliveryTime }}</td>
              <td>{{ row.domesticDeparturePlanned }}</td>
              <td>{{ row.domesticDepartureActual || '无' }}</td>
              <td class="calculated-field">{{ row.departureDelayDays || 0 }}</td>
              <td>{{ row.transitPortPlanned || '无' }}</td>
              <td>{{ row.destinationPortPlanned || '无' }}</td>
              <td>{{ row.projectSitePlanned || '无' }}</td>
              <td>{{ row.projectSiteActual || '无' }}</td>
              <td class="calculated-field">{{ row.actualTransportDays || 0 }}</td>
              <td>{{ row.remark || '无' }}</td>
              <td class="action-col">
                <button class="btn-text btn-text-primary" @click="handleEdit(row)">编辑</button>
                <button class="btn-text btn-text-danger" @click="handleDelete(row)">删除</button>
              </td>
            </tr>
            <tr v-if="tableData.length === 0">
              <td colspan="17" class="empty-data">暂无数据</td>
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
          <form class="form-sections">
            <!-- 基础信息 -->
            <div class="form-section">
              <h4 class="section-title">基础信息</h4>
              <div class="form-grid">
                <div class="form-item">
                  <label class="required">所辖项目：</label>
                  <select v-model="formData.projectName" required>
                    <option value="">请选择项目</option>
                    <option value="项目1">项目1</option>
                    <option value="项目2">项目2</option>
                    <option value="项目3">项目3</option>
                    <option value="项目4">项目4</option>
                    <option value="项目5">项目5</option>
                  </select>
                </div>
                <div class="form-item">
                  <label class="required">包件名称：</label>
                  <input v-model="formData.packageName" type="text" required />
                </div>
                <div class="form-item">
                  <label class="required">序号：</label>
                  <input v-model="formData.sequence" type="number" required />
                </div>
                <div class="form-item">
                  <label class="required">批次号：</label>
                  <input v-model="formData.batchNumber" type="text" required />
                </div>
                <div class="form-item">
                  <label>货代商：</label>
                  <select v-model="formData.forwarderId">
                    <option value="">请选择货代商</option>
                    <option v-for="forwarder in forwarderList" :key="forwarder.id" :value="forwarder.id">
                      {{ forwarder.name }}
                    </option>
                  </select>
                </div>
              </div>
            </div>

            <!-- 物流进度 -->
            <div class="form-section">
              <h4 class="section-title">物流进度</h4>
              <div class="logistics-grid">
                <div class="form-item">
                  <label class="required">制造完成时间：</label>
                  <input v-model="formData.manufacturingCompleteTime" type="date" />
                </div>
                <div class="form-item">
                  <label class="required">工厂交货时间：</label>
                  <input v-model="formData.factoryDeliveryTime" type="date" />
                </div>
                <div class="form-item">
                  <label class="required">国内起运时间（计划）：</label>
                  <input v-model="formData.domesticDeparturePlanned" type="date" />
                </div>
                <div class="form-item">
                  <label>国内起运时间（实际）：</label>
                  <input v-model="formData.domesticDepartureActual" type="date" disabled />
                </div>
                <div class="form-item">
                  <label>运抵中转港时间：</label>
                  <input v-model="formData.transitPortPlanned" type="date" disabled />
                </div>
                <div class="form-item">
                  <label>运抵目的港时间：</label>
                  <input v-model="formData.destinationPortPlanned" type="date" disabled />
                </div>
                <div class="form-item">
                  <label>运抵项目现场时间（计划）：</label>
                  <input v-model="formData.projectSitePlanned" type="date" />
                </div>
                <div class="form-item">
                  <label>运抵项目现场时间（实际）：</label>
                  <input v-model="formData.projectSiteActual" type="date" />
                </div>
              </div>
            </div>

            <!-- 备注 -->
            <div class="form-section">
              <h4 class="section-title">备注</h4>
              <div class="form-grid">
                <div class="form-item full-width">
                  <textarea v-model="formData.remark" rows="6" placeholder="请输入备注信息"></textarea>
                </div>
              </div>
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
  name: 'SubcontractLogisticsMaintenance',
  data() {
    return {
      filters: {
        projectName: '',
        packageName: '',
        batchNumber: '',
        forwarderId: ''
      },
      tableData: [
        {
          id: 1,
          batchNumber: 'BATCH-2024-001',
          sequence: 1,
          forwarderId: 1,
          projectName: '某大型基建项目',
          packageName: '主体结构包',
          manufacturingCompleteTime: '2024-01-15',
          factoryDeliveryTime: '2024-01-20',
          domesticDeparturePlanned: '2024-01-22',
          domesticDepartureActual: '2024-01-23',
          splitPlannedTime: '2024-01-25',
          splitActualTime: '2024-01-26',
          departureDelayDays: 1,
          transitPortPlanned: '2024-02-01',
          transitPortActual: '2024-02-02',
          destinationPortPlanned: '2024-02-10',
          destinationPortActual: '2024-02-12',
          projectSitePlanned: '2024-02-15',
          projectSiteActual: '2024-02-16',
          actualTransportDays: 24,
          remark: '运输正常',
          status: 'in-progress'
        },
        {
          id: 2,
          batchNumber: 'BATCH-2024-001',
          sequence: 2,
          forwarderId: 2,
          projectName: '某大型基建项目',
          packageName: '机电安装包',
          manufacturingCompleteTime: '2024-01-18',
          factoryDeliveryTime: '2024-01-25',
          domesticDeparturePlanned: '2024-01-28',
          domesticDepartureActual: '2024-01-28',
          splitPlannedTime: '2024-01-30',
          splitActualTime: '2024-01-31',
          departureDelayDays: 0,
          transitPortPlanned: '2024-02-05',
          transitPortActual: '2024-02-04',
          destinationPortPlanned: '2024-02-12',
          destinationPortActual: '2024-02-11',
          projectSitePlanned: '2024-02-18',
          projectSiteActual: '2024-02-17',
          actualTransportDays: 20,
          remark: '提前到达',
          status: 'completed'
        },
        {
          id: 3,
          batchNumber: 'BATCH-2024-002',
          sequence: 1,
          forwarderId: 3,
          projectName: '工业厂房建设项目',
          packageName: '钢结构包',
          manufacturingCompleteTime: '2024-02-01',
          factoryDeliveryTime: '2024-02-08',
          domesticDeparturePlanned: '2024-02-10',
          domesticDepartureActual: '2024-02-15',
          splitPlannedTime: '2024-02-12',
          splitActualTime: '2024-02-17',
          departureDelayDays: 5,
          transitPortPlanned: '2024-02-18',
          transitPortActual: '2024-02-20',
          destinationPortPlanned: '2024-02-25',
          destinationPortActual: '2024-02-27',
          projectSitePlanned: '2024-03-01',
          projectSiteActual: '2024-03-03',
          actualTransportDays: 17,
          remark: '因天气延误',
          status: 'delayed'
        }
      ],
      selectedRows: [],
      selectAll: false,
      showModal: false,
      modalTitle: '新增记录',
      isEdit: false,
      formData: {
        id: null,
        batchNumber: '',
        sequence: '',
        forwarderId: '',
        projectName: '',
        packageName: '',
        manufacturingCompleteTime: '',
        factoryDeliveryTime: '',
        domesticDeparturePlanned: '',
        splitPlannedTime: '',
        splitActualTime: '',
        transitPortPlanned: '',
        transitPortActual: '',
        destinationPortPlanned: '',
        destinationPortActual: '',
        projectSitePlanned: '',
        projectSiteActual: '',
        remark: '',
        status: 'in-progress'
      },
      forwarderList: [],
      isMounted: false
    }
  },
  watch: {
    selectedRows(newVal) {
      this.selectAll = newVal.length === this.tableData.length && this.tableData.length > 0
    }
  },
  computed: {
  },
  created() {
    this.loadForwarderData()
  },
  mounted() {
    this.isMounted = true
  },
  beforeUnmount() {
    this.isMounted = false
  },
  methods: {
    
    handleSearch() {
      console.log('查询条件:', this.filters)
      // 这里实现查询逻辑
    },
    handleReset() {
      this.filters = {
        projectName: '',
        packageName: '',
        batchNumber: '',
        forwarderId: ''
      }
    },
    handleAdd() {
      this.modalTitle = '新增记录'
      this.isEdit = false
      this.formData = {
        id: null,
        batchNumber: '',
        sequence: this.tableData.length + 1,
        forwarderId: '',
        projectName: '',
        packageName: '',
        manufacturingCompleteTime: '',
        factoryDeliveryTime: '',
        domesticDeparturePlanned: '',
        splitPlannedTime: '',
        splitActualTime: '',
        transitPortPlanned: '',
        transitPortActual: '',
        destinationPortPlanned: '',
        destinationPortActual: '',
        projectSitePlanned: '',
        projectSiteActual: '',
        remark: '',
        status: 'in-progress'
      }
      this.showModal = true
    },
    handleEdit(row) {
      this.modalTitle = '编辑记录'
      this.isEdit = true
      this.formData = { ...row }
      this.showModal = true
    },
    handleDelete(row) {
      if (confirm(`确定要删除记录"${row.batchNumber}-${row.sequence}"吗？`)) {
        this.tableData = this.tableData.filter(item => item.id !== row.id)
        this.selectedRows = this.selectedRows.filter(id => id !== row.id)
        console.log('删除记录:', row)
      }
    },
    
    handleBatchDelete() {
      if (confirm(`确定要删除选中的 ${this.selectedRows.length} 条记录吗？`)) {
        this.tableData = this.tableData.filter(item => !this.selectedRows.includes(item.id))
        this.selectedRows = []
      }
    },
    handleExport() {
      alert('导出数据功能')
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
    loadForwarderData() {
      // 这里应该从API获取货代商数据，暂时使用模拟数据
      this.forwarderList = [
        { id: 1, name: '中外运物流有限公司' },
        { id: 2, name: '顺丰速运' },
        { id: 3, name: 'DHL国际快递' }
      ]
    },
    getForwarderName(forwarderId) {
      const forwarder = this.forwarderList.find(item => item.id === forwarderId)
      return forwarder ? forwarder.name : ''
    },
    handleSubmit() {
      if (!this.formData.batchNumber || !this.formData.sequence || !this.formData.projectName) {
        alert('请填写必填项！')
        return
      }
      
      if (this.isEdit) {
        const index = this.tableData.findIndex(item => item.id === this.formData.id)
        if (index !== -1) {
          this.tableData.splice(index, 1, { ...this.formData })
          this.calculateFields(this.tableData[index])
        }
      } else {
        const newId = Math.max(...this.tableData.map(item => item.id)) + 1
        const newRecord = {
          ...this.formData,
          id: newId
        }
        this.tableData.push(newRecord)
        this.calculateFields(newRecord)
      }
      
      this.showModal = false
      alert(this.isEdit ? '修改成功！' : '新增成功！')
    },
    calculateFields(row) {
      // 计算起运延误天数
      if (row.domesticDeparturePlanned && row.domesticDepartureActual) {
        const plannedDate = new Date(row.domesticDeparturePlanned)
        const actualDate = new Date(row.domesticDepartureActual)
        const timeDiff = actualDate.getTime() - plannedDate.getTime()
        row.departureDelayDays = Math.ceil(timeDiff / (1000 * 3600 * 24))
      } else {
        row.departureDelayDays = 0
      }

      // 计算实际运输时间
      if (row.projectSiteActual && row.domesticDepartureActual) {
        const departureDate = new Date(row.domesticDepartureActual)
        const arrivalDate = new Date(row.projectSiteActual)
        const timeDiff = arrivalDate.getTime() - departureDate.getTime()
        row.actualTransportDays = Math.ceil(timeDiff / (1000 * 3600 * 24))
      } else {
        row.actualTransportDays = 0
      }
    },
    
  }
}
</script>

<style scoped>
.subcontract-logistics-maintenance {
  padding: 20px;
  /* 确保组件整体不会溢出页面 */
  max-width: 100%;
  box-sizing: border-box;
  overflow-x: hidden;
}

.card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  /* 确保卡片不会超出容器宽度 */
  max-width: 100%;
  box-sizing: border-box;
}

.table-card {
  /* 确保表格卡片不会影响页面整体布局 */
  overflow: hidden;
  max-width: 100%;
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
  width: 100%;
  max-width: 100%;
  /* 确保滚动在容器内部进行，不影响页面整体布局 */
  /* 移除 min-width: 1600px，避免强制表格最小宽度导致页面滚动 */
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
  /* 确保表格宽度不会超过容器 */
  table-layout: auto;
}

.data-table th,
.data-table td {
  padding: 12px 8px;
  text-align: center;
  border-bottom: 1px solid #eee;
  vertical-align: middle;
}

/* 设置各列宽度，使用百分比和固定宽度结合 */
.data-table th:nth-child(1),
.data-table td:nth-child(1) {
  width: 60px;
}

.data-table th:nth-child(2),
.data-table td:nth-child(2) {
  width: 12%;
}

.data-table th:nth-child(3),
.data-table td:nth-child(3) {
  width: 80px;
}

.data-table th:nth-child(4),
.data-table td:nth-child(4) {
  width: 8%;
}

.data-table th:nth-child(5),
.data-table td:nth-child(5) {
  width: 8%;
}

.data-table th:nth-child(6),
.data-table td:nth-child(6) {
  width: 8%;
}

.data-table th:nth-child(7),
.data-table td:nth-child(7) {
  width: 10%;
}

.data-table th:nth-child(8),
.data-table td:nth-child(8) {
  width: 10%;
}

.data-table th:nth-child(9),
.data-table td:nth-child(9) {
  width: 10%;
}

.data-table th:nth-child(10),
.data-table td:nth-child(10) {
  width: 8%;
}

.data-table th:nth-child(11),
.data-table td:nth-child(11) {
  width: 8%;
}

.data-table th:nth-child(12),
.data-table td:nth-child(12) {
  width: 8%;
}

.data-table th:nth-child(13),
.data-table td:nth-child(13) {
  width: 8%;
}

.data-table th:nth-child(14),
.data-table td:nth-child(14) {
  width: 8%;
}

.data-table th:nth-child(15),
.data-table td:nth-child(15) {
  width: 8%;
}

/* 备注列 */
.data-table th:nth-child(16),
.data-table td:nth-child(16) {
  width: 15%;
}

.data-table th:nth-child(17),
.data-table td:nth-child(17) {
  width: 140px;
}

.data-table th:nth-child(9),
.data-table td:nth-child(9) {
  width: 8%;
}

.data-table th:nth-child(10),
.data-table td:nth-child(10) {
  width: 8%;
}

/* 备注列 */
.data-table th:nth-child(9),
.data-table td:nth-child(9) {
  width: 15%;
}

.data-table th:nth-child(10),
.data-table td:nth-child(10) {
  width: 140px;
}

.data-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
  font-size: 14px;
  border-right: 1px solid #ddd;
  position: relative;
}

.data-table th:last-child {
  border-right: none;
}

.data-table th:last-child {
  border-right: none;
}

.data-table th[colspan] {
  background: #e8f4fd;
  font-weight: 700;
  text-align: center;
  color: #1976d2;
}

.data-table th:has(br) {
  background: #e8f4fd;
  font-weight: 700;
  text-align: center;
  color: #1976d2;
  line-height: 1.3;
}

/* 基础信息分组样式 */
.data-table thead tr:first-child th[colspan="4"] {
  background: #e3f2fd;
  font-weight: 700;
  text-align: center;
  color: #1976d2;
  border-right: 2px solid #bbdefb;
}

/* 子表头样式 */
.data-table thead tr:last-child th {
  background: #f8f9fa;
  font-weight: 600;
  color: #495057;
  font-size: 10px;
  border-top: 2px solid #dee2e6;
}

.data-table thead tr:last-child th:not(:empty) {
  background: #e9ecef;
  font-weight: 700;
  color: #6c757d;
}

.data-table .calculated-field {
  /* 移除黄色背景，保持普通样式 */
}

.data-table input[type="date"],
.data-table input[type="number"] {
  width: 100%;
  padding: 8px 10px;
  border: 1px solid #ddd;
  border-radius: 3px;
  font-size: 13px;
  box-sizing: border-box;
  text-align: center;
}

.data-table input[readonly] {
  background-color: #f5f5f5;
  color: #666;
  padding: 6px 8px;
}

.data-table .calculated-field input {
  /* 移除黄色背景，保持普通样式 */
}

.data-table textarea {
  width: 100%;
  padding: 4px 6px;
  border: 1px solid #ddd;
  border-radius: 3px;
  font-size: 12px;
  box-sizing: border-box;
  text-align: left;
  resize: vertical;
  min-height: 32px;
}

.data-table input[readonly] {
  background-color: #f5f5f5;
  color: #666;
  padding: 6px 8px;
}

.data-table .calculated-field input {
  /* 移除黄色背景，保持普通样式 */
}

.data-table textarea {
  resize: vertical;
  min-height: 32px;
  width: 100%;
  box-sizing: border-box;
}

.checkbox-col {
  text-align: center;
  vertical-align: middle;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px 4px;
  background: #f8f9fa;
  border-right: 1px solid #dee2e6;
  position: relative;
  z-index: 10;
}

.checkbox-col input[type="checkbox"] {
  width: 16px;
  height: 16px;
  margin: 0;
  cursor: pointer;
  border: 1px solid #007bff;
  background: white;
  accent-color: #007bff;
  border-radius: 3px;
  box-shadow: none;
}

.checkbox-col input[type="checkbox"]:checked {
  background-color: #007bff;
  border-color: #007bff;
  background-image: url("data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='white' xmlns='http://www.w3.org/2000/svg'%3e%3cpath d='m13.854 3.646-7.5 7.5a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6 10.293l7.146-7.147a.5.5 0 0 1 .708.708z'/%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: center;
  background-size: 10px;
}

.checkbox-col input[type="checkbox"]:focus {
  outline: 1px solid #007bff;
  outline-offset: 1px;
}

.checkbox-col input[type="checkbox"]:hover {
  border-color: #0056b3;
}

.action-col {
  display: flex;
  justify-content: center;
  gap: 12px;
  padding: 8px;
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
  width: 1200px;
  max-width: 95vw;
  max-height: 90vh;
  overflow-y: auto;
  overflow-x: hidden;
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

.form-sections {
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.form-section {
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  padding: 20px;
  background: #fafafa;
}

.section-title {
  margin: 0 0 20px 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
  border-bottom: 2px solid #3b82f6;
  padding-bottom: 8px;
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.form-grid .form-item {
  display: flex;
  align-items: center;
  min-width: 0;
  margin-bottom: 0;
  flex-direction: row;
}

.form-grid .form-item label {
  flex-shrink: 0;
  margin-right: 10px;
  margin-bottom: 0;
  white-space: nowrap;
  width: 100px;
  text-align: right;
  align-self: center;
}

.form-grid .form-item input,
.form-grid .form-item select {
  flex: 1;
  min-width: 0;
  margin-bottom: 0;
  align-self: center;
  height: 32px;
}

.logistics-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.logistics-grid .form-item {
  display: flex;
  align-items: center;
  min-width: 0;
  margin-bottom: 0;
  flex-direction: row;
}

.logistics-grid .form-item label {
  flex-shrink: 0;
  margin-right: 10px;
  margin-bottom: 0;
  white-space: nowrap;
  width: 180px;
  text-align: right;
  align-self: center;
}

.logistics-grid .form-item input {
  flex: 1;
  min-width: 0;
  margin-bottom: 0;
  align-self: center;
  height: 32px;
}

.form-item {
  display: flex;
  flex-direction: column;
}

.form-item.full-width {
  grid-column: span 2;
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
  width: 100%;
  box-sizing: border-box;
}

.form-item.full-width textarea {
  width: 100%;
  min-height: 120px;
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

.btn-info {
  background: #06b6d4;
  color: white;
}

.btn-info:hover {
  background: #0891b2;
}

.btn-text {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 12px;
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