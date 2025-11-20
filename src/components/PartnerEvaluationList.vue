<template>
  <div class="partner-evaluation-list">
    <!-- 页面标题和新增按钮 -->
    <div class="page-header">
      <h2>合作方评价</h2>
      <button class="btn-primary" @click="handleAdd">
        <span>+</span> 新增
      </button>
    </div>

    <!-- 审批列表表格 -->
    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>序号</th>
            <th>评定年份</th>
            <th>提交人</th>
            <th>提交时间</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in evaluationList" :key="item.id">
            <td>{{ index + 1 }}</td>
            <td>{{ item.evaluationYear }}</td>
            <td>{{ item.submitter }}</td>
            <td>{{ item.submitTime }}</td>
            <td>
              {{ getStatusText(item.status) }}
            </td>
            <td>
              <div class="action-buttons">
                <button
                  class="btn-primary btn-sm"
                  @click="handleView(item)"
                  title="查看"
                >
                  查看
                </button>
                <button
                  v-if="item.status === 'approving'"
                  class="btn-warning btn-sm"
                  @click="handleWithdraw(item)"
                  title="撤回"
                >
                  撤回
                </button>
                <button
                  v-if="item.status === 'pending' || item.status === 'rejected'"
                  class="btn-success btn-sm"
                  @click="handleEdit(item)"
                  title="编辑"
                >
                  编辑
                </button>
                <button
                  v-if="item.status === 'pending' || item.status === 'rejected'"
                  class="btn-danger btn-sm"
                  @click="handleDelete(item)"
                  title="删除"
                >
                  删除
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 空数据提示 -->
    <div v-if="evaluationList.length === 0" class="empty-state">
      <div class="empty-icon">📋</div>
      <p>暂无合作方评价数据</p>
      <button class="btn-primary" @click="handleAdd">立即新增</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PartnerEvaluationList',
  data() {
    return {
      evaluationList: [
        {
          id: 1,
          evaluationYear: '2024',
          submitter: '张三',
          submitTime: '2024-01-15 10:30:00',
          status: 'approving'
        },
        {
          id: 2,
          evaluationYear: '2024',
          submitter: '李四',
          submitTime: '2024-01-14 14:20:00',
          status: 'completed'
        },
        {
          id: 3,
          evaluationYear: '2023',
          submitter: '王五',
          submitTime: '2023-12-20 09:15:00',
          status: 'rejected'
        },
        {
          id: 4,
          evaluationYear: '2023',
          submitter: '赵六',
          submitTime: '2023-12-18 16:45:00',
          status: 'pending'
        }
      ]
    }
  },
  methods: {
    // 获取状态文本
    getStatusText(status) {
      const statusMap = {
        'pending': '草稿',
        'approving': '审批中',
        'completed': '已完成',
        'rejected': '已驳回'
      }
      return statusMap[status] || '未知'
    },
    // 新增按钮点击
    handleAdd() {
      this.$router.push('/partner-evaluation/add')
    },
    // 查看详情
    handleView(item) {
      this.$router.push(`/partner-evaluation/view/${item.id}`)
    },
    // 编辑
    handleEdit(item) {
      this.$router.push(`/partner-evaluation/edit/${item.id}`)
    },
    // 删除
    handleDelete(item) {
      if (confirm(`确定要删除${item.evaluationYear}年的合作方评价吗？`)) {
        // 这里可以调用删除API
        const index = this.evaluationList.findIndex(e => e.id === item.id)
        if (index > -1) {
          this.evaluationList.splice(index, 1)
        }
        alert('删除成功')
      }
    },
    // 撤回
    handleWithdraw(item) {
      if (confirm(`确定要撤回${item.evaluationYear}年的合作方评价吗？`)) {
        // 这里可以调用撤回API
        const index = this.evaluationList.findIndex(e => e.id === item.id)
        if (index > -1) {
          this.evaluationList[index].status = 'pending'
        }
        alert('撤回成功')
      }
    }
  }
}
</script>

<style scoped>
.partner-evaluation-list {
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

/* 表格容器 */
.table-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

/* 数据表格 */
.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th {
  background: #3b82f6;
  color: white;
  font-weight: 600;
  text-align: center;
  padding: 16px 12px;
  font-size: 14px;
  border: none;
}

.data-table td {
  padding: 12px;
  text-align: center;
  border-bottom: 1px solid #f0f0f0;
  font-size: 14px;
  color: #333;
}

.data-table tbody tr:hover {
  background-color: #f5f5f5;
}

.data-table tbody tr:last-child td {
  border-bottom: none;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 16px;
}

.empty-state p {
  color: #666;
  font-size: 16px;
  margin-bottom: 20px;
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

  .btn-primary {
    align-self: center;
  }

  .data-table {
    font-size: 12px;
  }

  .data-table th,
  .data-table td {
    padding: 8px 4px;
  }

  .action-buttons {
    flex-direction: column;
    gap: 4px;
  }
}
</style>