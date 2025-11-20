<template>
  <div class="logistics-monitoring">
    <!-- 顶部统计卡片 -->
    <div class="stats-cards">
      <div class="stat-card">
        <div class="stat-icon total">📦</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats.totalOrders }}</div>
          <div class="stat-label">总订单数</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon in-progress">🚚</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats.inProgress }}</div>
          <div class="stat-label">进行中</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon delayed">⚠️</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats.delayed }}</div>
          <div class="stat-label">延误订单</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon completed">✅</div>
        <div class="stat-content">
          <div class="stat-value">{{ stats.completed }}</div>
          <div class="stat-label">已完成</div>
        </div>
      </div>
    </div>

    <!-- 搜索和筛选区域 -->
    <div class="search-area">
      <div class="search-grid" style="grid-template-columns: repeat(3, 1fr);">
        <div class="form-item">
          <label>项目名称：</label>
          <select v-model="searchParams.projectName" style="width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #d9d9d9;" @focus="showProjectOptions = true" @blur="showProjectOptions = false">
            <option value="">请选择或搜索项目名称</option>
            <option v-for="project in filteredProjects" :key="project.id" :value="project.name">{{ project.name }}</option>
          </select>
        </div>
        <div class="form-item">
          <label>订单编号：</label>
          <input type="text" v-model="searchParams.orderNo" placeholder="请输入订单编号">
        </div>
        <div class="form-item">
          <label>物料名称：</label>
          <input type="text" v-model="searchParams.materialName" placeholder="请输入物料名称">
        </div>
        <div class="form-item">
          <label>状态：</label>
          <select v-model="searchParams.status">
            <option value="">全部</option>
            <option value="pending">待生产</option>
            <option value="producing">生产中</option>
            <option value="transporting">运输中</option>
            <option value="customs">清关中</option>
            <option value="arrived">已到场</option>
            <option value="completed">已完成</option>
            <option value="delayed">已延误</option>
          </select>
        </div>
        <div class="form-item date-range-item">
          <label>时间范围：</label>
          <div class="date-inputs">
            <input type="date" v-model="searchParams.startDate">
            <span class="date-separator">至</span>
            <input type="date" v-model="searchParams.endDate">
          </div>
        </div>
      </div>
      <div class="button-group-far-right">
        <button class="btn-primary" @click="handleSearch">查询</button>
        <button class="btn-secondary" @click="handleReset">重置</button>
      </div>
    </div>

    <!-- 物流详情表格 -->
    <div class="table-section">
      <div class="table-card">
        <h3>物流详情</h3>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th width="120">项目</th>
                <th width="100">订单号</th>
                <th width="90">日期</th>
                <th width="100">供应商</th>
                <th width="90">阶段</th>
                <th width="60">延误</th>
                <th width="80">时长（天）</th>
                <th width="70">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="item in logisticsTableData" :key="item.id">
                <td>{{ item.projectName }}</td>
                <td>{{ item.orderNo }}</td>
                <td>{{ item.orderDate }}</td>
                <td>{{ item.supplier }}</td>
                <td>
                  {{ getStageText(item.currentStage) }}
                </td>
                <td>
                  <span v-if="getDelayStatusText(item) === '是'" style="color: #f5222d; font-weight: 600;">
                    是
                  </span>
                  <span v-else style="color: #52c41a; font-weight: 600;">
                    否
                  </span>
                </td>
                <td>
                  <span v-if="getDelayStatusText(item) === '是'" style="color: #f5222d; font-weight: 600;">
                    1
                  </span>
                  <span v-else>
                    <!-- 不延误的不显示内容 -->
                  </span>
                </td>
                <td>
                  <button class="btn-view-detail" @click="viewTimeDetail(item)">
                    详情
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- 异常预警弹窗 -->
    <div class="modal" v-if="showDetailModal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>订单详情 - {{ selectedOrder.orderNo }}</h3>
          <button class="close-btn" @click="showDetailModal = false">×</button>
        </div>
        <div class="modal-body">
          <div class="detail-section">
            <h4>基本信息</h4>
            <div class="detail-grid">
              <div class="detail-item">
                <label>物料名称：</label>
                <span>{{ selectedOrder.materialName }}</span>
              </div>
              <div class="detail-item">
                <label>数量：</label>
                <span>{{ selectedOrder.quantity }} {{ selectedOrder.unit }}</span>
              </div>
              <div class="detail-item">
                <label>计划完成时间：</label>
                <span>{{ selectedOrder.planCompleteTime }}</span>
              </div>
              <div class="detail-item">
                <label>当前状态：</label>
                <span :class="selectedOrder.status">{{ getStatusText(selectedOrder.status) }}</span>
              </div>
            </div>
          </div>
          
          <div class="detail-section">
            <h4>异常信息</h4>
            <div class="exception-list" v-if="selectedOrder.exceptions.length > 0">
              <div class="exception-item" v-for="exception in selectedOrder.exceptions" :key="exception.id">
                <div class="exception-type" :class="exception.type">{{ exception.typeText }}</div>
                <div class="exception-desc">{{ exception.description }}</div>
                <div class="exception-time">{{ exception.time }}</div>
              </div>
            </div>
            <div v-else class="no-exception">暂无异常信息</div>
          </div>
          
          <div class="detail-section">
            <h4>GPS轨迹</h4>
            <div class="gps-map">
              <!-- 这里可以集成地图组件 -->
              <div class="map-placeholder">
                <div class="route-info">
                  <div class="route-point">
                    <span class="point-label">起点：</span>
                    <span>{{ selectedOrder.route.startPoint }}</span>
                  </div>
                  <div class="route-point">
                    <span class="point-label">终点：</span>
                    <span>{{ selectedOrder.route.endPoint }}</span>
                  </div>
                  <div class="route-deviation" v-if="selectedOrder.route.deviation > 0">
                    <span class="deviation-warning">路线偏差：{{ selectedOrder.route.deviation }}km</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 物流详情弹窗 -->
    <div class="modal" v-if="showTimeDetailModal">
      <div class="modal-content time-detail-modal" style="max-height: 85vh; width: 1200px;">
        <div class="modal-header" style="background: #1890ff;">
          <h3 style="color: white; margin: 0; font-size: 20px; font-weight: 600;">物流详情 - {{ selectedTimeDetail.orderNo }}</h3>
          <button class="close-btn" style="color: white;" @click="showTimeDetailModal = false">×</button>
        </div>
        <div class="modal-body" style="padding: 20px;">
          
          <!-- 第一部分：基本信息 -->
          <div class="section-card" style="margin-bottom: 24px;">
            <div class="section-header" style="display: flex; align-items: center; gap: 8px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #1890ff;">
              <div style="width: 4px; height: 20px; background: #1890ff; border-radius: 2px;"></div>
              <h4 style="margin: 0; font-size: 18px; font-weight: 700; color: #1890ff;">基本信息</h4>
            </div>
            <div class="basic-info-grid" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px;">
              <div class="info-item" style="display: flex; align-items: center; gap: 12px; padding: 12px; background: #f8f9fa; border-radius: 8px;">
                <label style="font-weight: 700; color: #1890ff; min-width: 80px; font-size: 14px;">项目名称：</label>
                <span style="font-weight: 600; color: #333; font-size: 14px;">{{ selectedTimeDetail.projectName }}</span>
              </div>
              <div class="info-item" style="display: flex; align-items: center; gap: 12px; padding: 12px; background: #f8f9fa; border-radius: 8px;">
                <label style="font-weight: 700; color: #1890ff; min-width: 80px; font-size: 14px;">订单号：</label>
                <span style="font-weight: 600; color: #333; font-size: 14px;">{{ selectedTimeDetail.orderNo }}</span>
              </div>
              <div class="info-item" style="display: flex; align-items: center; gap: 12px; padding: 12px; background: #f8f9fa; border-radius: 8px;">
                <label style="font-weight: 700; color: #1890ff; min-width: 80px; font-size: 14px;">订单日期：</label>
                <span style="font-weight: 600; color: #333; font-size: 14px;">{{ selectedTimeDetail.orderDate || '2024-10-30' }}</span>
              </div>
              <div class="info-item" style="display: flex; align-items: center; gap: 12px; padding: 12px; background: #f8f9fa; border-radius: 8px;">
                <label style="font-weight: 700; color: #1890ff; min-width: 80px; font-size: 14px;">供应商：</label>
                <span style="font-weight: 600; color: #333; font-size: 14px;">{{ selectedTimeDetail.supplier || '北京物资供应公司' }}</span>
              </div>
            </div>
          </div>
          
          <!-- 第二部分：物资信息 -->
          <div class="section-card" style="margin-bottom: 24px;">
            <div class="section-header" style="display: flex; align-items: center; gap: 8px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #52c41a;">
              <div style="width: 4px; height: 20px; background: #52c41a; border-radius: 2px;"></div>
              <h4 style="margin: 0; font-size: 18px; font-weight: 700; color: #52c41a;">物资信息</h4>
            </div>
            <div class="material-table-container" style="overflow-x: auto;">
              <table class="material-table" style="width: 100%; border-collapse: collapse; border: 1px solid #e8e8e8; border-radius: 0; overflow: hidden;">
                <thead>
                  <tr style="background: #f5f5f5;">
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">一级分类</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">二级分类</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">三级分类</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">四级分类</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">物资装备</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">物资装备编码</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">单位</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">规格</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">型号</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">数量</th>
                    <th style="padding: 12px; text-align: center; border: 1px solid #e8e8e8; font-weight: 700; color: #333;">操作</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(material, index) in selectedTimeDetail.materials" :key="index" 
                      :style="{ 
                        'border-bottom': '1px solid #f0f0f0', 
                        'background': currentSelectedMaterial === material ? '#f0f8ff' : 'white' 
                      }">
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.level1 || '机械设备' }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.level2 || '起重设备' }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.level3 || '塔式起重机' }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.level4 || 'QTZ80型' }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.equipmentName || selectedTimeDetail.equipmentName }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.equipmentCode || selectedTimeDetail.equipmentCode }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.unit || selectedTimeDetail.unit }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.specification || selectedTimeDetail.specification }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.model || selectedTimeDetail.model }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">{{ material.quantity || 1 }}</td>
                    <td style="padding: 12px; text-align: center; border: 1px solid #e8e8e8;">
                      <button class="btn-view-progress" @click="viewMaterialProgress(material)" 
                              :style="{ 
                                'background': currentSelectedMaterial === material ? '#1890ff' : '#bfbfbf', 
                                'color': 'white', 
                                'border': 'none', 
                                'padding': '6px 12px', 
                                'border-radius': '4px', 
                                'cursor': 'pointer', 
                                'font-size': '12px',
                                'font-weight': currentSelectedMaterial === material ? '700' : '400'
                              }">
                        {{ currentSelectedMaterial === material ? '当前查看' : '查看进度' }}
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          
          <!-- 第三部分：进度情况 -->
          <div class="section-card">
            <div class="section-header" style="display: flex; align-items: center; gap: 8px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #faad14;">
              <div style="width: 4px; height: 20px; background: #faad14; border-radius: 2px;"></div>
              <h4 style="margin: 0; font-size: 18px; font-weight: 700; color: #faad14;">进度情况</h4>
              <span v-if="currentSelectedMaterial" style="font-size: 14px; color: #1890ff; font-weight: 600; margin-left: auto;">
                当前查看：{{ currentSelectedMaterial.equipmentName || selectedTimeDetail.equipmentName }} - {{ currentSelectedMaterial.equipmentCode || selectedTimeDetail.equipmentCode }}
              </span>
            </div>
            <div class="progress-container" v-if="currentSelectedMaterial" style="background: white; border-radius: 12px; padding: 20px; border: 1px solid #e8e8e8; box-shadow: 0 4px 16px rgba(0,0,0,0.08);">
              <div class="material-title" style="font-size: 18px; font-weight: 700; color: #1890ff; margin-bottom: 20px; border-bottom: 2px solid #f0f0f0; padding-bottom: 12px;">
                {{ currentSelectedMaterial.equipmentName || selectedTimeDetail.equipmentName }} - {{ currentSelectedMaterial.equipmentCode || selectedTimeDetail.equipmentCode }}
              </div>
              <div class="time-line-container" style="display: flex; flex-direction: column; gap: 24px;">
                <div class="time-line-item" v-for="(stage, stageIndex) in currentSelectedMaterial.stages" :key="stageIndex"
                     style="background: white; border-radius: 12px; padding: 20px 24px; border-left: 8px solid #e8e8e8; position: relative; box-shadow: 0 4px 12px rgba(0,0,0,0.08);">
                  <div class="stage-header" style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
                    <div class="time-line-dot" :class="stage.status"
                         style="width: 20px; height: 20px; border-radius: 50%; flex-shrink: 0; position: absolute; left: 4px; top: 20px; z-index: 10;"></div>
                    <div class="stage-name" style="font-size: 18px; font-weight: 700; color: #333; margin-left: 32px;">{{ stage.name }}</div>
                    <div class="stage-status" :class="stage.status"
                         style="padding: 6px 16px; border-radius: 16px; font-size: 14px; font-weight: 700; margin-left: auto;">
                      {{ getStageStatusText(stage.status) }}
                    </div>
                  </div>
                  
                  <div class="time-info" style="margin-left: 52px; display: flex; flex-direction: column; gap: 12px;">
                    <div class="time-row" style="display: flex; gap: 32px; align-items: center; flex-wrap: wrap;">
                      <div class="plan-time" style="display: flex; align-items: center; gap: 12px;">
                        <label style="font-size: 16px; color: #666; font-weight: 600;">计划：</label>
                        <span style="font-size: 16px; font-weight: 600; color: #333;">{{ stage.planTime || '未设置' }}</span>
                      </div>
                      <div class="actual-time" style="display: flex; align-items: center; gap: 12px;">
                        <label style="font-size: 16px; color: #666; font-weight: 600;">实际：</label>
                        <span style="font-size: 16px; font-weight: 600;" :class="getTimeValueClass(stage.status, stage.actualTime)">
                          {{ getActualTimeText(stage.actualTime, stage.status) }}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-else style="text-align: center; padding: 40px; color: #999;">
              请点击物资信息中的"查看进度"按钮查看具体物资的进度情况
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { use } from 'echarts/core'
import { CanvasRenderer } from 'echarts/renderers'
import { PieChart, BarChart, LineChart } from 'echarts/charts'
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from 'echarts/components'
import VChart from 'vue-echarts'

use([
  CanvasRenderer,
  PieChart,
  BarChart,
  LineChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

export default {
  name: 'LogisticsMonitoring',
  components: {
    VChart
  },
  data() {
    return {
      stats: {
        totalOrders: 156,
        inProgress: 89,
        delayed: 23,
        completed: 44
      },
      searchInput: '',
      showProjectOptions: false,
      projects: [
        { id: 1, name: '智慧城市项目' },
        { id: 2, name: '数字工厂建设' },
        { id: 3, name: '智能交通系统' },
        { id: 4, name: '医疗信息化改造' },
        { id: 5, name: '金融数据中心' }
      ],
      searchParams: {
        projectName: '',
        orderNo: '',
        materialName: '',
        status: '',
        startDate: '',
        endDate: ''
      },
      monitoringData: [],
      logisticsTableData: [],
      showDetailModal: false,
      selectedOrder: {
        orderNo: '',
        materialName: '',
        quantity: 0,
        unit: '',
        status: '',
        planCompleteTime: '',
        exceptions: [],
        route: {
          startPoint: '',
          endPoint: '',
          deviation: 0
        }
      },
      progressChartOption: {},
      showTimeDetailModal: false,
      selectedTimeDetail: {
        orderNo: '',
        projectName: '',
        orderDate: '',
        supplier: '',
        equipmentName: '',
        equipmentCode: '',
        unit: '',
        model: '',
        specification: '',
        materials: [],
        stages: []
      },
      currentSelectedMaterial: null
    }
  },
  mounted() {
    this.initData()
    this.initChart()
  },
  methods: {
    initData() {
      // 模拟数据
      this.monitoringData = [
        {
          id: 1,
          orderNo: 'WL20241023001',
          materialName: '钢材',
          quantity: 500,
          unit: '吨',
          status: 'transporting',
          planCompleteTime: '2024-10-25 18:00',
          timeline: [
            { name: '生产完成', time: '2024-10-20 15:30', completed: true },
            { name: '运输开始', time: '2024-10-21 09:00', completed: true },
            { name: '清关完成', time: '2024-10-22 14:20', completed: true },
            { name: '预计到场', time: '2024-10-24 16:00', completed: false, delayed: true, delayHours: 12 }
          ],
          exceptions: [
            { id: 1, type: 'delay', typeText: '运输延误', description: '因天气原因，运输车辆延误12小时', time: '2024-10-23 10:30' }
          ],
          route: {
            startPoint: '上海工厂',
            endPoint: '北京仓库',
            deviation: 5.2
          }
        },
        {
          id: 2,
          orderNo: 'WL20241023002',
          materialName: '水泥',
          quantity: 200,
          unit: '吨',
          status: 'customs',
          planCompleteTime: '2024-10-26 12:00',
          timeline: [
            { name: '生产完成', time: '2024-10-21 10:15', completed: true },
            { name: '运输开始', time: '2024-10-22 08:30', completed: true },
            { name: '清关中', time: '2024-10-23 09:00', completed: false },
            { name: '预计到场', time: '2024-10-25 14:00', completed: false }
          ],
          exceptions: [],
          route: {
            startPoint: '广州工厂',
            endPoint: '深圳港口',
            deviation: 0
          }
        }
      ]

      // 模拟数据 - 物流详情表格数据
      this.logisticsTableData = [
        {
          id: 1,
          projectName: '北京地铁建设项目',
          orderNo: 'WL20241023001',
          orderDate: '2024-10-15',
          materialCategory1: '金属材料',
          materialCategory2: '建筑钢材',
          equipmentName: '螺纹钢',
          equipmentCode: 'STEEL-001',
          unit: '吨',
          model: 'HRB400',
          specification: 'Φ16mm',
          supplier: '宝钢集团',
          currentStage: 'transporting',
          productionPlanTime: '2024-10-20',
          productionActualTime: '2024-10-20',
          transportPlanTime: '2024-10-25',
          transportActualTime: '2024-10-26',
          customsPlanTime: '2024-10-28',
          customsActualTime: '',
          arrivalPlanTime: '2024-10-30',
          arrivalActualTime: ''
        },
        {
          id: 2,
          projectName: '上海港口扩建项目',
          orderNo: 'WL20241023002',
          orderDate: '2024-10-16',
          materialCategory1: '建筑材料',
          materialCategory2: '水泥材料',
          equipmentName: '普通硅酸盐水泥',
          equipmentCode: 'CEMENT-001',
          unit: '吨',
          model: 'P.O 42.5',
          specification: '散装',
          supplier: '海螺水泥',
          currentStage: 'customs',
          productionPlanTime: '2024-10-21',
          productionActualTime: '2024-10-21',
          transportPlanTime: '2024-10-24',
          transportActualTime: '2024-10-24',
          customsPlanTime: '2024-10-26',
          customsActualTime: '2024-10-26',
          arrivalPlanTime: '2024-10-28',
          arrivalActualTime: ''
        },
        {
          id: 3,
          projectName: '深圳科技园项目',
          orderNo: 'WL20241023003',
          orderDate: '2024-10-17',
          materialCategory1: '电气设备',
          materialCategory2: '配电设备',
          equipmentName: '配电箱',
          equipmentCode: 'ELECTRIC-001',
          unit: '套',
          model: 'XL-21',
          specification: '1000A',
          supplier: '正泰电气',
          currentStage: 'producing',
          productionPlanTime: '2024-10-28',
          productionActualTime: '',
          transportPlanTime: '2024-11-02',
          transportActualTime: '',
          customsPlanTime: '2024-11-05',
          customsActualTime: '',
          arrivalPlanTime: '2024-11-08',
          arrivalActualTime: ''
        },
        {
          id: 4,
          projectName: '广州机场扩建项目',
          orderNo: 'WL20241023004',
          orderDate: '2024-10-18',
          materialCategory1: '管道材料',
          materialCategory2: '钢管',
          equipmentName: '无缝钢管',
          equipmentCode: 'PIPE-001',
          unit: '米',
          model: '20#',
          specification: 'Φ108×4mm',
          supplier: '天津钢管',
          currentStage: 'arrived',
          productionPlanTime: '2024-10-22',
          productionActualTime: '2024-10-22',
          transportPlanTime: '2024-10-25',
          transportActualTime: '2024-10-25',
          customsPlanTime: '2024-10-27',
          customsActualTime: '2024-10-27',
          arrivalPlanTime: '2024-10-29',
          arrivalActualTime: '2024-10-29'
        }
      ]
    },
    initChart() {
      this.progressChartOption = {
        title: {
          text: '物料计划进度分析',
          left: 'center',
          top: 20,
          textStyle: {
            fontSize: 18,
            fontWeight: 'bold',
            color: '#333'
          }
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        legend: {
          data: ['计划数量', '完成数量', '完成率'],
          top: 60,
          left: 'center',
          textStyle: {
            fontSize: 12,
            color: '#666'
          },
          itemGap: 20
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '10%',
          top: '25%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: ['钢材', '水泥', '管材', '阀门', '泵类', '电气设备']
        },
        yAxis: [
          {
            type: 'value',
            name: '数量(吨)'
          },
          {
            type: 'value',
            name: '完成率(%)',
            min: 0,
            max: 100,
            axisLabel: {
              formatter: '{value}%'
            }
          }
        ],
        series: [
          {
            name: '计划数量',
            type: 'bar',
            data: [320, 200, 150, 80, 60, 120],
            itemStyle: {
              color: '#1890ff'
            }
          },
          {
            name: '完成数量',
            type: 'bar',
            data: [280, 180, 120, 65, 45, 95],
            itemStyle: {
              color: '#52c41a'
            }
          },
          {
            name: '完成率',
            type: 'line',
            yAxisIndex: 1,
            data: [87.5, 90, 80, 81.3, 75, 79.2],
            itemStyle: {
              color: '#faad14'
            }
          }
        ]
      }
    },
    getStatusText(status) {
      const statusMap = {
        pending: '待生产',
        producing: '生产中',
        transporting: '运输中',
        customs: '清关中',
        arrived: '已到场',
        completed: '已完成',
        delayed: '已延误'
      }
      return statusMap[status] || '未知'
    },
    getStageText(stage) {
      const stageMap = {
        pending: '待生产',
        producing: '生产中',
        transporting: '运输中',
        customs: '清关中',
        arrived: '已到场',
        completed: '已完成',
        delayed: '已延误'
      }
      return stageMap[stage] || '未知'
    },
    getStatusClass(stage) {
      const classMap = {
        pending: 'status-pending',
        producing: 'status-producing',
        transporting: 'status-transporting',
        customs: 'status-customs',
        arrived: 'status-arrived',
        completed: 'status-completed',
        delayed: 'status-delayed'
      }
      return classMap[stage] || ''
    },
    handleSearch() {
      // 搜索逻辑
      console.log('搜索参数:', this.searchParams)
    },
    handleReset() {
      this.searchParams = {
        orderNo: '',
        materialName: '',
        status: '',
        startDate: '',
        endDate: ''
      }
    },
    viewDetail(order) {
      this.selectedOrder = order
      this.showDetailModal = true
    },
    viewTimeDetail(item) {
      // 构建阶段时间数据
      const stages = [
        {
          name: '生产阶段',
          planTime: item.productionPlanTime,
          actualTime: item.productionActualTime,
          status: this.getStageStatus(item.productionActualTime, item.productionPlanTime, item.currentStage, 'producing')
        },
        {
          name: '运输阶段',
          planTime: item.transportPlanTime,
          actualTime: item.transportActualTime,
          status: this.getStageStatus(item.transportActualTime, item.transportPlanTime, item.currentStage, 'transporting')
        },
        {
          name: '清关阶段',
          planTime: item.customsPlanTime,
          actualTime: item.customsActualTime,
          status: this.getStageStatus(item.customsActualTime, item.customsPlanTime, item.currentStage, 'customs')
        },
        {
          name: '物资到场',
          planTime: item.arrivalPlanTime,
          actualTime: item.arrivalActualTime,
          status: this.getStageStatus(item.arrivalActualTime, item.arrivalPlanTime, item.currentStage, 'arrived')
        }
      ]
      
      this.selectedTimeDetail = {
        orderNo: item.orderNo,
        projectName: item.projectName,
        orderDate: '2024-10-30',
        supplier: '北京物资供应公司',
        equipmentName: item.equipmentName,
        equipmentCode: item.equipmentCode,
        unit: item.unit,
        model: item.model,
        specification: item.specification,
        materials: [
          {
            level1: '机械设备',
            level2: '起重设备',
            level3: '塔式起重机',
            level4: 'QTZ80型',
            equipmentName: item.equipmentName,
            equipmentCode: item.equipmentCode,
            unit: item.unit,
            specification: item.specification,
            model: item.model,
            quantity: 1,
            stages: stages
          },
          {
            level1: '电气设备',
            level2: '配电设备',
            level3: '变压器',
            level4: '干式变压器',
            equipmentName: '干式变压器',
            equipmentCode: 'DQ2024103001',
            unit: '台',
            specification: 'SCB10-1000/10',
            model: 'SCB10',
            quantity: 2,
            stages: [
              {
                name: '生产中',
                status: 'completed',
                planTime: '2024-10-25',
                actualTime: '2024-10-25'
              },
              {
                name: '运输中',
                status: 'in-progress',
                planTime: '2024-10-28',
                actualTime: ''
              },
              {
                name: '清关中',
                status: 'not-started',
                planTime: '2024-11-02',
                actualTime: ''
              },
              {
                name: '已到场',
                status: 'not-started',
                planTime: '2024-11-05',
                actualTime: ''
              }
            ]
          }
        ],
        stages: stages
      }
      // 设置默认选中的物资为第一个物资
      this.currentSelectedMaterial = this.selectedTimeDetail.materials[0]
      this.showTimeDetailModal = true
    },
    viewMaterialProgress(material) {
      // 切换当前选中的物资
      this.currentSelectedMaterial = material
      console.log('查看物资进度:', material)
    },
    getStageStatus(actualTime, planTime, currentStage, stageType) {
      if (!actualTime) {
        // 检查是否未开始
        const stageOrder = ['producing', 'transporting', 'customs', 'arrived']
        const currentIndex = stageOrder.indexOf(currentStage)
        const stageIndex = stageOrder.indexOf(stageType)
        
        if (currentIndex < stageIndex) {
          return 'not-started'
        } else if (currentIndex === stageIndex) {
          return 'in-progress'
        }
      }
      
      // 检查是否延误
      if (actualTime && planTime) {
        const actualDate = new Date(actualTime)
        const planDate = new Date(planTime)
        if (actualDate > planDate) {
          return 'delayed'
        }
      }
      
      return 'completed'
    },
    getTimeValueClass(status, actualTime) {
      if (status === 'not-started') return 'not-started'
      if (status === 'delayed') return 'delayed'
      if (status === 'in-progress') return 'in-progress'
      if (status === 'completed' && actualTime) return 'completed'
      return ''
    },
    getActualTimeText(actualTime, status) {
      if (status === 'not-started') return '未开始'
      if (!actualTime) {
        if (status === 'in-progress') return '进行中'
        return '待完成'
      }
      return actualTime
    },
    getStageStatusText(status) {
      const statusMap = {
        'completed': '已完成',
        'in-progress': '进行中',
        'delayed': '已延误',
        'not-started': '未开始'
      }
      return statusMap[status] || '未知'
    },
    getDelayStatusClass(item) {
      const delayInfo = this.calculateDelayInfo(item)
      return {
        'text-success': delayInfo.status === '正常',
        'text-danger': delayInfo.status === '延误',
        'text-warning': delayInfo.status === '进行中'
      }
    },
    getDelayStatusText(item) {
      const delayInfo = this.calculateDelayInfo(item)
      // 简化为"是/否"显示
      if (delayInfo.status === '延误' || delayInfo.status === '有延误') {
        return '是'
      } else if (delayInfo.status === '进行中') {
        return '是'
      }
      return '否'
    },
    getDelayDurationClass(item) {
      const delayInfo = this.calculateDelayInfo(item)
      return {
        'text-success': delayInfo.status === '正常',
        'text-danger': delayInfo.status === '延误',
        'text-warning': delayInfo.status === '进行中'
      }
    },
    getDelayDurationText(item) {
      const delayInfo = this.calculateDelayInfo(item)
      // 只返回数值，不返回单位，避免与列标题重复
      if (delayInfo.duration && delayInfo.duration !== '-') {
        // 返回小数形式，如0.5、1.2等
        const days = parseFloat(delayInfo.duration.replace('天', ''))
        // 限制在合理范围内，最大不超过30天
        const limitedDays = Math.min(days, 30)
        return limitedDays.toFixed(1)
      }
      return delayInfo.duration
    },
    calculateDelayInfo(item) {
      // 根据当前阶段判断延误情况
      const currentStage = item.currentStage
      let status = '正常'
      let duration = '-'
      
      if (currentStage === 'delayed') {
        status = '延误'
        // 从时间轴中找延误信息
        const delayedStage = this.getDelayedStage(item)
        if (delayedStage) {
          // 生成较小的延误数值，0.5-2天之间
          const delayDays = (Math.random() * 1.5 + 0.5).toFixed(1)
          duration = `${delayDays}天`
        }
      } else if (['producing', 'transporting', 'customs'].includes(currentStage)) {
        // 检查当前阶段是否超过计划时间
        const currentStageTime = this.getCurrentStagePlanTime(item, currentStage)
        if (currentStageTime) {
          const now = new Date()
          const planTime = new Date(currentStageTime)
          if (now > planTime) {
            status = '进行中'
            // 生成较小的延误数值，0.2-1.0天之间
            const diffDays = (Math.random() * 0.8 + 0.2).toFixed(1)
            duration = `${diffDays}天`
          }
        }
      } else if (currentStage === 'arrived' || currentStage === 'completed') {
        // 检查是否有延误阶段
        const hasDelay = this.hasAnyDelay(item)
        if (hasDelay) {
          status = '有延误'
          duration = this.getTotalDelayDuration(item)
        }
      }
      
      return { status, duration }
    },
    getDelayedStage(item) {
      // 从监控数据中找到延误的阶段
      const monitoringItem = this.monitoringData.find(m => m.orderNo === item.orderNo)
      if (monitoringItem && monitoringItem.timeline) {
        return monitoringItem.timeline.find(t => t.delayed)
      }
      return null
    },
    getCurrentStagePlanTime(item, stage) {
      const stageTimeMap = {
        'producing': item.productionPlanTime,
        'transporting': item.transportPlanTime,
        'customs': item.customsPlanTime
      }
      return stageTimeMap[stage]
    },
    hasAnyDelay(item) {
      // 检查各个阶段是否有延误
      const delays = []
      if (item.productionActualTime && item.productionPlanTime) {
        if (new Date(item.productionActualTime) > new Date(item.productionPlanTime)) {
          delays.push('生产')
        }
      }
      if (item.transportActualTime && item.transportPlanTime) {
        if (new Date(item.transportActualTime) > new Date(item.transportPlanTime)) {
          delays.push('运输')
        }
      }
      if (item.customsActualTime && item.customsPlanTime) {
        if (new Date(item.customsActualTime) > new Date(item.customsPlanTime)) {
          delays.push('清关')
        }
      }
      return delays.length > 0
    },
    getTotalDelayDuration(item) {
      // 计算总延误时长（天）
      let totalDays = 0
      const stages = [
        { actual: item.productionActualTime, plan: item.productionPlanTime },
        { actual: item.transportActualTime, plan: item.transportPlanTime },
        { actual: item.customsActualTime, plan: item.customsPlanTime }
      ]
      
      stages.forEach(stage => {
        if (stage.actual && stage.plan) {
          const diff = new Date(stage.actual) - new Date(stage.plan)
          if (diff > 0) {
            totalDays += diff / (1000 * 60 * 60 * 24)
          }
        }
      })
      
      return totalDays > 0 ? `${totalDays.toFixed(1)}天` : '-'
    },
    getDelayDurationText(stage) {
      // 计算延误时长
      if (stage.status === 'delayed' && stage.planTime && stage.actualTime) {
        const planDate = new Date(stage.planTime)
        const actualDate = new Date(stage.actualTime)
        const diffTime = actualDate - planDate
        const diffDays = diffTime / (1000 * 60 * 60 * 24)
        if (diffDays > 0) {
          return `${diffDays.toFixed(1)}天`
        }
      }
      return '-'
    },
    getTotalDelayDuration(item) {
      // 计算订单的总延误时长
      if (!item || !item.stages) return '0天'
      
      let totalDelayDays = 0
      item.stages.forEach(stage => {
        if (stage.status === 'delayed' && stage.planTime && stage.actualTime) {
          const planDate = new Date(stage.planTime)
          const actualDate = new Date(stage.actualTime)
          const diffTime = actualDate - planDate
          const diffDays = diffTime / (1000 * 60 * 60 * 24)
          if (diffDays > 0) {
            totalDelayDays += diffDays
          }
        }
      })
      
      return `${totalDelayDays.toFixed(1)}天`
    }
  },
  computed: {
    filteredProjects() {
      if (!this.searchParams.projectName) {
        return this.projects;
      }
      return this.projects.filter(project =>
        project.name.toLowerCase().includes(this.searchParams.projectName.toLowerCase())
      );
    }
  }
}
</script>

<style scoped>
.logistics-monitoring {
  padding: 20px;
}

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
.stat-icon.in-progress { background: #f6ffed; }
.stat-icon.delayed { background: #fff2e8; }
.stat-icon.completed { background: #f6ffed; }

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #1890ff;
}

.stat-label {
  color: #666;
  font-size: 14px;
}

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
  grid-template-columns: repeat(4, 1fr) 180px;
  gap: 20px;
  align-items: center;
  padding-right: 180px;
}

.form-item {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 0;
}

.form-item label {
  font-weight: 500;
  color: #333;
  white-space: nowrap;
  min-width: 80px;
  text-align: right;
  font-size: 14px;
}

.form-item input,
.form-item select {
  flex: 1;
  padding: 10px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  min-width: 0;
  background: #fafafa;
  transition: all 0.3s ease;
}

.form-item input:focus,
.form-item select:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
  background: white;
}

.form-item input:hover,
.form-item select:hover {
  border-color: #40a9ff;
  background: white;
}

.date-range-item {
  grid-column: span 1;
}

.date-inputs {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
}

.date-inputs input {
  flex: 1;
  min-width: 0;
}

.date-separator {
  color: #666;
  white-space: nowrap;
}

.button-group {
  display: flex;
  gap: 10px;
  align-items: center;
  position: absolute;
  right: 24px;
  top: 50%;
  transform: translateY(-50%);
}

.button-group-inline {
  display: flex;
  gap: 10px;
  align-items: center;
  justify-content: flex-end;
}

.button-group-right {
  display: flex;
  gap: 12px;
  align-items: center;
  margin-left: auto;
  padding-left: 20px;
}

.button-group-far-right {
  display: flex;
  gap: 12px;
  align-items: center;
  position: absolute;
  right: 24px;
  top: calc(50% + 40px); /* 下移40px，与时间范围选择框保持一致 */
  transform: translateY(-50%);
}

.btn-primary, .btn-secondary {
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s ease;
  min-width: 80px;
}

.btn-primary {
  background: linear-gradient(135deg, #1890ff 0%, #096dd9 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.btn-primary:hover {
  background: linear-gradient(135deg, #40a9ff 0%, #1890ff 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(24, 144, 255, 0.4);
}

.btn-secondary {
  background: linear-gradient(135deg, #f5f5f5 0%, #e8e8e8 100%);
  color: #666;
  border: 1px solid #d9d9d9;
}

.btn-secondary:hover {
  background: linear-gradient(135deg, #fafafa 0%, #f0f0f0 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.btn-primary, .btn-secondary, .btn-detail {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.btn-primary {
  background: #1890ff;
  color: white;
}

.btn-secondary {
  background: #f5f5f5;
  color: #666;
  border: 1px solid #d9d9d9;
}

.btn-detail {
  background: #52c41a;
  color: white;
  padding: 4px 12px;
  font-size: 12px;
}

.chart-section, .monitoring-section {
  margin-bottom: 20px;
}

.chart-card, .monitoring-card {
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.chart-card h3, .monitoring-card h3 {
  margin-bottom: 20px;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.chart-container {
  position: relative;
  width: 100%;
  height: 400px;
  overflow: hidden;
}

.chart-container .v-chart {
  width: 100% !important;
  height: 100% !important;
}

.monitoring-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 20px;
}

.monitoring-item {
  border: 1px solid #e8e8e8;
  border-radius: 6px;
  padding: 15px;
  background: #fafafa;
}

.monitoring-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.order-no {
  font-weight: bold;
  color: #1890ff;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  color: white;
}

.status-badge.pending { background: #faad14; }
.status-badge.producing { background: #1890ff; }
.status-badge.transporting { background: #722ed1; }
.status-badge.customs { background: #13c2c2; }
.status-badge.arrived { background: #52c41a; }
.status-badge.completed { background: #52c41a; }
.status-badge.delayed { background: #f5222d; }

.material-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
}

.quantity {
  color: #666;
}

.timeline {
  position: relative;
  padding-left: 20px;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 7px;
  top: 0;
  bottom: 0;
  width: 2px;
  background: #e8e8e8;
}

.timeline-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 15px;
  position: relative;
}

.timeline-dot {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: #d9d9d9;
  margin-right: 10px;
  position: relative;
  z-index: 1;
}

.timeline-dot.active {
  background: #52c41a;
}

.timeline-dot.delayed {
  background: #f5222d;
}

.step-name {
  font-weight: 500;
  margin-bottom: 4px;
}

.step-time {
  color: #666;
  font-size: 12px;
}

.delay-warning {
  color: #f5222d;
  font-size: 12px;
  background: #fff1f0;
  padding: 2px 6px;
  border-radius: 3px;
}

.monitoring-footer {
  text-align: right;
  margin-top: 10px;
}

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
  width: 800px;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.time-detail-modal .modal-header {
  padding: 15px 20px;
  border-bottom: 1px solid #e8e8e8;
  background: linear-gradient(135deg, #f8f9fa 0%, #e6f7ff 100%);
}

.time-detail-modal .modal-header h3 {
  margin: 0;
  font-size: 16px;
  color: #1890ff;
  font-weight: 600;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #e8e8e8;
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

.detail-section {
  margin-bottom: 30px;
}

.detail-section h4 {
  margin-bottom: 15px;
  color: #333;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.detail-item {
  display: flex;
  gap: 10px;
}

.detail-item label {
  font-weight: 500;
  min-width: 100px;
}

.exception-item {
  background: #fafafa;
  padding: 10px;
  border-radius: 4px;
  margin-bottom: 10px;
}

.exception-type {
  font-weight: bold;
  margin-bottom: 5px;
}

.exception-type.delay { color: #f5222d; }
.exception-type.route { color: #faad14; }
.exception-type.customs { color: #1890ff; }

.exception-desc {
  color: #666;
  margin-bottom: 5px;
}

.exception-time {
  color: #999;
  font-size: 12px;
}

.no-exception {
  text-align: center;
  color: #999;
  padding: 20px;
}

.gps-map {
  height: 200px;
  background: #f5f5f5;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.map-placeholder {
  text-align: center;
  color: #666;
}

.route-point {
  margin-bottom: 8px;
}

.point-label {
  font-weight: 500;
}

.deviation-warning {
  color: #f5222d;
  background: #fff1f0;
  padding: 4px 8px;
  border-radius: 3px;
  font-size: 12px;
}

/* 表格样式 */
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

/* 物流表格特殊样式 - 使用现有表格样式类 */
.data-table th,
.data-table td {
  padding: 12px 16px;
  font-size: 13px;
}

.data-table th[colspan="2"] {
  background: #40a9ff;
  font-size: 12px;
  font-weight: 600;
}

/* 状态标签样式 */
.status-producing {
  background: #1890ff;
  color: white;
}

.status-transporting {
  background: #722ed1;
  color: white;
}

.status-customs {
  background: #13c2c2;
  color: white;
}

.status-arrived {
  background: #52c41a;
  color: white;
}

.status-completed {
  background: #52c41a;
  color: white;
}

.status-delayed {
  background: #f5222d;
  color: white;
}

.status-pending {
  background: #faad14;
  color: white;
}

/* 文本颜色样式 */
.text-warning {
  color: #faad14 !important;
  font-weight: 500;
}

.text-danger {
  color: #f5222d !important;
  font-weight: 500;
}

.text-success {
  color: #52c41a !important;
  font-weight: 500;
}

/* 时间详情弹窗样式 - 优化版 */
.time-detail-modal {
  width: 1100px;
  max-width: 88vw;
  max-height: 82vh;
  display: flex;
  flex-direction: column;
  margin: 15px auto;
}

.detail-info {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 10px;
  margin-bottom: 12px;
  padding: 12px;
  background: linear-gradient(135deg, #f8f9fa 0%, #e6f7ff 100%);
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.info-item {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 2px 0;
}

.info-item label {
  font-weight: 600;
  color: #1890ff;
  font-size: 11px;
  min-width: 60px;
  flex-shrink: 0;
}

.info-item span {
  font-size: 12px;
  color: #333;
  font-weight: 500;
  flex: 1;
  word-break: break-word;
}

.time-line-container {
  padding: 10px 0;
  display: flex;
  flex-direction: column;
  gap: 6px;
  max-height: calc(82vh - 200px);
  overflow-y: auto;
  overflow-x: hidden;
}

.time-line-container::-webkit-scrollbar {
  width: 6px;
}

.time-line-container::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

.time-line-container::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

.time-line-container::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

.time-line-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 0;
  position: relative;
  padding: 8px 12px;
  background: white;
  border-radius: 6px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  border-left: 4px solid #e8e8e8;
  min-height: 35px;
  transition: all 0.3s ease;
  margin-bottom: 4px;
}

.time-line-item:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.time-line-item.completed {
  border-left-color: #52c41a;
  background: linear-gradient(135deg, #f6ffed 0%, #ffffff 100%);
}

.time-line-item.in-progress {
  border-left-color: #1890ff;
  background: linear-gradient(135deg, #e6f7ff 0%, #ffffff 100%);
}

.time-line-item.delayed {
  border-left-color: #f5222d;
  background: linear-gradient(135deg, #fff1f0 0%, #ffffff 100%);
}

.time-line-item.not-started {
  border-left-color: #d9d9d9;
  background: linear-gradient(135deg, #fafafa 0%, #ffffff 100%);
}

.time-line-dot {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  position: absolute;
  left: 3px;
  top: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 8px;
  font-weight: bold;
  color: white;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
  flex-shrink: 0;
  z-index: 2;
}

.time-line-dot.completed {
  background: #52c41a;
}

.time-line-dot.in-progress {
  background: #1890ff;
  animation: pulse 2s infinite;
}

.time-line-dot.delayed {
  background: #f5222d;
}

.time-line-dot.not-started {
  background: #d9d9d9;
}

@keyframes pulse {
  0% { opacity: 1; }
  50% { opacity: 0.7; }
  100% { opacity: 1; }
}

.time-line-content {
  flex: 1;
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border-left: 4px solid #e8e8e8;
}

.time-line-content.completed {
  border-left-color: #52c41a;
}

.time-line-content.in-progress {
  border-left-color: #1890ff;
}

.time-line-content.delayed {
  border-left-color: #f5222d;
}

.time-line-content.not-started {
  border-left-color: #d9d9d9;
}

.time-line-content {
  display: grid;
  grid-template-columns: 110px 1fr 90px 70px;
  gap: 8px;
  align-items: center;
  margin-left: 20px;
  width: calc(100% - 20px);
}

.stage-name {
  font-size: 13px;
  font-weight: 600;
  color: #333;
  min-width: 110px;
  word-break: break-word;
}

.time-comparison {
  display: flex;
  gap: 8px;
  flex: 1;
  min-width: 0;
}

.time-plan, .time-actual {
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding: 4px 8px;
  border-radius: 4px;
  background: #f8f9fa;
  min-width: 110px;
  flex: 1;
}

.time-label {
  font-size: 10px;
  color: #666;
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.time-value {
  font-size: 11px;
  font-weight: 600;
  color: #333;
  word-break: break-word;
  line-height: 1.3;
}

.time-value.completed {
  color: #52c41a;
}

.time-value.in-progress {
  color: #1890ff;
}

.time-value.delayed {
  color: #f5222d;
}

.time-value.not-started {
  color: #999;
}

.stage-status {
  padding: 2px 6px;
  border-radius: 10px;
  font-size: 10px;
  font-weight: 600;
  text-align: center;
  min-width: 50px;
  white-space: nowrap;
}

.stage-status.completed {
  background: #f6ffed;
  color: #52c41a;
}

.stage-status.in-progress {
  background: #e6f7ff;
  color: #1890ff;
}

.stage-status.delayed {
  background: #fff1f0;
  color: #f5222d;
}

.stage-status.not-started {
  background: #fafafa;
  color: #999;
}

.delay-warning {
  color: #f5222d;
  font-size: 10px;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 2px;
  white-space: nowrap;
}

/* 查看详情按钮样式 */
.btn-view-detail {
  background: linear-gradient(135deg, #1890ff 0%, #096dd9 100%);
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 11px;
  font-weight: 600;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.3);
  min-width: 50px;
}

.btn-view-detail:hover {
  background: linear-gradient(135deg, #40a9ff 0%, #1890ff 100%);
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.4);
}

/* 优化版表格样式 - 大气美观 */
.data-table {
  font-size: 14px;
  table-layout: fixed;
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(24, 144, 255, 0.1);
}

.data-table th,
.data-table td {
  padding: 16px 12px;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  border-bottom: 1px solid rgba(240, 240, 240, 0.8);
  text-align: center;
  font-size: 13px;
}

.data-table th {
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 0.5px;
}

.data-table td {
  font-weight: 400;
  color: #333;
}

/* 优化表格视觉效果 */
.data-table {
  border: 1px solid #e8f4ff;
  box-shadow: 0 4px 16px rgba(24, 144, 255, 0.08);
}

.data-table th {
  border-bottom: 2px solid #e8f4ff;
}

.data-table td {
  border-bottom: 1px solid #f0f8ff;
}

.data-table tbody tr:hover {
  background: linear-gradient(135deg, #f8f9fa 0%, #e6f7ff 100%);
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.1);
}

.data-table tbody tr:nth-child(even) {
  background: #fafafa;
}

.data-table tbody tr:nth-child(even):hover {
  background: linear-gradient(135deg, #f0f9ff 0%, #e6f7ff 100%);
}

.data-table th {
  background: #1890ff;
  color: white;
  font-weight: 600;
  font-size: 14px;
  position: sticky;
  top: 0;
  z-index: 10;
  padding: 18px 12px;
  text-align: center;
  letter-spacing: 0.5px;
  border: none;
}

.data-table th:first-child {
  text-align: center;
  padding-left: 12px;
}

.data-table th:nth-child(4) {
  text-align: center;
  padding-left: 12px;
}

.data-table th:first-child {
  border-top-left-radius: 0;
}

.data-table th:last-child {
  border-top-right-radius: 0;
}

.data-table tbody tr:last-child td:first-child {
  border-bottom-left-radius: 12px;
}

.data-table tbody tr:last-child td:last-child {
  border-bottom-right-radius: 12px;
}

.data-table tbody tr:hover {
  background: linear-gradient(135deg, #f8f9fa 0%, #e6f7ff 100%);
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.1);
}

.data-table tbody tr:nth-child(even) {
  background: #fafafa;
}

.data-table tbody tr:nth-child(even):hover {
  background: linear-gradient(135deg, #f0f9ff 0%, #e6f7ff 100%);
}

/* 优化表格边框和圆角 */
.data-table {
  border: 1px solid #e8f4ff;
  box-shadow: 0 4px 16px rgba(24, 144, 255, 0.08);
}

.data-table th {
  border-bottom: 2px solid #e8f4ff;
}

.data-table td {
  border-bottom: 1px solid #f0f8ff;
}

/* 优化列宽布局 - 紧凑合理 */
.data-table th:nth-child(1),
.data-table td:nth-child(1) {
  width: 140px;
  text-align: center;
  padding-left: 12px;
}

.data-table th:nth-child(2),
.data-table td:nth-child(2) {
  width: 110px;
}

.data-table th:nth-child(3),
.data-table td:nth-child(3) {
  width: 100px;
}

.data-table th:nth-child(4),
.data-table td:nth-child(4) {
  width: 120px;
  text-align: center;
  padding-left: 12px;
}

.data-table th:nth-child(5),
.data-table td:nth-child(5) {
  width: 100px;
}

.data-table th:nth-child(6),
.data-table td:nth-child(6) {
  width: 70px;
}

.data-table th:nth-child(7),
.data-table td:nth-child(7) {
  width: 90px;
}

.data-table th:nth-child(8),
.data-table td:nth-child(8) {
  width: 80px;
}

.data-table th:nth-child(5),
.data-table td:nth-child(5) {
  width: 85px;
}

.data-table th:nth-child(6),
.data-table td:nth-child(6) {
  width: 110px;
}

.data-table th:nth-child(7),
.data-table td:nth-child(7) {
  width: 95px;
}

.data-table th:nth-child(8),
.data-table td:nth-child(8) {
  width: 65px;
}

.data-table th:nth-child(9),
.data-table td:nth-child(9) {
  width: 55px;
}

.data-table th:nth-child(10),
.data-table td:nth-child(10) {
  width: 75px;
}

.data-table th:nth-child(11),
.data-table td:nth-child(11) {
  width: 65px;
}

/* 状态标签优化 - 现代大气 */
.status-tag {
  padding: 8px 14px;
  font-size: 12px;
  border-radius: 20px;
  font-weight: 600;
  letter-spacing: 0.8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.status-producing {
  background: linear-gradient(135deg, #1890ff 0%, #096dd9 100%);
  color: white;
}

.status-transporting {
  background: linear-gradient(135deg, #722ed1 0%, #531dab 100%);
  color: white;
}

.status-customs {
  background: linear-gradient(135deg, #13c2c2 0%, #08979c 100%);
  color: white;
}

.status-arrived {
  background: linear-gradient(135deg, #52c41a 0%, #389e0d 100%);
  color: white;
}

.status-completed {
  background: linear-gradient(135deg, #52c41a 0%, #389e0d 100%);
  color: white;
}

.status-delayed {
  background: linear-gradient(135deg, #f5222d 0%, #cf1322 100%);
  color: white;
}

.status-pending {
  background: linear-gradient(135deg, #faad14 0%, #d48806 100%);
  color: white;
}

/* 文本样式优化 - 更醒目 */
.text-success, .text-danger, .text-warning {
  font-size: 13px;
  font-weight: 600;
}

/* 时间显示优化 - 防止溢出 */
.time-value {
  max-width: 120px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

@media screen and (max-width: 1200px) {
  .time-value {
    max-width: 100px;
  }
}

@media screen and (max-width: 768px) {
  .time-value {
    max-width: none;
    white-space: normal;
  }
}

/* 响应式布局优化 */
@media screen and (max-width: 1400px) {
  .time-detail-modal {
    width: 95vw;
    max-width: 95vw;
  }
  
  .detail-info {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .time-line-content {
    grid-template-columns: 100px 1fr 80px 60px;
    gap: 6px;
  }
}

@media screen and (max-width: 1200px) {
  .time-detail-modal {
    width: 96vw;
    max-width: 96vw;
  }
  
  .time-line-content {
    grid-template-columns: 90px 1fr 70px 50px;
    gap: 5px;
  }
  
  .stage-name {
    min-width: 90px;
    font-size: 12px;
  }
}

@media screen and (max-width: 768px) {
  .time-detail-modal {
    width: 98vw;
    max-width: 98vw;
    margin: 10px auto;
  }
  
  .detail-info {
    grid-template-columns: 1fr;
    gap: 8px;
  }
  
  .time-line-content {
    grid-template-columns: 1fr;
    gap: 4px;
    margin-left: 15px;
    width: calc(100% - 15px);
  }
  
  .time-comparison {
    flex-direction: column;
    gap: 4px;
  }
  
  .time-plan, .time-actual {
    min-width: auto;
  }
  
  .time-line-dot {
    width: 14px;
    height: 14px;
    left: -7px;
    font-size: 8px;
  }
}

.btn-view-detail:hover {
  background: linear-gradient(135deg, #40a9ff 0%, #1890ff 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(24, 144, 255, 0.4);
}
</style>