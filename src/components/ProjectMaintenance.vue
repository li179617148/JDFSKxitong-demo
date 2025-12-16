<template>
  <div class="project-maintenance">
    <!-- 查询筛选模块 -->
    <div class="card filter-card">
      <div class="filter-grid">
        <div class="filter-item">
          <label>项目名称：</label>
          <input v-model="filters.name" type="text" placeholder="请输入项目名称" />
        </div>
        <div class="filter-item">
          <label>区域机构：</label>
          <select v-model="filters.region">
            <option value="">全部</option>
            <option v-for="r in options.regions" :key="r" :value="r">{{ r }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>项目类别：</label>
          <select v-model="filters.category">
            <option value="">全部</option>
            <option v-for="c in options.categories" :key="c" :value="c">{{ c }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>施工类型：</label>
          <select v-model="filters.constructionType">
            <option value="">全部</option>
            <option v-for="t in options.constructionTypes" :key="t" :value="t">{{ t }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>项目阶段：</label>
          <select v-model="filters.stage">
            <option value="">全部</option>
            <option v-for="s in options.stages" :key="s" :value="s">{{ s }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>产业链：</label>
          <select v-model="filters.industryChain">
            <option value="">全部</option>
            <option v-for="i in options.industryChains" :key="i" :value="i">{{ i }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>合同金额：</label>
          <select v-model="filters.amountRange">
            <option value="">全部</option>
            <option value="0-5000">5000万以下</option>
            <option value="5000-10000">5000万-1亿</option>
            <option value="10000-50000">1亿-5亿</option>
            <option value="50000-100000">5亿-10亿</option>
            <option value="100000+">10亿以上</option>
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
        <h4>项目列表</h4>
        <div class="header-actions">
            <button class="btn-success" @click="handleAdd">新增</button>
            <button class="btn-info" @click="handleExport">导出</button>
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
              <th>项目阶段</th>
              <th>项目所在国</th>
              <th>中标日期</th>
              <th>开工日期</th>
              <th>合同金额（万人民币）</th>
              <th>产业链</th>
              <th>审批状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, idx) in displayList" :key="row.id">
              <td>{{ idx + 1 }}</td>
              <td>{{ row.name }}</td>
              <td>{{ row.region }}</td>
              <td>{{ row.category }}</td>
              <td>{{ row.constructionType }}</td>
              <td>{{ row.stage }}</td>
              <td>{{ row.country }}</td>
              <td>{{ row.bidDate }}</td>
              <td>{{ row.startDate }}</td>
              <td>{{ row.amount }}</td>
              <td>{{ row.industryChain }}</td>
              <td>{{ getApprovalStatusText(row.approvalStatus) }}</td>
              <td>
                <div class="op-btns">
                  <button class="btn-primary" @click="handleEdit(row)">编辑</button>
                  <button
                    v-if="canDelete(row)"
                    class="btn-danger"
              @click="handleDelete(row)"
              >删除</button>
                </div>
              </td>
            </tr>
            <tr v-if="displayList.length === 0">
              <td colspan="13" class="empty">暂无数据</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 新增项目弹窗 -->
    <div v-if="showAddModal" class="modal-overlay">
      <div class="modal" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>项目信息</h3>
          <div class="header-actions">
            <button class="btn-primary" @click="handleAddSubmit">提交</button>
            <button class="btn-primary" @click="handleAddSave">暂存</button>
            <button class="btn-secondary" @click="handleAddCancel">取消</button>
          </div>
        </div>
        <div class="modal-body">
          <div class="modal-grid">
            <!-- 第一列 -->
            <div class="form-item">
              <label><span class="req">*</span>项目名称：</label>
              <input v-model="addForm.name" type="text" placeholder="请输入项目名称" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>合同金额（万人民币）：</label>
              <input v-model="addForm.amount" type="number" min="0" step="0.01" placeholder="请输入合同金额" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>项目类别：</label>
              <select v-model="addForm.category">
                <option value="">请选择</option>
                <option v-for="c in options.categories" :key="c" :value="c">{{ c }}</option>
              </select>
            </div>
            <!-- 第二列 -->
            <div class="form-item">
              <label>项目编号：</label>
              <input v-model="addForm.projectNo" type="text" placeholder="可选填写项目编号" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>产业链：</label>
              <select v-model="addForm.industryChain">
                <option value="">请选择</option>
                <option v-for="i in options.industryChains" :key="i" :value="i">{{ i }}</option>
              </select>
            </div>
            <div class="form-item">
              <label><span class="req">*</span>区域机构：</label>
              <select v-model="addForm.region">
                <option value="">请选择</option>
                <option v-for="r in options.regions" :key="r" :value="r">{{ r }}</option>
              </select>
            </div>
            <!-- 第三列 -->
            <div class="form-item">
              <label><span class="req">*</span>项目所在国：</label>
              <input v-model="addForm.country" type="text" placeholder="请输入所在国" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>施工类型：</label>
              <select v-model="addForm.constructionType">
                <option value="">请选择</option>
                <option v-for="t in options.constructionTypes" :key="t" :value="t">{{ t }}</option>
              </select>
            </div>
            <div class="form-item">
              <label><span class="req">*</span>项目阶段：</label>
              <select v-model="addForm.stage">
                <option value="">请选择</option>
                <option v-for="s in options.stages" :key="s" :value="s">{{ s }}</option>
              </select>
            </div>
            <!-- 日期行（同一网格继续排布） -->
            <div class="form-item">
              <label><span class="req">*</span>中标日期：</label>
              <input v-model="addForm.bidDate" type="date" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>开工日期：</label>
              <input v-model="addForm.startDate" type="date" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 编辑项目弹窗 -->
    <div v-if="showEditModal" class="modal-overlay">
      <div class="modal" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>项目信息</h3>
          <div class="header-actions">
            <button class="btn-primary" @click="handleEditSubmit">提交</button>
            <button class="btn-primary" @click="handleEditSave">暂存</button>
            <button class="btn-secondary" @click="handleEditCancel">取消</button>
          </div>
        </div>
        <div class="modal-body">
          <!-- 基本信息三列 -->
          <div class="modal-grid">
            <div class="form-item">
              <label><span class="req">*</span>项目名称</label>
              <input v-model="editForm.name" type="text" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>合同金额（万人民币）</label>
              <input v-model="editForm.amount" type="number" min="0" step="0.01" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>项目类别</label>
              <select v-model="editForm.category">
                <option value="">请选择</option>
                <option v-for="c in options.categories" :key="c" :value="c">{{ c }}</option>
              </select>
            </div>
            <div class="form-item">
              <label>项目编号</label>
              <input v-model="editForm.projectNo" type="text" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>产业链</label>
              <select v-model="editForm.industryChain">
                <option value="">请选择</option>
                <option v-for="i in options.industryChains" :key="i" :value="i">{{ i }}</option>
              </select>
            </div>
            <div class="form-item">
              <label><span class="req">*</span>区域机构</label>
              <select v-model="editForm.region">
                <option value="">请选择</option>
                <option v-for="r in options.regions" :key="r" :value="r">{{ r }}</option>
              </select>
            </div>
            <div class="form-item">
              <label><span class="req">*</span>项目所在国</label>
              <input v-model="editForm.country" type="text" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>施工类型</label>
              <select v-model="editForm.constructionType">
                <option value="">请选择</option>
                <option v-for="t in options.constructionTypes" :key="t" :value="t">{{ t }}</option>
              </select>
            </div>
            <div class="form-item">
              <label><span class="req">*</span>项目阶段</label>
              <select v-model="editForm.stage">
                <option value="">请选择</option>
                <option v-for="s in options.stages" :key="s" :value="s">{{ s }}</option>
              </select>
            </div>
            <div class="form-item">
              <label><span class="req">*</span>中标日期</label>
              <input v-model="editForm.bidDate" type="date" />
            </div>
            <div class="form-item">
              <label><span class="req">*</span>开工日期</label>
              <input v-model="editForm.startDate" type="date" />
            </div>
          </div>

          <!-- 物资装备投标价格清单（仅已审批状态显示） -->
          <div v-if="editForm.approvalStatus === 'approved'" class="section">
            <div class="section-header">
              <h5>物资装备投标价格清单</h5>
            </div>
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>序号</th>
                    <th>一级名称</th>
                    <th>二级名称</th>
                    <th>物资装备名称</th>
                    <th>合作方名称</th>
                    <th>币种</th>
                    <th>汇率</th>
                    <th>出厂价EXW（万元）</th>
                    <th>国内港口车板交货价（万元）</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(item, idx) in bidPrices" :key="'bid-'+idx">
                    <td>{{ idx + 1 }}</td>
                    <td>
                      <select v-model="item.level1">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.level1" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.level2">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.level2" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.equipment">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.equipments" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.partner">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.partners" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.currency">
                        <option v-for="v in priceOptions.currencies" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <input v-model.number="item.fxRate" type="number" min="0" step="0.0001" />
                    </td>
                    <td>
                      <input v-model.number="item.exw" type="number" min="0" step="0.01" />
                    </td>
                    <td>
                      <input v-model.number="item.domesticPrice" type="number" min="0" step="0.01" />
                    </td>
                    <td class="op-btns">
                      <button class="btn-primary" @click="editPriceRow('bid', idx)">编辑</button>
                      <button class="btn-danger" @click="deletePriceRow('bid', idx)">删除</button>
                    </td>
                  </tr>
                  <tr v-if="bidPrices.length === 0">
                    <td colspan="10" class="empty">暂无投标价格数据</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 物资装备实际采购价格清单（仅已审批状态显示） -->
          <div v-if="editForm.approvalStatus === 'approved'" class="section">
            <div class="section-header">
              <h5>物资装备实际采购价格清单</h5>
            </div>
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>序号</th>
                    <th>一级名称</th>
                    <th>二级名称</th>
                    <th>物资装备名称</th>
                    <th>合作方名称</th>
                    <th>币种</th>
                    <th>汇率</th>
                    <th>出厂价EXW（万元）</th>
                    <th>国内港口车板交货价（万元）</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(item, idx) in contractPrices" :key="'contract-'+idx">
                    <td>{{ idx + 1 }}</td>
                    <td>
                      <select v-model="item.level1">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.level1" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.level2">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.level2" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.equipment">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.equipments" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.partner">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.partners" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.currency">
                        <option v-for="v in priceOptions.currencies" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <input v-model.number="item.fxRate" type="number" min="0" step="0.0001" />
                    </td>
                    <td>
                      <input v-model.number="item.exw" type="number" min="0" step="0.01" />
                    </td>
                    <td>
                      <input v-model.number="item.domesticPrice" type="number" min="0" step="0.01" />
                    </td>
                    <td class="op-btns">
                      <button class="btn-primary" @click="editPriceRow('contract', idx)">编辑</button>
                      <button class="btn-danger" @click="deletePriceRow('contract', idx)">删除</button>
                    </td>
                  </tr>
                  <tr v-if="contractPrices.length === 0">
                    <td colspan="10" class="empty">暂无合同价格数据</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 物资装备弹窗 -->
    <div v-if="showEquipmentModal" class="modal-overlay">
      <div class="modal" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>物资装备维护</h3>
          <div class="header-actions">
            <button class="btn-primary" @click="handleEquipmentSave">保存</button>
            <button class="btn-secondary" @click="handleEquipmentCancel">取消</button>
          </div>
        </div>
        <div class="modal-body">
          <!-- 项目基本信息（只读） -->
          <div class="readonly-info">
            <h5>项目基本信息</h5>
            <div class="info-grid">
              <div class="info-item">
                <label>项目名称：</label>
                <span>{{ editForm.name }}</span>
              </div>
              <div class="info-item">
                <label>区域机构：</label>
                <span>{{ editForm.region }}</span>
              </div>
              <div class="info-item">
                <label>项目类别：</label>
                <span>{{ editForm.category }}</span>
              </div>
              <div class="info-item">
                <label>施工类型：</label>
                <span>{{ editForm.constructionType }}</span>
              </div>
              <div class="info-item">
                <label>合同金额：</label>
                <span>{{ editForm.amount }} 万人民币</span>
              </div>
              <div class="info-item">
                <label>审批状态：</label>
                <span>{{ getApprovalStatusText(editForm.approvalStatus) }}</span>
              </div>
            </div>
          </div>

          <!-- 物资装备投标价格清单 -->
          <div class="section">
            <div class="section-header">
              <h5>物资装备投标价格清单</h5>
              <div class="section-actions">
                <button class="btn-primary" @click="addPriceRow('bid')">添加</button>
                <button class="btn-primary" @click="importPriceRows('bid')">导入</button>
              </div>
            </div>
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>序号</th>
                    <th>一级名称</th>
                    <th>二级名称</th>
                    <th>物资装备名称</th>
                    <th>合作方名称</th>
                    <th>币种</th>
                    <th>汇率</th>
                    <th>出厂价EXW（万元）</th>
                    <th>国内港口车板交货价（万元）</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(item, idx) in bidPrices" :key="'bid-'+idx">
                    <td>{{ idx + 1 }}</td>
                    <td>
                      <select v-model="item.level1">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.level1" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.level2">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.level2" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.equipment">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.equipments" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.partner">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.partners" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.currency">
                        <option v-for="v in priceOptions.currencies" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <input v-model.number="item.fxRate" type="number" min="0" step="0.0001" />
                    </td>
                    <td>
                      <input v-model.number="item.exw" type="number" min="0" step="0.01" />
                    </td>
                    <td>
                      <input v-model.number="item.domesticPrice" type="number" min="0" step="0.01" />
                    </td>
                    <td class="op-btns">
                      <button class="btn-primary" @click="editPriceRow('bid', idx)">编辑</button>
                      <button class="btn-danger" @click="deletePriceRow('bid', idx)">删除</button>
                    </td>
                  </tr>
                  <tr v-if="bidPrices.length === 0">
                    <td colspan="10" class="empty">暂无投标价格数据</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- 物资装备合同价格清单 -->
          <div class="section">
            <div class="section-header">
              <h5>物资装备合同价格清单</h5>
              <div class="section-actions">
                <button class="btn-primary" @click="addPriceRow('contract')">添加</button>
                <button class="btn-primary" @click="importPriceRows('contract')">导入</button>
              </div>
            </div>
            <div class="table-wrapper">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>序号</th>
                    <th>一级名称</th>
                    <th>二级名称</th>
                    <th>物资装备名称</th>
                    <th>合作方名称</th>
                    <th>币种</th>
                    <th>汇率</th>
                    <th>出厂价EXW（万元）</th>
                    <th>国内港口车板交货价（万元）</th>
                    <th>操作</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(item, idx) in contractPrices" :key="'contract-'+idx">
                    <td>{{ idx + 1 }}</td>
                    <td>
                      <select v-model="item.level1">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.level1" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.level2">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.level2" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.equipment">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.equipments" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.partner">
                        <option value="">请选择</option>
                        <option v-for="v in priceOptions.partners" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <select v-model="item.currency">
                        <option v-for="v in priceOptions.currencies" :key="v" :value="v">{{ v }}</option>
                      </select>
                    </td>
                    <td>
                      <input v-model.number="item.fxRate" type="number" min="0" step="0.0001" />
                    </td>
                    <td>
                      <input v-model.number="item.exw" type="number" min="0" step="0.01" />
                    </td>
                    <td>
                      <input v-model.number="item.domesticPrice" type="number" min="0" step="0.01" />
                    </td>
                    <td class="op-btns">
                      <button class="btn-primary" @click="editPriceRow('contract', idx)">编辑</button>
                      <button class="btn-danger" @click="deletePriceRow('contract', idx)">删除</button>
                    </td>
                  </tr>
                  <tr v-if="contractPrices.length === 0">
                    <td colspan="10" class="empty">暂无合同价格数据</td>
                  </tr>
                </tbody>
              </table>
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
  name: 'ProjectMaintenance',
  data() {
    return {
      // 选项
      options: {
        regions: ['华北区域', '华东区域', '华南区域', '西南区域', '西北区域'],
        categories: ['市政工程', '房建工程', '轨道交通', '水利工程', '能源工程'],
        constructionTypes: ['总承包', '专业分包', '劳务分包', '设计施工一体化'],
        stages: ['投标', '签约', '施工', '竣工', '结算'],
        industryChains: ['水运', '公路', '轨道交通', '机场', '建筑', '市政', '海洋工程', '生态环保', '绿色能源', '新基建']
      },
      // 筛选条件
      filters: {
        name: '',
        region: '',
        category: '',
        constructionType: '',
        stage: '',
        industryChain: '',
        amountRange: ''
      },
      // 原始数据
      rawList: [
        {
          id: 1,
          name: '北京市地铁XX线三期工程',
          region: '华北区域',
          category: '轨道交通',
          constructionType: '总承包',
          stage: '施工',
          country: '中国',
          bidDate: '2023-08-15',
          startDate: '2023-10-01',
          amount: 128000,
          industryChain: '轨道交通',
          hasEquipment: true,
          approvalStatus: 'approved' // 已审批
        },
        {
          id: 2,
          name: '上海市浦东新区市政道路改造',
          region: '华东区域',
          category: '市政工程',
          constructionType: '专业分包',
          stage: '投标',
          country: '中国',
          bidDate: '2024-01-20',
          startDate: '2024-03-15',
          amount: 35000,
          industryChain: '市政',
          hasEquipment: false,
          approvalStatus: 'pending' // 审批中
        },
        {
          id: 3,
          name: '深圳某房建项目一期',
          region: '华南区域',
          category: '房建工程',
          constructionType: '劳务分包',
          stage: '签约',
          country: '中国',
          bidDate: '2023-12-10',
          startDate: '2024-02-01',
          amount: 82000,
          industryChain: '建筑',
          hasEquipment: false,
          approvalStatus: 'draft' // 未提交
        },
        {
          id: 4,
          name: '巴基斯坦卡拉奇港口建设项目',
          region: '西南区域',
          category: '水利工程',
          constructionType: '总承包',
          stage: '竣工',
          country: '巴基斯坦',
          bidDate: '2023-05-20',
          startDate: '2023-07-01',
          amount: 156000,
          industryChain: '水运',
          hasEquipment: true,
          approvalStatus: 'approved' // 已审批
        },
        {
          id: 5,
          name: '迪拜棕榈岛房建项目',
          region: '西北区域',
          category: '房建工程',
          constructionType: '设计施工一体化',
          stage: '结算',
          country: '阿联酋',
          bidDate: '2023-03-15',
          startDate: '2023-05-01',
          amount: 238000,
          industryChain: '建筑',
          hasEquipment: false,
          approvalStatus: 'approved' // 已审批
        }
      ],
      displayList: [],
      // 弹窗相关
      showAddModal: false,
      showEquipmentModal: false, // 物资装备弹窗
      addForm: {
        name: '',
        amount: '',
        category: '',
        projectNo: '',
        industryChain: '',
        region: '',
        country: '',
        constructionType: '',
        stage: '',
        bidDate: '',
        startDate: '',
        approvalStatus: 'draft' // 默认未提交
      },
      /* 编辑弹窗与价格清单数据 */
      showEditModal: false,
      editForm: {
        id: null,
        name: '',
        amount: '',
        category: '',
        projectNo: '',
        industryChain: '',
        region: '',
        country: '',
        constructionType: '',
        stage: '',
        bidDate: '',
        startDate: '',
        approvalStatus: 'draft'
      },
      bidPrices: [],
      contractPrices: [],
      priceOptions: {
        level1: ['土建', '机电', '设备'],
        level2: ['钢筋', '混凝土', '电缆', '塔吊', '挖掘机'],
        equipments: ['塔吊 TC7020', '挖掘机 CAT320', '混凝土泵车 SANY'],
        partners: ['北京建工集团', '中建三局', '上海某供应商'],
        currencies: ['CNY', 'USD', 'EUR']
      }
    }
  },
  created() {
    this.displayList = [...this.rawList]
  },
  methods: {
    // 获取审批状态文本
    getApprovalStatusText(status) {
      const statusMap = {
        'draft': '未提交',
        'pending': '审批中',
        'approved': '已审批',
        'rejected': '已驳回'
      }
      return statusMap[status] || '未知'
    },
    
    // 检查是否可以编辑物资装备
    canEditEquipment(row) {
      return row.approvalStatus === 'approved' // 只有已审批状态可以编辑物资装备
    },
    
    handleQuery() {
      const f = this.filters
      this.displayList = this.rawList.filter((row) => {
        const byName = f.name ? row.name.toLowerCase().includes(f.name.trim().toLowerCase()) : true
        const byRegion = f.region ? row.region === f.region : true
        const byCategory = f.category ? row.category === f.category : true
        const byType = f.constructionType ? row.constructionType === f.constructionType : true
        const byStage = f.stage ? row.stage === f.stage : true
        const byChain = f.industryChain ? row.industryChain === f.industryChain : true

        // 合同金额范围查询
        let byAmountRange = true
        if (f.amountRange) {
          const amount = row.amount
          switch (f.amountRange) {
            case '0-5000':
              byAmountRange = amount < 5000
              break
            case '5000-10000':
              byAmountRange = amount >= 5000 && amount < 10000
              break
            case '10000-50000':
              byAmountRange = amount >= 10000 && amount < 50000
              break
            case '50000-100000':
              byAmountRange = amount >= 50000 && amount < 100000
              break
            case '100000+':
              byAmountRange = amount >= 100000
              break
          }
        }

        return byName && byRegion && byCategory && byType && byStage && byChain && byAmountRange
      })
    },
    handleReset() {
      this.filters = {
        name: '',
        region: '',
        category: '',
        constructionType: '',
        stage: '',
        industryChain: '',
        amountRange: ''
      }
      this.displayList = [...this.rawList]
    },
    // 新增 -> 打开弹窗
    handleAdd() {
      this.resetAddForm()
      this.showAddModal = true
    },
    handleEdit(row) {
      this.editForm = {
        id: row.id,
        name: row.name,
        amount: row.amount,
        category: row.category,
        projectNo: row.projectNo || '',
        industryChain: row.industryChain,
        region: row.region,
        country: row.country || '',
        constructionType: row.constructionType,
        stage: row.stage,
        bidDate: row.bidDate || '',
        startDate: row.startDate || '',
        approvalStatus: row.approvalStatus || 'draft'
      }
      // 根据审批状态决定是否显示物资装备部分
      if (row.approvalStatus === 'approved') {
        this.bidPrices = Array.isArray(row.bidPrices) ? [...row.bidPrices] : []
        this.contractPrices = Array.isArray(row.contractPrices) ? [...row.contractPrices] : []
      } else {
        this.bidPrices = []
        this.contractPrices = []
      }
      this.showEditModal = true
    },
    handleDelete(row) {
      if (row.hasEquipment) {
        alert('该项目已维护物资装备，不能删除')
        return
      }
      // 检查审批状态
      if (row.approvalStatus === 'pending' || row.approvalStatus === 'approved') {
        alert('审批中和已审批状态的项目不允许删除')
        return
      }
      this.rawList = this.rawList.filter((r) => r.id !== row.id)
      this.handleQuery()
      alert('删除成功')
    },
    handleEquipment(row) {
      // 打开物资装备弹窗
      this.editForm = {
        id: row.id,
        name: row.name,
        amount: row.amount,
        category: row.category,
        projectNo: row.projectNo || '',
        industryChain: row.industryChain,
        region: row.region,
        country: row.country || '',
        constructionType: row.constructionType,
        stage: row.stage,
        bidDate: row.bidDate || '',
        startDate: row.startDate || '',
        approvalStatus: row.approvalStatus || 'draft'
      }
      this.bidPrices = Array.isArray(row.bidPrices) ? [...row.bidPrices] : []
      this.contractPrices = Array.isArray(row.contractPrices) ? [...row.contractPrices] : []
      this.showEquipmentModal = true
    },
    /* 删除按钮显示逻辑：审批中和已审批状态不允许删除 */
    canDelete(row) {
      const hasBid = Array.isArray(row.bidPrices) && row.bidPrices.length > 0
      const hasContract = Array.isArray(row.contractPrices) && row.contractPrices.length > 0
      const isApprovalProtected = row.approvalStatus === 'pending' || row.approvalStatus === 'approved'
      return !(hasBid || hasContract || isApprovalProtected)
    },
    // 弹窗方法
    resetAddForm() {
      this.addForm = {
        name: '',
        amount: '',
        category: '',
        projectNo: '',
        industryChain: '',
        region: '',
        country: '',
        constructionType: '',
        stage: '',
        bidDate: '',
        startDate: '',
        approvalStatus: 'draft'
      }
    },
    validateAddForm() {
      const f = this.addForm
      const required = [
        { key: 'name', label: '项目名称' },
        { key: 'amount', label: '合同金额（万人民币）' },
        { key: 'category', label: '项目类别' },
        { key: 'industryChain', label: '产业链' },
        { key: 'region', label: '区域机构' },
        { key: 'country', label: '项目所在国' },
        { key: 'constructionType', label: '施工类型' },
        { key: 'stage', label: '项目阶段' },
        { key: 'bidDate', label: '中标日期' },
        { key: 'startDate', label: '开工日期' }
      ]
      const missing = required.filter(r => !String(f[r.key] || '').trim())
      if (missing.length) {
        alert('请填写必填项：' + missing.map(m => m.label).join('、'))
        return false
      }
      const amt = Number(f.amount)
      if (Number.isNaN(amt) || amt < 0) {
        alert('合同金额需为非负数字')
        return false
      }
      return true
    },
    // 新增提交
    handleAddSubmit() {
      if (!this.validateAddForm()) return
      const nextId = (this.rawList[this.rawList.length - 1]?.id || 0) + 1
      const f = this.addForm
      const newItem = {
        id: nextId,
        name: f.name.trim(),
        region: f.region,
        category: f.category,
        constructionType: f.constructionType,
        stage: f.stage,
        amount: Number(f.amount),
        industryChain: f.industryChain,
        hasEquipment: false,
        projectNo: f.projectNo,
        country: f.country,
        bidDate: f.bidDate,
        startDate: f.startDate,
        approvalStatus: 'pending' // 提交后状态变为审批中
      }
      this.rawList.push(newItem)
      this.handleQuery()
      this.showAddModal = false
      alert('提交成功，项目已进入审批流程')
    },
    
    // 新增暂存
    handleAddSave() {
      if (!this.validateAddForm()) return
      const nextId = (this.rawList[this.rawList.length - 1]?.id || 0) + 1
      const f = this.addForm
      const newItem = {
        id: nextId,
        name: f.name.trim(),
        region: f.region,
        category: f.category,
        constructionType: f.constructionType,
        stage: f.stage,
        amount: Number(f.amount),
        industryChain: f.industryChain,
        hasEquipment: false,
        projectNo: f.projectNo,
        country: f.country,
        bidDate: f.bidDate,
        startDate: f.startDate,
        approvalStatus: 'draft' // 暂存保持未提交状态
      }
      this.rawList.push(newItem)
      this.handleQuery()
      this.showAddModal = false
      alert('暂存成功')
    },
    handleAddCancel() {
      this.showAddModal = false
    },
    // 编辑提交
    handleEditSubmit() {
      const required = [
        { key: 'name', label: '项目名称' },
        { key: 'amount', label: '合同金额（万人民币）' },
        { key: 'category', label: '项目类别' },
        { key: 'industryChain', label: '产业链' },
        { key: 'region', label: '区域机构' },
        { key: 'country', label: '项目所在国' },
        { key: 'constructionType', label: '施工类型' },
        { key: 'stage', label: '项目阶段' },
        { key: 'bidDate', label: '中标日期' },
        { key: 'startDate', label: '开工日期' }
      ]
      const f = this.editForm
      const missing = required.filter(r => !String(f[r.key] || '').trim())
      if (missing.length) {
        alert('请填写必填项：' + missing.map(m => m.label).join('、'))
        return
      }
      const amt = Number(f.amount)
      if (Number.isNaN(amt) || amt < 0) {
        alert('合同金额需为非负数字')
        return
      }
      const idx = this.rawList.findIndex(r => r.id === f.id)
      if (idx !== -1) {
        this.rawList[idx] = {
          ...this.rawList[idx],
          name: f.name.trim(),
          region: f.region,
          category: f.category,
          constructionType: f.constructionType,
          stage: f.stage,
          amount: Number(f.amount),
          industryChain: f.industryChain,
          projectNo: f.projectNo,
          country: f.country,
          bidDate: f.bidDate,
          startDate: f.startDate,
          approvalStatus: 'pending' // 提交后状态变为审批中
        }
        // 写回价格清单
        this.rawList[idx].bidPrices = [...this.bidPrices]
        this.rawList[idx].contractPrices = [...this.contractPrices]
      }
      this.handleQuery()
      this.showEditModal = false
      alert('提交成功，项目已进入审批流程')
    },
    
    // 编辑暂存
    handleEditSave() {
      const required = [
        { key: 'name', label: '项目名称' },
        { key: 'amount', label: '合同金额（万人民币）' },
        { key: 'category', label: '项目类别' },
        { key: 'industryChain', label: '产业链' },
        { key: 'region', label: '区域机构' },
        { key: 'country', label: '项目所在国' },
        { key: 'constructionType', label: '施工类型' },
        { key: 'stage', label: '项目阶段' },
        { key: 'bidDate', label: '中标日期' },
        { key: 'startDate', label: '开工日期' }
      ]
      const f = this.editForm
      const missing = required.filter(r => !String(f[r.key] || '').trim())
      if (missing.length) {
        alert('请填写必填项：' + missing.map(m => m.label).join('、'))
        return
      }
      const amt = Number(f.amount)
      if (Number.isNaN(amt) || amt < 0) {
        alert('合同金额需为非负数字')
        return
      }
      const idx = this.rawList.findIndex(r => r.id === f.id)
      if (idx !== -1) {
        this.rawList[idx] = {
          ...this.rawList[idx],
          name: f.name.trim(),
          region: f.region,
          category: f.category,
          constructionType: f.constructionType,
          stage: f.stage,
          amount: Number(f.amount),
          industryChain: f.industryChain,
          projectNo: f.projectNo,
          country: f.country,
          bidDate: f.bidDate,
          startDate: f.startDate
        }
        // 写回价格清单
        this.rawList[idx].bidPrices = [...this.bidPrices]
        this.rawList[idx].contractPrices = [...this.contractPrices]
      }
      // TODO: 在此提交 bidPrices/contractPrices 到后端
      this.handleQuery()
      this.showEditModal = false
      alert('暂存成功')
    },
    handleEditCancel() {
      this.showEditModal = false
    },
    
    // 物资装备弹窗保存
    handleEquipmentSave() {
      const idx = this.rawList.findIndex(r => r.id === this.editForm.id)
      if (idx !== -1) {
        // 只更新价格清单数据
        this.rawList[idx].bidPrices = [...this.bidPrices]
        this.rawList[idx].contractPrices = [...this.contractPrices]
      }
      this.handleQuery()
      this.showEquipmentModal = false
      alert('物资装备保存成功')
    },
    
    // 物资装备弹窗取消
    handleEquipmentCancel() {
      this.showEquipmentModal = false
    },
    /* 价格清单操作 */
    addPriceRow(type) {
      const target = type === 'bid' ? this.bidPrices : this.contractPrices
      target.push({
        level1: '',
        level2: '',
        equipment: '',
        partner: '',
        currency: 'CNY',
        fxRate: 1,
        exw: 0,
        domesticPrice: 0
      })
    },
    importPriceRows(type) {
      alert((type === 'bid' ? '投标' : '合同') + '价格清单导入功能（待接入）')
    },
    editPriceRow(type, idx) {
      const target = type === 'bid' ? this.bidPrices : this.contractPrices
      const item = target[idx]
      const val = prompt('修改出厂价EXW（万元）：', String(item.exw))
      if (val !== null) {
        const num = Number(val)
        if (!Number.isNaN(num) && num >= 0) item.exw = num
        else alert('请输入有效数字')
      }
    },
    deletePriceRow(type, idx) {
      const target = type === 'bid' ? this.bidPrices : this.contractPrices
      target.splice(idx, 1)
    },
    handleExport() {
      if (!this.displayList.length) {
        alert('当前无数据可导出')
        return
      }
      const headers = [
        '序号',
        '项目名称',
        '区域机构',
        '项目类别',
        '施工类型',
        '项目阶段',
        '合同金额（万人民币）',
        '产业链'
      ]
      const rows = this.displayList.map((row, idx) => [
        idx + 1,
        row.name,
        row.region,
        row.category,
        row.constructionType,
        row.stage,
        row.amount,
        row.industryChain
      ])
      const csv = [headers, ...rows]
        .map((r) => r.map((cell) => `"${String(cell).replace(/"/g, '""')}"`).join(','))
        .join('\n')
      const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' })
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = '项目维护导出.csv'
      document.body.appendChild(a)
      a.click()
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
    }
  }
}
</script>

<style scoped>
.project-maintenance {
  padding: 20px;
  background: #f0f2f5;
  min-height: 100vh;
  overflow-y: auto;
}

/* 通用卡片样式 - 使用统一蓝色主题 */
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

/* 筛选区布局 - 使用统一蓝色主题 */
.filter-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
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

/* 列表头部 - 使用统一蓝色主题 */
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

/* 表格 - 使用统一蓝色主题 */
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

/* 按钮样式 - 使用统一蓝色主题 */
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

.btn.export { 
  background: #722ed1; 
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

.btn.info { 
  background: #13c2c2; 
  color: #fff; 
}

.btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.btn:disabled {
  background: #f5f5f5 !important;
  color: #999 !important;
  cursor: not-allowed !important;
  border: 1px solid #e5e5e5 !important;
  transform: none;
  box-shadow: none;
}
.empty { color: #999; }

/* 弹窗样式 - 使用统一蓝色主题 */
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
  width: 1400px;
  max-width: 98vw;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 32px;
  font-size: 20px;
  font-weight: 700;
  background: #fafafa;
  color: #333;
  border-bottom: 1px solid #e8e8e8;
  border-radius: 16px 16px 0 0;
  margin: 0;
}

.header-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}

.header-actions .btn-primary {
  padding: 8px 16px;
  font-size: 14px;
  background: #1890ff;
  border: 1px solid #1890ff;
  color: white;
  font-weight: 600;
  transition: all 0.3s ease;
}

.header-actions .btn-primary:hover {
  background: #40a9ff;
  border-color: #40a9ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(24, 144, 255, 0.3);
}

.header-actions .btn-secondary {
  padding: 8px 16px;
  font-size: 14px;
  background: #fff;
  border: 1px solid #d9d9d9;
  color: #333;
  font-weight: 600;
  transition: all 0.3s ease;
}

.header-actions .btn-secondary:hover {
  background: #f0f0f0;
  border-color: #1890ff;
  color: #1890ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
.modal-body {
  padding: 32px;
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

.form-item label {
  min-width: 140px;
  text-align: right;
  color: #2c3e50;
  font-weight: 600;
  font-size: 14px;
}

.form-item input,
.form-item select {
  flex: 1;
  padding: 12px 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  font-size: 14px;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.form-item input:focus,
.form-item select:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
  background: white;
}
.req { color: #ff4d4f; margin-right: 4px; }
.modal-footer {
  padding: 16px;
  display: flex;
  justify-content: center;
  gap: 12px;
  border-top: 1px solid #f0f0f0;
}
/* 只读信息样式 */
.readonly-info {
  margin-bottom: 20px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 6px;
  border-left: 4px solid #13c2c2;
}
.readonly-info h5 {
  margin: 0 0 12px 0;
  font-size: 14px;
  font-weight: 600;
  color: #333;
}
.info-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}
.info-item {
  display: flex;
  align-items: center;
}
.info-item label {
  min-width: 100px;
  font-weight: 500;
  color: #666;
}
.info-item span {
  color: #333;
}

/* 区块与操作栏样式 */
.section { margin-top: 16px; }
.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 8px 0 12px;
}
.section-header h5 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #333;
  border-left: 4px solid #13c2c2;
  padding-left: 8px;
}
.section-actions {
  display: flex;
  gap: 14px;
}
.section .data-table th,
.section .data-table td {
  font-size: 12px;
  padding: 8px;
}
/* 清单表内的操作按钮更紧凑，避免拥挤 */
.section .data-table .btn {
  padding: 6px 10px;
  font-size: 12px;
}
.section .op-btns {
  gap: 12px;
}
</style>