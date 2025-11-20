<template>
  <div class="evaluation-approval-list">
    <!-- 表格区域 -->
    <div class="table-area">
      <div class="table-header">
        <h3>合作方评价审批列表</h3>
        <div class="header-buttons">
          <button class="btn-primary" @click="goToAddEvaluation">新增</button>
        </div>
      </div>
      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>序号</th>
              <th>评价年份</th>
              <th>提交人</th>
              <th>提交时间</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in approvalList" :key="item.id">
              <td>{{ index + 1 }}</td>
              <td>{{ item.evaluationYear }}</td>
              <td>{{ item.submitter }}</td>
              <td>{{ item.submitTime }}</td>
              <td>
                <span :class="['status-tag', item.status]">
                  {{ getStatusText(item.status) }}
                </span>
              </td>
              <td>
                <div class="action-buttons">
                  <button
                    v-if="item.status === 'pending'"
                    class="btn-primary"
                    @click="editItem(item)"
                  >
                    编辑
                  </button>
                  <button
                    v-if="item.status === 'pending'"
                    class="btn-danger"
                    @click="deleteItem(item)"
                  >
                    删除
                  </button>
                  <button
                    v-if="item.status === 'approving'"
                    class="btn-warning"
                    @click="withdrawItem(item)"
                  >
                    撤回
                  </button>
                  <button
                    class="btn-info"
                    @click="viewDetails(item)"
                  >
                    查看
                  </button>
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
  name: 'EvaluationApprovalList',
  data() {
    return {
      approvalList: [
        {
          id: 1,
          evaluationYear: 2024,
          submitter: '张三',
          submitTime: '2024-01-15 10:30:00',
          status: 'completed',
          evaluationData: null
        },
        {
          id: 2,
          evaluationYear: 2024,
          submitter: '李四',
          submitTime: '2024-01-14 14:20:00',
          status: 'approving',
          evaluationData: null
        },
        {
          id: 3,
          evaluationYear: 2023,
          submitter: '王五',
          submitTime: '2024-01-13 09:15:00',
          status: 'pending',
          evaluationData: null
        },
        {
          id: 4,
          evaluationYear: 2023,
          submitter: '赵六',
          submitTime: '2024-01-12 16:45:00',
          status: 'rejected',
          evaluationData: null
        }
      ]
    }
  },
  methods: {
    goToAddEvaluation() {
      // 跳转到新增评价页面
      this.$router.push('/partner-evaluation-form')
    },
    editItem(item) {
      // 跳转到编辑页面，携带数据
      this.$router.push({
        path: '/partner-evaluation-form',
        query: {
          id: item.id,
          mode: 'edit'
        }
      })
    },
    deleteItem(item) {
      if (confirm('确定要删除这条评价记录吗？')) {
        // 找到索引并删除
        const index = this.approvalList.findIndex(i => i.id === item.id)
        if (index > -1) {
          this.approvalList.splice(index, 1)
        }
      }
    },
    withdrawItem(item) {
      if (confirm('确定要撤回这条评价记录吗？')) {
        item.status = 'pending'
        alert('评价记录已撤回')
      }
    },
    viewDetails(item) {
      // 跳转到查看详情页面
      this.$router.push({
        path: '/partner-evaluation-form',
        query: {
          id: item.id,
          mode: 'view'
        }
      })
    },
    getStatusText(status) {
      const statusMap = {
        'pending': '未提交',
        'approving': '审批中',
        'completed': '已完成',
        'rejected': '已驳回'
      }
      return statusMap[status] || '未知'
    }
  }
}
</script>

<style scoped>
.evaluation-approval-list {
  padding: 20px;
  min-height: 100vh;
  overflow-y: auto;
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
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: none;
}

.table-header h3 {
  margin: 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
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

.data-table th:nth-child(2) {
  width: 100px;
}

.data-table th:nth-child(3) {
  width: 100px;
}

.data-table th:nth-child(4) {
  width: 150px;
}

.data-table th:nth-child(5) {
  width: 100px;
}

.data-table th:last-child {
  width: 200px;
}

/* 状态标签样式 */
.status-tag {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
  text-align: center;
  min-width: 60px;
}

.status-tag.pending {
  background: #f0f0f0;
  color: #666;
}

.status-tag.approving {
  background: #e6f7ff;
  color: #1890ff;
  border: 1px solid #91d5ff;
}

.status-tag.completed {
  background: #f6ffed;
  color: #52c41a;
  border: 1px solid #b7eb8f;
}

.status-tag.rejected {
  background: #fff2e8;
  color: #fa541c;
  border: 1px solid #ffbb96;
}

/* 操作按钮样式 */
.action-buttons {
  display: flex;
  gap: 6px;
  justify-content: center;
  flex-wrap: wrap;
}

.action-buttons .btn {
  padding: 6px 12px;
  font-size: 12px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 60px;
}

.action-buttons .btn-primary {
  background: #1890ff;
  color: white;
}

.action-buttons .btn-primary:hover {
  background: #40a9ff;
}

.action-buttons .btn-danger {
  background: #ff4d4f;
  color: white;
}

.action-buttons .btn-danger:hover {
  background: #ff7875;
}

.action-buttons .btn-warning {
  background: #faad14;
  color: white;
}

.action-buttons .btn-warning:hover {
  background: #ffc53d;
}

.action-buttons .btn-info {
  background: #13c2c2;
  color: white;
}

.action-buttons .btn-info:hover {
  background: #36cfc9;
}
</style>