<template>
  <div class="material-equipment-approval">
    <!-- 操作按钮区域 -->
    <div class="action-header">
      <div class="header-tabs">
        <button
          class="tab"
          :class="{ active: activeLeftTab === 'form' }"
          @click="activeLeftTab = 'form'"
        >流程表单</button>
        <button
          class="tab"
          :class="{ active: activeLeftTab === 'flow' }"
          @click="activeLeftTab = 'flow'"
        >流程图</button>
        <button
          class="tab"
          :class="{ active: activeLeftTab === 'status' }"
          @click="activeLeftTab = 'status'"
        >流程状态</button>
        <button
          class="tab"
          :class="{ active: activeLeftTab === 'resource' }"
          @click="activeLeftTab = 'resource'"
        >相关资源</button>
      </div>
      <div class="header-buttons">
          <button class="btn-primary" @click="handleSubmit">提交</button>
          <button class="btn-danger" @click="handleReturn">退回</button>
          <button class="btn-warning" @click="handleSave">暂存</button>
          <button class="btn-info" @click="handleCirculate">传阅</button>
        </div>
    </div>

    <div class="approval-content">
      <!-- 右侧审批表单区域 -->
      <div class="right-panel">
        <div class="approval-form" v-show="activeLeftTab === 'form'">
          <!-- 第一部分：审批意见 -->
          <div class="form-section">
            <h4>审批意见</h4>
            <textarea v-model="approvalOpinion" placeholder="请输入审批意见..." rows="6"></textarea>
          </div>

          <!-- 第二部分：流程节点列表 -->
          <div class="form-section">
            <h4>流程节点列表</h4>
            <table class="process-table">
              <thead>
                <tr>
                  <th>节点名称</th>
                  <th>操作部门</th>
                  <th>操作人</th>
                  <th>处理意见</th>
                  <th>操作时间</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(node, index) in processNodes" :key="index">
                  <td>{{ node.nodeName }}</td>
                  <td>{{ node.department }}</td>
                  <td>{{ node.operator }}</td>
                  <td>{{ node.opinion }}</td>
                  <td>{{ node.operateTime }}</td>
                </tr>
              </tbody>
            </table>
          </div>



          <!-- 第四部分：填报信息 -->
          <div class="form-section report-info-section">
            <h4>填报信息</h4>
            <div class="report-info-row">
              <div class="form-item inline">
                <label>填报日期：</label>
                <span>{{ reportInfo.reportDate }}</span>
              </div>
              <div class="form-item inline">
                <label>填报人：</label>
                <span>{{ reportInfo.reporter }}</span>
              </div>
            </div>
          </div>

          <!-- 第五部分：价格信息清单 -->
          <div class="form-section">
            <h4>价格信息清单</h4>
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
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(item, index) in priceInfoList" :key="index">
                    <td>{{ index + 1 }}</td>
                    <td>{{ item.level1Category }}</td>
                    <td>{{ item.level2Category }}</td>
                    <td>{{ item.level3Category }}</td>
                    <td>{{ item.level4Category }}</td>
                    <td>{{ item.equipmentName }}</td>
                    <td>{{ item.equipmentCode }}</td>
                    <td>{{ item.unit }}</td>
                    <td>{{ item.model }}</td>
                    <td>{{ item.specification }}</td>
                    <td>{{ item.exwPrice }}</td>
                    <td>{{ item.deliveryPrice }}</td>
                    <td>{{ item.collectionTime }}</td>
                    <td>{{ item.currency }}</td>
                    <td>{{ item.dataSource }}</td>
                    <td>{{ item.projectName }}</td>
                    <td>{{ item.partnerName }}</td>
                    <td>
                      <div class="file-list" v-if="item.attachments && item.attachments.length > 0">
                        <div class="file-item" v-for="(file, fileIndex) in item.attachments" :key="fileIndex">
                          <span>{{ file.name }}</span>
                        </div>
                      </div>
                      <span v-else>无附件</span>
                    </td>
                  </tr>
                  <tr v-if="priceInfoList.length === 0">
                    <td colspan="18" class="empty-row">暂无价格信息数据</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="info-section" v-show="activeLeftTab === 'flow'">
          <h4>流程图</h4>
          <div class="flow-chart-container">
            <div class="flow-chart">
              <!-- 开始节点 -->
              <div class="flow-node start">开始</div>
              
              <!-- 开始 → 发起 -->
              <div class="flow-arrow">→</div>
              
              <!-- 发起节点 -->
              <div class="flow-node active">发起</div>
              
              <!-- 发起 → 部门审核 -->
              <div class="flow-arrow">→</div>
              
              <!-- 部门审核节点 -->
              <div class="flow-node">分公司部门经理/项目经理审核</div>
              
              <!-- 部门审核 → 领导审批 -->
              <div class="flow-arrow">→</div>
              
              <!-- 领导审批节点 -->
              <div class="flow-node">分公司领导审批</div>
              
              <!-- 领导审批 → 结束 -->
              <div class="flow-arrow">→</div>
              
              <!-- 结束节点 -->
              <div class="flow-node end">结束</div>
            </div>
          </div>
        </div>

        <div class="info-section" v-show="activeLeftTab === 'status'">
          <h4>流程状态</h4>
          <div class="status-info">
            <p><strong>当前状态：</strong>待审批</p>
            <p><strong>当前节点：</strong>部门审批</p>
            <p><strong>发起时间：</strong>2024-01-15 10:30</p>
          </div>
        </div>

        <div class="info-section" v-show="activeLeftTab === 'resource'">
          <h4>相关资源</h4>
          <div class="resource-list">
            <div class="resource-item">物资装备信息表.pdf</div>
            <div class="resource-item">价格分析报告.docx</div>
            <div class="resource-item">供应商报价单.pdf</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'MaterialEquipmentApproval',
  data() {
    return {
      approvalOpinion: '',
      activeLeftTab: 'form',
      processNodes: [
        {
          nodeName: '提交申请',
          department: '业务部门',
          operator: '张三',
          opinion: '提交物资装备信息登记申请',
          operateTime: '2024-01-15 10:30'
        }
      ],

      reportInfo: {
        reportDate: '2024-01-15',
        reporter: '张三'
      },
      priceInfoList: [
        {
          level1Category: '机械设备',
          level2Category: '起重设备',
          level3Category: '塔式起重机',
          level4Category: '大型塔式起重机',
          equipmentName: '塔式起重机',
          equipmentCode: 'QZ001',
          unit: '台',
          model: 'TC7030',
          specification: 'QTZ80',
          exwPrice: 450000,
          deliveryPrice: 480000,
          collectionTime: '2024-01-10',
          currency: 'CNY',
          dataSource: '日常询价',
          projectName: '北京地铁项目',
          partnerName: '中建集团',
          attachments: [
            { name: '报价单.pdf' },
            { name: '技术参数.docx' }
          ]
        },
        {
          level1Category: '机械设备',
          level2Category: '起重设备',
          level3Category: '履带式起重机',
          level4Category: '大型履带式起重机',
          equipmentName: '履带式起重机',
          equipmentCode: 'QZ002',
          unit: '台',
          model: 'QUY260',
          specification: '260吨',
          exwPrice: 1200000,
          deliveryPrice: 1250000,
          collectionTime: '2024-01-12',
          currency: 'CNY',
          dataSource: '招投标',
          projectName: '上海高铁项目',
          partnerName: '中铁建工',
          attachments: [
            { name: '投标文件.pdf' }
          ]
        }
      ]
    }
  },
  mounted() {
    this.forceShowScrollbar()
  },
  methods: {
    forceShowScrollbar() {
      // 强制显示滚动条
      const container = this.$el.querySelector('.table-container')
      if (container) {
        // 方法1: 确保内容宽度超过容器宽度
        const table = container.querySelector('.equipment-table')
        if (table) {
          table.style.minWidth = '1800px'
        }
        
        // 方法2: 强制应用滚动条样式
        container.style.overflowX = 'scroll'
        container.style.overflowY = 'hidden'
        container.style.paddingBottom = '12px'
        
        // 方法3: 使用CSS变量确保滚动条可见
        container.style.setProperty('--scrollbar-height', '8px')
      }
    },
    handleSubmit() {
      if (!this.approvalOpinion.trim()) {
        alert('请填写审批意见')
        return
      }
      alert('提交审批成功')
    },
    handleReturn() {
      if (!this.approvalOpinion.trim()) {
        alert('请填写退回意见')
        return
      }
      alert('退回成功')
    },
    handleSave() {
      alert('暂存成功')
    },
    handleCirculate() {
      alert('传阅功能')
    }
  }
}
</script>

<style scoped>
.material-equipment-approval {
  padding: 20px;
  min-height: 100vh;
  overflow-y: auto;
}

/* 操作按钮区域 */
.action-header {
  background: white;
  padding: 20px;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.header-buttons {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
}

/* 头部页签样式 */
.header-tabs {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}
.header-tabs .tab {
  background: #f5f5f5;
  color: #555;
  border: 1px solid #e5e5e5;
  padding: 6px 12px;
  border-radius: 14px;
  cursor: pointer;
  font-size: 12px;
  line-height: 1;
}
.header-tabs .tab.active {
  background: #1890ff;
  color: #fff;
  border-color: #1890ff;
}

/* 主要内容区域 */
.approval-content {
  display: block;
}

.right-panel {
  flex: 1;
}

/* 审批表单区域 */
.approval-form {
  background: white;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.form-section {
  margin-bottom: 30px;
}

.form-section h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
  border-left: 4px solid #1890ff;
  padding-left: 10px;
}

.form-section textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  resize: vertical;
  font-size: 14px;
  box-sizing: border-box;
}

/* 流程节点表格 */
.process-table {
  width: 100%;
  border-collapse: collapse;
}

.process-table th,
.process-table td {
  padding: 10px;
  border: 1px solid #e8e8e8;
  text-align: center;
  font-size: 12px;
}

.process-table th {
  background: #fafafa;
  font-weight: 600;
  color: #333;
}



/* 填报信息区域样式 */
.report-info-section .report-info-row {
  display: flex !important;
  gap: 20px !important;
  align-items: center !important;
  margin-bottom: 20px !important;
}

.report-info-section .form-item.inline {
  display: flex !important;
  align-items: center !important;
  gap: 10px !important;
  margin-bottom: 0 !important;
}

.report-info-section .form-item.inline label {
  margin-bottom: 0 !important;
  white-space: nowrap !important;
  font-weight: 500;
  color: #333;
}

.report-info-section .form-item.inline span {
  color: #666;
  font-size: 14px;
}

/* 价格信息清单表格样式 */
.table-container {
  overflow-x: scroll;
  overflow-y: hidden;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  background: white;
  max-height: 500px;
  min-height: 200px;
  /* 强制显示滚动条 */
  scrollbar-width: thin;
  scrollbar-color: #c0c4cc #f5f7fa;
  /* 关键：添加padding-bottom为滚动条预留空间 */
  padding-bottom: 12px;
  /* 确保容器有足够的内容宽度来触发滚动 */
  min-width: 100%;
}

/* Webkit浏览器滚动条样式 - 强制显示 */
.table-container::-webkit-scrollbar {
  height: 8px;
  width: 8px;
  /* 强制显示滚动条 */
  -webkit-appearance: none;
  appearance: none;
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.table-container::-webkit-scrollbar-track {
  background: #f5f7fa;
  border-radius: 4px;
  /* 强制显示轨道 */
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.table-container::-webkit-scrollbar-thumb {
  background: #c0c4cc;
  border-radius: 4px;
  /* 强制显示滑块 */
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
}

.table-container::-webkit-scrollbar-thumb:hover {
  background: #909399;
}

/* 强制显示滚动条的核心样式 */
.table-container {
  overflow-x: scroll;
  overflow-y: hidden;
  -ms-overflow-style: scrollbar;
  scrollbar-width: thin;
  /* 关键：添加padding-bottom来为滚动条留出空间 */
  padding-bottom: 8px;
}

/* 确保表格内容不会被滚动条遮挡 */
.equipment-table {
  margin-bottom: 8px; /* 为滚动条留出空间 */
}

.equipment-table {
  min-width: 1800px;
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
  /* 为滚动条预留空间，防止内容被遮挡 */
  margin-bottom: 12px;
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
  white-space: nowrap;
  background-color: white;
  transition: background-color 0.3s ease;
}

.equipment-table tr:hover td {
  background-color: #f0f7ff;
}

.empty-row {
  text-align: center;
  color: #909399;
  font-style: italic;
}

.file-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.file-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 4px 8px;
  background: #f5f7fa;
  border-radius: 4px;
  font-size: 12px;
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

/* 流程图样式 */
.info-section {
  background: white;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.info-section h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
  border-left: 4px solid #1890ff;
  padding-left: 10px;
}

.flow-chart-container {
  margin-top: 20px;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 8px;
  position: relative;
  min-height: 200px;
}

.flow-chart {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  position: relative;
}

.flow-node {
  padding: 12px 20px;
  margin: 10px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  text-align: center;
  min-width: 100px;
  background-color: #e9ecef;
  border: 2px solid #dee2e6;
  transition: all 0.3s ease;
}

.flow-node.start,
.flow-node.end {
  background-color: #6c757d;
  color: white;
  border-color: #6c757d;
  border-radius: 50%;
  min-width: 80px;
  min-height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.flow-node.active {
  background-color: #007bff;
  color: white;
  border-color: #007bff;
  box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
}

.flow-arrow {
  font-size: 20px;
  color: #666;
  margin: 0 5px;
}

/* 流程状态样式 */
.status-info p {
  margin: 8px 0;
  font-size: 14px;
}

/* 相关资源样式 */
.resource-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.resource-item {
  padding: 6px 10px;
  background: #f8f9fa;
  border-radius: 4px;
  font-size: 12px;
  color: #666;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .flow-chart {
    flex-direction: column;
  }
  
  .flow-arrow {
    transform: rotate(90deg);
  }
  
  .info-grid {
    grid-template-columns: 1fr;
  }
}
</style>