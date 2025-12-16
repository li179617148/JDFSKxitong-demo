<template>
  <div class="partner-management">
    
    <!-- 搜索区域 -->
    <div class="search-area">
      <div class="search-form">
        <div class="form-row">
          <div class="form-item">
            <label>合作方类型：</label>
            <div class="partner-type-dropdown">
              <div class="multi-select-component">
                <div
                  class="multi-select-input"
                  @click="toggleSearchPartnerTypeDropdown"
                >
                  <div class="selected-items">
                    <span
                      v-for="(item, index) in searchParams.partnerType"
                      :key="index"
                      class="selected-item"
                    >
                      {{ getPartnerTypeLabel(item) }}
                      <button
                        @click.stop="removeSearchPartnerType(index)"
                        class="remove-btn"
                      >×</button>
                    </span>
                    <span v-if="searchParams.partnerType.length === 0" class="placeholder">
                      全部类型
                    </span>
                  </div>
                  <div class="dropdown-arrow" :class="{ 'active': searchPartnerTypeDropdownOpen }"></div>
                </div>

                <!-- 下拉选项 -->
                <div v-if="searchPartnerTypeDropdownOpen" class="dropdown-options">
                  <div
                    v-for="option in availableSearchPartnerTypes"
                    :key="option.value"
                    class="dropdown-option"
                    @click="selectSearchPartnerType(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="form-item">
            <label>产业链类型：</label>
            <div class="industry-chain-dropdown">
              <div class="multi-select-component">
                <div
                  class="multi-select-input"
                  @click="toggleSearchIndustryChainDropdown"
                >
                  <div class="selected-items">
                    <span
                      v-for="(item, index) in searchParams.industryChainType"
                      :key="index"
                      class="selected-item"
                    >
                      {{ getIndustryChainLabel(item) }}
                      <button
                        @click.stop="removeSearchIndustryChainType(index)"
                        class="remove-btn"
                      >×</button>
                    </span>
                    <span v-if="searchParams.industryChainType.length === 0" class="placeholder">
                      全部类型
                    </span>
                  </div>
                  <div class="dropdown-arrow" :class="{ 'active': searchIndustryChainDropdownOpen }"></div>
                </div>

                <!-- 下拉选项 -->
                <div v-if="searchIndustryChainDropdownOpen" class="dropdown-options">
                  <div
                    v-for="option in availableSearchIndustryChainTypes"
                    :key="option.value"
                    class="dropdown-option"
                    @click="selectSearchIndustryChainType(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="form-item">
            <label>经营范围：</label>
            <div class="business-scope-dropdown">
              <div class="multi-select-component">
                <div
                  class="multi-select-input"
                  @click="toggleSearchBusinessScopeDropdown"
                >
                  <div class="selected-items">
                    <span
                      v-for="(item, index) in searchParams.businessScope"
                      :key="index"
                      class="selected-item"
                    >
                      {{ getBusinessScopeLabel(item) }}
                      <button
                        @click.stop="removeSearchBusinessScope(index)"
                        class="remove-btn"
                      >×</button>
                    </span>
                    <span v-if="searchParams.businessScope.length === 0" class="placeholder">
                      全部范围
                    </span>
                  </div>
                  <div class="dropdown-arrow" :class="{ 'active': searchBusinessScopeDropdownOpen }"></div>
                </div>

                <!-- 下拉选项 -->
                <div v-if="searchBusinessScopeDropdownOpen" class="dropdown-options">
                  <div
                    v-for="option in availableSearchBusinessScopes"
                    :key="option.value"
                    class="dropdown-option"
                    @click="selectSearchBusinessScope(option)"
                  >
                    {{ option.label }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="form-row">
          <div class="form-item">
            <label>合作方名称：</label>
            <input type="text" v-model="searchParams.partnerName" placeholder="请输入合作方名称">
          </div>
          <div class="form-item">
            <label>联系人：</label>
            <input type="text" v-model="searchParams.contactPerson" placeholder="请输入联系人">
          </div>
          <div class="form-item">
            <label>供货名称：</label>
            <input type="text" v-model="searchParams.supplyName" placeholder="请输入供货名称">
          </div>
        </div>
        <div class="form-row">
          <div class="form-item" style="max-width: 250px;">
            <label>国别：</label>
            <select v-model="searchParams.country" class="country-select">
              <option value="">全部</option>
              <option v-for="country in countryOptions" :key="country" :value="country">{{ country }}</option>
            </select>
          </div>
        </div>
        <div class="form-row">
          <div class="form-item checkbox-item">
            <label class="checkbox-label">
              <input type="checkbox" v-model="searchParams.showDeleted">
              显示已删除的合作方
            </label>
          </div>
          <div class="form-item button-group">
            <button class="btn-primary" @click="handleSearch">查询</button>
            <button class="btn-secondary" @click="handleReset">重置</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 列表区域 -->
    <div class="table-area">
      <div class="table-header">
        <div class="header-buttons">
            <button class="btn-info" style="padding: 7px 14px; font-size: 13px;" @click="downloadImportTemplate">导入模板下载</button>
            <input ref="importFile" type="file" @change="handleImport" accept=".csv" style="display: none;" />
            <button class="btn-info" style="padding: 7px 14px; font-size: 13px;" @click="triggerImport">导入</button>
            <button class="btn-success" style="padding: 7px 14px; font-size: 13px;" @click="handleAdd">新增</button>
            <button class="btn-info" style="padding: 7px 14px; font-size: 13px;" @click="handleExport">导出</button>
          </div>
      </div>
      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>序号</th>
              <th>合作方类型</th>
              <th>合作方名称</th>
              <th>产业链类型</th>
              <th>经营范围</th>
              <th>国别</th>
              <th>最新评价</th>
              <th>合作方状态</th>
              <th>审批状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(partner, index) in filteredPartners" :key="partner.id">
              <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
              <td>
                <div class="partner-type-display">
                  <span v-if="partner.partnerType && partner.partnerType.length > 0">
                    {{ partner.partnerType.map(type => getPartnerTypeLabel(type)).join('、') }}
                  </span>
                  <span v-else style="color: #999;">
                    暂无
                  </span>
                </div>
              </td>
              <td>{{ partner.enterpriseName }}</td>
              <td>
                <div class="industry-chain-display">
                  <span v-if="partner.industryChainType && partner.industryChainType.length > 0">
                    {{ partner.industryChainType.map(chain => getIndustryChainLabel(chain)).join('、') }}
                  </span>
                  <span v-else style="color: #999;">
                    暂无
                  </span>
                </div>
              </td>
              <td>
                <div class="business-scope-display">
                  <span v-if="partner.businessScope && partner.businessScope.length > 0">
                    {{ partner.businessScope.map(scope => getBusinessScopeLabel(scope)).join('、') }}
                  </span>
                  <span v-else style="color: #999;">
                    暂无
                  </span>
                </div>
              </td>
              <td>
                <div class="country-display">
                  <span v-if="partner.country">
                    {{ partner.country }}
                  </span>
                  <span v-else style="color: #999;">
                    暂无
                  </span>
                </div>
              </td>
              <td>
                <div class="evaluation-cell">
                  <span :class="['evaluation', getEvaluationClass(partner.evaluation)]">
                    {{ partner.evaluation }}
                  </span>
                  <span v-if="partner.status === 'deleted'" class="deleted-badge">
                    (已删除)
                  </span>
                </div>
              </td>
              <td>
                <span v-if="partner.status === 'active'" class="status-active">正常</span>
                <span v-else-if="partner.status === 'deleted'" class="status-deleted">已删除</span>
              </td>
              <td>
                <span :class="['approval-status', partner.approvalStatus]">
                  {{ getApprovalStatusText(partner.approvalStatus) }}
                </span>
              </td>
              <td>
                <button class="btn-primary" @click="handleView(partner)">查看</button>
                <!-- 审批中状态：只显示查看和撤回按钮 -->
                <template v-if="partner.approvalStatus === 'approving'">
                  <button class="btn-primary" @click="handleWithdraw(partner)">撤回</button>
                </template>
                <!-- 其他状态：显示编辑和删除按钮 -->
                <template v-else>
                  <button
                    v-if="partner.approvalStatus !== 'approving'"
                    class="btn-primary"
                    @click="handleEdit(partner)"
                    :disabled="partner.approvalStatus === 'completed'"
                  >编辑</button>
                  <button
                    class="btn-primary"
                    @click="handleDelete(partner.id)"
                    :disabled="partner.status === 'deleted'"
                  >删除</button>
                </template>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <button class="btn-secondary" @click="prevPage" :disabled="currentPage === 1">上一页</button>
        <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
        <button class="btn-secondary" @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
      </div>
    </div>

    <!-- 合作方信息登记表弹窗 -->
    <div v-if="showAddModal" class="partner-modal-overlay">
      <div class="partner-modal-content">
        <div class="partner-modal-header">
          <h3>{{ isViewMode ? '查看合作方信息' : (currentPartnerId ? '编辑合作方信息' : '合作方信息登记表') }}</h3>
          <div v-if="!isViewMode" class="partner-modal-action-buttons">
            <!-- 根据当前页签显示不同的按钮 -->
            <template v-if="currentTab === 3">
              <!-- 声明/证明材料页签显示保存、提交、取消按钮 -->
              <button class="btn-primary btn-sm" @click="savePartner">保存</button>
              <button class="btn-primary btn-sm" @click="submitPartner">提交</button>
              <button class="btn-secondary btn-sm" @click="closeAddModal">取消</button>
            </template>
            <template v-else>
              <!-- 其他页签显示保存并下一步、取消按钮 -->
              <button class="btn-primary btn-sm" @click="saveAndContinue">保存并下一步</button>
              <button class="btn-secondary btn-sm" @click="closeAddModal">取消</button>
            </template>
          </div>
          <div v-else class="partner-modal-action-buttons">
            <button class="btn-secondary btn-sm" @click="closeAddModal">关闭</button>
          </div>
        </div>

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
                    <label>企业名称<span class="required">*</span>：</label>
                    <input type="text" v-model="newPartner.enterpriseName" :disabled="isViewMode" >
                  </div>
                  <div class="form-item">
                    <label>企业名称（当地语言）：</label>
                    <input type="text" v-model="newPartner.localEnterpriseName" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>营业执照号<span class="required">*</span>：</label>
                    <input type="text" v-model="newPartner.businessLicenseNo" :disabled="isViewMode" >
                  </div>
                  <div class="form-item">
                    <label>注册地址：</label>
                    <input type="text" v-model="newPartner.registeredAddress" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>往来单位类别：</label>
                    <input type="text" v-model="newPartner.partnerCategory" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>办公地址：</label>
                    <input type="text" v-model="newPartner.officeAddress" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>国别：</label>
                    <select v-model="newPartner.country" :disabled="isViewMode">
                      <option value="">请选择</option>
                      <option v-for="country in countryOptions" :key="country" :value="country">{{ country }}</option>
                    </select>
                  </div>
                  <div class="form-item">
                    <label>往来单位类型：</label>
                    <input type="text" v-model="newPartner.businessContactType" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>往来单位性质<span class="required">*</span>：</label>
                    <select v-model="newPartner.partnerNature" :disabled="isViewMode" >
                      <option value="">请选择</option>
                      <option value="国有企业">国有企业</option>
                      <option value="民营企业">民营企业</option>
                      <option value="外资企业">外资企业</option>
                      <option value="合资企业">合资企业</option>
                      <option value="其他">其他</option>
                    </select>
                  </div>
                  <div class="form-item">
                    <label>中国交建下属单位<span class="required">*</span>：</label>
                    <select v-model="newPartner.isCccSubordinate" :disabled="isViewMode" >
                      <option value="">请选择</option>
                      <option value="是">是</option>
                      <option value="否">否</option>
                    </select>
                  </div>
                  <div class="form-item">
                    <label>上级企业：</label>
                    <input type="text" v-model="newPartner.parentEnterprise" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>法定代表人<span class="required">*</span>：</label>
                    <input type="text" v-model="newPartner.legalRepresentative" :disabled="isViewMode" >
                  </div>
                  <div class="form-item">
                    <label>注册资本（人民币元）<span class="required">*</span>：</label>
                    <input type="number" v-model="newPartner.registeredCapital" :disabled="isViewMode" >
                  </div>
                  <div class="form-item">
                    <label>企业创建时间<span class="required">*</span>：</label>
                    <input type="date" v-model="newPartner.createTime" :disabled="isViewMode" >
                  </div>
                  <div class="form-item">
                    <label>公司网站：</label>
                    <input type="url" v-model="newPartner.website" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>合作方归属<span class="required">*</span>：</label>
                    <select v-model="newPartner.partnerAffiliation" :disabled="isViewMode" >
                      <option value="">请选择</option>
                      <option value="属地化">属地化</option>
                      <option value="总部">总部</option>
                    </select>
                  </div>
                  <div class="form-item">
                    <label>合作方类型<span class="required">*</span>：</label>
                    <div class="partner-type-dropdown">
                      <div class="multi-select-component">
                        <div
                          class="multi-select-input"
                          @click="togglePartnerTypeDropdown"
                          :class="{ 'disabled': isViewMode && currentPartnerId }"
                        >
                          <div class="selected-items">
                            <span
                              v-for="(item, index) in newPartner.partnerType"
                              :key="index"
                              class="selected-item"
                            >
                              {{ getPartnerTypeLabel(item) }}
                              <button
                                v-if="!isViewMode"
                                @click.stop="removePartnerType(index)"
                                class="remove-btn"
                              >×</button>
                            </span>
                            <span v-if="newPartner.partnerType.length === 0" class="placeholder">
                              请选择合作方类型
                            </span>
                          </div>
                          <div class="dropdown-arrow" :class="{ 'active': partnerTypeDropdownOpen }"></div>
                        </div>

                        <!-- 下拉选项 -->
                        <div v-if="partnerTypeDropdownOpen" class="dropdown-options">
                          <div
                            v-for="option in availablePartnerTypes"
                            :key="option.value"
                            class="dropdown-option"
                            @click="selectPartnerType(option)"
                          >
                            {{ option.label }}
                          </div>
                          <div v-if="availablePartnerTypes.length === 0" class="no-options">
                            没有更多选项
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="form-item">
                    <label>产业链类型<span class="required">*</span>：</label>
                    <div class="industry-chain-dropdown">
                      <div class="multi-select-component">
                        <div
                          class="multi-select-input"
                          @click="toggleIndustryChainDropdown"
                          :class="{ 'disabled': isViewMode && currentPartnerId }"
                        >
                          <div class="selected-items">
                            <span
                              v-for="(item, index) in newPartner.industryChainType"
                              :key="index"
                              class="selected-item"
                            >
                              {{ getIndustryChainLabel(item) }}
                              <button
                                v-if="!isViewMode"
                                @click.stop="removeIndustryChainType(index)"
                                class="remove-btn"
                              >×</button>
                            </span>
                            <span v-if="newPartner.industryChainType.length === 0" class="placeholder">
                              请选择产业链类型
                            </span>
                          </div>
                          <div class="dropdown-arrow" :class="{ 'active': industryChainDropdownOpen }"></div>
                        </div>

                        <!-- 下拉选项 -->
                        <div v-if="industryChainDropdownOpen && (!isViewMode || !currentPartnerId)" class="dropdown-options">
                          <div
                            v-for="option in availableIndustryChainTypes"
                            :key="option.value"
                            class="dropdown-option"
                            @click="selectIndustryChainType(option)"
                          >
                            {{ option.label }}
                          </div>
                          <div v-if="availableIndustryChainTypes.length === 0" class="no-options">
                            没有更多选项
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="form-item">
                    <label>经营范围<span class="required">*</span>：</label>
                    <div v-if="businessScopeError" class="error-message">{{ businessScopeError }}</div>

                    <!-- 内嵌式多选下拉控件 -->
                    <div class="business-scope-dropdown">
                      <div class="multi-select-component">
                        <div
                          class="multi-select-input"
                          @click="toggleBusinessScopeDropdown"
                          :class="{ 'disabled': isViewMode && currentPartnerId }"
                        >
                          <div class="selected-items">
                            <span
                              v-for="(item, index) in newPartner.businessScope"
                              :key="index"
                              class="selected-item"
                            >
                              {{ getBusinessScopeLabel(item) }}
                              <button
                                v-if="!isViewMode"
                                @click.stop="removeBusinessScope(index)"
                                class="remove-btn"
                              >×</button>
                            </span>
                            <span v-if="newPartner.businessScope.length === 0" class="placeholder">
                              请选择经营范围
                            </span>
                          </div>
                          <div class="dropdown-arrow" :class="{ 'active': businessScopeDropdownOpen }"></div>
                        </div>

                        <!-- 下拉选项 -->
                        <div v-if="businessScopeDropdownOpen && (!isViewMode || !currentPartnerId)" class="dropdown-options">
                          <div
                            v-for="option in availableBusinessScopes"
                            :key="option.value"
                            class="dropdown-option"
                            @click="selectBusinessScope(option)"
                          >
                            {{ option.label }}
                          </div>
                          <div v-if="availableBusinessScopes.length === 0" class="no-options">
                            没有更多选项
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="form-item">
                    <label>合作方等级<span class="required">*</span>：</label>
                    <select v-model="newPartner.partnerLevel" :disabled="isViewMode" >
                      <option value="">请选择</option>
                      <option value="A级">A级</option>
                      <option value="B级">B级</option>
                      <option value="C级">C级</option>
                      <option value="D级">D级</option>
                    </select>
                  </div>
                  <div class="form-item">
                    <label>公司规模（人）<span class="required">*</span>：</label>
                    <input type="number" v-model="newPartner.companyScale" :disabled="isViewMode" placeholder="请输入人数">
                  </div>
                  <div class="form-item">
                    <label>电话<span class="required">*</span>：</label>
                    <input type="tel" v-model="newPartner.contactPhone" :disabled="isViewMode" >
                  </div>
                  <div class="form-item">
                    <label>邮政编码：</label>
                    <input type="text" v-model="newPartner.postalCode" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>传真：</label>
                    <input type="text" v-model="newPartner.fax" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>联系人：</label>
                    <input type="text" v-model="newPartner.contactPerson" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>联系人邮箱：</label>
                    <input type="email" v-model="newPartner.contactEmail" :disabled="isViewMode">
                  </div>
                  <div class="form-item full-width">
                    <label>企业简介<span class="required">*</span>：</label>
                    <textarea v-model="newPartner.enterpriseIntro" rows="4" :disabled="isViewMode"  style="width: 100%;"></textarea>
                  </div>
                </div>
              </div>

              <!-- 证照信息 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>证照信息<span class="required">*</span></h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addLicenseInfo">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedLicenseInfo" :disabled="!hasSelectedLicenseInfo">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
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
                    <tr v-for="(license, index) in newPartner.licenseInfo" :key="license.id">
                      <td>
                        <input type="checkbox" v-model="license.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <span>{{ license.type }}</span>
                      </td>
                      <td>
                        <span>{{ license.code }}</span>
                      </td>
                      <td>
                        <span>{{ license.validDate }}</span>
                      </td>
                      <td>
                        <span>{{ license.level }}</span>
                      </td>
                      <td>
                        <span>{{ license.remark }}</span>
                      </td>
                      <td>
                        <span>{{ license.relatedFile }}</span>
                      </td>
                    </tr>
                    <tr v-if="newPartner.licenseInfo.length === 0">
                      <td colspan="8" style="text-align: center; padding: 20px; color: #999;">
                        暂无证照信息，点击右上角"新增"按钮添加
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 资质信息 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>资质信息</h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addQualificationInfo">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedQualificationInfo" :disabled="!hasSelectedQualificationInfo">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
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
                    <tr v-for="(item, index) in newPartner.qualificationInfo" :key="item.id">
                      <td>
                        <input type="checkbox" v-model="item.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <span>{{ item.classification }}</span>
                      </td>
                      <td>
                        <span>{{ item.level }}</span>
                      </td>
                      <td>
                        <span>{{ item.certificateNumber }}</span>
                      </td>
                      <td>
                        <span>{{ item.specification }}</span>
                      </td>
                      <td>
                        <span>{{ item.remark }}</span>
                      </td>
                      <td>
                        <span>{{ item.relatedFile }}</span>
                      </td>
                    </tr>
                    <tr v-if="!newPartner.qualificationInfo || newPartner.qualificationInfo.length === 0">
                      <td colspan="8" style="text-align: center; padding: 20px; color: #999;">
                        暂无资质信息，点击右上角"新增"按钮添加
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 现场考察 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>现场考察</h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addSiteInspection">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedSiteInspections" :disabled="!hasSelectedSiteInspections">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
                      <th width="60">序号</th>
                      <th>考察人员</th>
                      <th>考察地点</th>
                      <th>考察时间</th>
                      <th>意见汇总</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(item, index) in newPartner.siteInspections" :key="item.id">
                      <td>
                        <input type="checkbox" v-model="item.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <span>{{ item.inspector }}</span>
                      </td>
                      <td>
                        <span>{{ item.inspectionLocation }}</span>
                      </td>
                      <td>
                        <span>{{ item.inspectionTime }}</span>
                      </td>
                      <td>
                        <span>{{ item.summary }}</span>
                      </td>
                    </tr>
                    <tr v-if="newPartner.siteInspections.length === 0">
                      <td colspan="6" style="text-align: center; padding: 20px; color: #999;">
                        暂无现场考察记录，点击右上角"新增"按钮添加
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 不良记录 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>不良记录</h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addBadRecord">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedBadRecords" :disabled="!hasSelectedBadRecords">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
                      <th width="60">序号</th>
                      <th>不良记录审查</th>
                      <th>处理人</th>
                      <th>处理部门</th>
                      <th>处理时间</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(item, index) in newPartner.badRecords" :key="item.id">
                      <td>
                        <input type="checkbox" v-model="item.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <span>{{ item.record }}</span>
                      </td>
                      <td>
                        <span>{{ item.handler }}</span>
                      </td>
                      <td>
                        <span>{{ item.department }}</span>
                      </td>
                      <td>
                        <span>{{ item.handleTime }}</span>
                      </td>
                    </tr>
                    <tr v-if="newPartner.badRecords.length === 0">
                      <td colspan="6" style="text-align: center; padding: 20px; color: #999;">
                        暂无不良记录，点击右上角"新增"按钮添加
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 供货（物资装备）清单 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>供货（物资装备）清单</h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addSupplyItem">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedSupplyItems" :disabled="!hasSelectedSupplyItems">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
                      <th width="60">序号</th>
                      <th>一级名称</th>
                      <th>二级名称</th>
                      <th>物资装备名称</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(item, index) in newPartner.supplyList" :key="item.id">
                      <td>
                        <input type="checkbox" v-model="item.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <span>{{ item.firstLevelName }}</span>
                      </td>
                      <td>
                        <span>{{ item.secondLevelName }}</span>
                      </td>
                      <td>
                        <span>{{ item.equipmentName }}</span>
                      </td>
                    </tr>
                    <tr v-if="newPartner.supplyList.length === 0">
                      <td colspan="5" style="text-align: center; padding: 20px; color: #999;">
                        暂无供货清单，点击右上角"新增"按钮添加
                      </td>
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
                    <input type="text" v-model="newPartner.recommendPerson" :disabled="isViewMode" >
                  </div>
                  <div class="form-item">
                    <label>推荐人单位：</label>
                    <input type="text" v-model="newPartner.recommendUnit" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>推荐人电话：</label>
                    <input type="tel" v-model="newPartner.recommendPhone" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>推荐函：</label>
                    <div class="file-upload-section">
                      <div class="file-upload">
                        <input
                          type="file"
                          @change="handleRecommendFileUpload"
                          :disabled="isViewMode"
                          accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                          style="display: none;"
                          :id="'recommend-file-input'"
                        >
                        <label :for="'recommend-file-input'" :class="{ 'disabled': isViewMode }">
                          <span v-if="!newPartner.recommendFile" class="upload-text">选择文件</span>
                          <span v-else class="upload-text">{{ newPartner.recommendFile }}</span>
                        </label>
                      </div>
                      <div v-if="newPartner.recommendFile" class="file-info">
                        <span class="file-name">{{ newPartner.recommendFile }}</span>
                        <button
                          v-if="!isViewMode"
                          @click="removeRecommendFile"
                          class="file-remove-btn"
                        >×</button>
                      </div>
                    </div>
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
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addMainBusiness">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedMainBusiness" :disabled="!hasSelectedMainBusiness">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
                      <th width="60">序号</th>
                      <th>区域</th>
                      <th>专业</th>
                      <th>业务分类</th>
                      <th>专业明细</th>
                      <th>备注</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(business, index) in newPartner.mainBusinessList" :key="business.id">
                      <td>
                        <input type="checkbox" v-model="business.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <select v-model="business.region" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                          <option value="">请选择</option>
                          <option v-for="option in regionOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                        </select>
                      </td>
                      <td>
                        <select v-model="business.profession" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                          <option value="">请选择</option>
                          <option v-for="option in professionOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                        </select>
                      </td>
                      <td>
                        <select v-model="business.businessType" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                          <option value="">请选择</option>
                          <option v-for="option in businessScopeOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                        </select>
                      </td>
                      <td>
                        <select v-model="business.detailType" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                          <option value="">请选择</option>
                          <option v-for="option in businessScopeOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                        </select>
                      </td>
                      <td>
                        <input type="text" v-model="business.remark" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                    </tr>
                    <tr v-if="newPartner.mainBusinessList.length === 0">
                      <td colspan="7" style="text-align: center; padding: 20px; color: #999;">
                        暂无主要业务，点击右上角"新增"按钮添加
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 主要业绩列表 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>主要业绩</h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addMainProject">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedMainProjects" :disabled="!hasSelectedMainProjects">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
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
                    <tr v-for="(project, index) in newPartner.mainProjectsList" :key="project.id">
                      <td>
                        <input type="checkbox" v-model="project.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <input type="text" v-model="project.projectName" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="project.fundingSource" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="project.projectOwner" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="project.generalContractor" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="project.consultingUnit" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="date" v-model="project.startDate" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="project.projectFeatures" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="project.projectAwards" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <div style="display: flex; gap: 10px; justify-content: center;">
                          <label style="display: flex; align-items: center;">
                            <input type="radio" :name="`isCompleted-${project.id}`" value="是" v-model="project.isCompleted" :disabled="isViewMode">
                            是
                          </label>
                          <label style="display: flex; align-items: center;">
                            <input type="radio" :name="`isCompleted-${project.id}`" value="否" v-model="project.isCompleted" :disabled="isViewMode">
                            否
                          </label>
                        </div>
                      </td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="project.attachment">{{ project.attachment }}</span>
                          <span v-else style="color: #999;">无附件</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleProjectAttachment($event, project.id)"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`project-file-${project.id}`"
                          >
                          <label :for="`project-file-${project.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ project.attachment || '选择文件' }}
                          </label>
                        </div>
                      </td>
                    </tr>
                    <tr v-if="newPartner.mainProjectsList.length === 0">
                      <td colspan="12" style="text-align: center; padding: 20px; color: #999;">
                        暂无主要业绩，点击右上角"新增"按钮添加
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 近3年营业额列表 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>近3年营业额</h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addTurnover">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedTurnovers" :disabled="!hasSelectedTurnovers">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
                      <th width="60">序号</th>
                      <th>年份</th>
                      <th>营业额金额</th>
                      <th>类型</th>
                      <th>币种</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(turnover, index) in newPartner.turnoverList" :key="turnover.id">
                      <td>
                        <input type="checkbox" v-model="turnover.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <select v-model="turnover.year" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                          <option value="">请选择</option>
                          <option v-for="option in yearOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                        </select>
                      </td>
                      <td>
                        <input type="number" v-model="turnover.amount" :disabled="isViewMode" style="width: 100%; padding: 4px;" placeholder="请输入金额">
                      </td>
                      <td>
                        <select v-model="turnover.amountType" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                          <option v-for="option in amountTypeOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                        </select>
                      </td>
                      <td>
                        <select v-model="turnover.currency" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                          <option v-for="option in currencyOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                        </select>
                      </td>
                    </tr>
                    <tr v-if="newPartner.turnoverList.length === 0">
                      <td colspan="6" style="text-align: center; padding: 20px; color: #999;">
                        暂无营业额记录，点击右上角"新增"按钮添加
                      </td>
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
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addContactPerson">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedContactPersons" :disabled="!hasSelectedContactPersons">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
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
                    <tr v-for="(person, index) in newPartner.contactPersonList" :key="person.id">
                      <td>
                        <input type="checkbox" v-model="person.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <input type="text" v-model="person.name" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="person.department" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="person.position" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="tel" v-model="person.phone" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="email" v-model="person.email" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="person.remark" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                    </tr>
                    <tr v-if="newPartner.contactPersonList.length === 0">
                      <td colspan="8" style="text-align: center; padding: 20px; color: #999;">
                        暂无联系人信息，点击右上角"新增"按钮添加
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 专家信息 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>专家信息</h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addExpertInfo">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedExpertInfos" :disabled="!hasSelectedExpertInfos">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
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
                    <tr v-for="(expert, index) in newPartner.expertInfoList" :key="expert.id">
                      <td>
                        <input type="checkbox" v-model="expert.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <input type="text" v-model="expert.name" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="date" v-model="expert.birthDate" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <select v-model="expert.education" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                          <option value="">请选择</option>
                          <option v-for="option in educationOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                        </select>
                      </td>
                      <td>
                        <input type="text" v-model="expert.title" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <input type="text" v-model="expert.industryMajor" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="expert.expertResume">{{ expert.expertResume }}</span>
                          <span v-else style="color: #999;">无文件</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleExpertResumeUpload($event, expert.id)"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`expert-resume-${expert.id}`"
                          >
                          <label :for="`expert-resume-${expert.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ expert.expertResume || '选择文件' }}
                          </label>
                        </div>
                      </td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="expert.qualificationCertificate">{{ expert.qualificationCertificate }}</span>
                          <span v-else style="color: #999;">无文件</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleQualificationCertificateUpload($event, expert.id)"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`qualification-${expert.id}`"
                          >
                          <label :for="`qualification-${expert.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ expert.qualificationCertificate || '选择文件' }}
                          </label>
                        </div>
                      </td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="expert.attachment">{{ expert.attachment }}</span>
                          <span v-else style="color: #999;">无文件</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleExpertAttachmentUpload($event, expert.id)"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`expert-attachment-${expert.id}`"
                          >
                          <label :for="`expert-attachment-${expert.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ expert.attachment || '选择文件' }}
                          </label>
                        </div>
                      </td>
                      <td>
                        <input type="text" v-model="expert.remark" :disabled="isViewMode" style="width: 100%; padding: 4px;">
                      </td>
                    </tr>
                    <tr v-if="newPartner.expertInfoList.length === 0">
                      <td colspan="11" style="text-align: center; padding: 20px; color: #999;">
                        暂无专家信息，点击右上角"新增"按钮添加
                      </td>
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
                    <input type="text" v-model="newPartner.overseasInfo.overseasPersonnel" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>海外船机分布情况：</label>
                    <input type="text" v-model="newPartner.overseasInfo.overseasVesselDistribution" :disabled="isViewMode">
                  </div>
                  <div class="form-item">
                    <label>海外设备分布情况：</label>
                    <input type="text" v-model="newPartner.overseasInfo.overseasEquipmentDistribution" :disabled="isViewMode">
                  </div>
                </div>
              </div>
            </div>

            <!-- 声明/证明材料页签 -->
            <div v-if="currentTab === 3" class="tab-panel">
              <!-- 声明材料 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>声明材料<span class="required">*</span></h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addDeclarationMaterial">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedDeclarationMaterials" :disabled="!hasSelectedDeclarationMaterials">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
                      <th width="60">序号</th>
                      <th>声明材料<span class="required">*</span></th>
                      <th>法律纠纷承诺<span class="required">*</span></th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(material, index) in newPartner.declarationMaterials" :key="material.id">
                      <td>
                        <input type="checkbox" v-model="material.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="material.declarationMaterial">{{ material.declarationMaterial }}</span>
                          <span v-else style="color: #999;">未上传</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleDeclarationMaterialUpload($event, material.id, 'declarationMaterial')"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`declaration-material-${material.id}`"
                          >
                          <label :for="`declaration-material-${material.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ material.declarationMaterial || '选择文件' }}
                          </label>
                        </div>
                      </td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="material.legalDisputeCommitment">{{ material.legalDisputeCommitment }}</span>
                          <span v-else style="color: #999;">未上传</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleDeclarationMaterialUpload($event, material.id, 'legalDisputeCommitment')"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`legal-dispute-${material.id}`"
                          >
                          <label :for="`legal-dispute-${material.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ material.legalDisputeCommitment || '选择文件' }}
                          </label>
                        </div>
                      </td>
                    </tr>
                    <tr v-if="newPartner.declarationMaterials.length === 0">
                      <td colspan="4" style="text-align: center; padding: 20px; color: #999;">
                        暂无声明材料，点击右上角"新增"按钮添加
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 证明材料 -->
              <div class="form-section">
                <div class="section-header">
                  <h4>证明材料</h4>
                  <div>
                    <button v-if="!isViewMode" class="btn-primary btn-sm" @click="addProofMaterial">新增</button>
                    <button v-if="!isViewMode" class="btn-danger btn-sm" @click="deleteSelectedProofMaterials" :disabled="!hasSelectedProofMaterials">删除</button>
                  </div>
                </div>
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th width="60">选择</th>
                      <th width="60">序号</th>
                      <th>法人授权委托书原件</th>
                      <th>经审计的近三年的财务报告（复印件、加盖公章）</th>
                      <th>其他证明企业实力材料（如银行信誉等级、荣誉称号等）</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(material, index) in newPartner.proofMaterials" :key="material.id">
                      <td>
                        <input type="checkbox" v-model="material.selected" :disabled="isViewMode">
                      </td>
                      <td>{{ index + 1 }}</td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="material.legalAuthorization">{{ material.legalAuthorization }}</span>
                          <span v-else style="color: #999;">未上传</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleProofMaterialUpload($event, material.id, 'legalAuthorization')"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`legal-auth-${material.id}`"
                          >
                          <label :for="`legal-auth-${material.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ material.legalAuthorization || '选择文件' }}
                          </label>
                        </div>
                      </td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="material.auditedFinancialReport">{{ material.auditedFinancialReport }}</span>
                          <span v-else style="color: #999;">未上传</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleProofMaterialUpload($event, material.id, 'auditedFinancialReport')"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`financial-report-${material.id}`"
                          >
                          <label :for="`financial-report-${material.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ material.auditedFinancialReport || '选择文件' }}
                          </label>
                        </div>
                      </td>
                      <td>
                        <div v-if="isViewMode">
                          <span v-if="material.otherProofMaterials">{{ material.otherProofMaterials }}</span>
                          <span v-else style="color: #999;">未上传</span>
                        </div>
                        <div v-else>
                          <input
                            type="file"
                            @change="handleProofMaterialUpload($event, material.id, 'otherProofMaterials')"
                            accept=".pdf,.doc,.docx,.jpg,.jpeg,.png"
                            style="display: none;"
                            :id="`other-proof-${material.id}`"
                          >
                          <label :for="`other-proof-${material.id}`" style="cursor: pointer; color: #1890ff; text-decoration: underline;">
                            {{ material.otherProofMaterials || '选择文件' }}
                          </label>
                        </div>
                      </td>
                    </tr>
                    <tr v-if="newPartner.proofMaterials.length === 0">
                      <td colspan="5" style="text-align: center; padding: 20px; color: #999;">
                        暂无证明材料，点击右上角"新增"按钮添加
                      </td>
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
</template>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'PartnerManagement',
  data() {
    return {
      businessScopeOptions: [
        { value: '咨询服务', label: '咨询服务' },
        { value: '管理服务', label: '管理服务' },
        { value: '专项研究', label: '专项研究' },
        { value: '设计服务', label: '设计服务' },
        { value: '运营服务', label: '运营服务' },
        { value: '测量服务', label: '测量服务' },
        { value: '其他工程', label: '其他工程' },
        { value: '通讯工程', label: '通讯工程' },
        { value: '市政公用', label: '市政公用' },
        { value: '水利水电', label: '水利水电' },
        { value: '桥梁工程', label: '桥梁工程' },
        { value: '成套设备', label: '成套设备' },
        { value: '产业园区', label: '产业园区' },
        { value: '环保工程', label: '环保工程' },
        { value: '海事工程', label: '海事工程' },
        { value: '道路工程', label: '道路工程' },
        { value: '轨道交通', label: '轨道交通' },
        { value: '疏浚吹填', label: '疏浚吹填' },
        { value: '航空枢纽', label: '航空枢纽' },
        { value: '矿业工程', label: '矿业工程' },
        { value: '房屋建筑', label: '房屋建筑' },
        { value: '计算机软件的开发', label: '计算机软件的开发' },
        { value: '设计、制作', label: '设计、制作' },
        { value: '交通数据的采集', label: '交通数据的采集' },
        { value: '处理和分析', label: '处理和分析' },
        { value: '网络及软硬件领域内的技术开发', label: '网络及软硬件领域内的技术开发' },
        { value: '技术咨询', label: '技术咨询' },
        { value: '技术服务', label: '技术服务' },
        { value: '技术转让', label: '技术转让' },
        { value: '计算机系统集成', label: '计算机系统集成' }
      ],
      searchParams: {
        partnerType: [],
        industryChainType: [],
        businessScope: [],
        partnerName: '',
        contactPerson: '',
        supplyName: '',
        country: '',
        showDeleted: false
      },
      currentPage: 1,
      pageSize: 3,
      countryOptions: ['中国','美国','英国','德国','法国','日本','韩国','印度','俄罗斯','巴西','其他'],
      showAddModal: false,
      isViewMode: false,
      currentPartnerId: null,
      currentTab: 0, // 当前页签索引
      tabs: [
        { id: 'basic', name: '基本资料' },
        { id: 'business', name: '主要业务/业绩' },
        { id: 'contacts', name: '联系人' },
        { id: 'documents', name: '声明/证明材料' }
      ],
      businessScopeError: '',
      businessScopeDropdownOpen: false, // 控制经营范围下拉菜单显示状态
      industryChainDropdownOpen: false, // 控制产业链类型下拉菜单显示状态
      partnerTypeDropdownOpen: false, // 控制合作方类型下拉菜单显示状态
      searchPartnerTypeDropdownOpen: false, // 控制搜索合作方类型下拉菜单显示状态
      searchIndustryChainDropdownOpen: false, // 控制搜索产业链类型下拉菜单显示状态
      searchBusinessScopeDropdownOpen: false, // 控制搜索经营范围下拉菜单显示状态
      partnerTypeOptions: [
        { value: '勘察设计类', label: '勘察设计类' },
        { value: '工程咨询类', label: '工程咨询类' },
        { value: '施工类', label: '施工类' },
        { value: '信息化类', label: '信息化类' }
      ],
      industryChainOptions: [
        { value: '水运', label: '水运' },
        { value: '公路', label: '公路' },
        { value: '轨道交通', label: '轨道交通' },
        { value: '机场', label: '机场' },
        { value: '建筑', label: '建筑' },
        { value: '市政', label: '市政' },
        { value: '海洋工程', label: '海洋工程' },
        { value: '生态环保', label: '生态环保' },
        { value: '绿色能源', label: '绿色能源' },
        { value: '新基建', label: '新基建' }
      ],
      newPartner: {
        // 基本信息
        enterpriseName: '',
        localEnterpriseName: '',
        businessLicenseNo: '',
        registeredAddress: '',
        partnerCategory: '',
        officeAddress: '',
        country: '',
        businessContactType: '',
        partnerType: [],
        partnerNature: '',
        isCccSubordinate: '',
        parentEnterprise: '',
        legalRepresentative: '',
        registeredCapital: '',
        createTime: '',
        website: '',
        partnerAffiliation: '',
        industryChainType: [],
        companyScale: '',
        contactPhone: '',
        postalCode: '',
        fax: '',
        contactPerson: '',
        contactEmail: '',
        businessScope: [],
        enterpriseIntro: '',
        // 主要业务/业绩
        mainBusiness: '',
        mainProjects: '',
        // 联系人信息
        contactInfo: [],
        // 声明/证明材料
        declarationDocs: [],
        // 现场考察
        siteInspections: [],
        // 不良记录
        badRecords: [],
        // 证照信息
        licenseFiles: [],
        licenseInfo: [],
        // 供货清单
        supplyList: [],
        // 资质信息
        qualificationInfo: [],
        // 推荐信息
        recommendPerson: '',
        recommendUnit: '',
        recommendPhone: '',
        recommendFile: '',
        // 主要业务/业绩
        mainBusinessList: [],
        mainProjectsList: [],
        turnoverList: [],
        // 联系人扩展信息
        contactPersonList: [],
        expertInfoList: [],
        overseasInfo: {
          overseasPersonnel: '',
          overseasVesselDistribution: '',
          overseasEquipmentDistribution: ''
        },
        // 声明/证明材料
        declarationMaterials: [],
        proofMaterials: []
      },
      partnerList: [
        {
          id: 1,
          partnerType: ['施工类'],
          enterpriseName: '北京建工集团',
          industryChainType: ['建筑', '公路'],
          businessScope: ['建筑工程施工总承包', '市政公用工程施工总承包'],
          country: '中国',
          contactPerson: '张经理',
          evaluation: '优秀',
          status: 'active',
          approvalStatus: 'completed',
          supplyName: '建筑材料'
        },
        {
          id: 2,
          partnerType: ['勘察设计类'],
          enterpriseName: '上海建筑设计院',
          industryChainType: ['建筑'],
          businessScope: ['建筑工程设计', '工程设计咨询'],
          country: '中国',
          contactPerson: '李工',
          evaluation: '良好',
          status: 'active',
          approvalStatus: 'approving',
          supplyName: '设计服务'
        },
        {
          id: 3,
          partnerType: ['施工类'],
          enterpriseName: '广州建筑公司',
          industryChainType: ['建筑'],
          businessScope: ['房屋建筑工程施工', '装饰装修工程施工'],
          country: '中国',
          contactPerson: '王总',
          evaluation: '一般',
          status: 'active',
          approvalStatus: 'pending',
          supplyName: '施工设备'
        },
        {
          id: 4,
          partnerType: ['工程咨询类'],
          enterpriseName: '深圳装饰公司',
          industryChainType: ['建筑'],
          businessScope: ['工程咨询服务', '项目管理服务'],
          country: '中国',
          contactPerson: '赵经理',
          evaluation: '较差',
          status: 'deleted',
          approvalStatus: 'completed',
          supplyName: '装饰材料'
        },
        {
          id: 5,
          partnerType: ['信息化类'],
          enterpriseName: '天津监理公司',
          industryChainType: ['绿色能源'],
          businessScope: ['计算机软件开发', '技术咨询', '技术服务'],
          country: '中国',
          contactPerson: '钱工',
          evaluation: '良好',
          status: 'active',
          approvalStatus: 'pending',
          supplyName: '信息化解决方案'
        },
        {
          id: 6,
          partnerType: ['施工类'],
          enterpriseName: 'Siemens AG',
          industryChainType: ['新基建'],
          businessScope: ['工业自动化', '工业控制', '建筑电气'],
          country: '德国',
          contactPerson: 'Hans Schmidt',
          evaluation: '优秀',
          status: 'active',
          approvalStatus: 'completed',
          supplyName: '自动化设备'
        },
        {
          id: 7,
          partnerType: ['信息化类'],
          enterpriseName: 'Microsoft Corporation',
          industryChainType: ['新基建'],
          businessScope: ['软件服务', '云计算', '技术支持'],
          country: '美国',
          contactPerson: 'John Smith',
          evaluation: '优秀',
          status: 'active',
          approvalStatus: 'completed',
          supplyName: '软件服务'
        },
        {
          id: 8,
          partnerType: ['勘察设计类'],
          enterpriseName: 'Toyo Engineering Corporation',
          industryChainType: ['海洋工程'],
          businessScope: ['工程咨询', '工程设计', '项目管理'],
          country: '日本',
          contactPerson: '田中健一',
          evaluation: '良好',
          status: 'active',
          approvalStatus: 'approving',
          supplyName: '工程设计服务'
        },
        {
          id: 9,
          partnerType: ['施工类'],
          enterpriseName: 'Bouygues Construction',
          industryChainType: ['建筑'],
          businessScope: ['建筑工程', '市政工程', '工业建筑'],
          country: '法国',
          contactPerson: 'Pierre Dubois',
          evaluation: '良好',
          status: 'active',
          approvalStatus: 'pending',
          supplyName: '建筑工程'
        },
        {
          id: 10,
          partnerType: ['工程咨询类'],
          enterpriseName: 'Arup Group',
          industryChainType: ['建筑', '市政'],
          businessScope: ['工程咨询', '结构设计', '环境工程'],
          country: '英国',
          contactPerson: 'Robert Brown',
          evaluation: '优秀',
          status: 'active',
          approvalStatus: 'completed',
          supplyName: '工程咨询服务'
        },
        {
          id: 11,
          partnerType: ['信息化类'],
          enterpriseName: 'Samsung SDS',
          industryChainType: ['新基建'],
          businessScope: ['IT服务', '数字化转型', '云计算'],
          country: '韩国',
          contactPerson: 'Kim Lee',
          evaluation: '良好',
          status: 'active',
          approvalStatus: 'approving',
          supplyName: 'IT服务'
        },
        {
          id: 12,
          partnerType: ['施工类'],
          enterpriseName: 'Larsen & Toubro',
          industryChainType: ['建筑', '水运'],
          businessScope: ['工程总承包', '基建工程', '工业项目'],
          country: '印度',
          contactPerson: 'Raj Sharma',
          evaluation: '一般',
          status: 'active',
          approvalStatus: 'pending',
          supplyName: '基建工程'
        }
      ]
    }
  },
  computed: {
    filteredPartners() {
      let filtered = this.partnerList.filter(partner => {
        // 根据显示已删除选项过滤
        if (!this.searchParams.showDeleted && partner.status === 'deleted') {
          return false
        }

        // 根据合作方类型过滤
        if (this.searchParams.partnerType && this.searchParams.partnerType.length > 0) {
          if (!partner.partnerType || !partner.partnerType.some(type => this.searchParams.partnerType.includes(type))) {
            return false
          }
        }

        // 根据产业链类型过滤
        if (this.searchParams.industryChainType && this.searchParams.industryChainType.length > 0) {
          if (!partner.industryChainType || !partner.industryChainType.some(chain => this.searchParams.industryChainType.includes(chain))) {
            return false
          }
        }

        // 根据经营范围过滤
        if (this.searchParams.businessScope && this.searchParams.businessScope.length > 0) {
          if (!partner.businessScope || !partner.businessScope.some(scope => this.searchParams.businessScope.includes(scope))) {
            return false
          }
        }

        // 根据合作方名称过滤
        if (this.searchParams.partnerName && !(partner.enterpriseName || '').includes(this.searchParams.partnerName)) {
          return false
        }

        // 根据联系人过滤
        if (this.searchParams.contactPerson && !partner.contactPerson.includes(this.searchParams.contactPerson)) {
          return false
        }

        // 根据供货名称过滤
        if (this.searchParams.supplyName && !partner.supplyName.includes(this.searchParams.supplyName)) {
          return false
        }

        return true
      })

      // 根据当前页码和每页条数进行分页
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return filtered.slice(start, end)
    },
    totalPages() {
      const filtered = this.partnerList.filter(partner => {
        // 根据显示已删除选项过滤
        if (!this.searchParams.showDeleted && partner.status === 'deleted') {
          return false
        }

        // 根据合作方类型过滤
        if (this.searchParams.partnerType && this.searchParams.partnerType.length > 0) {
          if (!partner.partnerType || !partner.partnerType.some(type => this.searchParams.partnerType.includes(type))) {
            return false
          }
        }

        // 根据产业链类型过滤
        if (this.searchParams.industryChainType && this.searchParams.industryChainType.length > 0) {
          if (!partner.industryChainType || !partner.industryChainType.some(chain => this.searchParams.industryChainType.includes(chain))) {
            return false
          }
        }

        // 根据经营范围过滤
        if (this.searchParams.businessScope && this.searchParams.businessScope.length > 0) {
          if (!partner.businessScope || !partner.businessScope.some(scope => this.searchParams.businessScope.includes(scope))) {
            return false
          }
        }

        // 根据合作方名称过滤
        if (this.searchParams.partnerName && !(partner.enterpriseName || '').includes(this.searchParams.partnerName)) {
          return false
        }

        // 根据联系人过滤
        if (this.searchParams.contactPerson && !partner.contactPerson.includes(this.searchParams.contactPerson)) {
          return false
        }

        // 根据供货名称过滤
        if (this.searchParams.supplyName && !partner.supplyName.includes(this.searchParams.supplyName)) {
          return false
        }

        return true
      })
      return Math.ceil(filtered.length / this.pageSize)
    },
    // 检查是否有选中的证照信息
    hasSelectedLicenseInfo() {
      if (!this.newPartner.licenseInfo || !Array.isArray(this.newPartner.licenseInfo)) {
        return false
      }
      return this.newPartner.licenseInfo.some(license => license && license.selected)
    },
    // 检查是否有选中的现场考察
    hasSelectedSiteInspections() {
      if (!this.newPartner.siteInspections || !Array.isArray(this.newPartner.siteInspections)) {
        return false
      }
      return this.newPartner.siteInspections.some(item => item && item.selected)
    },
    // 检查是否有选中的不良记录
    hasSelectedBadRecords() {
      if (!this.newPartner.badRecords || !Array.isArray(this.newPartner.badRecords)) {
        return false
      }
      return this.newPartner.badRecords.some(item => item && item.selected)
    },
    // 检查是否有选中的供货清单
    hasSelectedSupplyItems() {
      if (!this.newPartner.supplyList || !Array.isArray(this.newPartner.supplyList)) {
        return false
      }
      return this.newPartner.supplyList.some(item => item && item.selected)
    },
    // 检查是否有选中的资质信息
    hasSelectedQualificationInfo() {
      if (!this.newPartner.qualificationInfo || !Array.isArray(this.newPartner.qualificationInfo)) {
        return false
      }
      return this.newPartner.qualificationInfo.some(item => item && item.selected)
    },
    // 检查是否有选中的联系人
    hasSelectedContacts() {
      if (!this.newPartner.contactInfo || !Array.isArray(this.newPartner.contactInfo)) {
        return false
      }
      return this.newPartner.contactInfo.some(contact => contact && contact.selected)
    },
    // 检查是否有选中的声明/证明材料
    hasSelectedDeclarations() {
      if (!this.newPartner.declarationDocs || !Array.isArray(this.newPartner.declarationDocs)) {
        return false
      }
      return this.newPartner.declarationDocs.some(doc => doc && doc.selected)
    },
    // 获取可选的经营范围选项（排除已选中的）
    availableBusinessScopes() {
      if (!this.newPartner.businessScope || !Array.isArray(this.newPartner.businessScope)) {
        return this.businessScopeOptions
      }
      return this.businessScopeOptions.filter(option =>
        !this.newPartner.businessScope.includes(option.value)
      )
    },
    // 获取可选的合作方类型选项（排除已选中的）
    availablePartnerTypes() {
      if (!this.newPartner.partnerType || !Array.isArray(this.newPartner.partnerType)) {
        return this.partnerTypeOptions
      }
      return this.partnerTypeOptions.filter(option =>
        !this.newPartner.partnerType.includes(option.value)
      )
    },
    // 获取可选的搜索合作方类型选项（排除已选中的）
    availableSearchPartnerTypes() {
      if (!this.searchParams.partnerType || !Array.isArray(this.searchParams.partnerType)) {
        return this.partnerTypeOptions
      }
      return this.partnerTypeOptions.filter(option =>
        !this.searchParams.partnerType.includes(option.value)
      )
    },
    // 获取可选的产业链类型选项（排除已选中的）
    availableIndustryChainTypes() {
      if (!this.newPartner.industryChainType || !Array.isArray(this.newPartner.industryChainType)) {
        return this.industryChainOptions
      }
      return this.industryChainOptions.filter(option =>
        !this.newPartner.industryChainType.includes(option.value)
      )
    },
    // 获取可选的搜索产业链类型选项（排除已选中的）
    availableSearchIndustryChainTypes() {
      if (!this.searchParams.industryChainType || !Array.isArray(this.searchParams.industryChainType)) {
        return this.industryChainOptions
      }
      return this.industryChainOptions.filter(option =>
        !this.searchParams.industryChainType.includes(option.value)
      )
    },
    // 获取可选的搜索经营范围选项（排除已选中的）
    availableSearchBusinessScopes() {
      if (!this.searchParams.businessScope || !Array.isArray(this.searchParams.businessScope)) {
        return this.businessScopeOptions
      }
      return this.businessScopeOptions.filter(option =>
        !this.searchParams.businessScope.includes(option.value)
      )
    },
    // 检查是否有选中的主要业务
    hasSelectedMainBusiness() {
      if (!this.newPartner.mainBusinessList || !Array.isArray(this.newPartner.mainBusinessList)) {
        return false
      }
      return this.newPartner.mainBusinessList.some(business => business.selected)
    },
    // 检查是否有选中的主要业绩
    hasSelectedMainProjects() {
      if (!this.newPartner.mainProjectsList || !Array.isArray(this.newPartner.mainProjectsList)) {
        return false
      }
      return this.newPartner.mainProjectsList.some(project => project.selected)
    },
    // 检查是否有选中的营业额
    hasSelectedTurnovers() {
      if (!this.newPartner.turnoverList || !Array.isArray(this.newPartner.turnoverList)) {
        return false
      }
      return this.newPartner.turnoverList.some(turnover => turnover.selected)
    },
    // 获取专业选项（合作方类型）
    professionOptions() {
      return [
        { value: '勘察设计类', label: '勘察设计类' },
        { value: '工程咨询类', label: '工程咨询类' },
        { value: '施工类', label: '施工类' },
        { value: '信息化类', label: '信息化类' }
      ]
    },
    // 获取年份选项（近3年）
    yearOptions() {
      const currentYear = new Date().getFullYear()
      return [
        { value: currentYear.toString(), label: currentYear.toString() },
        { value: (currentYear - 1).toString(), label: (currentYear - 1).toString() },
        { value: (currentYear - 2).toString(), label: (currentYear - 2).toString() }
      ]
    },
    // 获取币种选项
    currencyOptions() {
      return [
        { value: '人民币', label: '人民币' },
        { value: '美元', label: '美元' },
        { value: '欧元', label: '欧元' },
        { value: '日元', label: '日元' },
        { value: '英镑', label: '英镑' }
      ]
    },
    // 获取营业额类型选项
    amountTypeOptions() {
      return [
        { value: '年度营业额', label: '年度营业额' },
        { value: '累计营业额', label: '累计营业额' }
      ]
    },
    // 获取区域选项
    regionOptions() {
      return [
        { value: '华北', label: '华北' },
        { value: '华东', label: '华东' },
        { value: '华南', label: '华南' },
        { value: '华中', label: '华中' },
        { value: '西南', label: '西南' },
        { value: '西北', label: '西北' },
        { value: '东北', label: '东北' },
        { value: '港澳台', label: '港澳台' },
        { value: '海外', label: '海外' }
      ]
    },
    // 获取学历选项
    educationOptions() {
      return [
        { value: '博士', label: '博士' },
        { value: '硕士', label: '硕士' },
        { value: '本科', label: '本科' },
        { value: '大专', label: '大专' },
        { value: '中专', label: '中专' },
        { value: '高中', label: '高中' },
        { value: '其他', label: '其他' }
      ]
    },
    // 检查是否有选中的联系人信息
    hasSelectedContactPersons() {
      if (!this.newPartner.contactPersonList || !Array.isArray(this.newPartner.contactPersonList)) {
        return false
      }
      return this.newPartner.contactPersonList.some(person => person.selected)
    },
    // 检查是否有选中的专家信息
    hasSelectedExpertInfos() {
      if (!this.newPartner.expertInfoList || !Array.isArray(this.newPartner.expertInfoList)) {
        return false
      }
      return this.newPartner.expertInfoList.some(expert => expert.selected)
    },
    // 检查是否有选中的声明材料
    hasSelectedDeclarationMaterials() {
      if (!this.newPartner.declarationMaterials || !Array.isArray(this.newPartner.declarationMaterials)) {
        return false
      }
      return this.newPartner.declarationMaterials.some(material => material.selected)
    },
    // 检查是否有选中的证明材料
    hasSelectedProofMaterials() {
      if (!this.newPartner.proofMaterials || !Array.isArray(this.newPartner.proofMaterials)) {
        return false
      }
      return this.newPartner.proofMaterials.some(material => material.selected)
    }
  },
  methods: {
    // 切换页签
    switchTab(index) {
      this.currentTab = index
    },
    // 下一页签
    nextTab() {
      if (this.currentTab < this.tabs.length - 1) {
        this.currentTab++
      }
    },
    // 保存并继续
    saveAndContinue() {
      if (!this.validateBusinessScope()) {
        return
      }
      // 保存当前页签数据
      alert('保存成功')
      // 跳转到下一页签
      this.nextTab()
    },
    handleSearch() {
      this.currentPage = 1
      console.log('搜索参数：', this.searchParams)
    },
    handleReset() {
      this.searchParams = {
        partnerType: [],
        industryChainType: [],
        businessScope: [],
        partnerName: '',
        contactPerson: '',
        supplyName: '',
        country: '',
        showDeleted: false
      }
      this.currentPage = 1
    },
    handleAdd() {
      this.showAddModal = true
      this.isViewMode = false
    },
    validateBusinessScope() {
      if (this.newPartner.businessScope.length === 0) {
        this.businessScopeError = '请至少选择一项经营范围'
        return false
      } else {
        this.businessScopeError = ''
        return true
      }
    },
    closeAddModal() {
      this.showAddModal = false
      this.isViewMode = false
      this.currentPartnerId = null
      this.businessScopeDropdownOpen = false // 关闭经营范围下拉菜单
      this.industryChainDropdownOpen = false // 关闭产业链类型下拉菜单
      this.partnerTypeDropdownOpen = false // 关闭合作方类型下拉菜单
      this.resetNewPartner()
    },
    resetNewPartner() {
      this.newPartner = {
        // 基本信息
        enterpriseName: '',
        localEnterpriseName: '',
        businessLicenseNo: '',
        registeredAddress: '',
        partnerCategory: '',
        officeAddress: '',
        country: '',
        businessContactType: '',
        partnerType: [],
        partnerNature: '',
        isCccSubordinate: '',
        parentEnterprise: '',
        legalRepresentative: '',
        registeredCapital: '',
        createTime: '',
        website: '',
        partnerAffiliation: '',
        industryChainType: [],
        companyScale: '',
        contactPhone: '',
        postalCode: '',
        fax: '',
        contactPerson: '',
        contactEmail: '',
        businessScope: [],
        enterpriseIntro: '',
        // 主要业务/业绩
        mainBusiness: '',
        mainProjects: '',
        // 联系人信息
        contactInfo: [],
        // 声明/证明材料
        declarationDocs: [],
        // 现场考察
        siteInspections: [],
        // 不良记录
        badRecords: [],
        // 证照信息
        licenseFiles: [],
        licenseInfo: [],
        // 供货清单
        supplyList: [],
        // 资质信息
        qualificationInfo: [],
        // 推荐信息
        recommendPerson: '',
        recommendUnit: '',
        recommendPhone: '',
        recommendFile: '',
        // 主要业务/业绩
        mainBusinessList: [],
        mainProjectsList: [],
        turnoverList: [],
        // 联系人扩展信息
        contactPersonList: [],
        expertInfoList: [],
        overseasInfo: {
          overseasPersonnel: '',
          overseasVesselDistribution: '',
          overseasEquipmentDistribution: ''
        },
        // 声明/证明材料
        declarationMaterials: [],
        proofMaterials: []
      }

      // 清空文件输入框
      const fileInput = document.getElementById('recommend-file-input')
      if (fileInput) {
        fileInput.value = ''
      }
    },
    removeBusinessScope(index) {
      this.newPartner.businessScope.splice(index, 1)
      if (this.newPartner.businessScope.length === 0) {
        this.businessScopeError = '请至少选择一项经营范围'
      }
    },
    // 切换经营范围下拉菜单显示状态
    toggleBusinessScopeDropdown() {
      // 在新增模式下总是可以切换下拉菜单
      if (!this.isViewMode || !this.currentPartnerId) {
        this.businessScopeDropdownOpen = !this.businessScopeDropdownOpen
      }
    },
    // 选择经营范围
    selectBusinessScope(option) {
      this.newPartner.businessScope.push(option.value)
      this.businessScopeError = ''
      this.businessScopeDropdownOpen = false
    },
    // 根据value获取label
    getBusinessScopeLabel(value) {
      const option = this.businessScopeOptions.find(opt => opt.value === value)
      return option ? option.label : value
    },
    // 切换产业链类型下拉菜单显示状态
    toggleIndustryChainDropdown() {
      // 在新增模式下总是可以切换下拉菜单
      if (!this.isViewMode || !this.currentPartnerId) {
        this.industryChainDropdownOpen = !this.industryChainDropdownOpen
      }
    },
    // 选择产业链类型
    selectIndustryChainType(option) {
      this.newPartner.industryChainType.push(option.value)
      this.industryChainDropdownOpen = false
    },
    // 移除产业链类型
    removeIndustryChainType(index) {
      this.newPartner.industryChainType.splice(index, 1)
    },
    // 根据value获取产业链类型label
    getIndustryChainLabel(value) {
      const option = this.industryChainOptions.find(opt => opt.value === value)
      return option ? option.label : value
    },
    // 切换合作方类型下拉菜单显示状态
    togglePartnerTypeDropdown() {
      // 在新增模式下总是可以切换下拉菜单
      if (!this.isViewMode || !this.currentPartnerId) {
        this.partnerTypeDropdownOpen = !this.partnerTypeDropdownOpen
      }
    },
    // 选择合作方类型
    selectPartnerType(option) {
      this.newPartner.partnerType.push(option.value)
      this.partnerTypeDropdownOpen = false
    },
    // 移除合作方类型
    removePartnerType(index) {
      this.newPartner.partnerType.splice(index, 1)
    },
    // 根据value获取合作方类型label
    getPartnerTypeLabel(value) {
      const option = this.partnerTypeOptions.find(opt => opt.value === value)
      return option ? option.label : value
    },
    // 搜索合作方类型下拉菜单方法
    toggleSearchPartnerTypeDropdown() {
      this.searchPartnerTypeDropdownOpen = !this.searchPartnerTypeDropdownOpen
    },
    selectSearchPartnerType(option) {
      this.searchParams.partnerType.push(option.value)
      this.searchPartnerTypeDropdownOpen = false
    },
    removeSearchPartnerType(index) {
      this.searchParams.partnerType.splice(index, 1)
    },
    // 搜索产业链类型下拉菜单方法
    toggleSearchIndustryChainDropdown() {
      this.searchIndustryChainDropdownOpen = !this.searchIndustryChainDropdownOpen
    },
    selectSearchIndustryChainType(option) {
      this.searchParams.industryChainType.push(option.value)
      this.searchIndustryChainDropdownOpen = false
    },
    removeSearchIndustryChainType(index) {
      this.searchParams.industryChainType.splice(index, 1)
    },
    // 搜索经营范围下拉菜单方法
    toggleSearchBusinessScopeDropdown() {
      this.searchBusinessScopeDropdownOpen = !this.searchBusinessScopeDropdownOpen
    },
    selectSearchBusinessScope(option) {
      this.searchParams.businessScope.push(option.value)
      this.searchBusinessScopeDropdownOpen = false
    },
    removeSearchBusinessScope(index) {
      this.searchParams.businessScope.splice(index, 1)
    },
    addSiteInspection() {
      this.newPartner.siteInspections.push({
        id: Date.now(),
        inspector: '',
        inspectionLocation: '',
        inspectionTime: '',
        summary: '',
        selected: false
      })
    },
    saveSiteInspection(index) {
      this.newPartner.siteInspections[index].isEditing = false
    },
    editSiteInspection(index) {
      this.newPartner.siteInspections[index].isEditing = true
    },
    deleteSiteInspection(index) {
      this.newPartner.siteInspections.splice(index, 1)
    },
    addBadRecord() {
      this.newPartner.badRecords.push({
        id: Date.now(),
        record: '',
        handler: '',
        department: '',
        handleTime: '',
        selected: false
      })
    },
    saveBadRecord(index) {
      this.newPartner.badRecords[index].isEditing = false
    },
    editBadRecord(index) {
      this.newPartner.badRecords[index].isEditing = true
    },
    deleteBadRecord(index) {
      this.newPartner.badRecords.splice(index, 1)
    },
    addSupplyItem() {
      this.newPartner.supplyList.push({
        id: Date.now(),
        firstLevelName: '',
        secondLevelName: '',
        equipmentName: '',
        selected: false
      })
    },
    // 资质信息相关方法
    addQualificationInfo() {
      this.newPartner.qualificationInfo.push({
        id: Date.now(),
        classification: '',
        level: '',
        certificateNumber: '',
        specification: '',
        remark: '',
        relatedFile: '',
        selected: false
      })
    },
    // 批量删除资质信息
    deleteSelectedQualificationInfo() {
      const selectedCount = this.newPartner.qualificationInfo.filter(item => item.selected).length
      if (selectedCount === 0) {
        return
      }

      if (confirm(`确定要删除选中的 ${selectedCount} 条资质信息吗？`)) {
        this.newPartner.qualificationInfo = this.newPartner.qualificationInfo.filter(item => !item.selected)
      }
    },
    saveSupplyItem(index) {
      this.newPartner.supplyList[index].isEditing = false
    },
    editSupplyItem(index) {
      this.newPartner.supplyList[index].isEditing = true
    },
    deleteSupplyItem(index) {
      this.newPartner.supplyList.splice(index, 1)
    },
    handleLicenseUpload(event) {
      const files = event.target.files
      for (let i = 0; i < files.length; i++) {
        const file = files[i]
        this.newPartner.licenseFiles.push({
          id: Date.now() + i,
          name: files[i].name,
          file: files[i]
        })
      }
    },
    removeLicenseFile(index) {
      this.newPartner.licenseFiles.splice(index, 1)
    },
    // 证照信息相关方法
    addLicenseInfo() {
      this.newPartner.licenseInfo.push({
        id: Date.now(),
        type: '',
        code: '',
        validDate: '',
        level: '',
        remark: '',
        relatedFile: '',
        selected: false
      })
    },
    saveLicenseInfo(license) {
      // 简单验证
      if (!license.type) {
        alert('请输入证照类型')
        return
      }
      if (!license.code) {
        alert('请输入证照编码')
        return
      }
      license.isEditing = false
    },
    editLicenseInfo(license) {
      license.isEditing = true
    },
    cancelEditLicenseInfo(license) {
      license.isEditing = false
    },
    deleteLicenseInfo(licenseId) {
      if (confirm('确定删除该证照信息吗？')) {
        const index = this.newPartner.licenseInfo.findIndex(license => license.id === licenseId)
        if (index > -1) {
          this.newPartner.licenseInfo.splice(index, 1)
        }
      }
    },

    // 批量删除证照信息
    deleteSelectedLicenseInfo() {
      const selectedCount = this.newPartner.licenseInfo.filter(license => license.selected).length
      if (selectedCount === 0) {
        return
      }

      if (confirm(`确定要删除选中的 ${selectedCount} 条证照信息吗？`)) {
        this.newPartner.licenseInfo = this.newPartner.licenseInfo.filter(license => !license.selected)
      }
    },
    // 批量删除现场考察
    deleteSelectedSiteInspections() {
      const selectedCount = this.newPartner.siteInspections.filter(item => item.selected).length
      if (selectedCount === 0) {
        return
      }

      if (confirm(`确定要删除选中的 ${selectedCount} 条现场考察记录吗？`)) {
        this.newPartner.siteInspections = this.newPartner.siteInspections.filter(item => !item.selected)
      }
    },
    // 批量删除不良记录
    deleteSelectedBadRecords() {
      const selectedCount = this.newPartner.badRecords.filter(item => item.selected).length
      if (selectedCount === 0) {
        return
      }

      if (confirm(`确定要删除选中的 ${selectedCount} 条不良记录吗？`)) {
        this.newPartner.badRecords = this.newPartner.badRecords.filter(item => !item.selected)
      }
    },
    // 批量删除供货清单
    deleteSelectedSupplyItems() {
      const selectedCount = this.newPartner.supplyList.filter(item => item.selected).length
      if (selectedCount === 0) {
        return
      }

      if (confirm(`确定要删除选中的 ${selectedCount} 条供货清单吗？`)) {
        this.newPartner.supplyList = this.newPartner.supplyList.filter(item => !item.selected)
      }
    },

    savePartner() {
      if (!this.validateBusinessScope()) {
        return
      }
      alert('保存合作方信息')
      this.closeAddModal()
    },
    submitPartner() {
      if (!this.validateBusinessScope()) {
        return
      }
      alert('提交合作方信息')
      this.closeAddModal()
    },
    handleExport() {
      alert('导出功能')
    },
    downloadImportTemplate() {
      const headers = ['合作方类型','合作方名称','国别','联系人','联系电话','评价']
      const csvContent = headers.join(',') + '\n'
      const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
      const url = URL.createObjectURL(blob)
      const link = document.createElement('a')
      link.href = url
      link.download = '合作方导入模板.csv'
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
          const expected = ['合作方类型','合作方名称','国别','联系人','联系电话','评价']
          const valid = expected.every((h, i) => (header[i] || '').trim() === h)
          if (!valid) {
            alert('CSV表头不匹配，请使用模板导入')
            return
          }
          const added = []
          for (let i = 1; i < lines.length; i++) {
            const cols = lines[i].split(',')
            if (cols.length < expected.length) continue
            const partner = {
              id: Date.now() + i,
              partnerType: (cols[0] || '').trim(),
              partnerName: (cols[1] || '').trim(),
              country: (cols[2] || '').trim(),
              contactPerson: (cols[3] || '').trim(),
              contactPhone: (cols[4] || '').trim(),
              evaluation: (cols[5] || '').trim() || '一般',
              status: 'active',
              approvalStatus: 'pending'
            }
            // 简单校验
            if (!partner.partnerName) continue
            this.partnerList.push(partner)
            added.push(partner)
          }
          alert(`成功导入 ${added.length} 条合作方信息`)
        } catch (err) {
          console.error(err)
          alert('导入失败，请检查文件格式')
        }
      }
      reader.onerror = () => {
        alert('文件读取失败')
      }
      reader.readAsText(file, 'utf-8')
    },
    handleView(partner) {
      this.showAddModal = true
      this.isViewMode = true
      this.currentPartnerId = partner.id
      // 模拟加载数据
      this.loadPartnerData(partner.id)
    },
    handleEdit(partner) {
      // 先重置表单
      this.resetNewPartner()
      // 再打开弹窗
      this.showAddModal = true
      this.isViewMode = false
      this.currentPartnerId = partner.id
      // 模拟加载数据
      this.loadPartnerData(partner.id)
    },
    loadPartnerData(partnerId) {
      // 模拟从数据库加载数据
      const mockData = {
        1: {
          enterpriseName: '北京建工集团',
          partnerAffiliation: '属地化',
          parentEnterprise: '中国交建',
          isCccSubordinate: '是',
          partnerType: ['供应商'],
          country: '中国',
          legalRepresentative: '张三',
          registeredCapital: '5000',
          registeredAddress: '北京市朝阳区',
          officeAddress: '北京市海淀区',
          createTime: '2023-01-01',
          contactPerson: '张经理',
          contactPhone: '13800138000',
          contactEmail: 'zhang@example.com',
          website: 'www.example.com',
          recommendUnit: '集团总部',
          businessScope: ['咨询服务'],
          industryChainType: ['建筑', '道桥'],
          enterpriseIntro: '大型建筑企业，具有丰富的施工经验',
          siteInspections: [
            { id: 1, inspector: '李四', inspectionLocation: '北京总部', inspectionTime: '2023-06-01', summary: '考察合格', selected: false }
          ],
          badRecords: [
            { id: 1, record: '无不良记录', handler: '王五', department: '质量部', handleTime: '2023-07-01', selected: false }
          ],
          licenseFiles: [
            { id: 1, name: '营业执照.pdf' }
          ],
          licenseInfo: [
            {
              id: 1,
              type: '营业执照',
              code: '91110000123456789X',
              validDate: '2025-12-31',
              level: 'A级',
              remark: '有效期内',
              relatedFile: '营业执照.pdf',
              selected: false
            },
            {
              id: 2,
              type: '建筑业企业资质证书',
              code: 'D111012345',
              validDate: '2024-06-30',
              level: '特级',
              remark: '建筑工程施工总承包特级',
              relatedFile: '资质证书.pdf',
              selected: false
            }
          ],
          supplyList: [
            { id: 1, firstLevelName: '建筑材料', secondLevelName: '钢材', equipmentName: '螺纹钢', selected: false }
          ],
          // 资质信息
          qualificationInfo: [
            {
              id: 1,
              classification: '建筑业企业资质',
              level: '特级',
              certificateNumber: 'D111012345',
              specification: '建筑工程施工总承包',
              remark: '特级资质，可承担各类建筑工程施工总承包',
              relatedFile: '特级资质证书.pdf',
              selected: false
            },
            {
              id: 2,
              classification: '工程勘察资质',
              level: '甲级',
              certificateNumber: 'A222022345',
              specification: '岩土工程勘察',
              remark: '甲级勘察资质',
              relatedFile: '勘察资质证书.pdf',
              selected: false
            }
          ],
          // 推荐信息
          recommendPerson: '张总',
          recommendUnit: '集团总部',
          recommendPhone: '13900139000',
          recommendFile: '推荐函.pdf'
        },
        2: {
          enterpriseName: '上海建筑设计院',
          partnerAffiliation: '总部',
          parentEnterprise: '',
          isCccSubordinate: '否',
          partnerType: ['设计单位'],
          country: '中国',
          legalRepresentative: '李四',
          registeredCapital: '3000',
          registeredAddress: '上海市浦东新区',
          officeAddress: '上海市徐汇区',
          createTime: '2023-02-01',
          contactPerson: '李工',
          contactPhone: '13900139000',
          contactEmail: 'li@example.com',
          website: 'www.shdesign.com',
          recommendUnit: '',
          businessScope: ['咨询服务'],
          enterpriseIntro: '专业建筑设计单位',
          siteInspections: [],
          badRecords: [],
          licenseFiles: [],
          supplyList: []
        }
      }
      
      const data = mockData[partnerId] || {}
      Object.keys(data).forEach(key => {
        if (this.newPartner.hasOwnProperty(key)) {
          this.newPartner[key] = data[key]
        }
      })
    },
    handleDelete(id) {
      if (confirm('确定删除该合作方吗？')) {
        const partner = this.partnerList.find(p => p.id === id)
        if (partner) {
          partner.status = 'deleted'
        }
      }
    },
    getEvaluationClass(evaluation) {
      const classMap = {
        '优秀': 'excellent',
        '良好': 'good',
        '一般': 'normal',
        '较差': 'poor'
      }
      return classMap[evaluation] || 'normal'
    },
    getApprovalStatusText(status) {
      const statusMap = {
        'completed': '已完成',
        'approving': '审批中',
        'pending': '未提交'
      }
      return statusMap[status] || '未提交'
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
    // 处理推荐函文件上传
    handleRecommendFileUpload(event) {
      const file = event.target.files[0]
      if (file) {
        // 保存文件名（在实际项目中，这里应该保存文件对象或上传到服务器）
        this.newPartner.recommendFile = file.name
      }
    },
    // 删除推荐函文件
    removeRecommendFile() {
      this.newPartner.recommendFile = ''
      // 清空文件输入框
      const fileInput = document.getElementById('recommend-file-input')
      if (fileInput) {
        fileInput.value = ''
      }
    },
    // 点击外部关闭下拉菜单
    handleClickOutside(event) {
      const isOutside = (element) => {
        return element && !element.contains(event.target)
      }

      // 获取搜索区域和弹窗的容器元素
      const searchArea = this.$el.querySelector('.search-area')
      const modal = this.$el.querySelector('.partner-modal-content')

      // 处理搜索区域的下拉菜单
      if (searchArea) {
        const searchPartnerTypeEl = searchArea.querySelector('.partner-type-dropdown .multi-select-component')
        if (isOutside(searchPartnerTypeEl)) {
          this.searchPartnerTypeDropdownOpen = false
        }
        const searchIndustryChainEl = searchArea.querySelector('.industry-chain-dropdown .multi-select-component')
        if (isOutside(searchIndustryChainEl)) {
          this.searchIndustryChainDropdownOpen = false
        }
        const searchBusinessScopeEl = searchArea.querySelector('.business-scope-dropdown .multi-select-component')
        if (isOutside(searchBusinessScopeEl)) {
          this.searchBusinessScopeDropdownOpen = false
        }
      }

      // 处理弹窗内的下拉菜单
      if (modal) {
        const modalPartnerTypeEl = modal.querySelector('.partner-type-dropdown .multi-select-component')
        if (isOutside(modalPartnerTypeEl)) {
          this.partnerTypeDropdownOpen = false
        }
        const modalIndustryChainEl = modal.querySelector('.industry-chain-dropdown .multi-select-component')
        if (isOutside(modalIndustryChainEl)) {
          this.industryChainDropdownOpen = false
        }
        const modalBusinessScopeEl = modal.querySelector('.business-scope-dropdown .multi-select-component')
        if (isOutside(modalBusinessScopeEl)) {
          this.businessScopeDropdownOpen = false
        }
      }
    },
    // 联系人管理方法
    addContactInfo() {
      this.newPartner.contactInfo.push({
        id: Date.now(),
        name: '',
        position: '',
        phone: '',
        email: '',
        department: '',
        selected: false
      })
    },
    deleteSelectedContacts() {
      const selectedCount = this.newPartner.contactInfo.filter(contact => contact.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条联系人信息吗？`)) {
        this.newPartner.contactInfo = this.newPartner.contactInfo.filter(contact => !contact.selected)
      }
    },
    // 声明/证明材料管理方法
    addDeclarationDoc() {
      this.newPartner.declarationDocs.push({
        id: Date.now(),
        name: '',
        type: '',
        fileName: '',
        uploadTime: '',
        status: 'pending',
        selected: false
      })
    },
    deleteSelectedDeclarations() {
      const selectedCount = this.newPartner.declarationDocs.filter(doc => doc.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条声明/证明材料吗？`)) {
        this.newPartner.declarationDocs = this.newPartner.declarationDocs.filter(doc => !doc.selected)
      }
    },
    getDocStatusText(status) {
      const statusMap = {
        'pending': '待上传',
        'uploaded': '已上传',
        'approved': '已审核',
        'rejected': '已驳回'
      }
      return statusMap[status] || '待上传'
    },
    // 主要业务管理方法
    addMainBusiness() {
      this.newPartner.mainBusinessList.push({
        id: Date.now(),
        selected: false,
        region: '',
        profession: '',
        businessType: '',
        detailType: '',
        remark: ''
      })
    },
    deleteSelectedMainBusiness() {
      const selectedCount = this.newPartner.mainBusinessList.filter(business => business.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条主要业务吗？`)) {
        this.newPartner.mainBusinessList = this.newPartner.mainBusinessList.filter(business => !business.selected)
      }
    },
    // 主要业绩管理方法
    addMainProject() {
      this.newPartner.mainProjectsList.push({
        id: Date.now(),
        selected: false,
        projectName: '',
        fundingSource: '',
        projectOwner: '',
        generalContractor: '',
        consultingUnit: '',
        startDate: '',
        projectFeatures: '',
        projectAwards: '',
        isCompleted: '否',
        attachment: ''
      })
    },
    deleteSelectedMainProjects() {
      const selectedCount = this.newPartner.mainProjectsList.filter(project => project.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条主要业绩吗？`)) {
        this.newPartner.mainProjectsList = this.newPartner.mainProjectsList.filter(project => !project.selected)
      }
    },
    // 营业额管理方法
    addTurnover() {
      this.newPartner.turnoverList.push({
        id: Date.now(),
        selected: false,
        year: '',
        amount: '',
        amountType: '年度营业额',
        currency: '人民币'
      })
    },
    deleteSelectedTurnovers() {
      const selectedCount = this.newPartner.turnoverList.filter(turnover => turnover.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条营业额记录吗？`)) {
        this.newPartner.turnoverList = this.newPartner.turnoverList.filter(turnover => !turnover.selected)
      }
    },
    // 处理项目附件上传
    handleProjectAttachment(event, projectId) {
      const file = event.target.files[0]
      if (file) {
        const project = this.newPartner.mainProjectsList.find(p => p.id === projectId)
        if (project) {
          project.attachment = file.name
        }
      }
    },
    // 联系人信息管理方法
    addContactPerson() {
      this.newPartner.contactPersonList.push({
        id: Date.now(),
        selected: false,
        name: '',
        department: '',
        position: '',
        phone: '',
        email: '',
        remark: ''
      })
    },
    deleteSelectedContactPersons() {
      const selectedCount = this.newPartner.contactPersonList.filter(person => person.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条联系人信息吗？`)) {
        this.newPartner.contactPersonList = this.newPartner.contactPersonList.filter(person => !person.selected)
      }
    },
    // 专家信息管理方法
    addExpertInfo() {
      this.newPartner.expertInfoList.push({
        id: Date.now(),
        selected: false,
        name: '',
        birthDate: '',
        education: '',
        title: '',
        industryMajor: '',
        expertResume: '',
        qualificationCertificate: '',
        attachment: '',
        remark: ''
      })
    },
    deleteSelectedExpertInfos() {
      const selectedCount = this.newPartner.expertInfoList.filter(expert => expert.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条专家信息吗？`)) {
        this.newPartner.expertInfoList = this.newPartner.expertInfoList.filter(expert => !expert.selected)
      }
    },
    // 处理专家简历附件上传
    handleExpertResumeUpload(event, expertId) {
      const file = event.target.files[0]
      if (file) {
        const expert = this.newPartner.expertInfoList.find(e => e.id === expertId)
        if (expert) {
          expert.expertResume = file.name
        }
      }
    },
    // 处理职业资格证书附件上传
    handleQualificationCertificateUpload(event, expertId) {
      const file = event.target.files[0]
      if (file) {
        const expert = this.newPartner.expertInfoList.find(e => e.id === expertId)
        if (expert) {
          expert.qualificationCertificate = file.name
        }
      }
    },
    // 处理专家附件上传
    handleExpertAttachmentUpload(event, expertId) {
      const file = event.target.files[0]
      if (file) {
        const expert = this.newPartner.expertInfoList.find(e => e.id === expertId)
        if (expert) {
          expert.attachment = file.name
        }
      }
    },
    // 声明材料管理方法
    addDeclarationMaterial() {
      this.newPartner.declarationMaterials.push({
        id: Date.now(),
        selected: false,
        declarationMaterial: '', // 声明材料附件
        legalDisputeCommitment: '' // 法律纠纷承诺附件
      })
    },
    deleteSelectedDeclarationMaterials() {
      const selectedCount = this.newPartner.declarationMaterials.filter(material => material.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条声明材料吗？`)) {
        this.newPartner.declarationMaterials = this.newPartner.declarationMaterials.filter(material => !material.selected)
      }
    },
    // 处理声明材料附件上传
    handleDeclarationMaterialUpload(event, materialId, field) {
      const file = event.target.files[0]
      if (file) {
        const material = this.newPartner.declarationMaterials.find(m => m.id === materialId)
        if (material) {
          material[field] = file.name
        }
      }
    },
    // 证明材料管理方法
    addProofMaterial() {
      this.newPartner.proofMaterials.push({
        id: Date.now(),
        selected: false,
        legalAuthorization: '', // 法人授权委托书原件
        auditedFinancialReport: '', // 经审计的近三年的财务报告
        otherProofMaterials: '' // 其他证明企业实力材料
      })
    },
    deleteSelectedProofMaterials() {
      const selectedCount = this.newPartner.proofMaterials.filter(material => material.selected).length
      if (selectedCount === 0) {
        return
      }
      if (confirm(`确定要删除选中的 ${selectedCount} 条证明材料吗？`)) {
        this.newPartner.proofMaterials = this.newPartner.proofMaterials.filter(material => !material.selected)
      }
    },
    // 处理证明材料附件上传
    handleProofMaterialUpload(event, materialId, field) {
      const file = event.target.files[0]
      if (file) {
        const material = this.newPartner.proofMaterials.find(m => m.id === materialId)
        if (material) {
          material[field] = file.name
        }
      }
    }
  },
  mounted() {
    // 点击外部关闭下拉菜单
    document.addEventListener('click', this.handleClickOutside)
  },
  beforeUnmount() {
    document.removeEventListener('click', this.handleClickOutside)
  }
}
</script>

<style scoped>
.business-scope-container {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 10px;
  background: #f8f9fa;
  border-radius: 6px;
  border: 1px solid #e8e8e8;
  width: 100%;
  box-sizing: border-box;
}

.scope-category.merged-cell {
  background: white;
  padding: 8px 12px;
  border-radius: 4px;
  border: 1px solid #d9d9d9;
  min-height: 80px;
}

.scope-category h5 {
  margin: 0 0 6px 0;
  color: #1890ff;
  font-size: 13px;
  font-weight: 600;
  padding-bottom: 4px;
  border-bottom: 1px solid #1890ff;
  text-align: left;
}

.checkbox-group {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 5px;
  align-items: flex-start;
}

.checkbox-item {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 3px 5px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 3px;
  background: #fafafa;
  margin: 1px;
  flex: 0 0 180px;
  width: 180px;
  position: relative;
  box-sizing: border-box;
  border: 1px solid #e8e8e8;
  overflow: visible;
}

.checkbox-item input[type="checkbox"] {
  width: 16px;
  height: 16px;
  margin: 0;
  cursor: pointer;
  flex-shrink: 0;
  position: relative;
  display: inline-block;
  visibility: visible;
  opacity: 1;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  z-index: 2;
  border: 2px solid #1890ff;
  border-radius: 2px;
  background: white;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.checkbox-item input[type="checkbox"]:checked {
  background: #1890ff;
  border-color: #1890ff;
}

.checkbox-item input[type="checkbox"]:checked::after {
  content: "";
  position: absolute;
  left: 4px;
  top: 1px;
  width: 5px;
  height: 10px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: rotate(45deg);
}

.checkbox-item:hover {
  background: #e6f7ff;
  border-color: #40a9ff;
  box-shadow: 0 2px 8px rgba(24, 144, 255, 0.15);
}

.checkbox-item span {
  font-size: 12px;
  color: #2c3e50;
  line-height: 1.3;
  cursor: pointer;
  user-select: none;
  font-weight: 400;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-family: 'Microsoft YaHei', '思源黑体', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  max-width: 140px;
  display: inline-block;
}

/* 添加tooltip样式增强 */
.checkbox-item[title]:hover {
  position: relative;
}

.checkbox-item[title]:hover::after {
  content: attr(title);
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 4px 8px;
  border-radius: 3px;
  font-size: 11px;
  white-space: nowrap;
  z-index: 1000;
  opacity: 0;
  animation: tooltipFadeIn 0.3s ease forwards;
  pointer-events: none;
}

.checkbox-item[title]:hover::before {
  content: '';
  position: absolute;
  top: -6px;
  left: 50%;
  transform: translateX(-50%);
  border: 3px solid transparent;
  border-top-color: rgba(0, 0, 0, 0.8);
  z-index: 1001;
  opacity: 0;
  animation: tooltipFadeIn 0.3s ease forwards;
}

@keyframes tooltipFadeIn {
  to {
    opacity: 1;
  }
}

.checkbox-item input[type="checkbox"]:checked + span {
  color: #1890ff;
  font-weight: 600;
}

.checkbox-item:has(input[type="checkbox"]:checked) {
  background: linear-gradient(135deg, #e6f7ff 0%, #f0f7ff 100%);
  border: 2px solid #1890ff;
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.2);
}

/* 确保所有复选框统一标准 */
.checkbox-item input[type="checkbox"]::-webkit-inner-spin-button,
.checkbox-item input[type="checkbox"]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.checkbox-item input[type="checkbox"]::-ms-check {
  width: 16px;
  height: 16px;
  border: 2px solid #1890ff;
  background: white;
  border-radius: 4px;
}

.checkbox-item input[type="checkbox"]:checked::-ms-check {
  background: #1890ff;
  border-color: #1890ff;
  color: white;
}

/* 添加统一的焦点样式 */
.checkbox-item input[type="checkbox"]:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.2);
}

/* 确保在不同浏览器中显示一致 - 完美正方形 */
.checkbox-item input[type="checkbox"] {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  width: 16px;
  height: 16px;
  min-width: 16px;
  min-height: 16px;
  max-width: 16px;
  max-height: 16px;
  box-sizing: border-box !important;
  padding: 0 !important;
  margin: 0 !important;
  line-height: 16px !important;
  vertical-align: middle !important;
}

/* 确保IE/Edge浏览器中也显示为正方形 */
.checkbox-item input[type="checkbox"]::-ms-check {
  width: 16px;
  height: 16px;
  border: 2px solid #1890ff;
  background: white;
  border-radius: 2px;
  box-sizing: border-box;
}

/* 防止浏览器默认样式影响 */
.checkbox-item input[type="checkbox"]:before,
.checkbox-item input[type="checkbox"]:after {
  content: none !important;
  display: none !important;
}

/* 确保Firefox中显示为正方形 */
@-moz-document url-prefix() {
  .checkbox-item input[type="checkbox"] {
    width: 16px !important;
    height: 16px !important;
    min-width: 16px !important;
    min-height: 16px !important;
    max-width: 16px !important;
    max-height: 16px !important;
  }
}

.error-message {
  color: #ff4d4f;
  font-size: 12px;
  margin-top: 10px;
  padding-left: 4px;
  grid-column: 1 / -1;
}

.required {
  color: #ff4d4f;
  font-weight: bold;
}

.partner-management {
  padding: 20px;
  background: #f0f2f5;
  min-height: 100vh;
  overflow-y: auto;
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

.table-header {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 15px;
  padding: 0 10px;
}

.header-buttons {
  display: flex;
  gap: 10px;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  align-items: center;
}

.form-item {
  display: flex;
  align-items: center;
  white-space: nowrap;
  flex: 1;
}

.form-item label {
  width: 80px;
  text-align: right;
  margin-right: 8px;
  font-weight: 500;
  white-space: nowrap;
  color: #333;
  font-size: 14px;
}

.form-item input,
.form-item select {
  flex: 1;
  min-width: 120px;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: #fff;
}

.form-item input:focus,
.form-item select:focus {
  outline: none;
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

.form-item input:hover,
.form-item select:hover {
  border-color: #40a9ff;
}


.form-item.button-group {
  flex: none;
  margin-left: auto;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* 国别选择框特定样式 */
.form-item .country-select {
  flex: 1;
  min-width: 120px !important;
  max-width: 200px !important;
  padding: 8px 12px !important;
  border: 1px solid #d9d9d9 !important;
  border-radius: 6px !important;
  font-size: 14px !important;
  transition: all 0.3s ease !important;
  background: #fff !important;
  height: 36px !important;
  box-sizing: border-box !important;
}

/* 分页样式 */
.pagination {
  padding: 20px;
  border-top: 1px solid #e8e8e8;
  display: flex;
  justify-content: center;
  gap: 15px;
}

/* 合作方信息登记表弹窗样式 */
.modal {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  width: 100% !important;
  height: 100% !important;
  background: rgba(0, 0, 0, 0.5) !important;
  display: flex !important;
  justify-content: center !important;
  align-items: center !important;
  z-index: 99999 !important;
  overflow: auto !important;
  padding: 20px !important;
  box-sizing: border-box !important;
}

.modal-content {
  background: white !important;
  border-radius: 8px !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15) !important;
  overflow-y: auto !important;
  width: 90% !important;
  max-width: 1200px !important;
  max-height: 90vh !important;
  margin: 20px auto !important;
  position: relative !important;
  display: flex !important;
  flex-direction: column !important;
  transform: translateZ(0) !important;
  backface-visibility: hidden !important;
  perspective: 1000px !important;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #e8e8e8;
  background: #fafafa;
}

.modal-action-buttons {
  display: flex;
  gap: 8px;
  align-items: center;
}

.modal-header h3 {
  margin: 0;
  color: #333;
}

.modal-body {
  padding: 20px;
  flex: 1;
  overflow-y: auto;
  max-height: calc(90vh - 80px); /* 减去头部高度 */
}

.form-section {
  margin-bottom: 30px;
  border: 1px solid #e8e8e8;
  border-radius: 6px;
  padding: 20px;
}

.form-section h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
}

.form-item {
  display: flex;
  align-items: center;
  gap: 8px;
  white-space: nowrap;
}

.form-item.full-width {
  grid-column: 1 / -1;
}

.form-item label {
  margin-bottom: 0;
  font-weight: 500;
  color: #333;
  min-width: 150px;
  text-align: right;
  white-space: nowrap;
}

.form-item input,
.form-item select,
.form-item textarea {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  width: calc(100% - 160px);
  min-width: 0;
}

.form-item textarea {
  resize: vertical;
  min-height: 60px;
}

.sub-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 10px;
}

.sub-table th,
.sub-table td {
  padding: 8px;
  border: 1px solid #e8e8e8;
  text-align: center;
}

.sub-table th {
  background: #fafafa;
  font-weight: 600;
}

.sub-table input {
  width: 100%;
  padding: 4px;
  border: 1px solid #ddd;
  border-radius: 2px;
}


.table-btn-save {
  background: #52c41a;
  color: white;
  border: none;
  padding: 4px 8px;
  border-radius: 2px;
  cursor: pointer;
  font-size: 12px;
  margin-right: 5px;
}

.file-upload-section {
  margin-top: 10px;
}

.file-upload {
  display: inline-block;
  position: relative;
  margin: 10px 0;
}

.file-upload input {
  position: absolute;
  left: 0;
  top: 0;
  opacity: 0;
  width: 100%;
  height: 100%;
  cursor: pointer;
}

.file-upload span {
  display: inline-block;
  padding: 8px 16px;
  background: #f5f5f5;
  border: 1px dashed #ddd;
  border-radius: 4px;
  cursor: pointer;
}

.file-list {
  margin-top: 10px;
}

.file-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px;
  background: #fafafa;
  border-radius: 4px;
  margin-bottom: 5px;
}

/* 重置按钮样式 - 保持灰色，其他按钮使用全局蓝色样式 */
.btn-secondary {
  background: #f5f5f5 !important;
  color: #666 !important;
  border: 1px solid #d9d9d9 !important;
}

.btn-secondary:hover {
  background: #e6f7ff !important;
  border-color: #40a9ff !important;
  color: #1890ff !important;
}

/* 表格头部布局调整 */
.table-header {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding: 20px 0 10px 0;
  margin-bottom: 10px;
}

/* 区块标题头部样式 */
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.section-header div {
  display: flex;
  gap: 8px;
  align-items: center;
}

.section-header h4 {
  margin: 0;
  color: #333;
  font-weight: 600;
}

.header-buttons {
  display: flex;
  gap: 10px;
  margin-top: 10px;
  padding-right: 15px;
  margin-right: 20px;
}

.action-buttons {
  display: flex;
  gap: 15px;
}

/* 输入组样式 */
.input-group {
  display: flex;
  align-items: center;
  flex: 1;
  gap: 15px;
}

/* 复选框内联样式 */
.checkbox-label-inline {
  display: inline-flex;
  align-items: center;
  font-weight: normal;
  white-space: nowrap;
  cursor: pointer;
  color: #666;
  font-size: 14px;
  padding: 4px 8px;
  border-radius: 4px;
  transition: all 0.3s ease;
}

.checkbox-label-inline:hover {
  background-color: #f5f5f5;
}

.checkbox-label-inline input[type="checkbox"] {
  margin-right: 6px;
  width: 16px;
  height: 16px;
  cursor: pointer;
  accent-color: #1890ff;
}

/* 复选框选中状态 */
.checkbox-label-inline:has(input[type="checkbox"]:checked) {
  color: #1890ff;
  background-color: #e6f7ff;
}

/* 移除搜索区域的灰色背景框 */
.search-area {
  background: #fff;
  padding: 24px;
  border-radius: 12px;
  margin-bottom: 24px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  border: 1px solid rgba(24, 144, 255, 0.1);
}

/* 小按钮样式 */
.btn-sm {
  padding: 6px 12px !important;
  font-size: 12px !important;
  line-height: 1.5 !important;
  border-radius: 4px !important;
  min-width: 60px !important;
  height: auto !important;
}

/* 危险按钮样式（删除按钮）*/
.btn-danger {
  background: #ff4d4f !important;
  color: white !important;
  border: 1px solid #ff4d4f !important;
}

.btn-danger:hover {
  background: #ff7875 !important;
  border-color: #ff7875 !important;
}

.btn-danger:disabled {
  background: #d9d9d9 !important;
  color: rgba(0, 0, 0, 0.25) !important;
  border-color: #d9d9d9 !important;
  cursor: not-allowed !important;
}

/* 调整表单项目布局 */
.form-item {
  display: flex;
  align-items: center;
  white-space: nowrap;
  flex: 1;
}

.form-item label {
  width: 80px;
  text-align: right;
  margin-right: 8px;
  font-weight: 500;
  white-space: nowrap;
  color: #333;
  font-size: 14px;
}

.form-item input,
.form-item select {
  flex: 1;
  min-width: 120px;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: #fff;
}

/* 复选框项目样式 */
.checkbox-item {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  border: none; /* 移除边框 */
  background: transparent; /* 移除背景色 */
}

.checkbox-label {
  display: flex;
  align-items: center;
  font-weight: normal;
  cursor: pointer;
  color: #333;
  font-size: 14px;
  white-space: nowrap;
}

.checkbox-label input[type="checkbox"] {
  margin-right: 6px;
  width: 16px;
  height: 16px;
  cursor: pointer;
  accent-color: #1890ff;
}

/* 评价单元格样式 */
.evaluation-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  flex-wrap: wrap;
}

.deleted-badge {
  font-size: 12px;
  color: #999;
  background-color: #f5f5f5;
  padding: 2px 6px;
  border-radius: 3px;
  white-space: nowrap;
  margin-left: 20px; /* 向右移动20像素 */
  border: none; /* 去掉边框 */
}

/* 合作方状态样式 */
.status-active {
  color: #000000;
  font-size: 14px;
}

.status-deleted {
  color: #000000;
  font-size: 14px;
}

/* 多选下拉框样式 */
.multi-select-container {
  display: flex;
  flex-direction: column;
  gap: 8px;
  width: 100%;
}

.selected-items {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  min-height: 32px;
  padding: 4px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  background-color: #fafafa;
  transition: all 0.3s ease;
}

.selected-items:hover {
  border-color: #40a9ff;
  background-color: #f0f8ff;
}

.selected-item {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 8px;
  background: linear-gradient(135deg, #e6f7ff 0%, #f0f7ff 100%);
  border: 1px solid #91d5ff;
  border-radius: 16px;
  font-size: 12px;
  color: #1890ff;
  font-weight: 500;
  animation: fadeIn 0.3s ease;
  box-shadow: 0 2px 4px rgba(24, 144, 255, 0.1);
  transition: all 0.2s ease;
}

.selected-item:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(24, 144, 255, 0.2);
}

.remove-btn {
  background: none;
  border: none;
  color: #ff4d4f;
  font-size: 14px;
  cursor: pointer;
  padding: 2px;
  border-radius: 50%;
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  transition: all 0.2s ease;
}

.remove-btn:hover {
  background: #ff4d4f;
  color: white;
  transform: rotate(90deg);
}

.empty-state {
  color: #999;
  font-size: 12px;
  font-style: italic;
  padding: 0 8px;
}

.multi-select-dropdown {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  background: #fff;
  font-size: 14px;
  transition: all 0.3s ease;
  cursor: pointer;
}

.multi-select-dropdown:focus {
  border-color: #40a9ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
  outline: none;
}

.multi-select-dropdown:hover {
  border-color: #40a9ff;
}

/* 文件上传控件样式 */
.file-upload-section {
  display: flex;
  flex-direction: column;
  gap: 8px;
  width: 100%;
}

.file-upload {
  position: relative;
  display: inline-block;
  width: 100%;
}

.file-upload label {
  display: inline-block;
  padding: 8px 12px;
  background: #f8f9fa;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  color: #495057;
  transition: all 0.3s ease;
  text-align: left;
  height: auto;
  line-height: 1.4;
  display: flex;
  align-items: center;
  width: calc(100% - 160px);
  min-width: 0;
  box-sizing: border-box;
}

.file-upload label:hover:not(.disabled) {
  background: #e9ecef;
  border-color: #adb5bd;
}

.file-upload label.disabled {
  background: #f8f9fa;
  color: #6c757d;
  cursor: not-allowed;
  opacity: 0.6;
}

.upload-text {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

.file-info {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px 8px;
  background: #e3f2fd;
  border: 1px solid #bbdefb;
  border-radius: 4px;
  font-size: 12px;
}

.file-name {
  color: #1976d2;
  font-weight: 500;
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.file-remove-btn {
  background: none;
  border: none;
  color: #f44336;
  font-size: 16px;
  cursor: pointer;
  padding: 2px;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  transition: all 0.2s ease;
}

.file-remove-btn:hover {
  background: #f44336;
  color: white;
  transform: scale(1.1);
}

/* 内嵌式多选下拉控件样式 */
.business-scope-dropdown,
.industry-chain-dropdown,
.partner-type-dropdown {
  position: relative;
  flex: 1;
  min-width: 120px;
}

.multi-select-component {
  position: relative;
  width: 100%;
}

.multi-select-input {
  width: 100%;
  padding: 8px 30px 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  background: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 4px;
  transition: all 0.3s ease;
  font-size: 14px;
  box-sizing: border-box;
  line-height: 1.5;
  min-height: 20px;
}

.multi-select-input:hover {
  border-color: #40a9ff;
}

.multi-select-input:focus {
  outline: none;
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

.multi-select-input.disabled {
  background-color: #f5f5f5;
  cursor: not-allowed;
}

.selected-items {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  flex: 1;
  align-items: center;
}

.selected-item {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 2px 6px;
  background: #e6f7ff;
  border: 1px solid #91d5ff;
  border-radius: 12px;
  font-size: 12px;
  color: #1890ff;
  animation: fadeIn 0.3s ease;
}

.remove-btn {
  background: none;
  border: none;
  color: #ff4d4f;
  font-size: 12px;
  cursor: pointer;
  padding: 1px;
  border-radius: 50%;
  width: 14px;
  height: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  transition: all 0.2s ease;
}

.remove-btn:hover {
  background: #ff4d4f;
  color: white;
  transform: scale(1.1);
}

.placeholder {
  color: #bfbfbf;
  font-size: 14px;
}

.dropdown-arrow {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 5px 5px 0 5px;
  border-color: #999 transparent transparent transparent;
  transition: transform 0.3s;
}

.dropdown-arrow.active {
  transform: translateY(-50%) rotate(180deg);
}

.dropdown-options {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: #fff;
  border: 1px solid #d9d9d9;
  border-top: none;
  border-radius: 0 0 4px 4px;
  max-height: 200px;
  overflow-y: auto;
  z-index: 9999;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  width: 100%;
}

.dropdown-option {
  padding: 8px 12px;
  cursor: pointer;
  transition: background-color 0.2s ease;
  font-size: 14px;
  border-bottom: 1px solid #f0f0f0;
}

.dropdown-option:last-child {
  border-bottom: none;
}

.dropdown-option:hover {
  background-color: #f5f5f5;
}

.no-options {
  padding: 12px;
  text-align: center;
  color: #999;
  font-size: 14px;
}

/* 经营范围标签样式 */
.selected-business-scopes {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 10px;
  min-height: 40px;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background-color: #f9f9f9;
}

.scope-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 8px;
  background: #e6f7ff;
  border: 1px solid #91d5ff;
  border-radius: 4px;
  font-size: 12px;
  color: #1890ff;
  animation: fadeIn 0.3s ease;
}

.scope-tag span {
  font-weight: 500;
}

.scope-remove-btn {
  background: none;
  border: none;
  color: #ff4d4f;
  font-size: 14px;
  cursor: pointer;
  padding: 2px;
  border-radius: 2px;
  line-height: 1;
  transition: all 0.2s ease;
}

.scope-remove-btn:hover {
  background: #ff4d4f;
  color: white;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 页签导航样式 */
.tab-navigation {
  display: flex;
  border-bottom: 2px solid #e8e8e8;
  margin-bottom: 20px;
  background: #fafafa;
  padding: 0 20px;
}

.tab-item {
  padding: 10px 20px;
  cursor: pointer;
  border-bottom: 3px solid transparent;
  color: #666;
  font-weight: 500;
  font-size: 14px;
  transition: all 0.3s ease;
  margin-right: 2px;
  background: #f5f5f5;
  border-radius: 4px 4px 0 0;
  position: relative;
  top: 1px;
}

.tab-item:hover {
  background: #e6f7ff;
  color: #1890ff;
  border-bottom-color: #40a9ff;
}

.tab-item.active {
  background: #fff;
  color: #1890ff;
  border-bottom-color: #1890ff;
  border-top: 1px solid #d9d9d9;
  border-left: 1px solid #d9d9d9;
  border-right: 1px solid #d9d9d9;
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
  font-weight: 600;
}

.tab-content {
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 0 6px 6px 6px;
  margin-top: -1px;
}

.tab-panel {
  padding: 15px;
  min-height: 350px;
}

/* 文档状态样式 */
.doc-status {
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.doc-status.pending {
  background: #fff1f0;
  color: #ff4d4f;
  border: 1px solid #ffccc7;
}

.doc-status.uploaded {
  background: #e6f7ff;
  color: #1890ff;
  border: 1px solid #91d5ff;
}

.doc-status.approved {
  background: #f6ffed;
  color: #52c41a;
  border: 1px solid #b7eb8f;
}

.doc-status.rejected {
  background: #fff2e8;
  color: #fa541c;
  border: 1px solid #ffbb96;
}

/* 合作方类型标签样式 */
.partner-type-display {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  align-items: center;
  justify-content: center;
}

/* 产业链类型标签样式 */
.industry-chain-display {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  align-items: center;
  justify-content: center;
}

.chain-tag {
  display: inline-block;
  padding: 2px 6px;
  background: #e6f7ff;
  border: 1px solid #91d5ff;
  border-radius: 10px;
  font-size: 11px;
  color: #1890ff;
  font-weight: 500;
}

/* 经营范围标签样式 */
.business-scope-display {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  align-items: center;
  max-width: 200px;
  justify-content: center;
}

.scope-tag {
  display: inline-block;
  padding: 2px 6px;
  background: #f6ffed;
  border: 1px solid #b7eb8f;
  border-radius: 10px;
  font-size: 11px;
  color: #52c41a;
  font-weight: 500;
}

/* 国别显示样式 */
.country-display {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4px 8px;
  min-height: 28px;
}

.country-tag {
  display: inline-block;
  padding: 4px 8px;
  background: #fff0f6;
  border: 1px solid #ffadd2;
  border-radius: 12px;
  font-size: 12px;
  color: #eb2f96;
  font-weight: 500;
  text-align: center;
  min-width: 60px;
}

.country-display .country-tag {
  background: #fff0f6;
  border: 1px solid #ffadd2;
  color: #eb2f96;
}

</style>

<style>
/* 全局模态框样式 - 不使用scoped */
.partner-modal-overlay {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  width: 100% !important;
  height: 100% !important;
  background: rgba(0, 0, 0, 0.5) !important;
  display: flex !important;
  justify-content: center !important;
  align-items: center !important;
  z-index: 999999 !important;
  overflow: auto !important;
  padding: 20px !important;
  box-sizing: border-box !important;
}

.partner-modal-content {
  background: white !important;
  border-radius: 8px !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15) !important;
  overflow-y: auto !important;
  width: 90% !important;
  max-width: 1200px !important;
  max-height: 90vh !important;
  margin: 20px auto !important;
  position: relative !important;
  display: flex !important;
  flex-direction: column !important;
}

.partner-modal-header {
  display: flex !important;
  justify-content: space-between !important;
  align-items: center !important;
  padding: 20px !important;
  border-bottom: 1px solid #e8e8e8 !important;
  background: #fafafa !important;
}

.partner-modal-action-buttons {
  display: flex !important;
  gap: 8px !important;
  align-items: center !important;
}

.partner-modal-header h3 {
  margin: 0 !important;
  color: #333 !important;
}
</style>
