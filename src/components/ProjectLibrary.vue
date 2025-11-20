<template>
  <div class="project-library">
    <div class="toolbar">
      <button class="btn-primary" @click="addProject">新增项目</button>
      <div class="filter-box">
        <select v-model="filterStatus">
          <option value="">全部状态</option>
          <option value="planning">规划中</option>
          <option value="in-progress">进行中</option>
          <option value="completed">已完成</option>
        </select>
        <input type="text" placeholder="搜索项目..." v-model="searchKeyword">
        <button class="btn-search">搜索</button>
      </div>
    </div>
    
    <div class="project-cards">
      <div class="project-card" v-for="project in projectList" :key="project.id">
        <div class="card-header">
          <h4>{{ project.name }}</h4>
          <span :class="['status', project.status]">
            {{ getStatusText(project.status) }}
          </span>
        </div>
        <div class="card-content">
          <p><strong>项目经理:</strong> {{ project.manager }}</p>
          <p><strong>开始时间:</strong> {{ project.startDate }}</p>
          <p><strong>结束时间:</strong> {{ project.endDate }}</p>
          <p><strong>预算:</strong> {{ project.budget }}万元</p>
        </div>
        <div class="card-actions">
          <button class="btn-primary" @click="editProject(project)">编辑</button>
          <button class="btn-danger" @click="deleteProject(project.id)">删除</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProjectLibrary',
  data() {
    return {
      searchKeyword: '',
      filterStatus: '',
      projectList: [
        {
          id: 1,
          name: '城市中心商业综合体',
          manager: '王经理',
          startDate: '2024-01-01',
          endDate: '2024-12-31',
          budget: 5000,
          status: 'in-progress'
        },
        {
          id: 2,
          name: '工业园区基础设施',
          manager: '李经理',
          startDate: '2024-02-01',
          endDate: '2024-08-31',
          budget: 3000,
          status: 'planning'
        },
        {
          id: 3,
          name: '住宅小区开发',
          manager: '张经理',
          startDate: '2023-06-01',
          endDate: '2023-12-31',
          budget: 2000,
          status: 'completed'
        }
      ]
    }
  },
  methods: {
    getStatusText(status) {
      const statusMap = {
        'planning': '规划中',
        'in-progress': '进行中',
        'completed': '已完成'
      }
      return statusMap[status] || status
    },
    addProject() {
      alert('新增项目功能')
    },
    editProject(project) {
      alert(`编辑项目: ${project.name}`)
    },
    deleteProject(id) {
      if (confirm('确定删除该项目吗？')) {
        this.projectList = this.projectList.filter(project => project.id !== id)
      }
    }
  }
}
</script>

<style scoped>
.project-library {
  padding: 20px;
  min-height: 100vh;
  overflow-y: auto;
}

.filter-box {
  display: flex;
  gap: 10px;
  align-items: center;
}

.filter-box select {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.project-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.project-card {
  background: white;
  border-radius: 6px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  border-left: 4px solid #1890ff;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.card-header h4 {
  margin: 0;
  color: #333;
}

.card-content p {
  margin: 8px 0;
  color: #666;
}

.card-actions {
  margin-top: 15px;
  display: flex;
  gap: 10px;
}



.status.planning {
  color: #faad14;
  background: #fffbe6;
  padding: 4px 8px;
  border-radius: 4px;
}

.status.in-progress {
  color: #1890ff;
  background: #e6f7ff;
  padding: 4px 8px;
  border-radius: 4px;
}

.status.completed {
  color: #52c41a;
  background: #f6ffed;
  padding: 4px 8px;
  border-radius: 4px;
}
</style>