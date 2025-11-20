<template>
  <div class="logistics-reporting">
    <!-- 搜索和筛选区域 -->
    <div class="search-area" style="display: flex; flex-direction: column; gap: 16px;">
      <div class="search-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;">
        <div class="form-item">
          <label>订单号：</label>
          <input type="text" v-model="searchParams.orderNo" placeholder="请输入订单号">
        </div>
        <div class="form-item date-range-item">
          <label>订单日期：</label>
          <div class="date-inputs">
            <input type="date" v-model="searchParams.orderStartDate">
            <span class="date-separator">至</span>
            <input type="date" v-model="searchParams.orderEndDate">
          </div>
        </div>
        <div class="form-item">
          <label>当前阶段：</label>
          <select v-model="searchParams.currentStage">
            <option value="">全部</option>
            <option value="production">生产阶段</option>
            <option value="transport">运输阶段</option>
            <option value="customs">清关阶段</option>
            <option value="arrival">物资到场</option>
          </select>
        </div>
        <div class="form-item">
          <label>物流状态：</label>
          <select v-model="searchParams.logisticsStatus">
            <option value="">全部</option>
            <option value="normal">正常</option>
            <option value="delayed">延误</option>
            <option value="completed">已完成</option>
          </select>
        </div>
        <div class="form-item">
          <label>是否延误：</label>
          <select v-model="searchParams.isDelayed">
            <option value="">全部</option>
            <option value="true">是</option>
            <option value="false">否</option>
          </select>
        </div>
        <div class="form-item date-range-item">
          <label>填报时间：</label>
          <div class="date-inputs">
            <input type="date" v-model="searchParams.reportStartDate">
            <span class="date-separator">至</span>
            <input type="date" v-model="searchParams.reportEndDate">
          </div>
        </div>
        <div class="form-item">
          <label>装备名称：</label>
          <input type="text" v-model="searchParams.equipmentName" placeholder="请输入装备名称">
        </div>
      </div>
      <div style="display: flex; justify-content: flex-end;">
        <button class="btn-primary" @click="handleSearch" style="margin-right: 10px;">查询</button>
        <button class="btn-secondary" @click="handleReset">重置</button>
      </div>
    </div>

    <!-- 物流填报列表 -->
    <div class="table-section">
      <div class="table-card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
          <h3>物流填报列表</h3>
          <div class="action-buttons">
            <button class="btn-primary" @click="handleAdd" style="margin-right: 10px;">
              新增
            </button>
            <button class="btn-primary" @click="handleBatchDelete" :disabled="selectedRows.length === 0">
              删除
            </button>
          </div>
        </div>
        <div class="selected-info" v-if="selectedRows.length > 0">
          已选择 {{ selectedRows.length }} 条记录
        </div>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th width="40">
                  <input type="checkbox" v-model="selectAll" @change="handleSelectAll">
                </th>
                <th>订单号</th>
                <th>订单日期</th>
                <th>当前阶段</th>
                <th>物流状态</th>
                <th>是否延误</th>
                <th>延误时长（天）</th>
                <th>填报时间</th>
                <th>填报人</th>
                <th width="160">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in reportingTableData" :key="item.id">
                <td>
                  <input type="checkbox" v-model="selectedRows" :value="item.id">
                </td>
                <td>{{ item.orderNo }}</td>
                <td>{{ item.orderDate || '-' }}</td>
                <td>{{ getStageText(item.currentStage) }}</td>
                <td>
                  <span :class="getStatusClass(item.logisticsStatus)">
                    {{ getLogisticsStatusText(item.logisticsStatus) }}
                  </span>
                </td>
                <td>{{ item.isDelayed ? '是' : '否' }}</td>
                <td>{{ item.delayDays || 0 }}</td>
                <td>{{ item.reportTime }}</td>
                <td>{{ item.reporter }}</td>
                <td>
                    <div class="action-buttons-cell">
                      <button @click="handleEdit(item)" title="编辑">编辑</button>
                    </div>
                  </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- 新增/编辑弹窗 -->
    <div class="modal" v-if="showEditModal">
      <div class="modal-content" style="width: 1000px; max-height: 90vh;">
        <div class="modal-header" style="background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%); color: white;">
          <h3 style="color: white;">{{ editMode === 'add' ? '新增物流填报' : '编辑物流填报' }}</h3>
          <button class="close-btn" @click="showEditModal = false" style="color: white;">×</button>
        </div>
        <div class="modal-body">
          <form class="reporting-form">
            <!-- 订单信息 -->
            <div class="section-title">订单信息</div>
            <div class="form-row compact-row">
              <div class="form-group compact-group">
                <label class="required">订单号：</label>
                <input type="text" v-model="editForm.orderNo" class="form-control compact-control" placeholder="请输入订单号" required>
              </div>
              <div class="form-group compact-group">
                <label class="required">订单日期：</label>
                <input type="date" v-model="editForm.orderDate" class="form-control compact-control" required>
              </div>
            </div>

            <!-- 物资信息 -->
            <div class="section-title">物资信息</div>
            <div class="material-section">
              <div class="material-actions" style="display: flex; justify-content: flex-end;">
                <button type="button" class="btn-primary" @click="showMaterialSelector = true" style="background: #2563eb; border-color: #2563eb; margin-left: auto;">
                  新增
                </button>
                <button type="button" class="btn-primary" @click="removeSelectedMaterials" :disabled="selectedMaterialIds.length === 0" style="background: #2563eb; border-color: #2563eb; margin-left: 10px;">
                  删除
                </button>
              </div>
              
              <div class="material-table-container" style="margin-top: 16px;">
                <table class="material-table" style="width: 100%; border-collapse: collapse; border: 1px solid #e8e8e8;">
                  <thead>
                    <tr style="background: #f5f5f5;">
                      <th width="40" style="border: 1px solid #e8e8e8; padding: 8px; text-align: center;">
                        <input type="checkbox" v-model="selectAllMaterials" @change="handleSelectAllMaterials">
                      </th>
                      <th style="border: 1px solid #e8e8e8; padding: 8px; text-align: left;">供应商</th>
                      <th style="border: 1px solid #e8e8e8; padding: 8px; text-align: left;">装备编码</th>
                      <th style="border: 1px solid #e8e8e8; padding: 8px; text-align: left;">单位</th>
                      <th style="border: 1px solid #e8e8e8; padding: 8px; text-align: left;">型号</th>
                      <th style="border: 1px solid #e8e8e8; padding: 8px; text-align: left;">规格</th>
                      <th style="border: 1px solid #e8e8e8; padding: 8px; text-align: left;">数量</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="item in editForm.materials" :key="item.id" style="border-bottom: 1px solid #f0f0f0;">
                      <td style="border: 1px solid #e8e8e8; padding: 8px; text-align: center;">
                        <input type="checkbox" v-model="selectedMaterialIds" :value="item.id">
                      </td>
                      <td style="border: 1px solid #e8e8e8; padding: 8px;">{{ item.supplier }}</td>
                      <td style="border: 1px solid #e8e8e8; padding: 8px;">{{ item.equipmentCode }}</td>
                      <td style="border: 1px solid #e8e8e8; padding: 8px;">{{ item.unit }}</td>
                      <td style="border: 1px solid #e8e8e8; padding: 8px;">{{ item.model }}</td>
                      <td style="border: 1px solid #e8e8e8; padding: 8px;">{{ item.specification }}</td>
                      <td style="border: 1px solid #e8e8e8; padding: 8px;">
                        <input type="number" v-model="item.quantity" min="0" step="1" style="width: 80px; padding: 4px; border: 1px solid #ddd; border-radius: 3px;" placeholder="数量">
                      </td>
                    </tr>
                    <tr v-if="editForm.materials.length === 0">
                      <td colspan="7" style="text-align: center; color: #999; padding: 20px; border: 1px solid #e8e8e8;">
                        请点击"选择物资"按钮添加物资信息
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- 物流信息 -->
            <div class="section-title">物流信息</div>
            <div class="stage-section" style="background: #f8f9fa; border-radius: 8px; padding: 20px;">
              <div class="stage-grid" style="display: flex; flex-direction: column; gap: 16px;">
                <div class="stage-item" style="background: white; border-radius: 8px; padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                  <div class="stage-header" style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                    <div class="time-line-dot" :style="{ width: '14px', height: '14px', borderRadius: '50%', backgroundColor: getStageStatusColor(calculateStageStatus('production', editForm.stages.production)), flexShrink: 0 }"></div>
                    <div class="stage-name" style="font-size: 15px; font-weight: 600; color: #333;">生产阶段</div>
                    <span class="stage-status" :style="{ marginLeft: 'auto', fontSize: '12px', padding: '3px 8px', borderRadius: '4px', backgroundColor: getStatusBgColor(calculateStageStatus('production', editForm.stages.production)), color: 'white' }">
                      {{ getStageStatusText(calculateStageStatus('production', editForm.stages.production)) }}
                    </span>
                  </div>
                  <div class="form-row compact-row">
                      <div class="form-group compact-group" style="flex: 1; margin-right: 10px;">
                        <label class="required">计划时间：</label>
                        <input type="date" v-model="editForm.stages.production.planTime" class="form-control compact-control" required>
                      </div>
                      <div class="form-group compact-group" style="flex: 1;">
                        <label>实际时间：</label>
                        <input type="date" v-model="editForm.stages.production.actualTime" class="form-control compact-control" :disabled="isActualTimeDisabled('production')">
                      </div>
                    </div>
                </div>
                
                <div class="stage-item" style="background: white; border-radius: 8px; padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                  <div class="stage-header" style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                    <div class="time-line-dot" :style="{ width: '14px', height: '14px', borderRadius: '50%', backgroundColor: getStageStatusColor(calculateStageStatus('transport', editForm.stages.transport)), flexShrink: 0 }"></div>
                    <div class="stage-name" style="font-size: 15px; font-weight: 600; color: #333;">运输阶段</div>
                    <span class="stage-status" :style="{ marginLeft: 'auto', fontSize: '12px', padding: '3px 8px', borderRadius: '4px', backgroundColor: getStatusBgColor(calculateStageStatus('transport', editForm.stages.transport)), color: 'white' }">
                      {{ getStageStatusText(calculateStageStatus('transport', editForm.stages.transport)) }}
                    </span>
                  </div>
                  <div class="form-row compact-row">
                      <div class="form-group compact-group" style="flex: 1; margin-right: 10px;">
                        <label class="required">计划时间：</label>
                        <input type="date" v-model="editForm.stages.transport.planTime" class="form-control compact-control" required>
                      </div>
                      <div class="form-group compact-group" style="flex: 1;">
                        <label>实际时间：</label>
                        <input type="date" v-model="editForm.stages.transport.actualTime" class="form-control compact-control" :disabled="isActualTimeDisabled('transport')">
                      </div>
                    </div>
                </div>
                
                <div class="stage-item" style="background: white; border-radius: 8px; padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                  <div class="stage-header" style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                    <div class="time-line-dot" :style="{ width: '14px', height: '14px', borderRadius: '50%', backgroundColor: getStageStatusColor(calculateStageStatus('customs', editForm.stages.customs)), flexShrink: 0 }"></div>
                    <div class="stage-name" style="font-size: 15px; font-weight: 600; color: #333;">清关阶段</div>
                    <span class="stage-status" :style="{ marginLeft: 'auto', fontSize: '12px', padding: '3px 8px', borderRadius: '4px', backgroundColor: getStatusBgColor(calculateStageStatus('customs', editForm.stages.customs)), color: 'white' }">
                      {{ getStageStatusText(calculateStageStatus('customs', editForm.stages.customs)) }}
                    </span>
                  </div>
                  <div class="form-row compact-row">
                      <div class="form-group compact-group" style="flex: 1; margin-right: 10px;">
                        <label class="required">计划时间：</label>
                        <input type="date" v-model="editForm.stages.customs.planTime" class="form-control compact-control" required>
                      </div>
                      <div class="form-group compact-group" style="flex: 1;">
                        <label>实际时间：</label>
                        <input type="date" v-model="editForm.stages.customs.actualTime" class="form-control compact-control" :disabled="isActualTimeDisabled('customs')">
                      </div>
                    </div>
                </div>
                
                <div class="stage-item" style="background: white; border-radius: 8px; padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                  <div class="stage-header" style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                    <div class="time-line-dot" :style="{ width: '14px', height: '14px', borderRadius: '50%', backgroundColor: getStageStatusColor(calculateStageStatus('arrival', editForm.stages.arrival)), flexShrink: 0 }"></div>
                    <div class="stage-name" style="font-size: 15px; font-weight: 600; color: #333;">物资到场</div>
                    <span class="stage-status" :style="{ marginLeft: 'auto', fontSize: '12px', padding: '3px 8px', borderRadius: '4px', backgroundColor: getStatusBgColor(calculateStageStatus('arrival', editForm.stages.arrival)), color: 'white' }">
                      {{ getStageStatusText(calculateStageStatus('arrival', editForm.stages.arrival)) }}
                    </span>
                  </div>
                  <div class="form-row compact-row">
                      <div class="form-group compact-group" style="flex: 1; margin-right: 10px;">
                        <label class="required">计划时间：</label>
                        <input type="date" v-model="editForm.stages.arrival.planTime" class="form-control compact-control" required>
                      </div>
                      <div class="form-group compact-group" style="flex: 1;">
                        <label>实际时间：</label>
                        <input type="date" v-model="editForm.stages.arrival.actualTime" class="form-control compact-control" :disabled="isActualTimeDisabled('arrival')">
                      </div>
                    </div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer" style="display: flex; justify-content: center; gap: 15px;">
        <button type="button" class="btn-primary" @click="handleSubmit">保存</button>
        <button type="button" class="btn-secondary" @click="showEditModal = false">取消</button>
      </div>
      </div>
    </div>

    <!-- 物资选择弹窗 -->
    <div class="modal" v-if="showMaterialSelector">
      <div class="modal-content" style="width: 900px; max-height: 80vh;">
        <div class="modal-header">
          <h3>新增物资</h3>
          <button class="close-btn" @click="showMaterialSelector = false">×</button>
        </div>
        <div class="modal-body">
          <div class="material-form">
            <form class="material-info-form">
              <div class="form-row">
                <div class="form-group">
                  <label class="required">一级分类：</label>
                  <input type="text" v-model="newMaterial.category1" class="form-control" placeholder="请输入一级分类" required>
                </div>
                <div class="form-group">
                  <label class="required">二级分类：</label>
                  <input type="text" v-model="newMaterial.category2" class="form-control" placeholder="请输入二级分类" required>
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label class="required">装备名称：</label>
                  <input type="text" v-model="newMaterial.equipmentName" class="form-control" placeholder="请输入装备名称" required>
                </div>
                <div class="form-group">
                  <label class="required">供应商：</label>
                  <input type="text" v-model="newMaterial.supplier" class="form-control" placeholder="请输入供应商" required>
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label class="required">装备编码：</label>
                  <input type="text" v-model="newMaterial.equipmentCode" class="form-control" placeholder="请输入装备编码" required>
                </div>
                <div class="form-group">
                  <label class="required">单位：</label>
                  <input type="text" v-model="newMaterial.unit" class="form-control" placeholder="请输入单位" required>
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label>型号：</label>
                  <input type="text" v-model="newMaterial.model" class="form-control" placeholder="请输入型号">
                </div>
                <div class="form-group">
                  <label>规格：</label>
                  <input type="text" v-model="newMaterial.specification" class="form-control" placeholder="请输入规格">
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label class="required">数量：</label>
                  <input type="number" v-model="newMaterial.quantity" class="form-control" min="1" placeholder="请输入数量" required>
                </div>
              </div>
            </form>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn-secondary" @click="showMaterialSelector = false">取消</button>
          <button type="button" class="btn-primary" @click="confirmMaterialSelection">确认选择</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'LogisticsReporting',
  data() {
    return {
      // 搜索参数
      searchParams: {
        orderNo: '',
        orderStartDate: '',
        orderEndDate: '',
        currentStage: '',
        logisticsStatus: '',
        isDelayed: '',
        reportStartDate: '',
        reportEndDate: '',
        equipmentName: ''
      },
      // 物资选择相关
      showMaterialSelector: false,
      availableMaterials: [],
      tempSelectedMaterials: [],
      selectAllMaterials: false,
      selectedMaterialIds: [],
      selectAllAvailableMaterials: false,
      // 填报表格数据
      // 填报表格数据
      reportingTableData: [
        {
          id: 1,
          orderNo: 'ORD202410001',
          orderDate: '2024-10-20',
          reporter: '张三',
          reportTime: '2024-10-28 14:30',
          logisticsStatus: 'normal',
          currentStage: 'transport',
          isDelayed: false,
          delayDays: 0,
          materials: [{ equipmentName: '挖掘机' }]
        },
        {
          id: 2,
          orderNo: 'ORD202410002',
          orderDate: '2024-10-15',
          reporter: '李四',
          reportTime: '2024-10-28 10:15',
          logisticsStatus: 'delayed',
          currentStage: 'production',
          isDelayed: true,
          delayDays: 2,
          materials: [{ equipmentName: '装载机' }]
        },
        {
          id: 3,
          orderNo: 'ORD202410003',
          orderDate: '2024-10-18',
          reporter: '王五',
          reportTime: '2024-10-27 16:45',
          logisticsStatus: 'exception',
          currentStage: 'customs',
          isDelayed: true,
          delayDays: 3,
          materials: [{ equipmentName: '吊车' }]
        }
      ],
      // 表格选择
      selectedRows: [],
      selectAll: false,
      // 编辑弹窗
      showEditModal: false,
      editMode: 'add',
      editForm: {
        id: null,
        orderNo: '',
        orderDate: '',
        materials: [],
        stages: {
          production: { planTime: '', actualTime: '' },
          transport: { planTime: '', actualTime: '' },
          customs: { planTime: '', actualTime: '' },
          arrival: { planTime: '', actualTime: '' }
        },
        logisticsStatus: '',
        remark: '',
        attachments: []
      }
    }
  },
  methods: {
    // 搜索和重置
    handleSearch() {
      console.log('搜索参数:', this.searchParams)
      // 这里可以实现实际的搜索逻辑
    },
    handleReset() {
      this.searchParams = {
        orderNo: '',
        orderStartDate: '',
        orderEndDate: '',
        currentStage: '',
        logisticsStatus: '',
        isDelayed: '',
        reportStartDate: '',
        reportEndDate: '',
        equipmentName: ''
      }
    },
    // 表格选择
    handleSelectAll() {
      if (this.selectAll) {
        this.selectedRows = this.reportingTableData.map(item => item.id)
      } else {
        this.selectedRows = []
      }
    },
    // 新增填报
    handleAdd() {
      this.editMode = 'add'
      this.editForm = {
        id: null,
        orderNo: '',
        orderDate: '',
        materials: [],
        stages: {
          production: { planTime: '', actualTime: '' },
          transport: { planTime: '', actualTime: '' },
          customs: { planTime: '', actualTime: '' },
          arrival: { planTime: '', actualTime: '' }
        },
        logisticsStatus: '',
        remark: '',
        attachments: []
      }
      this.showEditModal = true
    },
    // 查看详情
    handleView(item) {
      console.log('查看详情:', item)
      // 这里可以实现查看详情的逻辑
    },
    // 编辑
    handleEdit(item) {
      this.editMode = 'edit'
      this.editForm = { 
        ...item, 
        attachments: [],
        stages: item.stages || {
          production: { planTime: '', actualTime: '' },
          transport: { planTime: '', actualTime: '' },
          customs: { planTime: '', actualTime: '' },
          arrival: { planTime: '', actualTime: '' }
        }
      }
      // 确保每个阶段都有实际时间属性
      Object.keys(this.editForm.stages).forEach(key => {
        if (!this.editForm.stages[key].actualTime) {
          this.editForm.stages[key].actualTime = ''
        }
      })
      this.showEditModal = true
    },
    // 删除
    handleDelete(item) {
      if (confirm(`确定要删除订单 ${item.orderNo} 的填报记录吗？`)) {
        const index = this.reportingTableData.findIndex(data => data.id === item.id)
        if (index > -1) {
          this.reportingTableData.splice(index, 1)
          this.$message?.success('删除成功')
        }
      }
    },
    // 批量删除
    handleBatchDelete() {
      if (this.selectedRows.length === 0) {
        alert('请选择要删除的记录')
        return
      }
      if (confirm(`确定要删除选中的 ${this.selectedRows.length} 条记录吗？`)) {
        this.reportingTableData = this.reportingTableData.filter(item => 
          !this.selectedRows.includes(item.id)
        )
        this.selectedRows = []
        this.selectAll = false
        this.$message?.success('批量删除成功')
      }
    },
    // 提交表单
    handleSubmit() {
      if (!this.editForm.orderNo) {
        alert('请填写订单号')
        return
      }
      if (!this.editForm.orderDate) {
        alert('请选择订单日期')
        return
      }
      if (!this.editForm.stages.production.planTime || !this.editForm.stages.transport.planTime ||
          !this.editForm.stages.customs.planTime || !this.editForm.stages.arrival.planTime) {
        alert('请填写各阶段计划时间')
        return
      }
      
      if (this.editMode === 'add') {
        // 新增
        const newReport = {
          ...this.editForm,
          id: Date.now(),
          reporter: '当前用户', // 实际应用中应该从用户信息获取
          reportTime: new Date().toLocaleString('zh-CN'),
          isDelayed: false,
          delayDays: 0
        }
        this.reportingTableData.unshift(newReport)
        this.$message?.success('新增填报成功')
      } else {
        // 编辑
        const index = this.reportingTableData.findIndex(item => item.id === this.editForm.id)
        if (index > -1) {
          this.reportingTableData[index] = { ...this.editForm }
          this.$message?.success('编辑填报成功')
        }
      }
      
      this.showEditModal = false
    },
    // 文件上传处理
    handleFileUpload(event) {
      const files = Array.from(event.target.files)
      this.editForm.attachments = [...this.editForm.attachments, ...files]
    },
    // 移除文件
    removeFile(index) {
      this.editForm.attachments.splice(index, 1)
    },
    // 状态文本转换
    getStageText(stage) {
      const stageMap = {
        'production': '生产阶段',
        'transport': '运输阶段',
        'customs': '清关阶段',
        'arrival': '物资到场',
        'pending': '待生产',
        'producing': '生产中',
        'transporting': '运输中',
        'arrived': '已到场',
        'completed': '已完成'
      }
      return stageMap[stage] || stage
    },
    getLogisticsStatusText(status) {
      const statusMap = {
        'normal': '正常',
        'delayed': '延误',
        'exception': '异常'
      }
      return statusMap[status] || status
    },
    getAuditStatusText(status) {
      const statusMap = {
        'pending': '待审核',
        'approved': '已审核',
        'rejected': '已拒绝'
      }
      return statusMap[status] || status
    },
    // 状态样式类
    getStatusClass(status) {
      return {
        'status-normal': status === 'normal',
        'status-delayed': status === 'delayed',
        'status-exception': status === 'exception'
      }
    },
    // 根据阶段顺序和完成情况计算阶段状态
     calculateStageStatus(stageName, stage) {
       const stageOrder = ['production', 'transport', 'customs', 'arrival']
       const currentIndex = stageOrder.indexOf(stageName)
       
       // 获取前一个阶段
       const hasPreviousStageCompleted = () => {
         // 生产阶段是第一个阶段，不需要前一个阶段完成
         if (currentIndex === 0) return true
         
         const prevStageName = stageOrder[currentIndex - 1]
         const prevStage = this.editForm.stages[prevStageName]
         // 前一个阶段必须有实际时间才视为完成
         return prevStage && prevStage.actualTime
       }
       
       // 获取所有阶段的完成状态，找到最后一个已完成的阶段
       const getLastCompletedStageIndex = () => {
         for (let i = stageOrder.length - 1; i >= 0; i--) {
           const stage = this.editForm.stages[stageOrder[i]]
           if (stage && stage.actualTime) {
             return i
           }
         }
         return -1 // 没有已完成的阶段
       }
       
       const lastCompletedIndex = getLastCompletedStageIndex()
       
       // 当前阶段有实际时间，视为已完成
       if (stage.actualTime) {
         // 判断是否延误
         if (stage.planTime) {
           const planDate = new Date(stage.planTime)
           const actualDate = new Date(stage.actualTime)
           return actualDate > planDate ? 'delayed' : 'completed'
         }
         return 'completed'
       }
       
       // 当前阶段是最后一个已完成阶段的下一个，且有计划时间，视为进行中
       if (currentIndex === lastCompletedIndex + 1 && stage.planTime && hasPreviousStageCompleted()) {
         return 'in_progress'
       }
       
       // 如果当前阶段在最后一个已完成阶段之前，且有计划时间但无实际时间，视为未完成（可能是数据不一致的情况）
       if (currentIndex <= lastCompletedIndex && stage.planTime && !stage.actualTime) {
         return 'pending'
       }
       
       // 其他情况为待开始
       return 'pending'
     },
    // 判断实际时间输入框是否禁用
      isActualTimeDisabled(stageName) {
        const stageOrder = ['production', 'transport', 'customs', 'arrival']
        const currentIndex = stageOrder.indexOf(stageName)
        
        // 生产阶段是第一个阶段，可以直接编辑实际时间
        if (currentIndex === 0) return false
        
        // 获取前一个阶段的实际时间
        const prevStageName = stageOrder[currentIndex - 1]
        const prevStageActualTime = this.editForm.stages[prevStageName]?.actualTime
        
        // 只有当前面阶段有实际时间时，才能编辑当前阶段的实际时间
        return !prevStageActualTime
      },
      // 获取阶段状态对应的颜色
      getStageStatusColor(status) {
        const colorMap = {
          'pending': '#d9d9d9',  // 灰色 - 待开始
          'in_progress': '#1890ff',  // 蓝色 - 进行中
          'completed': '#52c41a',  // 绿色 - 已完成
          'delayed': '#ff4d4f'  // 红色 - 已延误
        }
        return colorMap[status] || '#d9d9d9'
      },
    // 获取阶段状态文本
    getStageStatusText(status) {
      const textMap = {
        'pending': '待开始',
        'in_progress': '进行中',
        'completed': '已完成',
        'delayed': '已延误'
      }
      return textMap[status] || '待开始'
    },
    // 获取状态背景色
    getStatusBgColor(status) {
      const colorMap = {
        'pending': '#d9d9d9',
        'in_progress': '#1890ff',
        'completed': '#52c41a',
        'delayed': '#ff4d4f'
      }
      return colorMap[status] || '#d9d9d9'
    }
  },
  watch: {
    selectedRows(newVal) {
      this.selectAll = newVal.length === this.reportingTableData.length
    }
  }
}
</script>

<style scoped>
.logistics-reporting {
  padding: 20px;
}

/* 统计卡片样式 - 复用物流监控的样式 */
.stats-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  gap: 15px;
}

.stat-icon {
  font-size: 32px;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
}

.stat-icon.total { background: #e6f7ff; }
.stat-icon.pending { background: #fff2e8; }
.stat-icon.approved { background: #f6ffed; }
.stat-icon.rejected { background: #fff1f0; }

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #1890ff;
}

.stat-label {
  color: #666;
  font-size: 14px;
}

/* 搜索区域样式 - 复用物流监控的样式 */
.search-area {
  background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
  padding: 24px;
  border-radius: 12px;
  margin-bottom: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.2);
  position: relative;
}

.search-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  align-items: center;
}

.form-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.form-item label {
  font-weight: 500;
  color: #333;
  white-space: nowrap;
  min-width: 80px;
}

.form-item input,
.form-item select {
  flex: 1;
  padding: 10px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
}

.date-inputs {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
}

.date-inputs input {
  flex: 1;
}

.date-separator {
  color: #666;
}

.button-group-far-right {
  display: flex;
  gap: 12px;
  align-items: center;
  position: absolute;
  right: 24px;
  top: calc(50% + 40px);
  transform: translateY(-50%);
}

/* 操作栏样式 */
.action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 16px 20px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.action-buttons {
  display: flex;
  gap: 12px;
}

.action-buttons button {
  padding: 8px 16px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.btn-success {
  background: linear-gradient(135deg, #52c41a 0%, #389e0d 100%);
  color: white;
}

.btn-danger {
  background: linear-gradient(135deg, #f5222d 0%, #cf1322 100%);
  color: white;
}

.btn-danger:disabled {
  background: #d9d9d9;
  cursor: not-allowed;
}

.selected-info {
  color: #1890ff;
  font-weight: 500;
}

/* 表格样式 - 复用物流监控的样式 */
.table-section {
  margin-bottom: 20px;
}

.table-card {
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.table-card h3 {
  margin-bottom: 20px;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.table-container {
  overflow-x: auto;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(24, 144, 255, 0.1);
}

.data-table {
  font-size: 14px;
  table-layout: fixed;
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: white;
  border-radius: 12px;
  overflow: hidden;
}

.data-table th,
.data-table td {
  padding: 12px 16px;
  line-height: 1.5;
  text-align: center;
  border-bottom: 1px solid rgba(240, 240, 240, 0.8);
}

.data-table th {
  background: #1890ff;
  color: white;
  font-weight: 600;
  position: sticky;
  top: 0;
  z-index: 10;
}

.data-table tbody tr:hover {
  background: linear-gradient(135deg, #f8f9fa 0%, #e6f7ff 100%);
}

/* 状态标签样式 */
.status-normal {
  color: #52c41a;
  font-weight: 600;
}

.status-delayed {
  color: #faad14;
  font-weight: 600;
}

.status-exception {
  color: #f5222d;
  font-weight: 600;
}

.status-pending {
  color: #faad14;
  font-weight: 600;
}

.status-approved {
  color: #52c41a;
  font-weight: 600;
}

.status-rejected {
  color: #f5222d;
  font-weight: 600;
}

/* 操作按钮样式 */
.action-buttons-cell {
  display: flex;
  gap: 8px;
  justify-content: center;
  padding: 4px 0;
}

.action-buttons-cell button {
  background-color: #1890ff;
  color: white;
  border: none;
  padding: 4px 12px;
  cursor: pointer;
  font-size: 14px;
  border-radius: 4px;
  white-space: nowrap;
  min-width: 50px;
  text-align: center;
}

.action-buttons-cell button:hover {
  background-color: #40a9ff;
}

/* 修复复选框后面的点点问题 */
table th:first-child,
table td:first-child {
  overflow: hidden;
  text-overflow: clip;
  white-space: nowrap;
}
table th:first-child input[type="checkbox"],
table td:first-child input[type="checkbox"] {
  margin: 0;
  padding: 0;
  vertical-align: middle;
}
/* 确保 th 内容不会产生多余的点点 */
table th {
  overflow: hidden;
  text-overflow: clip;
  white-space: nowrap;
}

.btn-view {
  color: #1890ff;
}

.btn-edit {
  color: #52c41a;
}

.btn-delete {
  color: #f5222d;
}

.btn-view:hover,
.btn-edit:hover,
.btn-delete:hover {
  background: rgba(24, 144, 255, 0.1);
}

/* 备注文本样式 */
.remark-text {
  max-width: 150px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  display: inline-block;
}

/* 弹窗样式 */
  .modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }

  .modal-content {
    background: white;
    border-radius: 8px;
    max-height: 85vh;
    overflow-y: auto;
    scrollbar-width: none; /* Firefox */
    -ms-overflow-style: none; /* IE and Edge */
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    width: 900px; /* 增大弹窗宽度 */
  }
  
  /* Chrome, Safari and Opera */
  .modal-content::-webkit-scrollbar {
    display: none;
  }
  
  /* 隐藏滚动条但保持滚动功能 */
  .modal-body {
    padding: 0;
    overflow-y: auto;
    scrollbar-width: none; /* Firefox */
    -ms-overflow-style: none; /* IE and Edge */
  }
  
  /* Chrome, Safari and Opera */
  .modal-body::-webkit-scrollbar {
    display: none;
  }
  
  .reporting-form {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 20px;
    overflow: visible;
  }
  
  .stage-section,
  .stage-grid {
    overflow: visible;
  }

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #e8e8e8;
  background: linear-gradient(135deg, #f8f9fa 0%, #e6f7ff 100%);
}

.modal-header h3 {
  margin: 0;
  color: #1890ff;
  font-weight: 600;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #666;
}

.modal-body {
  padding: 20px;
}

.modal-footer {
  padding: 16px 20px;
  border-top: 1px solid #e8e8e8;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* 表单样式 */
.reporting-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
  overflow: hidden;
}

.form-row {
  display: flex;
  gap: 20px;
}

.form-group {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-weight: 500;
  color: #333;
}

.form-group label.required::before {
  content: '*';
  color: #f5222d;
  margin-right: 4px;
}

.form-control {
  padding: 10px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
}

.form-control:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
}

/* 紧凑表单样式 */
.compact-row {
  gap: 30px;
  align-items: center;
}

.compact-group {
  flex-direction: row;
  align-items: center;
  gap: 12px;
}

.compact-group label {
  white-space: nowrap;
  min-width: 90px;
  font-size: 15px;
  font-weight: 500;
}

.compact-control {
  padding: 10px 14px;
  font-size: 15px;
  height: 40px;
  border-radius: 6px;
  width: 100%;
  max-width: 350px;
}

.compact-control[type="date"] {
  min-width: 220px;
  width: 220px;
}

textarea.form-control {
  resize: vertical;
  min-height: 80px;
}

/* 文件列表样式 */
.file-list {
  margin-top: 8px;
}

.file-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  background: #f5f5f5;
  border-radius: 4px;
  margin-bottom: 4px;
}

.btn-remove-file {
  background: #f5222d;
  color: white;
  border: none;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .stats-cards {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .search-grid {
    grid-template-columns: 1fr;
  }
  
  .form-row {
    flex-direction: column;
  }
  
  .button-group-far-right {
    position: static;
    margin-top: 16px;
    justify-content: flex-end;
  }
  
  .action-bar {
    flex-direction: column;
    gap: 12px;
  }
}
</style>