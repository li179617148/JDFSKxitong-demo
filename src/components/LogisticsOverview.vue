<template>
  <div class="logistics-overview">
    <!-- 物流状态统计 -->
    <div class="card stats-card">
      <h4>物流状态统计</h4>
      <div class="stats-grid">
        <div class="stat-item">
          <span class="stat-label">总记录数：</span>
          <span class="stat-value">{{ filteredData.length }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">进行中：</span>
          <span class="stat-value in-progress">{{ getStatusCount('in-progress') }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">已完成：</span>
          <span class="stat-value completed">{{ getStatusCount('completed') }}</span>
        </div>
        <div class="stat-item">
          <span class="stat-label">已延误：</span>
          <span class="stat-value delayed">{{ getStatusCount('delayed') }}</span>
        </div>
        
      </div>
    </div>

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
        <div class="filter-item">
          <label>物流状态：</label>
          <select v-model="filters.status">
            <option value="">全部</option>
            <option value="in-progress">进行中</option>
            <option value="completed">已完成</option>
            <option value="delayed">已延误</option>
          </select>
        </div>
        <div class="filter-item filter-actions">
          <button class="btn btn-primary" @click="handleSearch">查询</button>
          <button class="btn btn-secondary" @click="handleReset">重置</button>
        </div>
      </div>
    </div>

    <!-- 数据表格 -->
    <div class="card table-card">
      <div class="table-header">
        <h3>物流总览</h3>
        <span class="record-count">共 {{ filteredData.length }} 条记录</span>
      </div>
      
      <div class="table-wrapper">
        <table class="data-table">
          <thead>
            <tr>
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
              <th>状态</th>
              <th>备注</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="row in filteredData" :key="row.id">
              <td>{{ row.projectName }}</td>
              <td>{{ row.packageName }}</td>
              <td>{{ row.sequence }}</td>
              <td>{{ row.batchNumber }}</td>
              <td>{{ getForwarderName(row.forwarderId) }}</td>
              <td>{{ row.manufacturingCompleteTime }}</td>
              <td>{{ row.factoryDeliveryTime }}</td>
              <td>{{ row.domesticDeparturePlanned }}</td>
              <td>{{ row.domesticDepartureActual || '未完成' }}</td>
              <td class="calculated-field" :class="{ 'delay-positive': row.departureDelayDays > 0, 'delay-normal': row.departureDelayDays <= 0 }">
                {{ row.departureDelayDays || 0 }}天
              </td>
              <td>{{ row.transitPortPlanned || '未完成' }}</td>
              <td>{{ row.destinationPortPlanned || '未完成' }}</td>
              <td>{{ row.projectSitePlanned || '未完成' }}</td>
              <td>{{ row.projectSiteActual || '未完成' }}</td>
              <td class="calculated-field">{{ row.actualTransportDays || 0 }}天</td>
              <td class="status-col">
                <span class="status-badge" :class="getStatusClass(row.status)">
                  {{ getStatusText(row.status) }}
                </span>
              </td>
              <td>{{ row.remark || '无' }}</td>
              <td class="action-col">
                <button class="btn-text btn-text-primary" @click="handleViewDocuments(row)">查询</button>
              </td>
            </tr>
            <tr v-if="filteredData.length === 0">
              <td colspan="18" class="empty-data">暂无数据</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 单据查看弹窗 -->
    <div v-if="showDocumentModal" class="modal-overlay" @click="handleCloseDocumentModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>单据详情 - {{ selectedRowData?.batchNumber }}-{{ selectedRowData?.sequence }}</h3>
          <button class="modal-close" @click="handleCloseDocumentModal">×</button>
        </div>
        <div class="modal-body">
          <div class="document-section">
            <h4>基础信息</h4>
            <div class="info-grid">
              <div class="info-item">
                <label>所辖项目：</label>
                <span>{{ selectedRowData?.projectName }}</span>
              </div>
              <div class="info-item">
                <label>包件名称：</label>
                <span>{{ selectedRowData?.packageName }}</span>
              </div>
              <div class="info-item">
                <label>批次号：</label>
                <span>{{ selectedRowData?.batchNumber }}</span>
              </div>
              <div class="info-item">
                <label>货代商：</label>
                <span>{{ getForwarderName(selectedRowData?.forwarderId) }}</span>
              </div>
            </div>
          </div>

          <div class="document-section">
            <h4>物流时间信息</h4>
            <div class="info-grid">
              <div class="info-item">
                <label>制造完成时间：</label>
                <span>{{ selectedRowData?.manufacturingCompleteTime || '未设置' }}</span>
              </div>
              <div class="info-item">
                <label>工厂交货时间：</label>
                <span>{{ selectedRowData?.factoryDeliveryTime || '未设置' }}</span>
              </div>
              <div class="info-item">
                <label>国内起运时间（计划）：</label>
                <span>{{ selectedRowData?.domesticDeparturePlanned || '未设置' }}</span>
              </div>
              <div class="info-item">
                <label>国内起运时间（实际）：</label>
                <span>{{ selectedRowData?.domesticDepartureActual || '未设置' }}</span>
              </div>
              <div class="info-item">
                <label>运抵中转港时间：</label>
                <span>{{ selectedRowData?.transitPortPlanned || '未设置' }}</span>
              </div>
              <div class="info-item">
                <label>运抵目的港时间：</label>
                <span>{{ selectedRowData?.destinationPortPlanned || '未设置' }}</span>
              </div>
              <div class="info-item">
                <label>运抵项目现场时间（计划）：</label>
                <span>{{ selectedRowData?.projectSitePlanned || '未设置' }}</span>
              </div>
              <div class="info-item">
                <label>运抵项目现场时间（实际）：</label>
                <span>{{ selectedRowData?.projectSiteActual || '未设置' }}</span>
              </div>
            </div>
          </div>

          <div class="document-section">
            <h4>相关单据</h4>
            <div class="document-list">
              <div class="document-item">
                <label>国内起运提单号单据：</label>
                <button 
                  class="btn btn-small btn-primary" 
                  @click="viewDocument('domesticDeparture', selectedRowData)"
                  :disabled="!selectedRowData?.domesticDepartureActual"
                >
                  查看
                </button>
              </div>
              <div class="document-item">
                <label>汽运运输单据：</label>
                <button 
                  class="btn btn-small btn-primary" 
                  @click="viewDocument('transitPort', selectedRowData)"
                  :disabled="!selectedRowData?.transitPortPlanned"
                >
                  查看
                </button>
              </div>
              <div class="document-item">
                <label>目的港提单号单据：</label>
                <button 
                  class="btn btn-small btn-primary" 
                  @click="viewDocument('destinationPort', selectedRowData)"
                  :disabled="!selectedRowData?.destinationPortPlanned"
                >
                  查看
                </button>
              </div>
            </div>
          </div>

          <div class="document-section">
            <h4>备注信息</h4>
            <div class="remark-content">
              {{ selectedRowData?.remark || '无备注信息' }}
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="handleCloseDocumentModal">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LogisticsOverview',
  data() {
    return {
      filters: {
        projectName: '',
        packageName: '',
        batchNumber: '',
        forwarderId: '',
        status: ''
      },
      showDocumentModal: false,
      selectedRowData: null,
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
          departureDelayDays: 1,
          transitPortPlanned: '2024-02-01',
          destinationPortPlanned: '2024-02-10',
          projectSitePlanned: '2024-02-15',
          projectSiteActual: '2024-02-16',
          actualTransportDays: 24,
          remark: '运输正常',
          status: 'completed'
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
          departureDelayDays: 0,
          transitPortPlanned: '2024-02-05',
          destinationPortPlanned: '2024-02-12',
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
          departureDelayDays: 5,
          transitPortPlanned: '2024-02-18',
          destinationPortPlanned: '2024-02-25',
          projectSitePlanned: '2024-03-01',
          projectSiteActual: '2024-03-03',
          actualTransportDays: 17,
          remark: '因天气延误',
          status: 'delayed'
        },
        {
          id: 4,
          batchNumber: 'BATCH-2024-003',
          sequence: 1,
          forwarderId: 1,
          projectName: '桥梁建设项目',
          packageName: '钢索结构包',
          manufacturingCompleteTime: '2024-02-10',
          factoryDeliveryTime: '2024-02-15',
          domesticDeparturePlanned: '2024-02-18',
          domesticDepartureActual: '',
          departureDelayDays: 0,
          transitPortPlanned: '',
          destinationPortPlanned: '',
          projectSitePlanned: '2024-03-10',
          projectSiteActual: '',
          actualTransportDays: 0,
          remark: '等待起运',
          status: 'in-progress'
        }
      ],
      forwarderList: []
    }
  },
  computed: {
    filteredData() {
      let result = [...this.tableData]
      
      if (this.filters.projectName) {
        result = result.filter(item => item.projectName === this.filters.projectName)
      }
      
      if (this.filters.packageName) {
        result = result.filter(item => 
          item.packageName.toLowerCase().includes(this.filters.packageName.toLowerCase())
        )
      }
      
      if (this.filters.batchNumber) {
        result = result.filter(item => 
          item.batchNumber.toLowerCase().includes(this.filters.batchNumber.toLowerCase())
        )
      }
      
      if (this.filters.forwarderId) {
        result = result.filter(item => item.forwarderId === parseInt(this.filters.forwarderId))
      }
      
      if (this.filters.status) {
        result = result.filter(item => item.status === this.filters.status)
      }
      
      return result
    }
  },
  created() {
    this.loadForwarderData()
  },
  methods: {
    handleSearch() {
      console.log('查询条件:', this.filters)
    },
    handleReset() {
      this.filters = {
        projectName: '',
        packageName: '',
        batchNumber: '',
        forwarderId: '',
        status: ''
      }
    },
    loadForwarderData() {
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
    getStatusClass(status) {
      const statusMap = {
        'in-progress': 'status-in-progress',
        'completed': 'status-completed',
        'delayed': 'status-delayed'
      }
      return statusMap[status] || 'status-unknown'
    },
    getStatusText(status) {
      const statusMap = {
        'in-progress': '进行中',
        'completed': '已完成',
        'delayed': '已延误'
      }
      return statusMap[status] || '未知'
    },
    getStatusCount(status) {
      return this.filteredData.filter(item => item.status === status).length
    },
    handleViewDocuments(row) {
      this.selectedRowData = row
      this.showDocumentModal = true
    },
    handleCloseDocumentModal() {
      this.showDocumentModal = false
      this.selectedRowData = null
    },
    viewDocument(type, row) {
      // 模拟查看单据功能
      const documentMap = {
        'domesticDeparture': {
          name: '国内起运提单号单据',
          filename: `提单号_${row.batchNumber}_${row.sequence}.pdf`,
          url: '#' // 实际应用中这里应该是真实的文件URL
        },
        'transitPort': {
          name: '汽运运输单据',
          filename: `汽运单据_${row.batchNumber}_${row.sequence}.pdf`,
          url: '#'
        },
        'destinationPort': {
          name: '目的港提单号单据',
          filename: `目的港提单_${row.batchNumber}_${row.sequence}.pdf`,
          url: '#'
        }
      }
      
      const doc = documentMap[type]
      if (doc) {
        // 模拟打开文档（在实际应用中可以实现真实的文件下载或预览）
        alert(`正在打开：${doc.name}\n文件名：${doc.filename}\n\n（模拟功能：实际应用中可实现文件预览或下载）`)
      }
    }
  }
}
</script>

<style scoped>
.logistics-overview {
  padding: 20px;
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
  max-width: 100%;
  box-sizing: border-box;
}

.stats-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.stats-card h4 {
  margin: 0 0 15px 0;
  color: white;
  font-size: 16px;
}

.filter-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
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
  grid-column: span 3;
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
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 12px;
  table-layout: auto;
}

.data-table th,
.data-table td {
  padding: 8px 6px;
  text-align: center;
  border-bottom: 1px solid #eee;
  vertical-align: middle;
  white-space: nowrap;
}

.data-table th {
  background: #f5f5f5;
  font-weight: 600;
  color: #333;
  font-size: 12px;
  border-right: 1px solid #ddd;
}

.data-table th:last-child {
  border-right: none;
}

.data-table .calculated-field {
  font-weight: 600;
}

.delay-positive {
  color: #ef4444;
  font-weight: 600;
}

.delay-normal {
  color: #10b981;
  font-weight: 600;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 600;
  text-align: center;
  min-width: 50px;
  display: inline-block;
}

.status-in-progress {
  background: #fef3c7;
  color: #92400e;
}

.status-completed {
  background: #d1fae5;
  color: #065f46;
}

.status-delayed {
  background: #fee2e2;
  color: #991b1b;
}

.empty-data {
  text-align: center;
  color: #999;
  padding: 40px !important;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
}

.stat-value.in-progress {
  color: #fbbf24;
}

.stat-value.completed {
  color: #34d399;
}

.stat-value.delayed {
  color: #f87171;
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

.btn-small {
  padding: 6px 12px;
  font-size: 12px;
  min-width: 60px;
}

.btn-small:disabled {
  background: #e5e7eb;
  color: #9ca3af;
  cursor: not-allowed;
}

.btn-small:not(:disabled):hover {
  background: #2563eb;
}

.action-col {
  display: flex;
  justify-content: center;
  padding: 8px;
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

.document-section {
  margin-bottom: 25px;
  padding: 15px;
  background: #f8f9fa;
  border-radius: 8px;
}

.document-section h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
  border-bottom: 2px solid #3b82f6;
  padding-bottom: 8px;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 15px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.info-item label {
  font-weight: 500;
  color: #666;
  min-width: 140px;
}

.info-item span {
  color: #333;
}

.document-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.document-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px;
  background: white;
  border-radius: 6px;
  border: 1px solid #e5e7eb;
}

.document-item label {
  font-weight: 500;
  color: #666;
  margin-right: 15px;
}



.remark-content {
  padding: 15px;
  background: white;
  border-radius: 6px;
  border: 1px solid #e5e7eb;
  min-height: 80px;
  line-height: 1.5;
  color: #333;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 20px;
  border-top: 1px solid #eee;
}
</style>