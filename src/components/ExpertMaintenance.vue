<template>
  <div class="expert-maintenance">
    <!-- 查询筛选模块 -->
    <div class="card filter-card">
      <div class="filter-grid">
        <div class="filter-item">
          <label>专家姓名：</label>
          <input v-model="filters.name" type="text" placeholder="请输入专家姓名" />
        </div>
        <div class="filter-item">
          <label>专业领域：</label>
          <select v-model="filters.specialty">
            <option value="">全部</option>
            <option v-for="s in options.specialties" :key="s" :value="s">{{ s }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>职称：</label>
          <select v-model="filters.title">
            <option value="">全部</option>
            <option v-for="t in options.titles" :key="t" :value="t">{{ t }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>最高学历：</label>
          <select v-model="filters.education">
            <option value="">全部</option>
            <option v-for="e in options.educations" :key="e" :value="e">{{ e }}</option>
          </select>
        </div>
        
      </div>
      <div class="filter-actions">
          <button class="btn-primary" @click="handleQuery">查询</button>
          <button class="btn-secondary" @click="handleReset">重置</button>
        </div>
    </div>

    <!-- 列表模块 -->
    <div class="card list-card">
      <div class="list-header">
        <h4>专家列表</h4>
        <div class="header-actions">
            <button class="btn-primary" @click="handleAdd">新增</button>
          </div>
      </div>
      <div class="table-wrapper">
        <table class="data-table">
          <thead>
            <tr>
              <th>序号</th>
              <th>专家姓名</th>
              <th>专业领域</th>
              <th>职称</th>
              <th>工作单位</th>
              <th>联系电话</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, idx) in displayList" :key="row.id">
              <td>{{ idx + 1 }}</td>
              <td>{{ row.name }}</td>
              <td>{{ row.specialty }}</td>
              <td>{{ row.title }}</td>
              <td>{{ row.workUnit }}</td>
              <td>{{ row.phone }}</td>
              <td>
                <div class="op-btns">
                  <button class="btn-primary" @click="handleEdit(row)">编辑</button>
                  <button class="btn-danger" @click="handleDelete(row)">删除</button>
                </div>
              </td>
            </tr>
            <tr v-if="displayList.length === 0">
              <td colspan="7" class="empty">暂无数据</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 分页控件 -->
    <div class="pagination">
      <button
        @click="pagination.currentPage--"
        :disabled="pagination.currentPage <= 1">
        上一页
      </button>
      <span class="page-info">
        第 {{ pagination.currentPage }} 页 / 共 {{ Math.ceil(filteredList.length / pagination.pageSize) }} 页
      </span>
      <button
        @click="pagination.currentPage++"
        :disabled="pagination.currentPage >= Math.ceil(filteredList.length / pagination.pageSize)">
        下一页
      </button>
    </div>

    <!-- 新增/编辑专家弹窗 -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">{{ isEdit ? '编辑专家信息' : '新增专家信息' }}</div>
        <div class="modal-body">
          <div class="modal-grid">
            <!-- 第一列 -->
            <div class="form-item">
              <label><span class="req">*</span>专家姓名：</label>
              <input v-model="form.name" type="text" placeholder="请输入专家姓名" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>专业领域：</label>
              <select v-model="form.specialty">
                <option value="">请选择</option>
                <option v-for="s in options.specialties" :key="s" :value="s">{{ s }}</option>
              </select>
            </div>
            <div class="form-item">
              <label><span class="req">*</span>职称：</label>
              <select v-model="form.title">
                <option value="">请选择</option>
                <option v-for="t in options.titles" :key="t" :value="t">{{ t }}</option>
              </select>
            </div>
            <!-- 第二列 -->
            <div class="form-item">
              <label><span class="req">*</span>工作单位：</label>
              <input v-model="form.workUnit" type="text" placeholder="请输入工作单位" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>联系电话：</label>
              <input v-model="form.phone" type="text" placeholder="请输入联系电话" />
            </div>
            <div class="form-item">
              <label>电子邮箱：</label>
              <input v-model="form.email" type="email" placeholder="请输入电子邮箱" />
            </div>
          </div>
          
          <!-- 工作总结 -->
          <div class="form-item full-width">
            <label>工作总结：</label>
            <textarea v-model="form.workSummary" placeholder="请输入专家的工作总结" rows="4"></textarea>
          </div>

          <!-- 关联项目信息 -->
          <div class="section">
            <div class="section-header">
              <h5>关联项目信息</h5>
              <div class="section-actions">
                <button class="btn-primary" @click="showProjectSelection = true">新增</button>
              </div>
            </div>
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>序号</th>
                    <th>项目名称</th>
                    <th>区域机构</th>
                    <th>项目类别</th>
                    <th>施工类型</th>
                    <th>合同金额（万人民币）</th>
                    <th>产业链</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(project, idx) in form.relatedProjects" :key="project.id">
                    <td>{{ idx + 1 }}</td>
                    <td>{{ project.name }}</td>
                    <td>{{ project.region }}</td>
                    <td>{{ project.category }}</td>
                    <td>{{ project.constructionType }}</td>
                    <td>{{ project.amount }}</td>
                    <td>{{ project.industryChain }}</td>
                    <td class="op-btns">
                      <button class="btn-danger" @click="removeProject(idx)">删除</button>
                    </td>
                  </tr>
                  <tr v-if="form.relatedProjects.length === 0">
                    <td colspan="8" class="empty">暂无关联项目</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-primary" @click="handleSubmit">提交</button>
        <button class="btn-secondary" @click="handleCancel">取消</button>
        </div>
      </div>
    </div>

    <!-- 项目选择弹窗 -->
    <div v-if="showProjectSelection" class="modal-overlay">
      <div class="modal project-selection-modal" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">选择项目</div>
        <div class="modal-body">
          <div class="search-bar">
            <input v-model="projectSearch" type="text" placeholder="搜索项目名称" class="search-input" />
          </div>
          <div class="table-wrapper">
            <table class="data-table">
              <thead>
                <tr>
                  <th>选择</th>
                  <th>项目名称</th>
                  <th>区域机构</th>
                  <th>项目类别</th>
                  <th>施工类型</th>
                  <th>合同金额（万人民币）</th>
                  <th>产业链</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="project in filteredProjects" :key="project.id">
                  <td>
                    <input type="checkbox" :value="project" v-model="selectedProjects" />
                  </td>
                  <td>{{ project.name }}</td>
                  <td>{{ project.region }}</td>
                  <td>{{ project.category }}</td>
                  <td>{{ project.constructionType }}</td>
                  <td>{{ project.amount }}</td>
                  <td>{{ project.industryChain }}</td>
                </tr>
                <tr v-if="filteredProjects.length === 0">
                  <td colspan="7" class="empty">暂无项目数据</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn-primary" @click="addSelectedProjects">确认添加</button>
        <button class="btn-secondary" @click="showProjectSelection = false">取消</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'ExpertMaintenance',
  data() {
    return {
      // 选项
      options: {
        specialties: ['土木工程', '电气工程', '机械工程', '建筑工程', '水利工程', '环境工程'],
        titles: ['高级工程师', '工程师', '助理工程师', '技术员', '教授', '副教授', '研究员'],
        educations: ['博士', '硕士', '本科', '专科', '高中']
      },
      // 筛选条件
      filters: {
        name: '',
        specialty: '',
        title: '',
        education: ''
      },
      // 原始数据
      rawList: [
        {
          id: 1,
          name: '张三',
          specialty: '土木工程',
          title: '高级工程师',
          workUnit: '北京建筑设计院',
          phone: '13800138000',
          email: 'zhangsan@example.com',
          education: '博士',
          birthDate: '1980-05-15',
          workSummary: '从事土木工程设计工作20年，参与多个大型工程项目设计。',
          relatedProjects: []
        },
        {
          id: 2,
          name: '李四',
          specialty: '电气工程',
          title: '工程师',
          workUnit: '上海电气集团',
          phone: '13900139000',
          email: 'lisi@example.com',
          education: '硕士',
          birthDate: '1985-08-20',
          workSummary: '专注于电气系统设计与优化，有丰富的现场经验。',
          relatedProjects: []
        },
        {
          id: 3,
          name: '王五',
          specialty: '机械工程',
          title: '高级工程师',
          workUnit: '广州机械研究所',
          phone: '13600136000',
          email: 'wangwu@example.com',
          education: '硕士',
          birthDate: '1978-12-10',
          workSummary: '机械设计与制造专家，拥有10多项专利技术。',
          relatedProjects: []
        },
        {
          id: 4,
          name: '赵六',
          specialty: '建筑工程',
          title: '教授',
          workUnit: '清华大学建筑学院',
          phone: '13500135000',
          email: 'zhaoliu@example.com',
          education: '博士',
          birthDate: '1975-03-22',
          workSummary: '建筑结构设计专家，参与多项国家级重点工程。',
          relatedProjects: []
        },
        {
          id: 5,
          name: '钱七',
          specialty: '水利工程',
          title: '高级工程师',
          workUnit: '长江水利委员会',
          phone: '13400134000',
          email: 'qianqi@example.com',
          education: '博士',
          birthDate: '1979-07-30',
          workSummary: '水工结构与防洪专家，具有丰富的水利项目经验。',
          relatedProjects: []
        },
        {
          id: 6,
          name: '孙八',
          specialty: '环境工程',
          title: '副教授',
          workUnit: '同济大学环境学院',
          phone: '13300133000',
          email: 'sunba@example.com',
          education: '博士',
          birthDate: '1982-11-05',
          workSummary: '水处理技术与环境保护专家，发表多篇核心期刊论文。',
          relatedProjects: []
        },
        {
          id: 7,
          name: '周九',
          specialty: '电气工程',
          title: '高级工程师',
          workUnit: '国家电网公司',
          phone: '13200132000',
          email: 'zhoujiu@example.com',
          education: '硕士',
          birthDate: '1977-09-18',
          workSummary: '电力系统规划与运行专家，参与多项电网建设项目。',
          relatedProjects: []
        }
      ],
      displayList: [],
      pagination: {
        pageSize: 3,
        currentPage: 1
      },
      filteredList: [],
      // 弹窗相关
      showModal: false,
      isEdit: false,
      form: {
        id: null,
        name: '',
        specialty: '',
        title: '',
        workUnit: '',
        phone: '',
        email: '',
        workSummary: '',
        relatedProjects: []
      },
      // 项目选择相关
      showProjectSelection: false,
      projectSearch: '',
      selectedProjects: [],
      // 项目数据（从项目维护页面获取）
      projectList: [
        {
          id: 1,
          name: '北京市地铁XX线三期工程',
          region: '华北区域',
          category: '轨道交通',
          constructionType: '总承包',
          amount: 128000,
          industryChain: '设备'
        },
        {
          id: 2,
          name: '上海市浦东新区市政道路改造',
          region: '华东区域',
          category: '市政工程',
          constructionType: '专业分包',
          amount: 35000,
          industryChain: '建材'
        },
        {
          id: 3,
          name: '深圳某房建项目一期',
          region: '华南区域',
          category: '房建工程',
          constructionType: '劳务分包',
          amount: 82000,
          industryChain: '施工'
        }
      ]
    }
  },
  computed: {
    filteredProjects() {
      if (!this.projectSearch) {
        return this.projectList;
      }
      const search = this.projectSearch.toLowerCase();
      return this.projectList.filter(project => 
        project.name.toLowerCase().includes(search)
      );
    }
  },
  created() {
    this.filteredList = [...this.rawList];
    this.pagination = {
      pageSize: 3,
      currentPage: 1
    };
    this.updateDisplayList();
    // 确保初始加载时执行查询以应用分页
    this.handleQuery();
    console.log('组件初始化:', {
      initialDataCount: this.rawList.length,
      paginationSettings: this.pagination
    });
  },
  watch: {
    'pagination.currentPage': 'updateDisplayList',
    'pagination.pageSize': 'updateDisplayList'
  },
  methods: {
    updateDisplayList() {
      const startIndex = (this.pagination.currentPage - 1) * this.pagination.pageSize;
      const endIndex = startIndex + this.pagination.pageSize;
      this.displayList = this.filteredList.slice(startIndex, endIndex);
      console.log('分页更新:', {
        currentPage: this.pagination.currentPage,
        pageSize: this.pagination.pageSize,
        startIndex,
        endIndex,
        totalItems: this.filteredList.length,
        displayedItems: this.displayList.length
      });
    },
    handleQuery() {
      const f = this.filters;
      this.filteredList = this.rawList.filter((row) => {
        const byName = f.name ? row.name.toLowerCase().includes(f.name.trim().toLowerCase()) : true;
        const bySpecialty = f.specialty ? row.specialty === f.specialty : true;
        const byTitle = f.title ? row.title === f.title : true;
        const byEducation = f.education ? row.education === f.education : true;

        return byName && bySpecialty && byTitle && byEducation;
      });
      
      this.pagination.currentPage = 1;
      this.updateDisplayList();
    },
    handleReset() {
      this.filters = {
        name: '',
        specialty: '',
        title: '',
        education: ''
      };
      this.filteredList = [...this.rawList];
      this.pagination.currentPage = 1;
      this.updateDisplayList();
    },
    handleAdd() {
      this.resetForm();
      this.isEdit = false;
      this.showModal = true;
    },
    handleEdit(row) {
      this.form = {
        id: row.id,
        name: row.name,
        specialty: row.specialty,
        title: row.title,
        workUnit: row.workUnit,
        phone: row.phone,
        email: row.email || '',
        workSummary: row.workSummary || '',
        relatedProjects: [...row.relatedProjects]
      };
      this.isEdit = true;
      this.showModal = true;
    },
    handleDelete(row) {
      if (confirm(`确定要删除专家"${row.name}"吗？`)) {
        this.rawList = this.rawList.filter((r) => r.id !== row.id);
        this.handleQuery();
      }
    },
    resetForm() {
      this.form = {
        id: null,
        name: '',
        specialty: '',
        title: '',
        workUnit: '',
        phone: '',
        email: '',
        workSummary: '',
        relatedProjects: []
      };
    },
    validateForm() {
      const f = this.form;
      const required = [
        { key: 'name', label: '专家姓名' },
        { key: 'specialty', label: '专业领域' },
        { key: 'title', label: '职称' },
        { key: 'workUnit', label: '工作单位' },
        { key: 'phone', label: '联系电话' }
      ];
      const missing = required.filter(r => !String(f[r.key] || '').trim());
      if (missing.length) {
        alert('请填写必填项：' + missing.map(m => m.label).join('、'));
        return false;
      }
      return true;
    },
    handleSubmit() {
      if (!this.validateForm()) return;
      
      if (this.isEdit) {
        const index = this.rawList.findIndex(r => r.id === this.form.id);
        if (index !== -1) {
          this.rawList[index] = { ...this.form };
        }
      } else {
        const nextId = (this.rawList[this.rawList.length - 1]?.id || 0) + 1;
        this.rawList.push({
          ...this.form,
          id: nextId
        });
      }
      
      this.handleQuery();
      this.showModal = false;
      alert(this.isEdit ? '编辑成功' : '新增成功');
    },
    handleCancel() {
      this.showModal = false;
    },
    // 关联项目相关方法
    removeProject(index) {
      this.form.relatedProjects.splice(index, 1);
    },
    addSelectedProjects() {
      this.selectedProjects.forEach(project => {
        // 检查是否已经关联
        if (!this.form.relatedProjects.some(p => p.id === project.id)) {
          this.form.relatedProjects.push({ ...project });
        }
      });
      this.selectedProjects = [];
      this.showProjectSelection = false;
      this.projectSearch = '';
    }
  }
}
</script>

<style scoped>
.expert-maintenance {
  padding: 20px;
  background: #f0f2f5;
  min-height: 100vh;
  overflow-y: auto;
}

/* 通用卡片样式 */
.card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  padding: 24px;
  margin-bottom: 24px;
  border: 1px solid rgba(24, 144, 255, 0.1);
  transition: all 0.3s ease;
}

.card:hover {
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

/* 筛选区布局 */
.filter-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px 16px;
  align-items: start;
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.filter-item label {
  min-width: 100px;
  text-align: right;
  color: #2c3e50;
  font-weight: 600;
  font-size: 14px;
}

.filter-item input,
.filter-item select {
  flex: 1;
  padding: 12px 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  font-size: 14px;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.filter-item input:focus,
.filter-item select:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
  background: white;
}

/* 筛选按钮靠右下 */
.filter-actions {
  margin-top: 12px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

/* 列表头部 */
.list-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.list-header h4 {
  margin: 0;
  color: #1890ff;
  font-size: 20px;
  font-weight: 700;
  border-left: 4px solid #1890ff;
  padding-left: 16px;
  background: linear-gradient(135deg, #1890ff 0%, #40a9ff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.header-actions {
  display: flex;
  gap: 12px;
}

/* 表格 */
.table-wrapper {
  overflow: auto;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}



/* 操作按钮样式 */
.op-btns {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
}

/* 按钮样式 */
.btn {
  border: none;
  border-radius: 8px;
  padding: 12px 24px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.btn.primary { 
  background: #1890ff; 
  color: #fff; 
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.btn.primary:hover {
  background: #40a9ff;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(24, 144, 255, 0.4);
}

.btn.default { 
  background: #f5f5f5; 
  color: #555; 
  border: 1px solid #e5e5e5; 
}

.btn.success { 
  background: #52c41a; 
  color: #fff; 
}

.btn.link { 
  background: #fafafa; 
  color: #1890ff; 
  border: 1px solid #e6f7ff; 
}

.btn.danger { 
  background: #ff4d4f; 
  color: #fff; 
}

.btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.empty { color: #999; }

/* 弹窗样式 */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(4px);
}

.modal {
  width: 1200px;
  max-width: 98vw;
  max-height: 90vh;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.2);
  display: flex;
  flex-direction: column;
}

.modal-header {
  padding: 24px 32px;
  font-size: 20px;
  font-weight: 700;
  background: #1890ff;
  color: white;
  border-radius: 16px 16px 0 0;
  margin: 0;
}

.modal-body {
  padding: 32px;
  overflow-y: auto;
  flex: 1;
  max-height: calc(90vh - 200px);
}

.modal-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 16px;
}

.form-item {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.form-item.full-width {
  grid-column: 1 / -1;
}

.form-item label {
  min-width: 140px;
  text-align: right;
  color: #2c3e50;
  font-weight: 600;
  font-size: 14px;
}

.form-item input,
.form-item select,
.form-item textarea {
  flex: 1;
  padding: 12px 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  font-size: 14px;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.form-item input:focus,
.form-item select:focus,
.form-item textarea:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
  background: white;
}

.form-item textarea {
  resize: vertical;
  min-height: 80px;
}

.req { color: #ff4d4f; margin-right: 4px; }

.modal-footer {
  padding: 16px;
  display: flex;
  justify-content: center;
  gap: 12px;
  border-top: 1px solid #f0f0f0;
}

/* 区块与操作栏样式 */
.section { 
  margin-top: 24px;
  border-top: 1px solid #f0f0f0;
  padding-top: 16px;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.section-header h5 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
  border-left: 4px solid #13c2c2;
  padding-left: 12px;
}

.section-actions {
  display: flex;
  gap: 12px;
}

/* 关联项目表格样式 */
.section .table-wrapper {
  max-height: 300px;
  overflow-y: auto;
}

.section .data-table th,
.section .data-table td {
  padding: 12px 16px;
  font-size: 13px;
}

.section .op-btns {
  gap: 6px;
}

.section .btn {
  padding: 8px 16px;
  font-size: 12px;
}

/* 项目选择弹窗 */
.project-selection-modal {
  width: 1000px;
}

.search-bar {
  margin-bottom: 16px;
}

.search-input {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  font-size: 14px;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.search-input:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
  background: white;
}
</style>