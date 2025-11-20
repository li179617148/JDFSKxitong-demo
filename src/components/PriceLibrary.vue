<template>
  <div class="price-library">
    <div class="toolbar">
      <div class="header-buttons">
        <button class="btn-secondary" @click="downloadImportTemplate">导入模板下载</button>
        <input ref="importFile" type="file" @change="handleImport" accept=".csv" style="display: none;" />
        <button class="btn-info" @click="triggerImport">导入</button>
        <button class="btn-primary" @click="addPrice">新增价格</button>
        <button class="btn-metal" @click="showMetalPrices">铜钢材实时价格</button>
      </div>
      <div class="search-box" style="display: flex; align-items: center; gap: 10px;">
        <input type="text" placeholder="搜索价格项目..." v-model="searchKeyword" style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <button @click="handleSearch" style="background: #1890ff; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 14px;">搜索</button>
      </div>
    </div>
    
    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>序号</th>
            <th>项目名称</th>
            <th>规格型号</th>
            <th>单位</th>
            <th>价格(元)</th>
            <th>更新时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in displayList" :key="item.id">
            <td>{{ index + 1 }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.spec }}</td>
            <td>{{ item.unit }}</td>
            <td class="price-value">{{ item.price }}</td>
            <td class="update-time">{{ item.updateTime }}</td>
            <td>
              <button class="btn-success btn-sm" @click="handleView(item)">查看</button>
        <button class="btn-primary btn-sm" @click="editPrice(item)">编辑</button>
        <button class="btn-danger btn-sm" @click="deletePrice(item.id)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 查看价格信息弹窗 -->
    <div v-if="showViewModal" class="modal-overlay">
      <div class="modal large-modal" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">
          <span>价格信息详情</span>
          <button class="btn-close" @click="showViewModal = false">×</button>
        </div>
        <div class="modal-body">
          <!-- 审批信息部分 -->
          <div class="form-section" v-if="viewForm.approvalStatus !== 'draft'">
            <h4>审批信息</h4>
            <div class="readonly-info">
              <div class="info-grid">
                <div class="info-item">
                  <label>审批状态：</label>
                  <span :class="getStatusClass(viewForm.approvalStatus)">
                    {{ getStatusText(viewForm.approvalStatus) }}
                  </span>
                </div>
                <div class="info-item">
                  <label>审批意见：</label>
                  <span>{{ viewForm.approvalOpinion || '暂无审批意见' }}</span>
                </div>
                <div class="info-item">
                  <label>提交人：</label>
                  <span>{{ viewForm.submitter || '系统管理员' }}</span>
                </div>
                <div class="info-item">
                  <label>提交时间：</label>
                  <span>{{ viewForm.submitTime || viewForm.updateTime }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 价格基本信息 -->
          <div class="form-section">
            <h4>价格基本信息</h4>
            <div class="readonly-info">
              <div class="info-grid">
                <div class="info-item">
                  <label>项目名称：</label>
                  <span>{{ viewForm.name }}</span>
                </div>
                <div class="info-item">
                  <label>规格型号：</label>
                  <span>{{ viewForm.spec }}</span>
                </div>
                <div class="info-item">
                  <label>单位：</label>
                  <span>{{ viewForm.unit }}</span>
                </div>
                <div class="info-item">
                  <label>价格(元)：</label>
                  <span class="price-value">{{ viewForm.price }}</span>
                </div>
                <div class="info-item">
                  <label>更新时间：</label>
                  <span class="update-time">{{ viewForm.updateTime }}</span>
                </div>
                <div class="info-item full-width">
                  <label>价格说明：</label>
                  <div class="summary-text">{{ viewForm.description || '暂无说明' }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- 价格历史记录 -->
          <div class="form-section" v-if="viewForm.priceHistory && viewForm.priceHistory.length > 0">
            <h4>价格历史记录</h4>
            <table class="process-table">
              <thead>
                <tr>
                  <th>序号</th>
                  <th>价格(元)</th>
                  <th>更新时间</th>
                  <th>更新人</th>
                  <th>备注</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(history, index) in viewForm.priceHistory" :key="index">
                  <td>{{ index + 1 }}</td>
                  <td>{{ history.price }}</td>
                  <td>{{ history.updateTime }}</td>
                  <td>{{ history.updater }}</td>
                  <td>{{ history.remark || '-' }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-secondary" @click="showViewModal = false">关闭</button>
        </div>
      </div>
    </div>
    
    <!-- 金属实时价格弹窗 -->
    <div v-if="showMetalPriceModal" class="modal-overlay">
      <div class="modal">
        <div class="modal-header">
          <span>铜、钢材实时价格</span>
          <button class="btn-close" @click="showMetalPriceModal = false">×</button>
        </div>
        <div class="modal-body">
          <table class="data-table">
            <thead>
              <tr>
                <th>名称</th>
                <th>规格</th>
                <th>单位</th>
                <th>价格(元)</th>
                <th>涨跌幅</th>
                <th>更新时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in metalPrices" :key="index">
                <td>{{ item.name }}</td>
                <td>{{ item.spec }}</td>
                <td>{{ item.unit }}</td>
                <td class="price-value">{{ item.price }}</td>
                <td :class="`price-change ${item.changeType}`">
                  {{ item.change }}
                </td>
                <td class="update-time">{{ item.updateTime }}</td>
              </tr>
            </tbody>
          </table>
          <p class="price-note">注：以上价格为市场参考价，实际价格以交易时为准。</p>
        </div>
        <div class="modal-footer">
          <button class="btn-primary" @click="showMetalPriceModal = false">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'PriceLibrary',
  data() {
    return {
      searchKeyword: '',
      showViewModal: false,
      showMetalPriceModal: false,
      viewForm: {
        id: null,
        name: '',
        spec: '',
        unit: '',
        price: '',
        updateTime: '',
        description: '',
        approvalStatus: 'approved',
        approvalOpinion: '',
        submitter: '',
        submitTime: '',
        priceHistory: []
      },
      metalPrices: [],
      priceList: []
    }
  },
  computed: {
    displayList() {
      if (!this.searchKeyword) {
        return this.priceList
      }
      const keyword = this.searchKeyword.toLowerCase()
      return this.priceList.filter(item => 
        item.name.toLowerCase().includes(keyword) ||
        item.spec.toLowerCase().includes(keyword) ||
        item.unit.toLowerCase().includes(keyword)
      )
    }
  },
  created() {
    this.loadPriceData()
  },
  methods: {
    loadPriceData() {
      // 从本地存储或API加载价格数据
      const savedPriceData = localStorage.getItem('priceLibraryData')
      if (savedPriceData) {
        this.priceList = JSON.parse(savedPriceData)
      } else {
        // 如果没有保存的数据，使用默认数据
        this.priceList = [
          {
            id: 1,
            name: '钢材',
            spec: 'HRB400 Φ20',
            unit: '吨',
            price: 3850,
            updateTime: '2024-01-15',
            description: '建筑用螺纹钢，HRB400级别，直径20mm',
            approvalStatus: 'approved',
            approvalOpinion: '价格合理，审核通过',
            submitter: '采购部-张三',
            submitTime: '2024-01-15 10:30:00',
            priceHistory: [
              { price: 3800, updateTime: '2024-01-10', updater: '系统管理员', remark: '初始价格' },
              { price: 3850, updateTime: '2024-01-15', updater: '采购部-张三', remark: '市场调价' }
            ]
          },
          {
            id: 2,
            name: '水泥',
            spec: 'P.O 42.5',
            unit: '吨',
            price: 320,
            updateTime: '2024-01-14',
            description: '普通硅酸盐水泥，P.O 42.5标号',
            approvalStatus: 'approved',
            approvalOpinion: '价格符合市场行情',
            submitter: '采购部-李四',
            submitTime: '2024-01-14 14:20:00',
            priceHistory: [
              { price: 310, updateTime: '2024-01-05', updater: '系统管理员', remark: '初始价格' },
              { price: 320, updateTime: '2024-01-14', updater: '采购部-李四', remark: '供应商调价' }
            ]
          },
          {
            id: 3,
            name: '商品混凝土',
            spec: 'C30',
            unit: '立方米',
            price: 450,
            updateTime: '2024-01-14',
            updater: '采购部-李四',
            remark: '供应商调价',
            priceHistory: [
              { price: 440, updateTime: '2024-01-05', updater: '系统管理员', remark: '初始价格' },
              { price: 450, updateTime: '2024-01-14', updater: '采购部-李四', remark: '供应商调价' }
            ]
          }
        ]
        this.savePriceData()
      }
    },
    
    savePriceData() {
      localStorage.setItem('priceLibraryData', JSON.stringify(this.priceList))
    },
    
    handleSearch() {
      // 搜索逻辑已在computed中实现
    },
    addPrice() {
      alert('新增价格功能')
    },
    editPrice(item) {
      alert(`编辑价格: ${item.name}`)
    },
    deletePrice(id) {
      if (confirm('确定删除该价格项吗？')) {
        this.priceList = this.priceList.filter(item => item.id !== id)
        this.savePriceData()
      }
    },
    downloadImportTemplate() {
      const headers = ['项目名称','规格型号','单位','价格(元)','价格说明']
      const csvContent = headers.join(',') + '\n'
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
      const url = URL.createObjectURL(blob)
      const link = document.createElement('a')
      link.href = url
      link.download = '价格库导入模板.csv'
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      URL.revokeObjectURL(url)
    },
    triggerImport() {
      const input = this.$refs.importFile
      if (input && input instanceof HTMLInputElement) {
        input.value = ''
        input.click()
      } else {
        alert('导入控件不可用')
      }
    },
    handleImport(event) {
      const input = event && event.target ? event.target : null
      if (!input || !input.files || input.files.length === 0) {
        alert('未选择文件')
        return
      }
      const file = input.files[0]
      if (!file.name.toLowerCase().endsWith('.csv')) {
        alert('仅支持CSV文件导入')
        return
      }
      const reader = new FileReader()
      reader.onload = (e) => {
        try {
          const text = e.target && e.target.result ? String(e.target.result) : ''
          const lines = text.split(/\r?\n/).filter(l => l.trim().length > 0)
          if (lines.length <= 1) {
            alert('文件内容为空或格式不正确')
            return
          }
          const header = lines[0].split(',')
          const expected = ['项目名称','规格型号','单位','价格(元)','价格说明']
          const valid = expected.every((h, i) => (header[i] || '').trim() === h)
          if (!valid) {
            alert('CSV表头不匹配，请使用模板导入')
            return
          }
          const added = []
          for (let i = 1; i < lines.length; i++) {
            const cols = lines[i].split(',')
            if (cols.length < expected.length) continue
            const priceItem = {
              id: Date.now() + i,
              name: (cols[0] || '').trim(),
              spec: (cols[1] || '').trim(),
              unit: (cols[2] || '').trim(),
              price: parseFloat(cols[3]) || 0,
              description: (cols[4] || '').trim(),
              updateTime: new Date().toISOString().split('T')[0],
              approvalStatus: 'pending',
              approvalOpinion: '',
              submitter: '系统导入',
              submitTime: new Date().toISOString().replace('T', ' ').split('.')[0],
              priceHistory: [
                { 
                  price: parseFloat(cols[3]) || 0, 
                  updateTime: new Date().toISOString().split('T')[0], 
                  updater: '系统导入', 
                  remark: '初始导入' 
                }
              ]
            }
            // 简单校验
            if (!priceItem.name) continue
            this.priceList.push(priceItem)
            added.push(priceItem)
          }
          alert(`成功导入 ${added.length} 条价格信息`)
        } catch (err) {
          console.error(err)
          alert('导入失败，请检查文件格式')
        }
      }
      reader.onerror = () => {
        alert('文件读取失败')
      }
      reader.readAsText(file, 'utf-8')
    },
    handleView(item) {
      this.viewForm = { ...item }
      this.showViewModal = true
    },
    getStatusClass(status) {
      const statusMap = {
        'draft': 'status-draft',
        'pending': 'status-pending',
        'approved': 'status-approved'
      }
      return statusMap[status] || ''
    },
    getStatusText(status) {
      const statusMap = {
        'draft': '未提交',
        'pending': '审批中',
        'approved': '已审批'
      }
      return statusMap[status] || status
    },
    
    showMetalPrices() {
      // 模拟获取实时金属价格数据
      this.metalPrices = [
        {
          name: '铜',
          spec: '电解铜',
          unit: '吨',
          price: 72500,
          change: '+2.3%',
          changeType: 'up',
          updateTime: new Date().toLocaleString('zh-CN')
        },
        {
          name: '铜',
          spec: '铜管',
          unit: '吨',
          price: 78300,
          change: '+1.8%',
          changeType: 'up',
          updateTime: new Date().toLocaleString('zh-CN')
        },
        {
          name: '钢材',
          spec: '螺纹钢 HRB400',
          unit: '吨',
          price: 3950,
          change: '-0.5%',
          changeType: 'down',
          updateTime: new Date().toLocaleString('zh-CN')
        },
        {
          name: '钢材',
          spec: '线材 HPB300',
          unit: '吨',
          price: 4120,
          change: '0%',
          changeType: 'stable',
          updateTime: new Date().toLocaleString('zh-CN')
        },
        {
          name: '钢材',
          spec: '热轧板卷',
          unit: '吨',
          price: 4380,
          change: '+0.8%',
          changeType: 'up',
          updateTime: new Date().toLocaleString('zh-CN')
        }
      ]
      
      // 显示金属价格模态框
      this.showMetalPriceModal = true
    }
  }
}
</script>

<style scoped>
.price-library {
  background: #f8f9fa;
  min-height: 100vh;
  padding: 24px;
  overflow: auto;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  background: white;
  padding: 16px 24px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  border: 1px solid #f0f0f0;
}

.header-buttons {
  display: flex;
  gap: 10px;
}

.search-box {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: nowrap;
}

.search-box input {
  flex: 1;
  min-width: 150px;
  outline: none;
  transition: border-color 0.3s ease;
}

.search-box input:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

.btn-search {
  padding: 8px 16px !important;
  background: #1890ff !important;
  color: white !important;
  border: none !important;
  border-radius: 4px !important;
  cursor: pointer !important;
  font-size: 14px !important;
  font-weight: 500 !important;
  transition: all 0.3s ease !important;
  display: inline-block !important;
  text-align: center !important;
  line-height: 1.4 !important;
  white-space: nowrap !important;
  vertical-align: middle !important;
}

.btn-search:hover {
  background: #40a9ff !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.3) !important;
}

.search-box .btn-info.btn-search {
  background: #1890ff !important;
  color: white !important;
  border: none !important;
  padding: 8px 16px !important;
  font-size: 14px !important;
  font-weight: 500 !important;
  border-radius: 4px !important;
  cursor: pointer !important;
  transition: all 0.3s ease !important;
  display: inline-block !important;
  text-align: center !important;
  line-height: 1.4 !important;
}

.search-box .btn-info.btn-search:hover {
  background: #40a9ff !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.3) !important;
}

.btn-metal {
  background: #1890ff !important;
  color: white !important;
  border: none !important;
  padding: 8px 16px !important;
  border-radius: 8px !important;
  cursor: pointer !important;
  font-size: 16px !important;
  font-weight: 500 !important;
  transition: all 0.3s ease !important;
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3) !important;
}

.btn-metal:hover {
  background: #40a9ff !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 6px 16px rgba(24, 144, 255, 0.4) !important;
}

.table-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  border: 1px solid #f0f0f0;
  overflow: hidden;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.data-table th,
.data-table td {
  padding: 12px 16px;
  border: 1px solid #f0f0f0;
  text-align: left;
}

.data-table th {
  background: #fafafa;
  font-weight: 600;
  color: #262626;
  border-bottom: 2px solid #f0f0f0;
}

.data-table tbody tr:hover {
  background: #f8f9fa;
}

.data-table tbody tr:nth-child(even) {
  background: #fafafa;
}

.data-table tbody tr:nth-child(even):hover {
  background: #f8f9fa;
}



/* 弹窗样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.large-modal {
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  width: 800px;
  max-width: 90vw;
  max-height: 90vh;
  overflow: auto;
}

.modal-header {
  padding: 16px 20px;
  border-bottom: 1px solid #eee;
  font-size: 16px;
  font-weight: 600;
  display: flex;
  justify-content: space-between;
  align-items: center;
}



.modal-body {
  padding: 20px;
  max-height: 600px;
  overflow-y: auto;
}

.modal-footer {
  padding: 16px 20px;
  border-top: 1px solid #eee;
  display: flex;
  gap: 12px;
  justify-content: center;
}



/* 表单部分样式 */
.form-section {
  margin-bottom: 24px;
  border: 1px solid #e8e8e8;
  border-radius: 6px;
  padding: 16px;
  background: #fafafa;
}

.form-section h4 {
  margin: 0 0 12px 0;
  color: #1890ff;
  font-size: 14px;
  font-weight: 600;
  padding-bottom: 8px;
  border-bottom: 2px solid #1890ff;
}

.readonly-info {
  background: white;
  border-radius: 4px;
  padding: 16px;
  border: 1px solid #e8e8e8;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.info-item {
  display: flex;
  align-items: center;
  min-height: 32px;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-item label {
  min-width: 100px;
  font-weight: 500;
  color: #666;
  margin-right: 8px;
}

.info-item span {
  flex: 1;
  color: #333;
}

.summary-text {
  white-space: pre-wrap;
  line-height: 1.5;
  padding: 8px;
  background: #f8f9fa;
  border-radius: 4px;
  border: 1px solid #e8e8e8;
  margin-top: 8px;
}

/* 状态样式 */
.status-draft {
  color: #f56c6c;
  font-weight: 500;
}

.status-pending {
  color: #e6a23c;
  font-weight: 500;
}

.status-approved {
  color: #67c23a;
  font-weight: 500;
}

/* 价格变化样式 */
.price-change.up {
  color: #f56c6c;
  font-weight: 500;
}

.price-change.down {
  color: #67c23a;
  font-weight: 500;
}

.price-change.stable {
  color: #909399;
  font-weight: 500;
}

.price-note {
  margin-top: 16px;
  color: #909399;
  font-size: 12px;
  font-style: italic;
  text-align: center;
}

/* 流程表格样式 */
.process-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 12px;
  margin-top: 8px;
}

.process-table th,
.process-table td {
  padding: 8px;
  border: 1px solid #e8e8e8;
  text-align: center;
}

.process-table th {
  background: #f8f9fa;
  font-weight: 500;
}

.process-table tr:hover {
  background: #f5f5f5;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .toolbar {
    flex-direction: column;
    gap: 12px;
    align-items: stretch;
  }
  
  .search-box {
    width: 100%;
  }
  
  .search-box input {
    width: 100%;
  }
  
  .info-grid {
    grid-template-columns: 1fr;
  }
  
  .large-modal {
    width: 95%;
  }
}
</style>