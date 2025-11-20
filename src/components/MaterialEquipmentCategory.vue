<template>
  <div class="material-equipment-category">
    <!-- 搜索区域 -->
    <div class="search-area">
      <div class="search-form">
        <div class="search-content">
          <div class="form-grid">
            <div class="form-item">
              <label>一级分类：</label>
              <select v-model="searchParams.firstLevel">
                <option value="">全部</option>
                <option value="机械设备">机械设备</option>
                <option value="电气设备">电气设备</option>
                <option value="建筑材料">建筑材料</option>
              </select>
            </div>
            <div class="form-item">
              <label>二级分类：</label>
              <select v-model="searchParams.secondLevel">
                <option value="">全部</option>
                <option value="起重设备">起重设备</option>
                <option value="输送设备">输送设备</option>
                <option value="变压器">变压器</option>
              </select>
            </div>
            <div class="form-item">
              <label>三级分类：</label>
              <select v-model="searchParams.thirdLevel">
                <option value="">全部</option>
                <option value="塔式起重机">塔式起重机</option>
                <option value="桥式起重机">桥式起重机</option>
                <option value="干式变压器">干式变压器</option>
              </select>
            </div>
            <div class="form-item">
              <label>四级分类：</label>
              <select v-model="searchParams.fourthLevel">
                <option value="">全部</option>
                <option value="大型塔吊">大型塔吊</option>
                <option value="小型塔吊">小型塔吊</option>
                <option value="高压变压器">高压变压器</option>
              </select>
            </div>
            <div class="form-item">
              <label>装备名称：</label>
              <input type="text" v-model="searchParams.equipmentName" placeholder="请输入装备名称">
            </div>
            <div class="form-item">
              <label>装备编码：</label>
              <input type="text" v-model="searchParams.equipmentCode" placeholder="请输入装备编码">
            </div>
            <div class="form-item">
              <label>型号：</label>
              <input type="text" v-model="searchParams.model" placeholder="请输入型号">
            </div>
            <div class="form-item">
              <label>规格：</label>
              <input type="text" v-model="searchParams.specification" placeholder="请输入规格">
            </div>
          </div>
          <div class="button-group">
            <button class="btn-primary" @click="handleSearch">查询</button>
            <button class="btn-primary" @click="handleReset">重置</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 新增弹窗 -->
    <div class="modal" v-if="showAddModal">
      <div class="modal-content" style="width: 2400px !important; max-height: 90vh;">
        <div class="modal-header">
          <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
            <h3>新增分类</h3>
            <div class="header-actions">
              <button class="btn-primary" @click="handleSave">保存</button>
              <button class="btn-primary" @click="closeModal">取消</button>
            </div>
          </div>
        </div>
        <div class="modal-body">
          <form class="add-form">
            <div class="form-grid" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; width: 100%; margin-bottom: 20px;">
              <div class="form-item">
                <label class="required">一级分类：</label>
                <select v-model="newEquipment.firstLevel" required>
                  <option value="">请选择一级分类</option>
                  <option value="机械设备">机械设备</option>
                  <option value="电气设备">电气设备</option>
                  <option value="建筑材料">建筑材料</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">二级分类：</label>
                <select v-model="newEquipment.secondLevel" required>
                  <option value="">请选择二级分类</option>
                  <option value="起重设备">起重设备</option>
                  <option value="输送设备">输送设备</option>
                  <option value="变压器">变压器</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">三级分类：</label>
                <select v-model="newEquipment.thirdLevel" required>
                  <option value="">请选择三级分类</option>
                  <option value="塔式起重机">塔式起重机</option>
                  <option value="桥式起重机">桥式起重机</option>
                  <option value="干式变压器">干式变压器</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">四级分类：</label>
                <select v-model="newEquipment.fourthLevel" required>
                  <option value="">请选择四级分类</option>
                  <option value="大型塔吊">大型塔吊</option>
                  <option value="小型塔吊">小型塔吊</option>
                  <option value="高压变压器">高压变压器</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">装备名称：</label>
                <input type="text" v-model="newEquipment.equipmentName" placeholder="请输入装备名称" required>
              </div>
              
              <div class="form-item">
                <label class="required">装备编码：</label>
                <input type="text" v-model="newEquipment.equipmentCode" placeholder="请输入装备编码" required>
              </div>
              
              <div class="form-item">
                <label class="required">单位：</label>
                <select v-model="newEquipment.unit" required>
                  <option value="">请选择单位</option>
                  <option value="台">台</option>
                  <option value="套">套</option>
                  <option value="吨">吨</option>
                  <option value="千克">千克</option>
                  <option value="米">米</option>
                  <option value="平方米">平方米</option>
                  <option value="立方米">立方米</option>
                  <option value="升">升</option>
                  <option value="件">件</option>
                  <option value="箱">箱</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">型号：</label>
                <input type="text" v-model="newEquipment.model" placeholder="请输入型号" required>
              </div>
              
              <div class="form-item">
                <label class="required">规格：</label>
                <input type="text" v-model="newEquipment.specification" placeholder="请输入规格" required>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- 编辑弹窗 -->
    <div class="modal" v-if="showEditModal">
      <div class="modal-content" style="width: 2400px !important; max-height: 90vh;">
        <div class="modal-header">
          <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
            <h3>编辑分类</h3>
            <div class="header-actions">
              <button class="btn-primary" @click="handleEditSave">保存</button>
              <button class="btn-primary" @click="closeEditModal">取消</button>
            </div>
          </div>
        </div>
        <div class="modal-body">
          <form class="edit-form">
            <div class="form-grid" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 24px; width: 100%; margin-bottom: 20px;">
              <div class="form-item">
                <label class="required">一级分类：</label>
                <select v-model="editEquipment.firstLevel" required>
                  <option value="">请选择一级分类</option>
                  <option value="机械设备">机械设备</option>
                  <option value="电气设备">电气设备</option>
                  <option value="建筑材料">建筑材料</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">二级分类：</label>
                <select v-model="editEquipment.secondLevel" required>
                  <option value="">请选择二级分类</option>
                  <option value="起重设备">起重设备</option>
                  <option value="输送设备">输送设备</option>
                  <option value="变压器">变压器</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">三级分类：</label>
                <select v-model="editEquipment.thirdLevel" required>
                  <option value="">请选择三级分类</option>
                  <option value="塔式起重机">塔式起重机</option>
                  <option value="桥式起重机">桥式起重机</option>
                  <option value="干式变压器">干式变压器</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">四级分类：</label>
                <select v-model="editEquipment.fourthLevel" required>
                  <option value="">请选择四级分类</option>
                  <option value="大型塔吊">大型塔吊</option>
                  <option value="小型塔吊">小型塔吊</option>
                  <option value="高压变压器">高压变压器</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">装备名称：</label>
                <input type="text" v-model="editEquipment.equipmentName" placeholder="请输入装备名称" required>
              </div>
              
              <div class="form-item">
                <label class="required">装备编码：</label>
                <input type="text" v-model="editEquipment.equipmentCode" placeholder="请输入装备编码" required>
              </div>
              
              <div class="form-item">
                <label class="required">单位：</label>
                <select v-model="editEquipment.unit" required>
                  <option value="">请选择单位</option>
                  <option value="台">台</option>
                  <option value="套">套</option>
                  <option value="吨">吨</option>
                  <option value="千克">千克</option>
                  <option value="米">米</option>
                  <option value="平方米">平方米</option>
                  <option value="立方米">立方米</option>
                  <option value="升">升</option>
                  <option value="件">件</option>
                  <option value="箱">箱</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">型号：</label>
                <input type="text" v-model="editEquipment.model" placeholder="请输入型号" required>
              </div>
              
              <div class="form-item">
                <label class="required">规格：</label>
                <input type="text" v-model="editEquipment.specification" placeholder="请输入规格" required>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- 表格区域 -->
    <div class="table-area">
      <div class="table-header">
        <h3>物资装备列表</h3>
        <div class="header-buttons">
          <button class="btn-primary" @click="downloadImportTemplate">导入模板下载</button>
          <input ref="importFile" type="file" @change="handleImport" accept=".csv" style="display: none;" />
          <button class="btn-primary" @click="triggerImport">导入</button>
          <button class="btn-primary" @click="handleAdd">新增</button>
        </div>
      </div>
      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>序号</th>
              <th>一级分类</th>
              <th>二级分类</th>
              <th>三级分类</th>
              <th>四级分类</th>
              <th>装备名称</th>
              <th>装备编码</th>
              <th>单位</th>
              <th>型号</th>
              <th>规格</th>
              <th>创建时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in sortedEquipmentList" :key="item.id">
              <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
              <td>{{ item.firstLevel }}</td>
              <td>{{ item.secondLevel }}</td>
              <td>{{ item.thirdLevel }}</td>
              <td>{{ item.fourthLevel }}</td>
              <td>{{ item.equipmentName }}</td>
              <td>{{ item.equipmentCode }}</td>
              <td>{{ item.unit }}</td>
              <td>{{ item.model }}</td>
              <td>{{ item.specification }}</td>
              <td>{{ formatDate(item.createTime) }}</td>
              <td>
                <button class="btn-primary btn-sm" @click="handleEdit(item)">编辑</button>
                <button class="btn-primary btn-sm" @click="handleDelete(item.id)">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <button class="btn-primary" @click="prevPage" :disabled="currentPage === 1">上一页</button>
        <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
        <button class="btn-primary" @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'MaterialEquipmentCategory',
  data() {
    return {
      searchParams: {
        firstLevel: '',
        secondLevel: '',
        thirdLevel: '',
        fourthLevel: '',
        equipmentName: '',
        equipmentCode: '',
        model: '',
        specification: ''
      },
      showAddModal: false,
      showEditModal: false,
      newEquipment: {
        firstLevel: '',
        secondLevel: '',
        thirdLevel: '',
        fourthLevel: '',
        equipmentName: '',
        equipmentCode: '',
        unit: '',
        model: '',
        specification: ''
      },
      editEquipment: {
        id: null,
        firstLevel: '',
        secondLevel: '',
        thirdLevel: '',
        fourthLevel: '',
        equipmentName: '',
        equipmentCode: '',
        unit: '',
        model: '',
        specification: ''
      },
      equipmentList: [
        {
          id: 1,
          firstLevel: '机械设备',
          secondLevel: '起重设备',
          thirdLevel: '塔式起重机',
          fourthLevel: '大型塔吊',
          equipmentName: 'QTZ80塔式起重机',
          equipmentCode: 'QTZ80-001',
          unit: '台',
          model: 'QTZ80',
          specification: '最大起重量8吨，臂长60米',
          createTime: '2024-10-28'
        },
        {
          id: 2,
          firstLevel: '电气设备',
          secondLevel: '变压器',
          thirdLevel: '干式变压器',
          fourthLevel: '高压变压器',
          equipmentName: 'SCB10干式变压器',
          equipmentCode: 'SCB10-1000',
          unit: '台',
          model: 'SCB10',
          specification: '容量1000kVA，电压10kV/0.4kV',
          createTime: '2024-10-28'
        },
        {
          id: 3,
          firstLevel: '建筑材料',
          secondLevel: '起重设备',
          thirdLevel: '桥式起重机',
          fourthLevel: '小型塔吊',
          equipmentName: 'LD型电动单梁起重机',
          equipmentCode: 'LD-5T',
          unit: '台',
          model: 'LD',
          specification: '起重量5吨，跨度16米',
          createTime: '2024-10-28'
        }
      ],
      currentPage: 1,
      pageSize: 10,
      totalItems: 3
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.totalItems / this.pageSize)
    },
    sortedEquipmentList() {
      let filteredList = [...this.equipmentList]
      
      // 应用过滤条件
      if (this.searchParams.firstLevel) {
        filteredList = filteredList.filter(item =>
          item.firstLevel === this.searchParams.firstLevel
        )
      }
      if (this.searchParams.secondLevel) {
        filteredList = filteredList.filter(item =>
          item.secondLevel === this.searchParams.secondLevel
        )
      }
      if (this.searchParams.thirdLevel) {
        filteredList = filteredList.filter(item =>
          item.thirdLevel === this.searchParams.thirdLevel
        )
      }
      if (this.searchParams.fourthLevel) {
        filteredList = filteredList.filter(item =>
          item.fourthLevel === this.searchParams.fourthLevel
        )
      }
      if (this.searchParams.equipmentName) {
        filteredList = filteredList.filter(item =>
          item.equipmentName.includes(this.searchParams.equipmentName)
        )
      }
      if (this.searchParams.equipmentCode) {
        filteredList = filteredList.filter(item =>
          item.equipmentCode.includes(this.searchParams.equipmentCode)
        )
      }
      if (this.searchParams.model) {
        filteredList = filteredList.filter(item =>
          item.model.includes(this.searchParams.model)
        )
      }
      if (this.searchParams.specification) {
        filteredList = filteredList.filter(item =>
          item.specification.includes(this.searchParams.specification)
        )
      }
      
      return filteredList
    }
  },
  methods: {
    handleSearch() {
      // 搜索逻辑
      this.currentPage = 1
      console.log('搜索参数：', this.searchParams)
    },
    
    handleReset() {
      this.searchParams = {
        firstLevel: '',
        secondLevel: '',
        thirdLevel: '',
        fourthLevel: '',
        equipmentName: '',
        equipmentCode: '',
        model: '',
        specification: ''
      }
      this.currentPage = 1
    },
    
    handleAdd() {
      // 重置表单数据
      this.newEquipment = {
        firstLevel: '',
        secondLevel: '',
        thirdLevel: '',
        fourthLevel: '',
        equipmentName: '',
        equipmentCode: '',
        unit: '',
        model: '',
        specification: ''
      }
      // 显示新增弹窗
      this.showAddModal = true
    },
    
    handleEdit(item) {
      this.editEquipment = { ...item }
      this.showEditModal = true
    },
    
    handleDelete(id) {
      if (confirm('确定删除该物资装备吗？')) {
        this.equipmentList = this.equipmentList.filter(item => item.id !== id)
        this.totalItems = this.equipmentList.length
      }
    },
    
    handleSave() {
      // 验证必填字段
      const requiredFields = [
        'firstLevel',
        'secondLevel',
        'thirdLevel',
        'fourthLevel',
        'equipmentName',
        'equipmentCode',
        'unit',
        'model',
        'specification'
      ]
      
      for (const field of requiredFields) {
        if (!this.newEquipment[field]) {
          alert(`请填写${this.getFieldLabel(field)}`)
          return
        }
      }
      
      // 验证装备编码是否重复
      const isCodeDuplicate = this.equipmentList.some(item => 
        item.equipmentCode === this.newEquipment.equipmentCode
      )
      if (isCodeDuplicate) {
        alert('装备编码已存在，请重新输入')
        return
      }
      
      // 新增模式
      const newId = Math.max(...this.equipmentList.map(item => item.id)) + 1
      const newItem = {
        id: newId,
        ...this.newEquipment,
        createTime: new Date().toISOString().split('T')[0]
      }
      
      this.equipmentList.push(newItem)
      this.totalItems = this.equipmentList.length
      alert('新增成功！')
      
      this.closeModal()
    },
    
    handleEditSave() {
      // 验证必填字段
      const requiredFields = [
        'firstLevel',
        'secondLevel',
        'thirdLevel',
        'fourthLevel',
        'equipmentName',
        'equipmentCode',
        'unit',
        'model',
        'specification'
      ]
      
      for (const field of requiredFields) {
        if (!this.editEquipment[field]) {
          alert(`请填写${this.getFieldLabel(field)}`)
          return
        }
      }
      
      // 验证装备编码是否重复（排除当前编辑的装备）
      const isCodeDuplicate = this.equipmentList.some(item => 
        item.id !== this.editEquipment.id && item.equipmentCode === this.editEquipment.equipmentCode
      )
      if (isCodeDuplicate) {
        alert('装备编码已存在，请重新输入')
        return
      }
      
      // 更新模式
      const index = this.equipmentList.findIndex(item => item.id === this.editEquipment.id)
      if (index !== -1) {
        this.equipmentList[index] = {
          ...this.editEquipment
        }
        alert('更新成功！')
      }
      
      this.closeEditModal()
    },
    
    closeModal() {
      this.showAddModal = false
    },
    
    closeEditModal() {
      this.showEditModal = false
    },
    
    getFieldLabel(field) {
      const labels = {
        firstLevel: '一级分类',
        secondLevel: '二级分类',
        thirdLevel: '三级分类',
        fourthLevel: '四级分类',
        equipmentName: '物资装备名称',
        equipmentCode: '装备编码',
        unit: '单位',
        model: '型号',
        specification: '规格'
      }
      return labels[field] || field
    },
    
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--
      }
    },
    
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++
      }
    },
    
    formatDate(date) {
      return date
    },
    
    downloadImportTemplate() {
      const headers = ['一级分类','二级分类','三级分类','四级分类','物资装备名称','装备编码','单位','型号','规格']
      const csvContent = headers.join(',') + '\n'
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
      const url = URL.createObjectURL(blob)
      const link = document.createElement('a')
      link.href = url
      link.download = '物资装备导入模板.csv'
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      URL.revokeObjectURL(url)
    },
    
    triggerImport() {
      const input = this.$refs.importFile
      if (input && input instanceof HTMLInputElement) {
        input.value = ''
        input.click()
      } else {
        alert('导入控件不可用')
      }
    },
    
    handleImport(event) {
      const input = event && event.target ? event.target : null
      if (!input || !input.files || input.files.length === 0) {
        alert('未选择文件')
        return
      }
      const file = input.files[0]
      if (!file.name.toLowerCase().endsWith('.csv')) {
        alert('仅支持CSV文件导入')
        return
      }
      const reader = new FileReader()
      reader.onload = (e) => {
        try {
          const text = e.target && e.target.result ? String(e.target.result) : ''
          const lines = text.split(/\r?\n/).filter(l => l.trim().length > 0)
          if (lines.length <= 1) {
            alert('文件内容为空或格式不正确')
            return
          }
          const header = lines[0].split(',')
          const expected = ['一级分类','二级分类','三级分类','四级分类','物资装备名称','装备编码','单位','型号','规格']
          const valid = expected.every((h, i) => (header[i] || '').trim() === h)
          if (!valid) {
            alert('CSV表头不匹配，请使用模板导入')
            return
          }
          const added = []
          for (let i = 1; i < lines.length; i++) {
            const cols = lines[i].split(',')
            if (cols.length < expected.length) continue
            const equipment = {
              id: Date.now() + i,
              firstLevel: (cols[0] || '').trim(),
              secondLevel: (cols[1] || '').trim(),
              thirdLevel: (cols[2] || '').trim(),
              fourthLevel: (cols[3] || '').trim(),
              equipmentName: (cols[4] || '').trim(),
              equipmentCode: (cols[5] || '').trim(),
              unit: (cols[6] || '').trim(),
              model: (cols[7] || '').trim(),
              specification: (cols[8] || '').trim(),
              createTime: new Date().toISOString().split('T')[0]
            }
            // 简单校验
            if (!equipment.equipmentName) continue
            this.equipmentList.push(equipment)
            added.push(equipment)
          }
          this.totalItems = this.equipmentList.length
          alert(`成功导入 ${added.length} 条物资装备信息`)
        } catch (err) {
          console.error(err)
          alert('导入失败，请检查文件格式')
        }
      }
      reader.onerror = () => {
        alert('文件读取失败')
      }
      reader.readAsText(file, 'utf-8')
    }
  }
}
</script>

<style scoped>
.material-equipment-category {
  padding: 20px;
  background: #f0f2f5;
  min-height: 100vh;
  overflow: auto;
}

/* 搜索区域样式 - 使用统一蓝色主题 */
.search-area {
  background: #fff;
  padding: 24px;
  border-radius: 12px;
  margin-bottom: 24px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(24, 144, 255, 0.1);
}

.search-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.search-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-grid {
  display: grid !important;
  grid-template-columns: repeat(2, 1fr) !important;
  gap: 24px !important;
  width: 100% !important;
  margin-bottom: 20px !important;
  align-items: start !important;
}

.button-group {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 10px;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  align-items: flex-start;
  justify-content: space-between;
}

.form-item {
  display: flex;
  align-items: center;
  flex: 1;
  min-height: 40px;
}

.form-item label {
  width: 100px;
  text-align: right;
  margin-right: 12px;
  font-weight: 500;
  color: #333;
  flex-shrink: 0;
}

.form-item input,
.form-item select {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  min-height: 36px;
  box-sizing: border-box;
}

.form-item input:focus,
.form-item select:focus {
  outline: none;
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

.date-range {
  display: flex;
  align-items: center;
  gap: 8px;
}

.date-input {
  width: 140px;
}

.range-separator {
  color: #666;
  font-size: 14px;
}

.button-group {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  flex: 0 0 auto;
  min-width: 200px;
  margin-left: auto;
}

/* 表格区域样式 */
.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-top: 20px;
}

.header-buttons {
  display: flex;
  gap: 20px;
  margin-top: 10px;
  margin-right: 20px;
}

/* 弹窗样式 */
.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 12px;
  max-height: 85vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
  border: 1px solid rgba(24, 144, 255, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #f0f0f0;
  background: #f0f0f0;
  border-radius: 12px 12px 0 0;
}

.modal-header h3 {
  margin: 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.modal-header .header-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}

.modal-header .header-actions .btn-primary {
  padding: 8px 16px;
  font-size: 14px;
  background: #1890ff;
  border: 1px solid #1890ff;
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
  border-radius: 6px;
}

.modal-header .header-actions .btn-primary:hover {
  background: #40a9ff;
  border-color: #40a9ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(24, 144, 255, 0.3);
}

.close {
  font-size: 24px;
  cursor: pointer;
  color: rgba(255, 255, 255, 0.8);
  transition: color 0.2s;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
}

.close:hover {
  color: white;
  background: rgba(255, 255, 255, 0.1);
}

.modal-body {
  padding: 24px 32px;
  background: #fafafa;
}

.add-form, .edit-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  align-items: start;
  margin-bottom: 16px;
}

.form-group {
  display: flex;
  flex-direction: column;
  min-height: 72px;
}

.form-group label {
  width: 100%;
  text-align: left;
  margin-bottom: 8px;
  font-weight: 500;
  color: #333;
  font-size: 14px;
  line-height: 1.4;
}

.form-group label.required::after {
  content: '*';
  color: #ff4d4f;
  margin-left: 4px;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.2s;
  background: white;
  min-height: 40px;
  box-sizing: border-box;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

.form-group input:disabled {
  background: #f5f5f5;
  color: #999;
  cursor: not-allowed;
}

.form-group textarea {
  resize: vertical;
  min-height: 60px;
  line-height: 1.5;
}

.form-group.full-width {
  grid-column: 1 / -1;
}

.form-group.full-width textarea {
  min-height: 80px;
}

.modal-footer {
  padding: 24px;
  border-top: 1px solid #f0f0f0;
  display: flex;
  justify-content: center;
  gap: 16px;
  background: white;
  border-radius: 0 0 12px 12px;
}

.modal-footer .btn-primary {
  min-width: 100px;
  height: 44px;
  padding: 0 24px;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.2s;
  background: #1890ff;
  color: white;
}

.modal-footer .btn-primary:hover {
  background: #40a9ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

/* 表格样式 */
.table-container {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
  background: white;
  border-radius: 6px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.data-table th {
  background: #1890ff;
  padding: 12px 8px;
  text-align: center;
  font-weight: 600;
  color: white;
  border-bottom: 1px solid #e8e8e8;
}

.data-table td {
  padding: 12px 8px;
  border-bottom: 1px solid #f0f0f0;
  color: #333;
  text-align: center;
}

.data-table tbody tr:hover {
  background: #f5f5f5;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 20px;
  padding: 16px;
  background: #fafafa;
  border-radius: 0 0 6px 6px;
}

.pagination button {
  padding: 8px 16px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  background: white;
  cursor: pointer;
  transition: all 0.2s;
  background: #1890ff;
  color: white;
  border: none;
}

.pagination button:hover:not(:disabled) {
  background: #40a9ff;
}

.pagination button:disabled {
  background: #f5f5f5;
  color: #bfbfbf;
  cursor: not-allowed;
}

.btn-primary {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s;
  background: #1890ff;
  color: white;
}

.btn-primary:hover {
  background: #40a9ff;
}

.btn-sm {
  padding: 4px 8px;
  font-size: 12px;
  margin-right: 4px;
}
</style>