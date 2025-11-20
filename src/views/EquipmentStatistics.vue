<template>
  <div class="equipment-statistics">
    <!-- 搜索区域 -->
    <div class="search-area">
      <div class="search-form">
        <div class="form-row">
          <div class="form-item">
            <label>一级分类名称：</label>
            <select v-model="searchParams.firstLevelCategory">
              <option value="">全部</option>
              <option value="机械设备">机械设备</option>
              <option value="电气设备">电气设备</option>
              <option value="建筑材料">建筑材料</option>
              <option value="化工材料">化工材料</option>
              <option value="仪器仪表">仪器仪表</option>
            </select>
          </div>
          <div class="form-item">
            <label>二级分类名称：</label>
            <select v-model="searchParams.secondLevelCategory">
              <option value="">全部</option>
              <option value="起重设备">起重设备</option>
              <option value="输送设备">输送设备</option>
              <option value="变压器">变压器</option>
              <option value="开关设备">开关设备</option>
              <option value="钢材">钢材</option>
              <option value="水泥">水泥</option>
              <option value="管材">管材</option>
              <option value="阀门">阀门</option>
              <option value="泵类">泵类</option>
            </select>
          </div>
          <div class="form-item">
            <label>物资装备名称：</label>
            <select v-model="searchParams.equipmentName">
              <option value="">全部</option>
              <option value="塔式起重机">塔式起重机</option>
              <option value="门式起重机">门式起重机</option>
              <option value="电力变压器">电力变压器</option>
              <option value="配电箱">配电箱</option>
              <option value="螺纹钢">螺纹钢</option>
              <option value="线材">线材</option>
              <option value="普通硅酸盐水泥">普通硅酸盐水泥</option>
              <option value="复合硅酸盐水泥">复合硅酸盐水泥</option>
              <option value="球墨铸铁管">球墨铸铁管</option>
              <option value="不锈钢管">不锈钢管</option>
              <option value="闸阀">闸阀</option>
              <option value="截止阀">截止阀</option>
              <option value="离心泵">离心泵</option>
              <option value="潜水泵">潜水泵</option>
            </select>
          </div>
        </div>
        <div class="form-row">
          <div class="form-item">
            <label>数据来源：</label>
            <select v-model="searchParams.dataSource">
              <option value="">全部</option>
              <option value="集团供应链">集团供应链</option>
              <option value="机电分公司">机电分公司</option>
            </select>
          </div>
          <div class="form-item button-group">
            <button class="btn-primary" @click="handleSearch">查询</button>
            <button class="btn-secondary" @click="handleReset">重置</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 统计图表区域 -->
    <div class="charts-area">
      <div class="chart-row">
        <!-- 价格变化折线图 -->
        <div class="chart-container">
          <div class="chart-header">
            <h3>物资装备价格变化趋势</h3>
          </div>
          <div class="chart-content">
            <div id="price-chart" style="width: 100%; height: 400px;"></div>
          </div>
        </div>

        <!-- 二级分类占比饼状图 -->
        <div class="chart-container">
          <div class="chart-header">
            <h3>二级分类物资装备占比</h3>
          </div>
          <div class="chart-content">
            <div id="category-chart" style="width: 100%; height: 400px;"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import '../assets/styles/button-styles.css'

export default {
  name: 'EquipmentStatistics',
  data() {
    return {
      searchParams: {
        firstLevelCategory: '',
        secondLevelCategory: '',
        equipmentName: '',
        dataSource: ''
      },
      priceChart: null,
      categoryChart: null,
      // 模拟价格变化数据
      priceTrendData: [
        { period: '项目1', exwPrice: 450000, deliveryPrice: 480000 },
        { period: '项目2', exwPrice: 440000, deliveryPrice: 470000 },
        { period: '项目3', exwPrice: 460000, deliveryPrice: 490000 },
        { period: '项目4', exwPrice: 455000, deliveryPrice: 485000 }
      ],
      // 模拟二级分类占比数据
      categoryDistribution: [
        { name: '起重设备', value: 25 },
        { name: '变压器', value: 20 },
        { name: '钢材', value: 30 },
        { name: '水泥', value: 15 },
        { name: '管材', value: 10 }
      ]
    }
  },
  methods: {
    handleSearch() {
      console.log('搜索参数：', this.searchParams)
      // 这里应该调用API获取统计数据
      this.updateCharts()
    },
    handleReset() {
      this.searchParams = {
        firstLevelCategory: '',
        secondLevelCategory: '',
        equipmentName: '',
        dataSource: ''
      }
      this.updateCharts()
    },
    updateCharts() {
      // 根据搜索条件更新图表数据
      console.log('更新图表数据')
      this.initPriceChart()
      this.initCategoryChart()
    },
    initPriceChart() {
      const chartDom = document.getElementById('price-chart')
      if (!chartDom) return
      
      if (this.priceChart) {
        this.priceChart.dispose()
      }
      
      this.priceChart = echarts.init(chartDom)
      
      const option = {
        title: {
          text: '物资装备价格变化趋势',
          left: 'center'
        },
        tooltip: {
          trigger: 'axis',
          formatter: function(params) {
            let result = params[0].name + '<br/>'
            params.forEach(param => {
              result += `${param.seriesName}: ${param.value.toLocaleString()}元<br/>`
            })
            return result
          }
        },
        legend: {
          data: ['出厂价EXW', '国内港口车板交货价'],
          top: '10%'
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          top: '20%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: this.priceTrendData.map(item => item.period),
          axisLabel: {
            rotate: 45
          }
        },
        yAxis: {
          type: 'value',
          name: '价格（元）',
          axisLabel: {
            formatter: function(value) {
              return (value / 1000).toFixed(0) + 'k'
            }
          }
        },
        series: [
          {
            name: '出厂价EXW',
            type: 'line',
            data: this.priceTrendData.map(item => item.exwPrice),
            itemStyle: {
              color: '#5470c6'
            },
            lineStyle: {
              width: 3
            }
          },
          {
            name: '国内港口车板交货价',
            type: 'line',
            data: this.priceTrendData.map(item => item.deliveryPrice),
            itemStyle: {
              color: '#91cc75'
            },
            lineStyle: {
              width: 3
            }
          }
        ]
      }
      
      this.priceChart.setOption(option)
    },
    initCategoryChart() {
      const chartDom = document.getElementById('category-chart')
      if (!chartDom) return
      
      if (this.categoryChart) {
        this.categoryChart.dispose()
      }
      
      this.categoryChart = echarts.init(chartDom)
      
      const option = {
        title: {
          text: '二级分类物资装备占比',
          left: 'center'
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left',
          top: 'center'
        },
        series: [
          {
            name: '物资装备数量',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: '18',
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: this.categoryDistribution.map(item => ({
              value: item.value,
              name: item.name
            }))
          }
        ]
      }
      
      this.categoryChart.setOption(option)
    },
    handleResize() {
      if (this.priceChart) {
        this.priceChart.resize()
      }
      if (this.categoryChart) {
        this.categoryChart.resize()
      }
    }
  },
  mounted() {
    this.updateCharts()
    window.addEventListener('resize', this.handleResize)
  },
  beforeUnmount() {
    window.removeEventListener('resize', this.handleResize)
    if (this.priceChart) {
      this.priceChart.dispose()
    }
    if (this.categoryChart) {
      this.categoryChart.dispose()
    }
  }
}
</script>

<style scoped>
.equipment-statistics {
  padding: 20px;
  min-height: 100vh;
  overflow: auto;
}

/* 搜索区域样式 */
.search-area {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 6px;
  margin-bottom: 20px;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
}

.form-item {
  display: flex;
  align-items: center;
  flex: 1;
}

.form-item label {
  width: 120px;
  text-align: right;
  margin-right: 10px;
  font-weight: 500;
}

.form-item select {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.button-group {
  justify-content: flex-end;
  gap: 10px;
}

/* 图表区域样式 */
.charts-area {
  margin-top: 20px;
}

.chart-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.chart-container {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.chart-header {
  padding: 20px;
  border-bottom: 1px solid #e8e8e8;
  background: #fafafa;
}

.chart-header h3 {
  margin: 0;
  color: #333;
  font-size: 16px;
}

.chart-content {
  padding: 20px;
  min-height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: auto;
}

.chart-placeholder {
  text-align: center;
  color: #666;
}

.chart-placeholder p {
  margin: 5px 0;
}
</style>