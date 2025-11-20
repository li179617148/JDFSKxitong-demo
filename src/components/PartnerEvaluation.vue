<template>
  <div class="partner-evaluation">
    <!-- 表单头部信息 -->
    <div class="form-header">
      <div class="form-info">
        <div class="info-row">
          <label>提交年份：</label>
          <select v-model="submitYear" class="year-select">
            <option v-for="year in availableYears" :key="year" :value="year">
              {{ year }}
            </option>
          </select>
        </div>
        <div class="info-row">
          <label>提交人：</label>
          <input type="text" v-model="submitter" class="submitter-input" readonly>
        </div>
      </div>
      <div class="header-buttons">
        <button class="btn-primary" @click="addEvaluation">新增</button>
        <button class="btn-primary" @click="submitForm">提交</button>
      </div>
    </div>

    <!-- 表格区域 -->
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
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(evaluation, index) in sortedEvaluations" :key="evaluation.id">
              <td>{{ index + 1 }}</td>
              <td>
                <input v-if="evaluation.isEditing" v-model="evaluation.partnerName" placeholder="请输入合作方名称" required>
                <span v-else>{{ evaluation.partnerName }}</span>
              </td>
              <td>
                <input v-if="evaluation.isEditing" type="number" v-model="evaluation.evaluationYear" placeholder="请输入年份" required>
                <span v-else>{{ evaluation.evaluationYear }}</span>
              </td>
              <td>
                <select v-if="evaluation.isEditing" v-model="evaluation.evaluationResult" required>
                  <option value="">请选择</option>
                  <option value="优秀">优秀</option>
                  <option value="良好">良好</option>
                  <option value="一般">一般</option>
                  <option value="较差">较差</option>
                </select>
                <span v-else>{{ evaluation.evaluationResult }}</span>
              </td>
              <td>
                <div v-if="evaluation.isEditing" class="file-upload">
                  <input type="file" @change="handleFileUpload(evaluation, $event)" multiple>
                  <span>上传附件</span>
                </div>
                <div v-else class="file-list">
                  <span v-for="file in evaluation.attachments" :key="file.id" class="file-item">
                    {{ file.name }}
                  </span>
                </div>
              </td>
              <td>
                <div class="action-buttons">
                  <button v-if="evaluation.isEditing" class="btn-primary" @click="saveEvaluation(index)">保存</button>
                  <button v-if="evaluation.isEditing" class="btn-secondary" @click="cancelEvaluation(index)">取消</button>
                  <button v-else class="btn-primary" @click="editEvaluation(index)">编辑</button>
                  <button class="btn-danger" @click="deleteEvaluation(index)">删除</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'PartnerEvaluation',
  data() {
    return {
      submitYear: new Date().getFullYear(),
      submitter: '张三',
      mode: 'add', // add, edit, view
      availableYears: [2025, 2024, 2023, 2022, 2021],
      evaluations: [
        {
          id: 1,
          partnerName: '北京建工集团',
          evaluationYear: 2024,
          evaluationResult: '优秀',
          attachments: [
            { id: 1, name: '评价报告.pdf' }
          ],
          isEditing: false
        },
        {
          id: 2,
          partnerName: '上海建筑设计院',
          evaluationYear: 2024,
          evaluationResult: '良好',
          attachments: [
            { id: 2, name: '现场考察记录.docx' }
          ],
          isEditing: false
        },
        {
          id: 3,
          partnerName: '广州建筑公司',
          evaluationYear: 2023,
          evaluationResult: '一般',
          attachments: [
            { id: 3, name: '合作方评估表.pdf' }
          ],
          isEditing: false
        }
      ]
    }
  },
  computed: {
    sortedEvaluations() {
      return [...this.evaluations].sort((a, b) => {
        // 按年份降序排序
        return b.evaluationYear - a.evaluationYear
      })
    }
  },
  mounted() {
    // 根据路由参数判断是新增、编辑还是查看模式
    this.checkMode()
  },
  methods: {
    checkMode() {
      const query = this.$route.query
      if (query.mode === 'edit' && query.id) {
        this.mode = 'edit'
        // 这里可以根据ID加载对应的评价数据
        this.loadEvaluationData(query.id)
      } else if (query.mode === 'view' && query.id) {
        this.mode = 'view'
        // 这里可以根据ID加载对应的评价数据并设为只读
        this.loadEvaluationData(query.id)
      } else {
        this.mode = 'add'
        // 新增模式，清空表单
        this.evaluations = []
      }
    },
    loadEvaluationData(id) {
      // 这里可以从API加载数据，现在使用模拟数据
      console.log('加载评价数据，ID:', id)
    },
    addEvaluation() {
      this.evaluations.push({
        id: Date.now(),
        partnerName: '',
        evaluationYear: this.submitYear,
        evaluationResult: '',
        attachments: [],
        isEditing: true
      })
    },
    saveEvaluation(index) {
      const evaluation = this.evaluations[index]

      // 必填字段验证
      if (!evaluation.partnerName.trim()) {
        alert('请填写合作方名称')
        return
      }

      if (!evaluation.evaluationYear) {
        alert('请填写评价年份')
        return
      }

      if (!evaluation.evaluationResult) {
        alert('请选择评价结果')
        return
      }

      this.evaluations[index].isEditing = false
    },
    editEvaluation(index) {
      if (this.mode === 'view') {
        alert('查看模式下不能编辑')
        return
      }
      this.evaluations[index].isEditing = true
    },
    deleteEvaluation(index) {
      if (this.mode === 'view') {
        alert('查看模式下不能删除')
        return
      }
      if (confirm('确定删除该评价记录吗？')) {
        this.evaluations.splice(index, 1)
      }
    },
    cancelEvaluation(index) {
      // 如果是新增的行（没有ID或ID为临时值），直接删除
      if (this.evaluations[index].id > 1000) { // 临时ID判断
        this.evaluations.splice(index, 1)
      } else {
        // 如果是编辑现有行，退出编辑模式
        this.evaluations[index].isEditing = false
      }
    },
    handleFileUpload(evaluation, event) {
      const files = event.target.files
      for (let i = 0; i < files.length; i++) {
        evaluation.attachments.push({
          id: Date.now() + i,
          name: files[i].name,
          file: files[i]
        })
      }
    },
    submitForm() {
      if (this.evaluations.length === 0) {
        alert('请至少添加一条评价记录')
        return
      }

      // 检查是否有正在编辑的记录
      const hasEditing = this.evaluations.some(e => e.isEditing)
      if (hasEditing) {
        alert('请先保存正在编辑的记录')
        return
      }

      // 检查必填字段
      const hasInvalid = this.evaluations.some(e =>
        !e.partnerName.trim() || !e.evaluationYear || !e.evaluationResult
      )
      if (hasInvalid) {
        alert('请完善所有评价记录的必填信息')
        return
      }

      if (confirm('确定要提交评价表单吗？')) {
        // 提交逻辑
        alert('评价表单提交成功！')
        // 可以跳转到审批列表页面
        this.$router.push('/evaluation-approval-list')
      }
    }
  }
}
</script>

<style scoped>
.partner-evaluation {
  padding: 20px;
  min-height: 100vh;
  overflow-y: auto;
}

/* 表单头部样式 */
.form-header {
  background: white;
  padding: 20px;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.form-info {
  display: flex;
  gap: 30px;
  align-items: center;
}

.info-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-row label {
  font-weight: 500;
  color: #333;
  white-space: nowrap;
}

.year-select {
  padding: 6px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  background: white;
  font-size: 14px;
  min-width: 100px;
}

.submitter-input {
  padding: 6px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  background: #f5f5f5;
  color: #666;
  font-size: 14px;
  min-width: 120px;
}

.header-buttons {
  display: flex;
  gap: 12px;
}

.header-buttons .btn {
  padding: 12px 24px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 100px;
  text-align: center;
}

.header-buttons .btn-primary {
  background: #1890ff;
  color: white;
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.header-buttons .btn-primary:hover {
  background: #40a9ff;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(24, 144, 255, 0.4);
}

/* 表格区域样式 */
.table-area {
  background: white;
  border-radius: 6px;
  box-shadow: none;
  border: none;
}

.table-header {
  display: flex;
  justify-content: flex-end;
  padding: 20px;
  border-bottom: none;
}

.header-buttons {
  display: flex;
  gap: 12px;
}

.header-buttons .btn {
  padding: 12px 24px;
  font-size: 14px;
  font-weight: 600;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 100px;
  text-align: center;
}

.header-buttons .btn-primary {
  background: #1890ff;
  color: white;
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.header-buttons .btn-primary:hover {
  background: #40a9ff;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(24, 144, 255, 0.4);
}

.header-buttons .btn-success {
  background: linear-gradient(135deg, #27ae60, #229954);
  color: white;
  box-shadow: 0 4px 12px rgba(39, 174, 96, 0.3);
}

.header-buttons .btn-success:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(39, 174, 96, 0.4);
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
  width: 40px;
}

.data-table th:nth-child(2) {
  width: 60px;
}

.data-table td:first-child {
  text-align: center;
  vertical-align: middle;
}

/* 文件上传样式 */
.file-upload {
  position: relative;
  display: inline-block;
  cursor: pointer;
}

.file-upload input[type="file"] {
  position: absolute;
  left: 0;
  top: 0;
  opacity: 0;
  width: 100%;
  height: 100%;
  cursor: pointer;
}

.file-upload span {
  display: inline-block;
  padding: 4px 8px;
  background: #f0f8ff;
  color: #1890ff;
  border: 1px solid #91d5ff;
  border-radius: 4px;
  font-size: 12px;
  transition: all 0.3s ease;
}

.file-upload:hover span {
  background: #e6f7ff;
  border-color: #40a9ff;
}

/* 文件列表样式 */
.file-list {
  display: flex;
  flex-direction: column;
  gap: 2px;
  max-width: 150px;
  align-items: center;
  justify-content: center;
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

/* 操作按钮样式 */
.action-buttons {
  display: flex;
  gap: 6px;
  justify-content: center;
  flex-wrap: wrap;
}
</style>