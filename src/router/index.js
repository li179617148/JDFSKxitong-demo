import { createRouter, createWebHashHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Home from '../views/Home.vue'
import EquipmentStatistics from '../views/EquipmentStatistics.vue'
import ProjectMaintenance from '../components/ProjectMaintenance.vue'
import ProjectApproval from '../components/ProjectApproval.vue'
import ExpertManagement from '../components/ExpertManagement.vue'
import ExpertApproval from '../components/ExpertApproval.vue'
import ExpertMaintenance from '../components/ExpertMaintenance.vue'
import LogisticsMonitoring from '../components/LogisticsMonitoring.vue'
import LogisticsReporting from '../components/LogisticsReporting.vue'
import LogisticsOverview from '../components/LogisticsOverview.vue'
import ForwarderMaintenance from '../components/ForwarderMaintenance.vue'
import SubcontractMaintenance from '../components/SubcontractMaintenance.vue'
import SubcontractLogisticsMaintenance from '../components/SubcontractLogisticsMaintenance.vue'
import SubcontractLogisticsTest from '../components/SubcontractLogisticsTest.vue'
import ForwarderLogisticsMaintenance from '../components/ForwarderLogisticsMaintenance.vue'

import StaffManagement from '../components/StaffManagement.vue'
import DepartmentManagement from '../components/DepartmentManagement.vue'
import RoleManagement from '../components/RoleManagement.vue'

import MaterialEquipmentCategory from '../components/MaterialEquipmentCategory.vue'
import PriceMaintenance from '../components/PriceMaintenance.vue'
import PriceAdd from '../components/PriceAdd.vue'
import PartnerManagement from '../components/PartnerManagement.vue'
import ButtonStyleTest from '../views/ButtonStyleTest.vue'
import CheckboxStyleTest from '../views/CheckboxStyleTest.vue'
import BusinessScopeTooltipTest from '../views/BusinessScopeTooltipTest.vue'
import EvaluationApprovalList from '../components/EvaluationApprovalList.vue'
import PartnerEvaluationForm from '../components/PartnerEvaluation.vue'
import PartnerEvaluationList from '../components/PartnerEvaluationList.vue'
import PartnerEvaluationMaintenance from '../components/PartnerEvaluationMaintenance.vue'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/home',
    name: 'Home',
    component: Home
  },
  {
    path: '/statistics',
    name: 'EquipmentStatistics',
    component: EquipmentStatistics
  },
  {
    path: '/project-maintenance',
    name: 'ProjectMaintenance',
    component: ProjectMaintenance
  },
  {
    path: '/project-approval',
    name: 'ProjectApproval',
    component: ProjectApproval
  },
  {
    path: '/expert-management',
    name: 'ExpertManagement',
    component: ExpertManagement
  },
  {
    path: '/expert-approval',
    name: 'ExpertApproval',
    component: ExpertApproval
  },
  {
    path: '/expert-maintenance',
    name: 'ExpertMaintenance',
    component: ExpertMaintenance
  },
  {
    path: '/button-style-test',
    name: 'ButtonStyleTest',
    component: ButtonStyleTest
  },
  {
    path: '/checkbox-style-test',
    name: 'CheckboxStyleTest',
    component: CheckboxStyleTest
  },
  {
    path: '/business-scope-tooltip-test',
    name: 'BusinessScopeTooltipTest',
    component: BusinessScopeTooltipTest
  },
  {
    path: '/logistics-monitoring',
    name: 'LogisticsMonitoring',
    component: LogisticsMonitoring
  },
  {
    path: '/logistics-reporting',
    name: 'LogisticsReporting',
    component: LogisticsReporting
  },
  {
    path: '/logistics-overview',
    name: 'LogisticsOverview',
    component: LogisticsOverview
  },
  {
    path: '/forwarder-maintenance',
    name: 'ForwarderMaintenance',
    component: ForwarderMaintenance
  },
  {
    path: '/subcontract-maintenance',
    name: 'SubcontractMaintenance',
    component: SubcontractMaintenance
  },
  {
    path: '/subcontract-logistics-maintenance',
    name: 'SubcontractLogisticsMaintenance',
    component: SubcontractLogisticsTest
  },
  {
    path: '/forwarder-logistics-maintenance',
    name: 'ForwarderLogisticsMaintenance',
    component: ForwarderLogisticsMaintenance
  },

  {
    path: '/material-equipment-category',
    name: 'MaterialEquipmentCategory',
    component: MaterialEquipmentCategory
  },
  {
    path: '/price-maintenance',
    name: 'PriceMaintenance',
    component: PriceMaintenance
  },
  {
    path: '/price-add',
    name: 'PriceAdd',
    component: PriceAdd
  },
  {
    path: '/partner-management',
    name: 'PartnerManagement',
    component: PartnerManagement
  },
  {
    path: '/evaluation-approval-list',
    name: 'EvaluationApprovalList',
    component: EvaluationApprovalList
  },
  {
    path: '/partner-evaluation-form',
    name: 'PartnerEvaluationForm',
    component: PartnerEvaluationForm
  },
  {
    path: '/partner-evaluation-list',
    name: 'PartnerEvaluationList',
    component: PartnerEvaluationList
  },
  {
    path: '/partner-evaluation/add',
    name: 'PartnerEvaluationAdd',
    component: PartnerEvaluationMaintenance
  },
  {
    path: '/staff-management',
    name: 'StaffManagement',
    component: StaffManagement
  },
  {
    path: '/department-management',
    name: 'DepartmentManagement',
    component: DepartmentManagement
  },
  {
    path: '/role-management',
    name: 'RoleManagement',
    component: RoleManagement
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router