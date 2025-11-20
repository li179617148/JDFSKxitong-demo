<template>
  <div class="project-approval">
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

          <!-- 第三部分：项目信息 -->
          <div class="form-section">
            <h4>项目信息</h4>
            <div class="project-info">
              <div class="info-grid">
                <div class="info-item">
                  <label>项目名称：</label>
                  <span>{{ projectInfo.name }}</span>
                </div>
                <div class="info-item">
                  <label>项目编号：</label>
                  <span>{{ projectInfo.projectNo }}</span>
                </div>
                <div class="info-item">
                  <label>区域机构：</label>
                  <span>{{ projectInfo.region }}</span>
                </div>
                <div class="info-item">
                  <label>项目类别：</label>
                  <span>{{ projectInfo.category }}</span>
                </div>
                <div class="info-item">
                  <label>施工类型：</label>
                  <span>{{ projectInfo.constructionType }}</span>
                </div>
                <div class="info-item">
                  <label>项目阶段：</label>
                  <span>{{ projectInfo.stage }}</span>
                </div>
                <div class="info-item">
                  <label>合同金额：</label>
                  <span>{{ projectInfo.amount }} 万元</span>
                </div>
                <div class="info-item">
                  <label>产业链：</label>
                  <span>{{ projectInfo.industryChain }}</span>
                </div>
                <div class="info-item">
                  <label>项目所在国：</label>
                  <span>{{ projectInfo.country }}</span>
                </div>
                <div class="info-item">
                  <label>中标日期：</label>
                  <span>{{ projectInfo.bidDate }}</span>
                </div>
                <div class="info-item">
                  <label>开工日期：</label>
                  <span>{{ projectInfo.startDate }}</span>
                </div>
              </div>
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
            <div class="resource-item">项目合同.pdf</div>
            <div class="resource-item">投标文件.docx</div>
            <div class="resource-item">物资装备清单.xlsx</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'ProjectApproval',
  data() {
    return {
      approvalOpinion: '',
      activeLeftTab: 'form',
      processNodes: [
        {
          nodeName: '提交申请',
          department: '业务部门',
          operator: '张三',
          opinion: '提交项目信息审批申请',
          operateTime: '2024-01-15 10:30'
        }
      ],
      projectInfo: {
        name: '北京市地铁XX线三期工程',
        projectNo: 'PROJ-2024-001',
        region: '华北区域',
        category: '轨道交通',
        constructionType: '总承包',
        stage: '施工',
        amount: '128000',
        industryChain: '设备',
        country: '中国',
        bidDate: '2024-01-10',
        startDate: '2024-02-01'
      },

    }
  },
  methods: {
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
.project-approval {
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

/* 左侧信息区域 */
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

.form-content p {
  margin: 0;
  color: #666;
}

.flow-chart {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.flow-step {
  padding: 8px 12px;
  background: #f5f5f5;
  border-radius: 4px;
  font-size: 12px;
  text-align: center;
  min-width: 60px;
}

.flow-step.current {
  background: #1890ff;
  color: white;
}

.flow-arrow {
  color: #999;
  font-weight: bold;
}

.status-info p {
  margin: 8px 0;
  font-size: 14px;
}

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

/* 项目信息 */
.project-info {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  padding: 20px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.info-item {
  display: flex;
  align-items: center;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-item label {
  font-weight: 500;
  color: #333;
  min-width: 100px;
  text-align: right;
  margin-right: 10px;
}

.info-item span {
  color: #666;
  flex: 1;
}

.empty {
  color: #999;
  text-align: center;
  padding: 20px;
}
/* 流程图样式 */
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
  z-index: 1;
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

/* 移除了循环箭头相关样式 */

/* 响应式调整 */
@media (max-width: 768px) {
  .flow-chart {
    flex-direction: column;
  }
  
  .flow-arrow {
    transform: rotate(90deg);
  }
}
</style>