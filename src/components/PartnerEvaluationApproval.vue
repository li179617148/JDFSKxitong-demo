<template>
  <div class="partner-evaluation-approval">
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

          <!-- 第三部分：合作方评价信息 -->
          <div class="form-section">
            <h4>合作方评价信息</h4>
            <div class="table-area">
              <div class="table-container">
                <table class="data-table">
                  <thead>
                    <tr>
                      <th>序号</th>
                      <th>合作方名称</th>
                      <th>评价年份</th>
                      <th>评价结果</th>
                      <th>附件</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(evaluation, index) in sortedEvaluations" :key="evaluation.id">
                      <td>{{ index + 1 }}</td>
                      <td>{{ evaluation.partnerName }}</td>
                      <td>{{ evaluation.evaluationYear }}</td>
                      <td>{{ evaluation.evaluationResult }}</td>
                      <td>
                        <div class="file-list">
                          <span v-for="file in evaluation.attachments" :key="file.id" class="file-item">
                            {{ file.name }}
                          </span>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
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
            <div class="resource-item">合作方评价报告.pdf</div>
            <div class="resource-item">现场考察记录.docx</div>
            <div class="resource-item">合作方评估表.pdf</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'PartnerEvaluationApproval',
  data() {
    return {
      approvalOpinion: '',
      activeLeftTab: 'form',
      processNodes: [
        {
          nodeName: '提交申请',
          department: '业务部门',
          operator: '张三',
          opinion: '提交合作方评价申请',
          operateTime: '2024-01-15 10:30'
        }
      ],
      evaluations: [
        {
          id: 1,
          partnerName: '北京建工集团',
          evaluationYear: 2024,
          evaluationResult: '优秀',
          attachments: [
            { id: 1, name: '评价报告.pdf' }
          ],
          approvalStatus: 'approving'
        },
        {
          id: 2,
          partnerName: '上海建筑设计院',
          evaluationYear: 2024,
          evaluationResult: '良好',
          attachments: [
            { id: 2, name: '现场考察记录.docx' }
          ],
          approvalStatus: 'approving'
        },
        {
          id: 3,
          partnerName: '广州建筑公司',
          evaluationYear: 2023,
          evaluationResult: '一般',
          attachments: [
            { id: 3, name: '合作方评估表.pdf' }
          ],
          approvalStatus: 'approving'
        }
      ]
    }
  },
  computed: {
    sortedEvaluations() {
      return [...this.evaluations].sort((a, b) => {
        // 首先按审批状态排序：已完成放最后
        if (a.approvalStatus === 'completed' && b.approvalStatus !== 'completed') {
          return 1
        }
        if (a.approvalStatus !== 'completed' && b.approvalStatus === 'completed') {
          return -1
        }
        // 相同状态下按年份降序排序
        return b.evaluationYear - a.evaluationYear
      })
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
    },
    // 获取审批状态文本
    getApprovalStatusText(status) {
      const statusMap = {
        'pending': '未提交',
        'approving': '审批中',
        'completed': '已完成',
        'rejected': '已驳回'
      }
      return statusMap[status] || '未提交'
    }
  }
}
</script>

<style scoped>
.partner-evaluation-approval {
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

/* 响应式调整 */
@media (max-width: 768px) {
  .flow-chart {
    flex-direction: column;
  }

  .flow-arrow {
    transform: rotate(90deg);
  }
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

/* 表格区域样式 */
.table-area {
  background: white;
  border-radius: 6px;
  box-shadow: none;
  border: none;
}

/* 审批状态样式 */
.approval-status {
  font-size: 12px;
  color: black;
}

/* 表格样式增强 */
.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th,
.data-table td {
  padding: 12px 8px;
  text-align: center;
  border: none;
}

.data-table th {
  background: #3b82f6;
  font-weight: 600;
  color: white;
}

.data-table th:first-child {
  width: 60px;
}

/* 确保附件列居中 */
.data-table td:nth-child(5) {
  text-align: center;
}

/* 文件列表样式 */
.file-list {
  display: flex;
  flex-direction: column;
  gap: 2px;
  max-width: 150px;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
}

.file-item {
  font-size: 12px;
  color: #1890ff;
  text-decoration: underline;
  cursor: pointer;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: center;
}

.file-item:hover {
  color: #40a9ff;
}
</style>