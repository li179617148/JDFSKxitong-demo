<template>
  <div class="home-container">
    <!-- 顶部导航栏 -->
    <header class="header" style="position: relative; z-index: 10; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);">
      <div class="header-left">
        <div class="logo">
          <img src="@/assets/images/new-logo.png" alt="公司Logo" class="logo-image">
        </div>
      </div>
      <div class="header-center">
        <h1 class="system-title">资源管理系统</h1>
      </div>
      <div class="header-right">
        <div class="user-info">
          <span class="user-name">管理员</span>
          <button class="logout-btn" @click="handleLogout">退出</button>
        </div>
      </div>
    </header>

    <div class="main-content">
      <!-- 左侧导航栏 -->
     <aside class="sidebar" style="margin-top: -1px; border-top-left-radius: 0; border-top-right-radius: 0;">
        <nav class="nav-menu">
          <ul>
            <li 
              v-for="item in menuItems" 
              :key="item.id"
              :class="{ 
                'has-children': item.children,
                'expanded': expandedMenus.has(item.id)
              }"
            >
              <div 
                class="menu-item"
                @click="toggleMenu(item.id)"
              >
                <span class="menu-text">{{ item.name }}</span>
                <span class="arrow" v-if="item.children"></span>
              </div>
              <ul class="sub-menu" v-if="item.children && expandedMenus.has(item.id)">
                <li 
                  v-for="child in item.children" 
                  :key="child.id"
                  :class="{ active: activeMenu === child.id }"
                  @click="switchMenu(child.id)"
                >
                  {{ child.name }}
                </li>
              </ul>
            </li>
          </ul>
        </nav>
      </aside>

      <!-- 右侧内容区域 -->
      <main class="content-area">
        <div class="content-body">
          <component :is="currentComponent" />
        </div>
      </main>
    </div>
  </div>
</template>

<script>
import PriceLibrary from '../components/PriceLibrary.vue'
import PartnerManagement from '../components/PartnerManagement.vue'
import ProjectLibrary from '../components/ProjectLibrary.vue'
import ExpertManagement from '../components/ExpertManagement.vue'
import ExpertApproval from '../components/ExpertApproval.vue'

// 子功能组件
import MaterialEquipment from '../components/MaterialEquipment.vue'
import MaterialEquipmentApproval from '../components/MaterialEquipmentApproval.vue'

import MaterialEquipmentCategory from '../components/MaterialEquipmentCategory.vue'
import PriceStatistics from '../components/PriceStatistics.vue'
import PartnerEvaluation from '../components/PartnerEvaluation.vue'
import PartnerApproval from '../components/PartnerApproval.vue'
import PartnerEvaluationApproval from '../components/PartnerEvaluationApproval.vue'
import ProjectMaintenance from '../components/ProjectMaintenance.vue'
import ProjectApproval from '../components/ProjectApproval.vue'
import ExpertMaintenance from '../components/ExpertMaintenance.vue'
import LogisticsMonitoring from '../components/LogisticsMonitoring.vue'
import LogisticsReporting from '../components/LogisticsReporting.vue'
import LogisticsOverview from '../components/LogisticsOverview.vue'
import ForwarderMaintenance from '../components/ForwarderMaintenance.vue'
import SubcontractMaintenance from '../components/SubcontractMaintenance.vue'
import SubcontractLogisticsMaintenance from '../components/SubcontractLogisticsMaintenance.vue'
import ForwarderLogisticsMaintenance from '../components/ForwarderLogisticsMaintenance.vue'
import PriceMaintenance from '../components/PriceMaintenance.vue'
import PriceAdd from '../components/PriceAdd.vue'
import PartnerEvaluationList from '../components/PartnerEvaluationList.vue'
import StaffManagement from '../components/StaffManagement.vue'
import DepartmentManagement from '../components/DepartmentManagement.vue'
import RoleManagement from '../components/RoleManagement.vue'

export default {
  name: 'Home',
  components: {
    PriceLibrary,
    PartnerManagement,
    ProjectLibrary,
    ExpertManagement,
    ExpertApproval,
    MaterialEquipment,
    MaterialEquipmentApproval,

    MaterialEquipmentCategory,
    PriceStatistics,
    PartnerEvaluation,
    PartnerApproval,
    PartnerEvaluationApproval,
    ProjectMaintenance,
    ProjectApproval,
    ExpertMaintenance,
    LogisticsMonitoring,
    LogisticsReporting,
    LogisticsOverview,
    ForwarderMaintenance,
    SubcontractMaintenance,
    SubcontractLogisticsMaintenance,
    ForwarderLogisticsMaintenance,
    PriceMaintenance,
    PriceAdd,
    PartnerEvaluationList,
    StaffManagement,
    DepartmentManagement,
    RoleManagement
  },
  data() {
    return {
      activeMenu: 'material', // 默认激活价格查询菜单
      expandedMenus: new Set(['price']), // 默认只展开价格库管理
      showPriceAdd: false, // 控制新增页面显示
      menuItems: [
        { 
          id: 'price', 
          name: '价格库管理', 
          component: 'PriceLibrary',
          children: [
            { id: 'material', name: '价格查询', component: 'MaterialEquipment' },
            { id: 'price-maintenance', name: '价格维护', component: 'PriceMaintenance' },
            { id: 'material-category', name: '分类维护', component: 'MaterialEquipmentCategory' },
            { id: 'material-approval', name: '审批页面', component: 'MaterialEquipmentApproval' }
          ]
        },
        {
          id: 'partner',
          name: '合作方管理',
          component: 'PartnerManagement',
          children: [
            { id: 'partner-maintenance', name: '合作方维护', component: 'PartnerManagement' },
            { id: 'partner-evaluation-list', name: '合作方评价', component: 'PartnerEvaluationList' },
            { id: 'partner-approval', name: '合作方维护审批', component: 'PartnerApproval' },
            { id: 'partner-evaluation-approval', name: '合作方评价审批', component: 'PartnerEvaluationApproval' }
          ]
        },
        { 
          id: 'project', 
          name: '项目管理', 
          component: 'ProjectLibrary',
          children: [
            { id: 'project-maintenance', name: '项目维护', component: 'ProjectMaintenance' },
            { id: 'project-approval', name: '项目维护审批', component: 'ProjectApproval' }
          ]
        },
        {
          id: 'expert',
          name: '专家库管理',
          component: 'ExpertManagement',
          children: [
            { id: 'expert-maintenance', name: '专家库维护', component: 'ExpertManagement' },
            { id: 'expert-approval', name: '专家库维护审批', component: 'ExpertApproval' }
          ]
        },
        {
          id: 'logistics',
          name: '物流监控管理',
          component: 'LogisticsOverview',
          children: [
            { id: 'logistics-overview', name: '物流总览', component: 'LogisticsOverview' },
            { id: 'forwarder-maintenance', name: '国际货运代理商维护', component: 'ForwarderMaintenance' },
            { id: 'subcontract-logistics-maintenance', name: '包件物流维护', component: 'SubcontractLogisticsMaintenance' },
            { id: 'forwarder-logistics-maintenance', name: '国际货运代理物流维护', component: 'ForwarderLogisticsMaintenance' }
          ]
        },
        // 系统管理功能已隐藏，后续再设计
        // {
        //   id: 'system',
        //   name: '系统管理',
        //   component: 'StaffManagement',
        //   children: [
        //     { id: 'staff-management', name: '人员管理', component: 'StaffManagement' },
        //     { id: 'department-management', name: '部门管理', component: 'DepartmentManagement' },
        //     { id: 'role-management', name: '角色管理', component: 'RoleManagement' }
        //   ]
        // }
      ]
    }
  },
  created() {
    // 处理URL参数，如果指定了menu参数，则设置对应的菜单
    const urlParams = new URLSearchParams(window.location.search)
    const menuParam = urlParams.get('menu')
    if (menuParam && this.menuItems.some(item => 
      item.id === menuParam || (item.children && item.children.some(child => child.id === menuParam))
    )) {
      this.activeMenu = menuParam
    }
  },
  computed: {
    currentMenuName() {
      // 查找所有菜单项（包括子菜单）
      let menu = this.menuItems.find(item => item.id === this.activeMenu)
      if (!menu) {
        // 如果在主菜单中没找到，查找子菜单
        for (const parent of this.menuItems) {
          if (parent.children) {
            const child = parent.children.find(child => child.id === this.activeMenu)
            if (child) {
              menu = child
              break
            }
          }
        }
      }
      return menu ? menu.name : ''
    },
    currentComponent() {
      // 查找所有菜单项（包括子菜单）
      let menu = this.menuItems.find(item => item.id === this.activeMenu)
      if (!menu) {
        // 如果在主菜单中没找到，查找子菜单
        for (const parent of this.menuItems) {
          if (parent.children) {
            const child = parent.children.find(child => child.id === this.activeMenu)
            if (child) {
              menu = child
              break
            }
          }
        }
      }
      return menu ? menu.component : 'MaterialEquipment'
    }
  },
  methods: {
      toggleMenu(menuId) {
        if (this.expandedMenus.has(menuId)) {
          this.expandedMenus.delete(menuId)
        } else {
          this.expandedMenus.add(menuId)
        }
      },
      switchMenu(menuId) {
        this.activeMenu = menuId
      },
      handleLogout() {
        this.$router.push('/login')
      },
      
      handleShowPriceAdd() {
        this.showPriceAdd = true
      },
      
      handlePriceAddClose() {
        this.showPriceAdd = false
        // 切换到价格维护菜单
        this.switchMenu('price-maintenance')
      }
    }
}
</script>

<style scoped>
.home-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #f0f2f5;
  overflow: hidden;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #3b82f6;
  padding: 0 20px 0 0;
  height: 60px;
  color: white;
  box-shadow: 0 4px 20px rgba(37, 99, 235, 0.25);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  position: relative;
}

.header-left {
  display: flex;
  align-items: center;
  width: 320px;
  justify-content: flex-start;
}


.header-center {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
}

.system-title {
  color: white;
  font-size: 20px;
  font-weight: 600;
  margin: 0;
}

.logo {
  display: flex;
  align-items: center;
  justify-content: center;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
}

.logo-image {
  width: 320px;
  height: 58px;
  display: block;
  object-fit: contain;
}

.company-name {
  color: white;
  font-size: 24px;
  font-weight: 600;
  margin-left: 15px;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-name {
  margin-right: 15px;
  color: white;
  font-weight: 500;
}

.logout-btn {
  padding: 6px 16px;
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 16px;
  color: white;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  font-size: 14px;
}

.logout-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.logout-btn:active {
  transform: translateY(0);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.main-content {
  flex: 1;
  display: flex;
  overflow: hidden;
  transition: all 0.3s ease;
}

.sidebar {
  width: 250px;
  background: #3b82f6;
  border-right: 1px solid #2563eb;
  padding-top: 20px;
  overflow-y: auto;
  overflow-x: hidden;
  height: calc(100vh - 60px);
  position: sticky;
  top: 0;
  transition: all 0.3s ease;
  white-space: nowrap;
  flex-shrink: 0;
  position: relative;
}

.system-name {
  padding: 20px;
  border-bottom: 1px solid #2563eb;
  background: #3b82f6;
}

.system-name h2 {
  color: white;
  font-size: 16px;
  text-align: center;
}

.nav-menu ul {
  list-style: none;
  padding: 0;
  margin: 0;
  width: 100%;
}

.nav-menu li {
  border-left: 3px solid transparent;
  transition: all 0.3s;
  color: white;
  width: 100%;
  box-sizing: border-box;
}

.menu-item {
  padding: 15px 16px;
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  box-sizing: border-box;
}

.menu-item:hover {
  background: rgba(255, 255, 255, 0.1);
}

.nav-menu li.has-children .menu-item:hover {
  background: rgba(255, 255, 255, 0.1);
}

.arrow {
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 5px 0 5px 8px;
  border-color: transparent transparent transparent #fff;
  margin-left: 8px;
  transition: transform 0.3s;
}

.nav-menu li.expanded .arrow {
  transform: rotate(90deg);
}

.nav-menu li:not(.expanded) .arrow {
  transform: rotate(0deg);
}

.sub-menu {
  list-style: none;
  padding-left: 32px;
  background: rgba(255, 255, 255, 0.05);
  overflow: hidden;
  transition: all 0.3s ease;
  margin-left: 8px;
  border-left: 1px solid rgba(255, 255, 255, 0.2);
}

.sub-menu li {
  padding: 12px 16px;
  font-size: 14px;
  border-left: 2px solid transparent;
  cursor: pointer;
  transition: all 0.3s;
  margin-left: 4px;
  width: 100%;
  box-sizing: border-box;
}

.sub-menu li:hover {
  background: rgba(255, 255, 255, 0.08);
}

.sub-menu li.active {
  background: rgba(255, 255, 255, 0.15);
  border-left-color: rgba(255, 255, 255, 0.8);
}

.content-area {
  flex: 1;
  padding: 20px;
  background: #fafafa;
  overflow-y: auto;
  height: calc(100vh - 60px);
  transition: all 0.3s ease;
}

.content-header {
  margin-bottom: 20px;
}

.content-header h3 {
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.content-body {
  background: white;
  border-radius: 6px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  min-height: 400px;
  overflow: auto;
}
</style>