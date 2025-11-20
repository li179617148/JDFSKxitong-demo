<template>
  <div class="expert-approval">
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

          <!-- 第三部分：专家信息（登记表样式） -->
          <div class="form-section">
            <h4>专家信息</h4>
            <div class="registration-form">
              <!-- 基本信息（含照片，只读） -->
              <div class="form-section">
                <h4 class="section-title">基本信息</h4>
                <div class="head-grid">
                  <div class="photo-section">
                    <div class="photo-frame">
                      <img v-if="expertInfo.photo" :src="expertInfo.photo" alt="专家照片" class="photo-preview">
                      <div v-else class="photo-placeholder">暂无照片</div>
                    </div>
                  </div>
                  <div class="form-grid">
                    <div class="form-group">
                      <label>姓名</label>
                      <input v-model="expertInfo.name" type="text" disabled>
                    </div>
                    <div class="form-group">
                      <label>性别</label>
                      <select v-model="expertInfo.gender" disabled>
                        <option value="男">男</option>
                        <option value="女">女</option>
                      </select>
                    </div>
                    <div class="form-group">
                      <label>国籍</label>
                      <input v-model="expertInfo.nationality" type="text" disabled>
                    </div>
                    <div class="form-group">
                      <label>出生日期</label>
                      <input v-model="expertInfo.birthDate" type="date" disabled>
                    </div>
                    <div class="form-group">
                      <label>联系方式</label>
                      <input v-model="expertInfo.phone" type="tel" disabled>
                    </div>
                    <div class="form-group">
                      <label>海外工作年限</label>
                      <input v-model="expertInfo.overseasYears" type="number" min="0" disabled>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 工作信息（只读） -->
              <div class="form-section">
                <h4 class="section-title">工作信息</h4>
                <div class="form-grid">
                  <div class="form-group">
                    <label>工作单位</label>
                    <input v-model="expertInfo.workUnit" type="text" disabled>
                  </div>
                  <div class="form-group">
                    <label>职务</label>
                    <input v-model="expertInfo.position" type="text" disabled>
                  </div>
                  <div class="form-group">
                    <label>职称</label>
                    <select v-model="expertInfo.title" disabled>
                      <option v-for="t in options.titles" :key="t" :value="t">{{ t }}</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label>专家分类</label>
                    <select v-model="expertInfo.expertClassification" disabled>
                      <option value="">{{ expertInfo.expertClassification || '未设置' }}</option>
                      <option v-for="c in options.expertClassifications" :key="c" :value="c">{{ c }}</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label>业务领域</label>
                    <select v-model="expertInfo.businessField" disabled>
                      <option v-for="f in options.businessFields" :key="f" :value="f">{{ f }}</option>
                    </select>
                  </div>
                </div>
              </div>

              <!-- 教育信息（只读） -->
              <div class="form-section">
                <h4 class="section-title">教育信息</h4>
                <div class="form-grid">
                  <div class="form-group">
                    <label>最高学历</label>
                    <select v-model="expertInfo.highestEducation" disabled>
                      <option value="博士">博士</option>
                      <option value="硕士">硕士</option>
                      <option value="本科">本科</option>
                      <option value="大专">大专</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label>毕业院校</label>
                    <input v-model="expertInfo.graduateSchool" type="text" disabled>
                  </div>
                  <div class="form-group">
                    <label>专业名称</label>
                    <input v-model="expertInfo.major" type="text" disabled>
                  </div>
                </div>
              </div>

              <!-- 专业资格（只读） -->
              <div class="form-section">
                <h4 class="section-title">专业资格</h4>
                <div class="form-grid">
                  <div class="form-group">
                    <label>执业资格</label>
                    <select v-model="expertInfo.qualification" disabled>
                      <option v-for="q in options.qualifications" :key="q" :value="q">{{ q }}</option>
                    </select>
                  </div>
                  <div class="form-group full-width">
                    <label>专业方向</label>
                    <div class="specialty-checkbox">
                      <label v-for="(spec, index) in specialtyOptions" :key="index">
                        <input type="checkbox" :checked="Array.isArray(expertInfo.specialties) ? expertInfo.specialties.includes(spec.value) : (expertInfo.specialty === spec.value)" disabled>
                        {{ spec.label }}
                        <input v-if="spec.value === '其他' && ((Array.isArray(expertInfo.specialties) && expertInfo.specialties.includes('其他')) || expertInfo.specialty === '其他')"
                               v-model="expertInfo.otherSpecialty" type="text" disabled placeholder="其他专业方向">
                      </label>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 证明材料（只读） -->
              <div class="form-section">
                <h4 class="section-title">证明材料</h4>
                <div class="attachment-area">
                  <div class="attachment-list">
                    <div v-if="Array.isArray(expertInfo.attachments) && expertInfo.attachments.length > 0">
                      <div v-for="(file, index) in expertInfo.attachments" :key="index" class="attachment-item">
                        <span>{{ file.name }}</span>
                      </div>
                    </div>
                    <div v-else class="attachment-item">
                      <span>暂无附件</span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 工作总结（只读） -->
              <div class="form-section">
                <h4 class="section-title">工作总结</h4>
                <textarea v-model="expertInfo.summary" class="summary-textarea" disabled></textarea>
              </div>
              
              <!-- 关联项目信息（只读） -->
              <div class="form-section">
                <h4 class="section-title">关联项目信息</h4>
                <table class="process-table">
                  <thead>
                    <tr>
                      <th>项目名称</th>
                      <th>项目编号</th>
                      <th>参与角色</th>
                      <th>参与时间</th>
                      <th>项目金额（万元）</th>
                      <th>项目阶段</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(project, index) in expertInfo.relatedProjects" :key="index">
                      <td>{{ project.name }}</td>
                      <td>{{ project.code }}</td>
                      <td>{{ project.role }}</td>
                      <td>{{ project.participationTime }}</td>
                      <td>{{ project.amount }}</td>
                      <td>{{ project.stage }}</td>
                    </tr>
                    <tr v-if="!expertInfo.relatedProjects || expertInfo.relatedProjects.length === 0">
                      <td colspan="6" style="text-align: center;">暂无关联项目</td>
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
            <div class="resource-item">专家简历.pdf</div>
            <div class="resource-item">学历证明.docx</div>
            <div class="resource-item">执业资格证书.pdf</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'ExpertApproval',
  data() {
    return {
      approvalOpinion: '',
      activeLeftTab: 'form',
      processNodes: [
        {
          nodeName: '提交申请',
          department: '业务部门',
          operator: '张三',
          opinion: '提交专家信息登记申请',
          operateTime: '2024-01-15 10:30'
        }
      ],
      expertInfo: {
        name: '张三',
        gender: '男',
        nationality: '中国',
        birthDate: '1980-01-15',
        phone: '13800138000',
        overseasYears: '5',
        workUnit: '某某设计院',
        position: '高级工程师',
        title: '高级工程师',
        expertClassification: '系统内',
        businessField: '建筑工程',
        highestEducation: '本科',
        graduateSchool: '清华大学',
        major: '土木工程',
        qualification: '高级工程师',
        specialties: ['工艺', '供电'],
        otherSpecialty: '',
        attachments: [
          { name: '学历证明.pdf' },
          { name: '执业资格证书.pdf' }
        ],
        summary: '具有丰富的建筑工程经验，参与过多项国家重点工程项目。',
        photo: '',
        relatedProjects: [
          {
            name: '国家体育场扩建工程',
            code: 'PRJ-2023-001',
            role: '技术顾问',
            participationTime: '2023.03-2023.12',
            amount: '5600',
            stage: '已完成'
          },
          {
            name: '城市轨道交通1号线工程',
            code: 'PRJ-2022-045',
            role: '设计负责人',
            participationTime: '2022.05-2024.02',
            amount: '12000',
            stage: '进行中'
          },
          {
            name: '商业综合体开发项目',
            code: 'PRJ-2021-123',
            role: '专家评审',
            participationTime: '2021.10-2021.11',
            amount: '8000',
            stage: '已完成'
          }
        ]
      },
      specialtyOptions: [
        { value: '工艺', label: '工艺' },
        { value: '供电', label: '供电' },
        { value: '配电', label: '配电' },
        { value: '弱电', label: '弱电' },
        { value: '其他', label: '其他' }
      ],
      options: {
        qualifications: ['高级工程师', '工程师', '助理工程师', '技术员'],
        titles: ['教授', '副教授', '讲师', '助教'],
        expertClassifications: ['系统内', '系统外', '外部专家', '特邀专家', '顾问专家', '合作专家', '临时专家'],
        businessFields: ['建筑工程', '机械工程', '电气工程', '化工工程', '信息技术']
      }
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
.expert-approval {
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

/* 响应式调整 */
@media (max-width: 768px) {
  .flow-chart {
    flex-direction: column;
  }
  
  .flow-arrow {
    transform: rotate(90deg);
  }
}

/* 保留原有样式以保持兼容性 */
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

/* 专家信息登记表样式 */
.registration-form {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  padding: 20px;
}

.head-grid {
  display: grid;
  grid-template-columns: 220px 1fr;
  gap: 20px;
}

.photo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.photo-frame {
  width: 180px;
  height: 240px;
  border: 2px dashed #d9d9d9;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.photo-preview {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.photo-placeholder {
  color: #999;
  font-size: 14px;
  text-align: center;
  padding: 20px;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(240px, 1fr));
  gap: 12px;
}

.form-group {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}

.form-group label {
  display: inline-flex;
  align-items: center;
  justify-content: flex-end;
  text-align: right;
  margin: 0;
  min-width: 96px;
  font-weight: 600;
  color: #444;
  white-space: nowrap;
}

.form-group input,
.form-group select,
.form-group textarea {
  flex: 1;
  min-width: 0;
  padding: 10px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  font-size: 14px;
}

.form-group.full-width {
  grid-column: 1 / -1;
}

.specialty-checkbox {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.specialty-checkbox label {
  display: flex;
  align-items: center;
  padding: 6px 10px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  background: #fafafa;
}

.attachment-area {
  border: 1px dashed #d9d9d9;
  border-radius: 4px;
  padding: 16px;
}

.attachment-list {
  margin-bottom: 12px;
}

.attachment-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px;
  background: #fafafa;
  border-radius: 4px;
  margin-bottom: 8px;
}

.summary-textarea {
  width: 100%;
  min-height: 160px;
  padding: 12px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  resize: vertical;
  line-height: 1.6;
}
</style>