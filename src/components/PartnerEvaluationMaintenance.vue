<template>
  <div class="partner-evaluation-maintenance">
    <!-- 页面标题和操作按钮 -->
    <div class="page-header">
      <h2>专项合作方维护</h2>
      <div class="header-actions">
        <button class="btn-primary" @click="handleSubmit">提交</button>
        <button class="btn-secondary" @click="handleSave">暂存</button>
        <button class="btn-cancel" @click="handleCancel">取消</button>
      </div>
    </div>

    <!-- 表单头部信息 -->
    <div class="form-header">
      <div class="header-row">
        <div class="form-group">
          <label>年份</label>
          <input
            type="text"
            v-model="formData.year"
            readonly
            class="readonly-input"
          >
        </div>
        <div class="form-group">
          <label>提交人</label>
          <input
            type="text"
            v-model="formData.submitter"
            readonly
            class="readonly-input"
          >
        </div>
      </div>
    </div>

    <!-- 主表单区域 -->
    <div class="main-form">
      <div class="form-header-with-actions">
        <h3>合作方评价信息</h3>
        <div class="form-actions">
          <button class="btn-primary btn-sm" @click="handleAddRow">
            <span>+</span> 新增
          </button>
          <button class="btn-danger btn-sm" @click="handleDeleteRow">
            <span>-</span> 删除
          </button>
        </div>
      </div>

      <!-- 表单表格 -->
      <div class="form-table-container">
        <table class="form-table">
          <thead>
            <tr>
              <th>
                <input
                  type="checkbox"
                  v-model="selectAll"
                  @change="handleSelectAll"
                  ref="selectAllCheckbox"
                >
              </th>
              <th>合作方名称</th>
              <th>评价结果</th>
              <th>附件</th>
              <th>备注</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in formData.evaluations" :key="index">
              <td>
                <input
                  type="checkbox"
                  v-model="item.selected"
                  @change="updateSelectAll"
                >
              </td>
              <td>
                <input
                  type="text"
                  v-model="item.partnerName"
                  class="form-input"
                  placeholder="请输入合作方名称"
                >
              </td>
              <td>
                <select v-model="item.evaluationResult" class="form-select">
                  <option value="">请选择评价结果</option>
                  <option value="excellent">优秀</option>
                  <option value="good">良好</option>
                  <option value="average">一般</option>
                  <option value="poor">较差</option>
                </select>
              </td>
              <td>
                <div class="file-upload">
                  <input
                    type="file"
                    :id="`file-${index}`"
                    @change="handleFileUpload($event, index)"
                    style="display: none"
                    ref="fileInputs"
                  >
                  <label :for="`file-${index}`" class="file-upload-label">
                    <span v-if="!item.fileName">选择文件</span>
                    <span v-else class="file-name">{{ item.fileName }}</span>
                  </label>
                  <button
                    v-if="item.fileName"
                    class="btn-remove-file"
                    @click="removeFile(index)"
                  >
                    ×
                  </button>
                </div>
              </td>
              <td>
                <input
                  type="text"
                  v-model="item.remarks"
                  class="form-input"
                  placeholder="请输入备注"
                >
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PartnerEvaluationMaintenance',
  data() {
    const currentYear = new Date().getFullYear().toString()
    return {
      selectAll: false,
      formData: {
        year: currentYear,
        submitter: '张三',
        evaluations: [
          {
            selected: false,
            partnerName: '',
            evaluationResult: '',
            fileName: '',
            file: null,
            remarks: ''
          },
          {
            selected: false,
            partnerName: '',
            evaluationResult: '',
            fileName: '',
            file: null,
            remarks: ''
          },
          {
            selected: false,
            partnerName: '',
            evaluationResult: '',
            fileName: '',
            file: null,
            remarks: ''
          },
          {
            selected: false,
            partnerName: '',
            evaluationResult: '',
            fileName: '',
            file: null,
            remarks: ''
          },
          {
            selected: false,
            partnerName: '',
            evaluationResult: '',
            fileName: '',
            file: null,
            remarks: ''
          }
        ]
      }
    }
  },
  methods: {
    // 新增行
    handleAddRow() {
      this.formData.evaluations.push({
        selected: false,
        partnerName: '',
        evaluationResult: '',
        fileName: '',
        file: null,
        remarks: ''
      })
      this.updateSelectAll()
    },

    // 删除选中行
    handleDeleteRow() {
      const selectedIndices = this.formData.evaluations
        .map((item, index) => item.selected ? index : -1)
        .filter(index => index !== -1)
        .reverse() // 从后往前删除，避免索引变化

      if (selectedIndices.length === 0) {
        alert('请先选择要删除的行')
        return
      }

      if (confirm(`确定要删除选中的 ${selectedIndices.length} 行吗？`)) {
        selectedIndices.forEach(index => {
          this.formData.evaluations.splice(index, 1)
        })

        // 如果删除后没有数据了，添加一个空行
        if (this.formData.evaluations.length === 0) {
          this.handleAddRow()
        }

        this.updateSelectAll()
      }
    },

    // 全选/取消全选
    handleSelectAll() {
      this.formData.evaluations.forEach(item => {
        item.selected = this.selectAll
      })
    },

    // 更新全选状态
    updateSelectAll() {
      const allSelected = this.formData.evaluations.length > 0 &&
                        this.formData.evaluations.every(item => item.selected)
      this.selectAll = allSelected
    },

    // 文件上传
    handleFileUpload(event, index) {
      const file = event.target.files[0]
      if (file) {
        this.formData.evaluations[index].fileName = file.name
        this.formData.evaluations[index].file = file
      }
    },

    // 移除文件
    removeFile(index) {
      this.formData.evaluations[index].fileName = ''
      this.formData.evaluations[index].file = null
      // 清空对应的文件输入框
      const fileInput = this.$refs.fileInputs[index]
      if (fileInput) {
        fileInput.value = ''
      }
    },

    // 提交
    handleSubmit() {
      // 表单验证
      if (!this.validateForm()) {
        return
      }

      // 这里可以调用提交API
      console.log('提交数据:', this.formData)
      alert('提交成功')
      this.$router.push('/home?menu=partner-evaluation-list')
    },

    // 暂存
    handleSave() {
      // 这里可以调用暂存API
      console.log('暂存数据:', this.formData)
      alert('暂存成功')
    },

    // 取消
    handleCancel() {
      if (confirm('确定要取消吗？未保存的数据将丢失。')) {
        this.$router.push('/home?menu=partner-evaluation-list')
      }
    },

    // 表单验证
    validateForm() {
      const emptyRows = this.formData.evaluations.filter(item =>
        !item.partnerName.trim() || !item.evaluationResult
      )

      if (emptyRows.length > 0) {
        alert('请完善所有必填信息（合作方名称和评价结果）')
        return false
      }

      return true
    }
  }
}
</script>

<style scoped>
.partner-evaluation-maintenance {
  padding: 20px;
  background-color: #f5f5f5;
  min-height: 100vh;
}

/* 页面头部 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 20px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.page-header h2 {
  margin: 0;
  color: #333;
  font-size: 24px;
  font-weight: 500;
}

.header-actions {
  display: flex;
  gap: 10px;
}

/* 按钮样式 */
.btn-primary {
  background: #1890ff;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.3s ease;
}

.btn-primary:hover {
  background: #40a9ff;
}

.btn-secondary {
  background: #1890ff;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.btn-secondary:hover {
  background: #40a9ff;
}

.btn-cancel {
  background: #1890ff;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.3s ease;
}

.btn-cancel:hover {
  background: #40a9ff;
}

.btn-sm {
  padding: 6px 12px;
  font-size: 13px;
}

.btn-danger {
  background: #1890ff;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.3s ease;
}

.btn-danger:hover {
  background: #40a9ff;
}

/* 表单头部 */
.form-header {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}

.header-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-weight: 500;
  color: #333;
  font-size: 14px;
}

.readonly-input {
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  background-color: #f5f5f5;
  color: #666;
  font-size: 14px;
}

/* 主表单区域 */
.main-form {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.form-header-with-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
  background: #fafafa;
}

.form-header-with-actions h3 {
  margin: 0;
  color: #333;
  font-size: 18px;
  font-weight: 500;
}

.form-actions {
  display: flex;
  gap: 8px;
}

/* 表单表格 */
.form-table-container {
  overflow-x: auto;
}

.form-table {
  width: 100%;
  border-collapse: collapse;
}

.form-table th {
  background: #3b82f6;
  color: white;
  font-weight: 600;
  text-align: center;
  padding: 16px 12px;
  font-size: 14px;
  border: none;
  white-space: nowrap;
}

.form-table td {
  padding: 12px;
  text-align: center;
  border-bottom: 1px solid #f0f0f0;
  font-size: 14px;
  color: #333;
  vertical-align: middle;
}

.form-table tbody tr:hover {
  background-color: #f5f5f5;
}

.form-table tbody tr:last-child td {
  border-bottom: none;
}

/* 表单控件 */
.form-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  transition: border-color 0.3s ease;
  min-width: 150px;
}

.form-input:focus {
  outline: none;
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

.form-select {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  background: white;
  cursor: pointer;
  min-width: 120px;
}

.form-select:focus {
  outline: none;
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

/* 文件上传 */
.file-upload {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
}

.file-upload-label {
  padding: 6px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  background: white;
  color: #666;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.3s ease;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 120px;
}

.file-upload-label:hover {
  border-color: #1890ff;
  color: #1890ff;
}

.file-name {
  color: #1890ff;
}

.btn-remove-file {
  background: #1890ff;
  color: white;
  border: none;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.btn-remove-file:hover {
  background: #40a9ff;
}

/* 复选框 */
input[type="checkbox"] {
  width: 16px;
  height: 16px;
  cursor: pointer;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    gap: 15px;
    align-items: stretch;
  }

  .page-header h2 {
    text-align: center;
  }

  .header-actions {
    justify-content: center;
  }

  .header-row {
    grid-template-columns: 1fr;
    gap: 15px;
  }

  .form-header-with-actions {
    flex-direction: column;
    gap: 15px;
    align-items: stretch;
  }

  .form-table {
    font-size: 12px;
  }

  .form-table th,
  .form-table td {
    padding: 8px 4px;
  }

  .form-input,
  .form-select {
    min-width: 100px;
    font-size: 13px;
  }

  .file-upload-label {
    max-width: 80px;
    font-size: 12px;
  }
}
</style>