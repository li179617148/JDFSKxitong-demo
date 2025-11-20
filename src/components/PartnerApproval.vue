<template>
  <div class="partner-approval">
    <!-- 操作按钮区域 -->
    <div class="action-header">
      <div class="header-tabs">
        <button
          class="tab"
          :class="{ active: activeLeftTab === 'form' }"
          @click="activeLeftTab = 'form'"
        >流程表单</button>
        <button
          class="tab"
          :class="{ active: activeLeftTab === 'flow' }"
          @click="activeLeftTab = 'flow'"
        >流程图</button>
        <button
          class="tab"
          :class="{ active: activeLeftTab === 'status' }"
          @click="activeLeftTab = 'status'"
        >流程状态</button>
        <button
          class="tab"
          :class="{ active: activeLeftTab === 'resource' }"
          @click="activeLeftTab = 'resource'"
        >相关资源</button>
      </div>
      <div class="header-buttons">
          <button class="btn-primary" @click="handleSubmit">提交</button>
          <button class="btn-danger" @click="handleReturn">退回</button>
          <button class="btn-warning" @click="handleSave">暂存</button>
          <button class="btn-info" @click="handleCirculate">传阅</button>
        </div>
    </div>

    <div class="approval-content">
      <!-- 右侧审批表单区域 -->
      <div class="right-panel">
        <div class="approval-form" v-show="activeLeftTab === 'form'">
          <!-- 第一部分：审批意见 -->
          <div class="form-section">
            <h4>审批意见</h4>
            <textarea v-model="approvalOpinion" placeholder="请输入审批意见..." rows="6"></textarea>
          </div>

          <!-- 第二部分：流程节点列表 -->
          <div class="form-section">
            <h4>流程节点列表</h4>
            <table class="process-table">
              <thead>
                <tr>
                  <th>节点名称</th>
                  <th>操作部门</th>
                  <th>操作人</th>
                  <th>处理意见</th>
                  <th>操作时间</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(node, index) in processNodes" :key="index">
                  <td>{{ node.nodeName }}</td>
                  <td>{{ node.department }}</td>
                  <td>{{ node.operator }}</td>
                  <td>{{ node.opinion }}</td>
                  <td>{{ node.operateTime }}</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- 第三部分：合作方信息 -->
          <div class="form-section">
            <div class="partner-modal-content">
              <div class="modal-body">
                <!-- 页签导航 -->
                <div class="tab-navigation">
                  <div
                    v-for="(tab, index) in tabs"
                    :key="tab.id"
                    :class="['tab-item', { active: currentTab === index }]"
                    @click="switchTab(index)"
                  >
                    {{ tab.name }}
                  </div>
                </div>

                <!-- 页签内容 -->
                <div class="tab-content">
                  <!-- 基本资料页签 -->
                  <div v-if="currentTab === 0" class="tab-panel">
                    <div class="form-section">
                      <h4>基本信息</h4>
                      <div class="form-grid" style="grid-template-columns: repeat(2, 1fr);">
                        <div class="form-item">
                          <label>企业名称：</label>
                          <span>{{ partnerInfo.enterpriseName }}</span>
                        </div>
                        <div class="form-item">
                          <label>企业名称（当地语言）：</label>
                          <span>{{ partnerInfo.localEnterpriseName }}</span>
                        </div>
                        <div class="form-item">
                          <label>营业执照号：</label>
                          <span>{{ partnerInfo.businessLicenseNo }}</span>
                        </div>
                        <div class="form-item">
                          <label>注册地址：</label>
                          <span>{{ partnerInfo.registeredAddress }}</span>
                        </div>
                        <div class="form-item">
                          <label>往来单位类别：</label>
                          <span>{{ partnerInfo.partnerCategory }}</span>
                        </div>
                        <div class="form-item">
                          <label>办公地址：</label>
                          <span>{{ partnerInfo.officeAddress }}</span>
                        </div>
                        <div class="form-item">
                          <label>往来单位类型：</label>
                          <span>{{ partnerInfo.partnerType }}</span>
                        </div>
                        <div class="form-item">
                          <label>往来单位性质：</label>
                          <span>{{ partnerInfo.partnerNature }}</span>
                        </div>
                        <div class="form-item">
                          <label>中国交建下属单位：</label>
                          <span>{{ partnerInfo.isCccSubordinate }}</span>
                        </div>
                        <div class="form-item">
                          <label>上级企业：</label>
                          <span>{{ partnerInfo.parentEnterprise }}</span>
                        </div>
                        <div class="form-item">
                          <label>法定代表人：</label>
                          <span>{{ partnerInfo.legalRepresentative }}</span>
                        </div>
                        <div class="form-item">
                          <label>注册资本（人民币元）：</label>
                          <span>{{ partnerInfo.registeredCapital }}</span>
                        </div>
                        <div class="form-item">
                          <label>企业创建时间：</label>
                          <span>{{ partnerInfo.createTime }}</span>
                        </div>
                        <div class="form-item">
                          <label>公司网站：</label>
                          <span>{{ partnerInfo.website }}</span>
                        </div>
                        <div class="form-item">
                          <label>合作方归属：</label>
                          <span>{{ partnerInfo.partnerAffiliation }}</span>
                        </div>
                        <div class="form-item">
                          <label>合作方类型：</label>
                          <span>{{ partnerInfo.partnerType }}</span>
                        </div>
                        <div class="form-item">
                          <label>产业链类型：</label>
                          <span>{{ partnerInfo.industryChainType }}</span>
                        </div>
                        <div class="form-item">
                          <label>经营范围：</label>
                          <span>{{ partnerInfo.businessScope }}</span>
                        </div>
                        <div class="form-item">
                          <label>合作方等级：</label>
                          <span>{{ partnerInfo.partnerLevel }}</span>
                        </div>
                        <div class="form-item">
                          <label>公司规模（人）：</label>
                          <span>{{ partnerInfo.companyScale }}</span>
                        </div>
                        <div class="form-item">
                          <label>电话：</label>
                          <span>{{ partnerInfo.contactPhone }}</span>
                        </div>
                        <div class="form-item">
                          <label>邮政编码：</label>
                          <span>{{ partnerInfo.postalCode }}</span>
                        </div>
                        <div class="form-item">
                          <label>传真：</label>
                          <span>{{ partnerInfo.fax }}</span>
                        </div>
                        <div class="form-item">
                          <label>联系人：</label>
                          <span>{{ partnerInfo.contactPerson }}</span>
                        </div>
                        <div class="form-item">
                          <label>联系人邮箱：</label>
                          <span>{{ partnerInfo.contactEmail }}</span>
                        </div>
                        <div class="form-item full-width">
                          <label>企业简介：</label>
                          <span style="white-space: pre-wrap;">{{ partnerInfo.enterpriseIntro }}</span>
                        </div>
                      </div>
                    </div>

                    <!-- 证照信息 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>证照信息</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>证照类型</th>
                            <th>证照编码</th>
                            <th>有效日期</th>
                            <th>等级</th>
                            <th>备注</th>
                            <th>相关文件</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(license, index) in partnerInfo.licenseInfo" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ license.type }}</td>
                            <td>{{ license.code }}</td>
                            <td>{{ license.validDate }}</td>
                            <td>{{ license.level }}</td>
                            <td>{{ license.remark }}</td>
                            <td>{{ license.relatedFile }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 资质信息 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>资质信息</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>资质分类</th>
                            <th>等级</th>
                            <th>证书编号</th>
                            <th>资质规格/专项类别</th>
                            <th>备注</th>
                            <th>相关文件</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(item, index) in partnerInfo.qualificationInfo" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ item.classification }}</td>
                            <td>{{ item.level }}</td>
                            <td>{{ item.certificateNumber }}</td>
                            <td>{{ item.specification }}</td>
                            <td>{{ item.remark }}</td>
                            <td>{{ item.relatedFile }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 现场考察 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>现场考察</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>考察人员</th>
                            <th>考察地点</th>
                            <th>考察时间</th>
                            <th>意见汇总</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(item, index) in partnerInfo.siteInspections" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ item.inspector }}</td>
                            <td>{{ item.inspectionLocation }}</td>
                            <td>{{ item.inspectionTime }}</td>
                            <td>{{ item.summary }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 不良记录 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>不良记录</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>不良记录审查</th>
                            <th>处理人</th>
                            <th>处理部门</th>
                            <th>处理时间</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(item, index) in partnerInfo.badRecords" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ item.record }}</td>
                            <td>{{ item.handler }}</td>
                            <td>{{ item.department }}</td>
                            <td>{{ item.handleTime }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 供货（物资装备）清单 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>供货（物资装备）清单</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>一级名称</th>
                            <th>二级名称</th>
                            <th>物资装备名称</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(item, index) in partnerInfo.supplyList" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ item.firstLevelName }}</td>
                            <td>{{ item.secondLevelName }}</td>
                            <td>{{ item.equipmentName }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 推荐信息 -->
                    <div class="form-section">
                      <h4>推荐信息</h4>
                      <div class="form-grid" style="grid-template-columns: repeat(2, 1fr);">
                        <div class="form-item">
                          <label>推荐人：</label>
                          <span>{{ partnerInfo.recommendPerson }}</span>
                        </div>
                        <div class="form-item">
                          <label>推荐人单位：</label>
                          <span>{{ partnerInfo.recommendUnit }}</span>
                        </div>
                        <div class="form-item">
                          <label>推荐人电话：</label>
                          <span>{{ partnerInfo.recommendPhone }}</span>
                        </div>
                        <div class="form-item">
                          <label>推荐函：</label>
                          <span>{{ partnerInfo.recommendFile }}</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- 主要业务/业绩页签 -->
                  <div v-if="currentTab === 1" class="tab-panel">
                    <!-- 主要业务列表 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>主要业务</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>区域</th>
                            <th>专业</th>
                            <th>业务分类</th>
                            <th>专业明细</th>
                            <th>备注</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(business, index) in partnerInfo.mainBusinessList" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ business.region }}</td>
                            <td>{{ business.profession }}</td>
                            <td>{{ business.businessType }}</td>
                            <td>{{ business.detailType }}</td>
                            <td>{{ business.remark }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 主要业绩列表 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>主要业绩</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>项目名称</th>
                            <th>资金来源</th>
                            <th>项目业主名称</th>
                            <th>总包单位名称</th>
                            <th>咨工单位</th>
                            <th>开工时间</th>
                            <th>项目特点关键词</th>
                            <th>项目获奖情况</th>
                            <th>是否完工</th>
                            <th>附件</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(project, index) in partnerInfo.mainProjectsList" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ project.projectName }}</td>
                            <td>{{ project.fundingSource }}</td>
                            <td>{{ project.projectOwner }}</td>
                            <td>{{ project.generalContractor }}</td>
                            <td>{{ project.consultingUnit }}</td>
                            <td>{{ project.startDate }}</td>
                            <td>{{ project.projectFeatures }}</td>
                            <td>{{ project.projectAwards }}</td>
                            <td>{{ project.isCompleted }}</td>
                            <td>{{ project.attachment }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 近3年营业额列表 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>近3年营业额</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>年份</th>
                            <th>营业额金额</th>
                            <th>类型</th>
                            <th>币种</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(turnover, index) in partnerInfo.turnoverList" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ turnover.year }}</td>
                            <td>{{ turnover.amount }}</td>
                            <td>{{ turnover.amountType }}</td>
                            <td>{{ turnover.currency }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>

                  <!-- 联系人页签 -->
                  <div v-if="currentTab === 2" class="tab-panel">
                    <!-- 联系人信息 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>联系人信息</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>姓名</th>
                            <th>部门</th>
                            <th>职位</th>
                            <th>电话</th>
                            <th>邮箱</th>
                            <th>备注</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(person, index) in partnerInfo.contactPersonList" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ person.name }}</td>
                            <td>{{ person.department }}</td>
                            <td>{{ person.position }}</td>
                            <td>{{ person.phone }}</td>
                            <td>{{ person.email }}</td>
                            <td>{{ person.remark }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 专家信息 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>专家信息</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>姓名</th>
                            <th>出生日期</th>
                            <th>学历</th>
                            <th>职称</th>
                            <th>行业专业</th>
                            <th>专家简历</th>
                            <th>职业资格证书</th>
                            <th>附件</th>
                            <th>备注信息</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(expert, index) in partnerInfo.expertInfoList" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ expert.name }}</td>
                            <td>{{ expert.birthDate }}</td>
                            <td>{{ expert.education }}</td>
                            <td>{{ expert.title }}</td>
                            <td>{{ expert.industryMajor }}</td>
                            <td>{{ expert.expertResume }}</td>
                            <td>{{ expert.qualificationCertificate }}</td>
                            <td>{{ expert.attachment }}</td>
                            <td>{{ expert.remark }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 海外信息 -->
                    <div class="form-section">
                      <h4>海外信息</h4>
                      <div class="form-grid" style="grid-template-columns: repeat(3, 1fr);">
                        <div class="form-item">
                          <label>海外人员信息：</label>
                          <span>{{ partnerInfo.overseasInfo?.overseasPersonnel }}</span>
                        </div>
                        <div class="form-item">
                          <label>海外船机分布情况：</label>
                          <span>{{ partnerInfo.overseasInfo?.overseasVesselDistribution }}</span>
                        </div>
                        <div class="form-item">
                          <label>海外设备分布情况：</label>
                          <span>{{ partnerInfo.overseasInfo?.overseasEquipmentDistribution }}</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- 声明/证明材料页签 -->
                  <div v-if="currentTab === 3" class="tab-panel">
                    <!-- 声明材料 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>声明材料</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>声明材料</th>
                            <th>法律纠纷承诺</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(material, index) in partnerInfo.declarationMaterials" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ material.declarationMaterial }}</td>
                            <td>{{ material.legalDisputeCommitment }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <!-- 证明材料 -->
                    <div class="form-section">
                      <div class="section-header">
                        <h4>证明材料</h4>
                      </div>
                      <table class="sub-table">
                        <thead>
                          <tr>
                            <th width="60">序号</th>
                            <th>法人授权委托书原件</th>
                            <th>经审计的近三年的财务报告（复印件、加盖公章）</th>
                            <th>其他证明企业实力材料（如银行信誉等级、荣誉称号等）</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr v-for="(material, index) in partnerInfo.proofMaterials" :key="index">
                            <td>{{ index + 1 }}</td>
                            <td>{{ material.legalAuthorization }}</td>
                            <td>{{ material.auditedFinancialReport }}</td>
                            <td>{{ material.otherProofMaterials }}</td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          </div>

        <div class="info-section" v-show="activeLeftTab === 'flow'">
          <h4>流程图</h4>
          <div class="flow-chart-container">
            <div class="flow-chart">
              <!-- 开始节点 -->
              <div class="flow-node start">开始</div>
              
              <!-- 开始 → 发起 -->
              <div class="flow-arrow">→</div>
              
              <!-- 发起节点 -->
              <div class="flow-node active">发起</div>
              
              <!-- 发起 → 部门审核 -->
              <div class="flow-arrow">→</div>
              
              <!-- 部门审核节点 -->
              <div class="flow-node">分公司部门经理/项目经理审核</div>
              
              <!-- 部门审核 → 领导审批 -->
              <div class="flow-arrow">→</div>
              
              <!-- 领导审批节点 -->
              <div class="flow-node">分公司领导审批</div>
              
              <!-- 领导审批 → 结束 -->
              <div class="flow-arrow">→</div>
              
              <!-- 结束节点 -->
              <div class="flow-node end">结束</div>
            </div>
          </div>
        </div>

        <div class="info-section" v-show="activeLeftTab === 'status'">
          <h4>流程状态</h4>
          <div class="status-info">
            <p><strong>当前状态：</strong>待审批</p>
            <p><strong>当前节点：</strong>部门审批</p>
            <p><strong>发起时间：</strong>2024-01-15 10:30</p>
          </div>
        </div>

        <div class="info-section" v-show="activeLeftTab === 'resource'">
          <h4>相关资源</h4>
          <div class="resource-list">
            <div class="resource-item">营业执照.pdf</div>
            <div class="resource-item">资质证明.docx</div>
            <div class="resource-item">现场考察报告.pdf</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'PartnerApproval',
  data() {
    return {
      approvalOpinion: '',
      activeLeftTab: 'form',
      currentTab: 0, // 当前页签索引
      tabs: [
        { id: 'basic', name: '基本资料' },
        { id: 'business', name: '主要业务/业绩' },
        { id: 'contacts', name: '联系人' },
        { id: 'documents', name: '声明/证明材料' }
      ],
      processNodes: [
        {
          nodeName: '提交申请',
          department: '业务部门',
          operator: '张三',
          opinion: '提交合作方信息登记申请',
          operateTime: '2024-01-15 10:30'
        }
      ],
      partnerInfo: {
        enterpriseName: '北京建工集团',
        localEnterpriseName: '',
        businessLicenseNo: '91110000123456789X',
        registeredAddress: '北京市朝阳区',
        partnerCategory: '供应商',
        officeAddress: '北京市海淀区',
        partnerType: ['施工类'],
        partnerNature: '国有企业',
        isCccSubordinate: '是',
        parentEnterprise: '中国交建',
        legalRepresentative: '张三',
        registeredCapital: '5000',
        createTime: '2023-01-01',
        website: 'www.example.com',
        partnerAffiliation: '属地化',
        industryChainType: ['建筑', '道桥'],
        businessScope: ['建筑工程施工总承包', '市政公用工程施工总承包'],
        partnerLevel: 'A级',
        companyScale: '1000',
        contactPhone: '13800138000',
        postalCode: '100000',
        fax: '010-12345678',
        contactPerson: '张经理',
        contactEmail: 'zhang@example.com',
        enterpriseIntro: '大型建筑企业，具有丰富的施工经验，承建过多项国家重点工程',
        siteInspections: [
          { id: 1, inspector: '李四', inspectionLocation: '北京总部', inspectionTime: '2023-06-01', summary: '考察合格' }
        ],
        badRecords: [
          { id: 1, record: '无不良记录', handler: '王五', department: '质量部', handleTime: '2023-07-01' }
        ],
        licenseInfo: [
          {
            id: 1,
            type: '营业执照',
            code: '91110000123456789X',
            validDate: '2025-12-31',
            level: 'A级',
            remark: '有效期内',
            relatedFile: '营业执照.pdf'
          }
        ],
        qualificationInfo: [
          {
            id: 1,
            classification: '建筑业企业资质',
            level: '特级',
            certificateNumber: 'D111012345',
            specification: '建筑工程施工总承包',
            remark: '特级资质，可承担各类建筑工程施工总承包',
            relatedFile: '特级资质证书.pdf'
          }
        ],
        supplyList: [
          { id: 1, firstLevelName: '建筑材料', secondLevelName: '钢材', equipmentName: '螺纹钢' }
        ],
        recommendPerson: '张总',
        recommendUnit: '集团总部',
        recommendPhone: '13900139000',
        recommendFile: '推荐函.pdf',
        mainBusinessList: [
          {
            id: 1,
            region: '华北',
            profession: '施工类',
            businessType: '建筑工程施工总承包',
            detailType: '房屋建筑工程',
            remark: '房屋建筑工程施工总承包特级资质'
          }
        ],
        mainProjectsList: [
          {
            id: 1,
            projectName: '北京大厦建设项目',
            fundingSource: '政府投资',
            projectOwner: '北京政府',
            generalContractor: '北京建工集团',
            consultingUnit: '北京监理公司',
            startDate: '2023-01-01',
            projectFeatures: '高层建筑，绿色施工',
            projectAwards: '鲁班奖',
            isCompleted: '是',
            attachment: '项目报告.pdf'
          }
        ],
        turnoverList: [
          {
            id: 1,
            year: '2023',
            amount: '100000',
            amountType: '年度营业额',
            currency: '人民币'
          }
        ],
        contactPersonList: [
          {
            id: 1,
            name: '张经理',
            department: '业务部',
            position: '部门经理',
            phone: '13800138000',
            email: 'zhang@example.com',
            remark: '主要负责人'
          }
        ],
        expertInfoList: [
          {
            id: 1,
            name: '李工',
            birthDate: '1980-01-01',
            education: '本科',
            title: '高级工程师',
            industryMajor: '建筑工程',
            expertResume: '工程师简历.pdf',
            qualificationCertificate: '注册证书.pdf',
            attachment: '专业证书.pdf',
            remark: '资深工程师'
          }
        ],
        overseasInfo: {
          overseasPersonnel: '200人',
          overseasVesselDistribution: '东南亚、非洲',
          overseasEquipmentDistribution: '挖掘机、起重机等'
        },
        declarationMaterials: [
          {
            id: 1,
            declarationMaterial: '声明材料.pdf',
            legalDisputeCommitment: '法律纠纷承诺书.pdf'
          }
        ],
        proofMaterials: [
          {
            id: 1,
            legalAuthorization: '法人授权委托书.pdf',
            auditedFinancialReport: '审计报告.pdf',
            otherProofMaterials: '银行资信证明.pdf'
          }
        ]
      }
    }
  },
  methods: {
    // 切换页签
    switchTab(index) {
      this.currentTab = index
    },
    handleSubmit() {
      if (!this.approvalOpinion.trim()) {
        alert('请填写审批意见')
        return
      }
      alert('提交审批成功')
    },
    handleReturn() {
      if (!this.approvalOpinion.trim()) {
        alert('请填写退回意见')
        return
      }
      alert('退回成功')
    },
    handleSave() {
      alert('暂存成功')
    },
    handleCirculate() {
      alert('传阅功能')
    }
  }
}
</script>

<style scoped>
/* 页面主体样式 */
.partner-approval {
  padding: 20px;
  min-height: 100vh;
  overflow-y: auto;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  box-sizing: border-box;
}

/* 操作按钮区域 */
.action-header {
  background: white;
  padding: 20px;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.header-buttons {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
}








/* 头部页签样式 */
.header-tabs {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}
.header-tabs .tab {
  background: #f5f5f5;
  color: #555;
  border: 1px solid #e5e5e5;
  padding: 6px 12px;
  border-radius: 14px;
  cursor: pointer;
  font-size: 12px;
  line-height: 1;
}
.header-tabs .tab.active {
  background: #1890ff;
  color: #fff;
  border-color: #1890ff;
}

/* 主要内容区域 */
.approval-content {
  display: block;
}



.right-panel {
  flex: 1;
}

/* 左侧信息区域 */
.info-section {
  background: white;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.info-section h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
  border-left: 4px solid #1890ff;
  padding-left: 10px;
}

.form-content p {
  margin: 0;
  color: #666;
}

.flow-chart {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.flow-step {
  padding: 8px 12px;
  background: #f5f5f5;
  border-radius: 4px;
  font-size: 12px;
  text-align: center;
  min-width: 60px;
}

/* 流程图样式 */
.flow-chart-container {
  margin-top: 20px;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 8px;
  position: relative;
  min-height: 200px;
}

.flow-chart {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  position: relative;
}

.flow-node {
  padding: 12px 20px;
  margin: 10px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  text-align: center;
  min-width: 100px;
  background-color: #e9ecef;
  border: 2px solid #dee2e6;
  transition: all 0.3s ease;
}

.flow-node.start,
.flow-node.end {
  background-color: #6c757d;
  color: white;
  border-color: #6c757d;
  border-radius: 50%;
  min-width: 80px;
  min-height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.flow-node.active {
  background-color: #007bff;
  color: white;
  border-color: #007bff;
  box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
}

.flow-arrow {
  font-size: 20px;
  color: #666;
  margin: 0 5px;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .flow-chart {
    flex-direction: column;
  }
  
  .flow-arrow {
    transform: rotate(90deg);
  }
}

.flow-step.current {
  background: #1890ff;
  color: white;
}

.flow-arrow {
  color: #999;
  font-weight: bold;
}

.status-info p {
  margin: 8px 0;
  font-size: 14px;
}

.resource-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.resource-item {
  padding: 6px 10px;
  background: #f8f9fa;
  border-radius: 4px;
  font-size: 12px;
  color: #666;
}

/* 审批表单区域 */
.approval-form {
  background: white;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 20px;
  width: 100%;
  max-width: none;
}

.form-section {
  margin-bottom: 30px;
}

.form-section h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
  border-left: 4px solid #1890ff;
  padding-left: 10px;
}

.form-section textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  resize: vertical;
  font-size: 14px;
  box-sizing: border-box;
}

/* 流程节点表格 */
.process-table {
  width: 100%;
  border-collapse: collapse;
}

.process-table th,
.process-table td {
  padding: 10px;
  border: 1px solid #e8e8e8;
  text-align: center;
  font-size: 12px;
}

.process-table th {
  background: #fafafa;
  font-weight: 600;
  color: #333;
}

/* 合作方信息 */
.partner-info {
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  padding: 20px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.info-item {
  display: flex;
  align-items: center;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-item label {
  font-weight: 500;
  color: #333;
  min-width: 150px;
  text-align: right;
  margin-right: 10px;
}

.info-item span {
  color: #666;
  flex: 1;
}

/* 合作方信息区域样式 */
.partner-modal-content {
  background: white;
  border-radius: 6px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: none;
  width: 100%;
  max-width: 1200px;
  min-height: 600px;
  margin: 0 auto;
  padding: 0;
}

.partner-modal-header {
  padding: 20px 20px 0 20px;
}

.partner-modal-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
  border-left: 4px solid #1890ff;
  padding-left: 10px;
}

.modal-body {
  padding: 20px;
  width: 100%;
}

/* 页签导航样式 */
.tab-navigation {
  display: flex;
  gap: 2px;
  border-bottom: 2px solid #e8e8e8;
  margin-bottom: 20px;
  width: 100%;
}

.tab-item {
  padding: 10px 16px;
  cursor: pointer;
  border: none;
  background: #f5f5f5;
  color: #666;
  font-size: 14px;
  font-weight: 500;
  border-bottom: 2px solid transparent;
  transition: all 0.3s ease;
  position: relative;
}

.tab-item.active {
  background: white;
  color: #1890ff;
  border-bottom: 2px solid #1890ff;
  font-weight: 600;
}

.tab-item:hover:not(.active) {
  background: #fafafa;
  color: #333;
}

/* 页签内容样式 */
.tab-content {
  margin-top: 20px;
  width: 100%;
}

.tab-panel {
  background: white;
  border-radius: 6px;
  padding: 20px;
  width: 100%;
}

.form-section {
  margin-bottom: 20px;
}

.form-section h4 {
  margin: 0 0 15px 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
  border-left: 4px solid #1890ff;
  padding-left: 10px;
  margin-bottom: 10px;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 15px;
}

.section-header h4 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #333;
  border-left: 4px solid #1890ff;
  padding-left: 8px;
  margin-bottom: 0;
}

/* 表单网格布局 */
.form-grid {
  display: grid;
  gap: 16px;
  align-items: start;
  grid-template-columns: repeat(4, 1fr);
  width: 100%;
}

.form-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.form-item label {
  font-size: 12px;
  color: #666;
  font-weight: 500;
  white-space: nowrap;
  min-width: 140px;
  text-align: right;
}

.form-item span {
  font-size: 12px;
  color: #333;
  font-weight: 500;
  background: #f8f9fa;
  padding: 4px 8px;
  border-radius: 4px;
  border: 1px solid #e9ecef;
  min-height: 20px;
  display: inline-block;
  flex: 1;
}

.form-item.full-width {
  grid-column: 1 / -1;
}

.form-item.full-width label {
  min-width: 140px;
}

/* 子表格样式 */
.sub-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
  font-size: 12px;
  table-layout: auto;
  min-width: 800px;
}

.sub-table th,
.sub-table td {
  padding: 8px 12px;
  text-align: left;
  border: 1px solid #e8e8e8;
}

.sub-table th {
  background: #fafafa;
  font-weight: 600;
  color: #333;
  font-size: 12px;
}

.sub-table td {
  background: white;
  color: #666;
  font-size: 12px;
}

.sub-table tr:nth-child(even) td {
  background: #f9f9f9;
}

.sub-table tr:hover td {
  background: #f0f8ff;
}



</style>