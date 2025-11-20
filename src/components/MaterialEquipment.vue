<template>
  <div class="material-equipment">
    <!-- 页面标题 -->
    <div class="page-header">
    </div>
    <!-- 搜索区域 -->
    <div class="search-area">
      <div class="search-form">
        <div class="search-content">
          <div class="form-grid">
            <!-- 一级分类 -->
            <div class="form-item">
              <label>一级分类：</label>
              <select v-model="searchParams.firstLevelCategory">
                <option value="">请选择一级分类</option>
                <option v-for="category in uniqueFirstLevelCategories" :key="category" :value="category">{{ category }}</option>
              </select>
            </div>
            
            <!-- 二级分类 -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">二级分类：</label>
              <select v-model="searchParams.secondLevelCategory" style="flex: 1; min-width: 100px; padding: 6px 8px; border: 1px solid #d9d9d9; border-radius: 4px;">
                <option value="">请选择二级分类</option>
                <option v-for="category in uniqueSecondLevelCategories" :key="category" :value="category">{{ category }}</option>
              </select>
            </div>
            
            <!-- 三级分类 -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">三级分类：</label>
              <select v-model="searchParams.thirdLevelCategory" style="flex: 1; min-width: 100px; padding: 6px 8px; border: 1px solid #d9d9d9; border-radius: 4px;">
                <option value="">请选择三级分类</option>
                <option v-for="category in uniqueThirdLevelCategories" :key="category" :value="category">{{ category }}</option>
              </select>
            </div>
            
            <!-- 四级分类 -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">四级分类：</label>
              <select v-model="searchParams.fourthLevelCategory" style="flex: 1; min-width: 100px; padding: 6px 8px; border: 1px solid #d9d9d9; border-radius: 4px;">
                <option value="">请选择四级分类</option>
                <option v-for="category in uniqueFourthLevelCategories" :key="category" :value="category">{{ category }}</option>
              </select>
            </div>
            
            <!-- 装备名称（带模糊搜索） -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">装备名称：</label>
              <select v-model="searchParams.equipmentName" style="flex: 1; min-width: 100px; padding: 6px 8px; border: 1px solid #d9d9d9; border-radius: 4px;">
                <option value="">请选择装备名称</option>
                <option v-for="equipment in uniqueEquipmentNames" :key="equipment" :value="equipment">{{ equipment }}</option>
              </select>
            </div>
            
            <!-- 型号 -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">型号：</label>
              <input type="text" v-model="searchParams.model" placeholder="请输入型号" style="flex: 1; min-width: 100px; padding: 6px 8px; border: 1px solid #d9d9d9; border-radius: 4px;">
            </div>
            
            <!-- 规格 -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">规格：</label>
              <input type="text" v-model="searchParams.specification" placeholder="请输入规格" style="flex: 1; min-width: 100px; padding: 6px 8px; border: 1px solid #d9d9d9; border-radius: 4px;">
            </div>
            
            <!-- 供应商（带模糊搜索） -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">供应商：</label>
              <select v-model="searchParams.supplier" style="flex: 1; min-width: 100px; padding: 6px 8px; border: 1px solid #d9d9d9; border-radius: 4px;">
                <option value="">请选择供应商</option>
                <option v-for="supplier in uniqueSuppliers" :key="supplier" :value="supplier">{{ supplier }}</option>
              </select>
            </div>
            
            <!-- 项目名称（从项目维护获取） -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">项目名称：</label>
              <select v-model="searchParams.projectName" style="flex: 1; min-width: 100px; padding: 6px 8px; border: 1px solid #d9d9d9; border-radius: 4px;">
                <option value="">请选择项目名称</option>
                <option v-for="project in projectList" :key="project.id" :value="project.name">{{ project.name }}</option>
              </select>
            </div>
            

            
            <!-- 采集时间 -->
            <div class="form-item">
              <label style="display: inline-block; min-width: 70px; text-align: right; margin-right: 8px;">采集时间：</label>
              <div class="date-range" style="display: inline-flex; align-items: center; flex: 1; min-width: 100px;">
                <input 
                  type="date" 
                  v-model="searchParams.startDate" 
                  class="date-input"
                  style="flex: 1; min-width: 100px; padding: 8px 10px; border: 1px solid #d9d9d9; border-radius: 4px; height: 36px; font-size: 14px;"
                />
                <span class="range-separator" style="margin: 0 8px; font-size: 14px;">至</span>
                <input 
                  type="date" 
                  v-model="searchParams.endDate" 
                  class="date-input"
                  style="flex: 1; min-width: 100px; padding: 8px 10px; border: 1px solid #d9d9d9; border-radius: 4px; height: 36px; font-size: 14px;"
                />
              </div>
            </div>
          </div>
        </div>
        <!-- 按钮组移到搜索表单底部 -->
        <div class="button-group">
          <button class="btn-metal" @click="showMetalPrices">铜、钢材实时价格</button>
          <button class="btn-primary" @click="handleSearch">查询</button>
          <button class="btn-primary" @click="handleReset">重置</button>
        </div>
      </div>
    </div>

    <!-- 新增弹窗 -->
    <div class="modal" v-if="showAddModal">
      <div class="modal-content" style="width: 90vw !important; max-width: 2400px; max-height: 90vh;">
        <div class="modal-header">
          <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
            <h3>信息登记表</h3>
            <span class="close" @click="closeModal">&times;</span>
          </div>
        </div>
        <div class="modal-body">
          <form class="add-form">
            <div class="form-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; width: 100%; margin-bottom: 20px;">
              <div style="grid-column: span 3; margin-bottom: 15px; text-align: right;">
                <button class="btn-primary" @click="showMetalPriceModal = true">铜、钢材实时价格</button>
              </div>
              <div class="form-item">
                <label class="required">一级分类名称：</label>
                <select v-model="newEquipment.firstLevelCategory" required>
                  <option value="">请选择一级分类</option>
                  <option value="机械设备">机械设备</option>
                  <option value="电气设备">电气设备</option>
                  <option value="建筑材料">建筑材料</option>
                  <option value="化工材料">化工材料</option>
                  <option value="仪器仪表">仪器仪表</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">二级分类名称：</label>
                <select v-model="newEquipment.secondLevelCategory" required>
                  <option value="">请选择二级分类</option>
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
                <label class="required">物资名称：</label>
                <select v-model="newEquipment.equipmentName" required>
                  <option value="">请选择物资名称</option>
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
              
              <div class="form-item">
                <label class="required">物资编码：</label>
                <input type="text" v-model="newEquipment.equipmentCode" placeholder="请输入物资编码" required>
              </div>
              
              <div class="form-item">
                <label class="required">型号：</label>
                <input type="text" v-model="newEquipment.model" placeholder="请输入型号" required>
              </div>
              
              <div class="form-item">
                <label class="required">规格：</label>
                <input type="text" v-model="newEquipment.specification" placeholder="请输入规格" required>
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
                <label class="required">初始出厂价-EXW（元）：</label>
                <input type="number" v-model="newEquipment.exwPrice" step="0.01" min="0" placeholder="0.00" required>
              </div>
              
              <div class="form-item">
                <label class="required">初始国内港口车板交货价（元）：</label>
                <input type="number" v-model="newEquipment.deliveryPrice" step="0.01" min="0" placeholder="0.00" required>
              </div>
            </div>
            
            <div class="form-row">
              <div class="form-item full-width">
                <label>物资说明：</label>
                <textarea v-model="newEquipment.description" placeholder="请输入物资说明（可选）" rows="3"></textarea>
              </div>
            </div>
            
            <!-- 附件上传区域 -->
            <div class="form-row">
              <div class="form-item full-width">
                <label>附件上传（可选）：</label>
                <div class="upload-container">
                  <input type="file" id="attachmentUpload" class="file-input"
                         @change="handleFileUpload" multiple>
                  <label for="attachmentUpload" class="upload-btn">
                    <span class="upload-button">选择文件</span>
                  </label>
                  <div class="file-list" v-if="uploadedFiles.length > 0">
                    <div v-for="(file, index) in uploadedFiles" :key="index" class="file-item">
                      <span class="file-name">{{ file.name }}</span>
                      <span class="file-size">({{ formatFileSize(file.size) }})</span>
                      <span class="remove-file" @click="removeFile(index)">&times;</span>
                    </div>
                  </div>
                  <div class="upload-hint">支持上传PDF、Word、Excel、图片等格式，单个文件不超过10MB</div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn-primary" @click="handleSave">保存</button>
          <button class="btn-secondary" @click="closeModal">取消</button>
        </div>
      </div>
    </div>

    <!-- 编辑弹窗 -->
    <div class="modal" v-if="showEditModal">
      <div class="modal-content" style="width: 90vw !important; max-width: 2400px; max-height: 90vh;">
        <div class="modal-header">
                  <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                    <h3>编辑信息</h3>
                    <span class="close" @click="closeEditModal">&times;</span>
                  </div>
                </div>
        <div class="modal-body">
          <form class="edit-form">
            <div class="form-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; width: 100%; margin-bottom: 20px;">
              <div style="grid-column: span 3; margin-bottom: 15px; text-align: right;">
                <button class="btn-primary" @click="showMetalPriceModal = true">铜、钢材实时价格</button>
              </div>
              <div class="form-item">
                <label class="required">一级分类名称：</label>
                <select v-model="editEquipment.firstLevelCategory" required>
                  <option value="">请选择一级分类</option>
                  <option value="机械设备">机械设备</option>
                  <option value="电气设备">电气设备</option>
                  <option value="建筑材料">建筑材料</option>
                  <option value="化工材料">化工材料</option>
                  <option value="仪器仪表">仪器仪表</option>
                </select>
              </div>
              
              <div class="form-item">
                <label class="required">二级分类名称：</label>
                <select v-model="editEquipment.secondLevelCategory" required>
                  <option value="">请选择二级分类</option>
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
                <label class="required">物资名称：</label>
                <select v-model="editEquipment.equipmentName" required>
                  <option value="">请选择物资名称</option>
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
              
              <div class="form-item">
                  <label class="required">物资编码：</label>
                  <input type="text" v-model="editEquipment.equipmentCode" placeholder="请输入物资编码" required>
                </div>
              
              <div class="form-item">
                <label class="required">型号：</label>
                <input type="text" v-model="editEquipment.model" placeholder="请输入型号" required>
              </div>
              
              <div class="form-item">
                <label class="required">规格：</label>
                <input type="text" v-model="editEquipment.specification" placeholder="请输入规格" required>
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
                <label class="required">初始出厂价-EXW（元）：</label>
                <input type="number" v-model="editEquipment.exwPrice" step="0.01" min="0" placeholder="0.00" required>
              </div>
              
              <div class="form-item">
                <label class="required">初始国内港口车板交货价（元）：</label>
                <input type="number" v-model="editEquipment.deliveryPrice" step="0.01" min="0" placeholder="0.00" required>
              </div>
            </div>
            
            <div class="form-row">
              <div class="form-item full-width">
                <label>物资说明：</label>
                <textarea v-model="editEquipment.description" placeholder="请输入物资说明（可选）" rows="3"></textarea>
              </div>
            </div>
            
            <!-- 附件上传区域 -->
            <div class="form-row">
              <div class="form-item full-width">
                <label>附件上传（可选）：</label>
                <div class="upload-container">
                  <input type="file" id="editAttachmentUpload" class="file-input"
                         @change="handleEditFileUpload" multiple>
                  <label for="editAttachmentUpload" class="upload-btn">
                    <span class="upload-button">选择文件</span>
                  </label>
                  <div class="file-list" v-if="editUploadedFiles.length > 0">
                    <div v-for="(file, index) in editUploadedFiles" :key="index" class="file-item">
                      <span class="file-name">{{ file.name }}</span>
                      <span class="file-size">({{ formatFileSize(file.size) }})</span>
                      <span class="remove-file" @click="removeEditFile(index)">&times;</span>
                    </div>
                  </div>
                  <div class="upload-hint">支持上传PDF、Word、Excel、图片等格式，单个文件不超过10MB</div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn-primary" @click="handleEditSave">保存</button>
          <button class="btn-secondary" @click="closeEditModal">取消</button>
        </div>
      </div>
    </div>

    <!-- 价格查询弹窗 -->
    <div class="modal" v-if="showPriceModal">
      <div class="modal-content price-modal" style="width: 90vw !important; max-width: 2400px; max-height: 90vh;">
        <div class="modal-header">
          <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
            <h3>{{ currentPriceEquipment?.equipmentName }}</h3>
            <div class="header-actions">
              <button class="btn-secondary" @click="closePriceModal">取消</button>
            </div>
          </div>
        </div>
        <div class="modal-body">
          <!-- 物资装备信息（只读） -->
          <div class="equipment-info">
            <h4>物资装备信息</h4>
            <div class="info-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
              <div class="info-item">
                <label>一级分类：</label>
                <span>{{ currentPriceEquipment?.firstLevelCategory }}</span>
              </div>
              <div class="info-item">
                <label>二级分类：</label>
                <span>{{ currentPriceEquipment?.secondLevelCategory }}</span>
              </div>
              <div class="info-item">
                <label>三级分类：</label>
                <span>{{ currentPriceEquipment?.thirdLevelCategory || '无' }}</span>
              </div>
              <div class="info-item">
                <label>四级分类：</label>
                <span>{{ currentPriceEquipment?.fourthLevelCategory || '无' }}</span>
              </div>
              <div class="info-item">
                <label>装备名称：</label>
                <span>{{ currentPriceEquipment?.equipmentName }}</span>
              </div>
              <div class="info-item">
                <label>物资装备编码：</label>
                <span>{{ currentPriceEquipment?.equipmentCode }}</span>
              </div>
              <div class="info-item">
                <label>单位：</label>
                <span>{{ currentPriceEquipment?.unit }}</span>
              </div>
              <div class="info-item">
                <label>型号：</label>
                <span>{{ currentPriceEquipment?.model || '无' }}</span>
              </div>
              <div class="info-item">
                <label>规格：</label>
                <span>{{ currentPriceEquipment?.specification }}</span>
              </div>
            </div>
          </div>

          <!-- 价格历史列表 -->
          <div class="price-history">
            <div class="price-history-header">
              <h4>价格历史记录</h4>
            </div>
            <table class="price-table">
              <thead>
                <tr>
                  <th width="60">序号</th>
                  <th width="120">出厂价-EXW（元）</th>
                  <th width="150">国内港口车板交货价（元）</th>
                  <th width="80">币种</th>
                  <th width="120">数据来源</th>
                  <th width="80">状态</th>
                  <th width="150">采集时间</th>
                  <th width="150">项目名称</th>
                  <th width="150">合作方名称</th>
                  <th width="100">附件</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(price, index) in priceHistoryList" :key="price.id">
                  <td>{{ index + 1 }}</td>
                  <td>{{ price.exwPrice }}</td>
                  <td>{{ price.deliveryPrice }}</td>
                  <td>{{ price.currency }}</td>
                  <td>{{ price.dataSource }}</td>
                  <td>
                    <span>{{ price.status }}</span>
                  </td>
                  <td>{{ price.collectionTime || '暂无数据' }}</td>
                  <td>{{ price.projectName }}</td>
                  <td>{{ price.partnerName }}</td>
                  <td>
                    <div class="price-attachments" v-if="price.attachments && price.attachments.length > 0">
                      <div v-for="(file, fileIndex) in price.attachments" :key="fileIndex" class="attachment-item">
                        <span class="file-name">{{ file.name }}</span>
                        <button class="btn-link btn-sm" @click="downloadPriceFile(file)">下载</button>
                      </div>
                    </div>
                    <span v-else>无附件</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- 铜、钢材实时价格弹窗 -->
    <div class="modal" v-if="showMetalPriceModal">
      <div class="modal-content" style="width: 800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>铜、钢材实时价格</h3>
          <span class="close" @click="showMetalPriceModal = false">&times;</span>
        </div>
        <div class="modal-body">
          <table class="data-table">
            <thead>
              <tr>
                <th>名称</th>
                <th>规格</th>
                <th>单位</th>
                <th>价格(元)</th>
                <th>涨跌幅</th>
                <th>更新时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in metalPrices" :key="index">
                <td>{{ item.name }}</td>
                <td>{{ item.spec }}</td>
                <td>{{ item.unit }}</td>
                <td class="price-value">{{ item.price }}</td>
                <td :class="`price-change ${item.changeType}`">
                  {{ item.change }}
                </td>
                <td class="update-time">{{ item.updateTime }}</td>
              </tr>
            </tbody>
          </table>
          <p class="price-note">注：以上价格为市场参考价，实际价格以交易时为准。</p>
        </div>
        <div class="modal-footer">
          <button class="btn-secondary" @click="showMetalPriceModal = false">关闭</button>
        </div>
      </div>
    </div>

    <!-- 表格区域 -->
    <div class="table-area" style="margin: 0; overflow: hidden;">
      <div class="table-header" style="display: flex; justify-content: flex-end; align-items: center; margin-bottom: 0; padding: 10px 0;">
        <div class="header-buttons">
          <!-- 简化按钮组，只保留必要功能 -->
        </div>
      </div>
      <div class="table-container" style="box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); border-radius: 0; overflow-x: auto;">
        <table class="data-table" style="min-width: 100%;">
          <thead>
            <tr>
              <th>序号</th>
              <th>一级分类</th>
              <th>二级分类</th>
              <th>三级分类</th>
              <th>四级分类</th>
              <th>装备名称</th>
              <th>物资装备编码</th>
              <th>单位</th>
              <th>型号</th>
              <th>规格</th>
              <th>最新出厂价EXW（元）</th>
              <th>最新国内港口车板交货价（元）</th>
              <th>价格采集时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in sortedEquipmentList" :key="item.id">
              <td>{{ (currentPage - 1) * pageSize + index + 1 }}</td>
              <td>{{ item.firstLevelCategory }}</td>
              <td>{{ item.secondLevelCategory }}</td>
              <td>{{ item.thirdLevelCategory || '无' }}</td>
              <td>{{ item.fourthLevelCategory || '无' }}</td>
              <td>{{ item.equipmentName }}</td>
              <td>{{ item.equipmentCode }}</td>
              <td>{{ item.unit }}</td>
              <td>{{ item.model || '无' }}</td>
              <td>{{ item.specification }}</td>
              <td>{{ item.exwPrice }}</td>
              <td>{{ item.deliveryPrice }}</td>
              <td>{{ item.priceCollectionTime || '暂无数据' }}</td>
              <td>
                <button class="btn-info btn-sm" @click="handlePriceQuery(item)">历史查询</button>
              </td>
            </tr>
          </tbody>
        </table>
        
        <!-- 分页 -->
        <div class="pagination">
          <button class="btn-secondary" @click="prevPage" :disabled="currentPage === 1">上一页</button>
          <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
          <button class="btn-secondary" @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
  /* 表格容器样式 - 无边框 */
  .table-container {
    width: 100%;
    overflow-x: auto;
    white-space: nowrap;
    border: none;
  }
  
  /* 数据表格样式 - 无边框 */
  .data-table {
    width: 100%;
    border-collapse: collapse;
    table-layout: auto;
    border: none;
  }
  
  /* 表头样式 - 蓝色背景，白色文字 */
  .data-table th {
    padding: 12px 6px;
    text-align: center;
    border: none;
    background-color: #1677ff;
    font-weight: normal;
    color: #ffffff;
    font-size: 13px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  
  /* 单元格样式 - 黑色字体，无边框 */
  .data-table td {
    padding: 10px 6px;
    text-align: center;
    border: none;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    font-size: 13px;
    color: #000000;
  }
  
  /* 调整各列宽度 - 更紧凑的布局，所有列居中 */
  .data-table th:first-child,
  .data-table td:first-child {
    width: 50px;
    text-align: center;
  }
  
  .data-table th:nth-child(2),
  .data-table td:nth-child(2) {
    width: 90px;
  }
  
  .data-table th:nth-child(3),
  .data-table td:nth-child(3) {
    width: 90px;
  }
  
  .data-table th:nth-child(4),
  .data-table td:nth-child(4) {
    width: 90px;
  }
  
  .data-table th:nth-child(5),
  .data-table td:nth-child(5) {
    width: 90px;
  }
  
  .data-table th:nth-child(6),
  .data-table td:nth-child(6) {
    width: 120px;
  }
  
  .data-table th:nth-child(7),
  .data-table td:nth-child(7) {
    width: 100px;
  }
  
  .data-table th:nth-child(8),
  .data-table td:nth-child(8) {
    width: 50px;
  }
  
  .data-table th:nth-child(9),
  .data-table td:nth-child(9) {
    width: 80px;
  }
  
  .data-table th:nth-child(10),
  .data-table td:nth-child(10) {
    width: 90px;
  }
  
  .data-table th:nth-child(11),
  .data-table td:nth-child(11) {
    width: 120px;
  }
  
  .data-table th:nth-child(12),
  .data-table td:nth-child(12) {
    width: 150px;
  }
  
  .data-table th:nth-child(13),
  .data-table td:nth-child(13) {
    width: 110px;
  }
  
  .data-table th:last-child,
  .data-table td:last-child {
    width: 110px;
    text-align: center;
  }
  
  /* 响应式调整 - 多个断点优化 */
  @media (max-width: 1600px) {
    .data-table th,
    .data-table td {
      font-size: 12px;
    }
  }
  
  @media (max-width: 1400px) {
    .data-table th,
    .data-table td {
      padding: 8px 4px;
      font-size: 12px;
    }
    
    /* 进一步压缩列宽 */
    .data-table th:nth-child(6),
    .data-table td:nth-child(6) {
      width: 100px;
    }
    
    .data-table th:nth-child(12),
    .data-table td:nth-child(12) {
      width: 120px;
    }
  }
  
  @media (max-width: 1200px) {
    /* 表格容器添加水平滚动条作为最后防线 */
    .table-container {
      overflow-x: auto;
    }
    
    /* 确保表格最小宽度以容纳所有列 */
    .data-table {
      min-width: 1200px;
    }
  }
  
  /* 优化表格行悬停效果 */
  .data-table tbody tr:hover {
    background-color: #f5f5f5;
  }
  
  /* 优化历史价格查询按钮大小 */
  .data-table td:last-child button {
    padding: 4px 8px;
    font-size: 11px;
    min-width: 90px;
  }

  /* 调整表单区域行高度 */
  .search-area {
    margin: 0 15px 16px 15px;
    background: #f8f9fa;
    border-radius: 6px;
    padding: 20px;
  }

  .form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 16px;
    margin-bottom: 16px;
  }

  .form-item {
    display: flex;
    align-items: center;
    min-height: 42px;
    gap: 8px;
  }

  .form-item label {
    min-width: 70px;
    text-align: right;
    margin-right: 8px;
    font-weight: 500;
    color: #333;
    font-size: 14px;
  }

  .form-item select,
  .form-item input {
    flex: 1;
    padding: 10px 12px;
    border: 1px solid #d9d9d9;
    border-radius: 4px;
    font-size: 14px;
    height: 40px;
    min-height: 40px;
  }

  .form-item .date-range {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .form-item .date-input {
    flex: 1;
    height: 40px;
    min-height: 40px;
  }

  .button-group {
    display: flex;
    gap: 12px !important;
    justify-content: flex-end;
    margin-top: 16px;
    margin-bottom: 8px;
    flex-wrap: nowrap !important;
    padding-top: 16px;
    border-top: 1px solid #f0f0f0;
  }

  .button-group button {
    padding: 10px 24px !important;
    font-size: 14px !important;
    height: 40px;
    min-height: 40px;
    white-space: nowrap !important;
    flex-shrink: 0 !important;
  }

  .btn-metal {
    background: #52c41a !important;
    color: white !important;
    border: none !important;
    padding: 10px 24px !important;
    border-radius: 8px !important;
    cursor: pointer !important;
    font-size: 14px !important;
    font-weight: 500 !important;
    transition: all 0.3s ease !important;
    box-shadow: 0 4px 12px rgba(82, 196, 26, 0.3) !important;
    height: 40px !important;
    min-height: 40px !important;
    white-space: nowrap !important;
    flex-shrink: 0 !important;
  }

  .btn-metal:hover {
    background: #73d13d !important;
    transform: translateY(-1px) !important;
    box-shadow: 0 6px 16px rgba(82, 196, 26, 0.4) !important;
  }

  /* 价格变化样式 */
  .price-change.up {
    color: #f56c6c;
    font-weight: 500;
  }

  .price-change.down {
    color: #67c23a;
    font-weight: 500;
  }

  .price-change.stable {
    color: #909399;
    font-weight: 500;
  }

  .price-note {
    margin-top: 16px;
    color: #909399;
    font-size: 12px;
    font-style: italic;
    text-align: center;
  }
</style>

<script>
import '../assets/styles/button-styles.css'
export default {
  name: 'MaterialEquipment',
  data() {
    return {
      searchParams: {
        firstLevelCategory: '',
        secondLevelCategory: '',
        thirdLevelCategory: '',
        fourthLevelCategory: '',
        equipmentName: '',
        model: '',
        specification: '',
        supplier: '',
        projectName: '',
        startDate: '',
        endDate: ''
      },
      showAddModal: false,
      showEditModal: false,
      showPriceModal: false,
      showMetalPriceModal: false,
      metalPrices: [],
      newEquipment: {
        firstLevelCategory: '',
        secondLevelCategory: '',
        equipmentName: '',
        equipmentCode: '',
        unit: '',
        model: '',
        specification: '',
        exwPrice: '',
        deliveryPrice: '',
        description: ''
      },
      uploadedFiles: [],
      editUploadedFiles: [],
      editEquipment: {
        id: null,
        firstLevelCategory: '',
        secondLevelCategory: '',
        equipmentName: '',
        equipmentCode: '',
        unit: '',
        model: '',
        specification: '',
        exwPrice: '',
        deliveryPrice: '',
        description: ''
      },
      currentPriceEquipment: null,
      selectedPrices: [],
      priceHistoryList: [
        {
          id: 1,
          exwPrice: 450000,
          deliveryPrice: 480000,
          currency: 'CNY',
          status: '最新价格',
          projectName: '北京地铁项目',
          partnerName: '中建集团',
          dataSource: '日常询价',
          collectionTime: '2025-10-28',
          attachments: [
            { name: '报价单.pdf', size: 1024000 },
            { name: '合同扫描件.docx', size: 512000 }
          ]
        },
        {
          id: 2,
          exwPrice: 440000,
          deliveryPrice: 470000,
          currency: 'CNY',
          status: '历史价格',
          projectName: '上海高铁项目',
          partnerName: '中铁建工',
          dataSource: '实际采购价格',
          collectionTime: '2025-10-25',
          attachments: [
            { name: '采购合同.pdf', size: 2048000 }
          ]
        },
        {
          id: 3,
          exwPrice: 460000,
          deliveryPrice: 490000,
          currency: 'CNY',
          status: '历史价格',
          projectName: '广州机场项目',
          partnerName: '中交集团',
          dataSource: '日常询价',
          collectionTime: '2025-10-22',
          attachments: [
            { name: '询价记录.xlsx', size: 256000 },
            { name: '供应商资质.jpg', size: 1536000 }
          ]
        },
        {
          id: 4,
          exwPrice: 455000,
          deliveryPrice: 485000,
          currency: 'CNY',
          status: '历史价格',
          projectName: '深圳地铁项目',
          partnerName: '中铁集团',
          dataSource: '日常询价',
          collectionTime: '2025-10-18',
          attachments: [
            { name: '询价单.pdf', size: 768000 }
          ]
        },
        {
          id: 5,
          exwPrice: 445000,
          deliveryPrice: 475000,
          currency: 'CNY',
          status: '历史价格',
          projectName: '成都高铁项目',
          partnerName: '中铁二局',
          dataSource: '实际采购价格',
          collectionTime: '2025-10-15',
          attachments: []
        }
      ],
      // 项目数据（从项目维护页面获取）
      projectList: [
        {
          id: 1,
          name: '北京市地铁XX线三期工程',
          region: '华北区域',
          category: '轨道交通',
          constructionType: '总承包',
          stage: '施工',
          amount: 128000,
          industryChain: '设备',
          hasEquipment: true,
          approvalStatus: 'approved'
        },
        {
          id: 2,
          name: '上海市浦东新区市政道路改造',
          region: '华东区域',
          category: '市政工程',
          constructionType: '专业分包',
          stage: '投标',
          amount: 35000,
          industryChain: '建材',
          hasEquipment: false,
          approvalStatus: 'pending'
        },
        {
          id: 3,
          name: '深圳某房建项目一期',
          region: '华南区域',
          category: '房建工程',
          constructionType: '劳务分包',
          stage: '签约',
          amount: 82000,
          industryChain: '施工',
          hasEquipment: false,
          approvalStatus: 'draft'
        },
        {
          id: 4,
          name: '广州白云机场扩建工程',
          region: '华南区域',
          category: '市政工程',
          constructionType: '总承包',
          stage: '施工',
          amount: 256000,
          industryChain: '设备',
          hasEquipment: true,
          approvalStatus: 'approved'
        },
        {
          id: 5,
          name: '成都地铁18号线工程',
          region: '西南区域',
          category: '轨道交通',
          constructionType: '专业分包',
          stage: '施工',
          amount: 189000,
          industryChain: '设备',
          hasEquipment: true,
          approvalStatus: 'approved'
        }
      ],
      equipmentList: [
        {
          id: 1,
          firstLevelCategory: '机械设备',
          secondLevelCategory: '起重设备',
          thirdLevelCategory: '塔式起重机',
          fourthLevelCategory: '中型',
          equipmentName: '塔式起重机',
          equipmentCode: 'QZ001',
          unit: '台',
          model: 'TC7030',
          specification: 'QTZ80',
          exwPrice: 450000,
          deliveryPrice: 480000,
          priceCollectionTime: '2025-10-28',
          description: ''
        },
        {
          id: 2,
          firstLevelCategory: '电气设备',
          secondLevelCategory: '变压器',
          thirdLevelCategory: '电力变压器',
          fourthLevelCategory: '油浸式',
          equipmentName: '电力变压器',
          equipmentCode: 'BYQ001',
          unit: '台',
          model: 'SCB13',
          specification: 'S11-1000kVA',
          exwPrice: 85000,
          deliveryPrice: 90000,
          priceCollectionTime: '2025-10-27',
          description: ''
        },
        {
          id: 3,
          firstLevelCategory: '建筑材料',
          secondLevelCategory: '钢材',
          thirdLevelCategory: '钢筋',
          fourthLevelCategory: '螺纹钢',
          equipmentName: '螺纹钢',
          equipmentCode: 'LG001',
          unit: '吨',
          model: 'HRB400',
          specification: 'Φ20',
          exwPrice: 3800,
          deliveryPrice: 4000,
          priceCollectionTime: '2025-10-26',
          description: ''
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
      if (this.searchParams.firstLevelCategory) {
        filteredList = filteredList.filter(item =>
          item.firstLevelCategory.includes(this.searchParams.firstLevelCategory)
        )
      }
      if (this.searchParams.secondLevelCategory) {
        filteredList = filteredList.filter(item =>
          item.secondLevelCategory.includes(this.searchParams.secondLevelCategory)
        )
      }
      if (this.searchParams.equipmentName) {
        filteredList = filteredList.filter(item =>
          item.equipmentName.includes(this.searchParams.equipmentName)
        )
      }
      if (this.searchParams.model) {
        filteredList = filteredList.filter(item =>
          item.model && item.model.includes(this.searchParams.model)
        )
      }
      if (this.searchParams.specification) {
        filteredList = filteredList.filter(item =>
          item.specification.includes(this.searchParams.specification)
        )
      }

      
      // 按价格采集时间倒序排序
      return filteredList.sort((a, b) => {
        return new Date(b.priceCollectionTime) - new Date(a.priceCollectionTime)
      })
    },
    isAllSelected() {
      const selectablePrices = this.priceHistoryList.filter(price => price.dataSource !== '实际采购价格')
      return selectablePrices.length > 0 && this.selectedPrices.length === selectablePrices.length
    },
    // 获取唯一的一级分类
    uniqueFirstLevelCategories() {
      const categories = [...new Set(this.equipmentList.map(item => item.firstLevelCategory))]
      return categories.filter(Boolean).sort()
    },
    // 获取唯一的二级分类
    uniqueSecondLevelCategories() {
      const categories = [...new Set(this.equipmentList.map(item => item.secondLevelCategory))]
      return categories.filter(Boolean).sort()
    },
    // 获取唯一的三级分类
    uniqueThirdLevelCategories() {
      const categories = [...new Set(this.equipmentList.map(item => item.thirdLevelCategory))]
      return categories.filter(Boolean).sort()
    },
    // 获取唯一的四级分类
    uniqueFourthLevelCategories() {
      const categories = [...new Set(this.equipmentList.map(item => item.fourthLevelCategory))]
      return categories.filter(Boolean).sort()
    },
    // 获取唯一的装备名称
    uniqueEquipmentNames() {
      const names = [...new Set(this.equipmentList.map(item => item.equipmentName))]
      return names.filter(Boolean).sort()
    },
    // 获取唯一的供应商
    uniqueSuppliers() {
      const suppliers = [...new Set(this.equipmentList.map(item => item.supplier))]
      return suppliers.filter(Boolean).sort()
    }
  },
  methods: {
    handleFileUpload(e) {
      const files = Array.from(e.target.files);
      const validFiles = this.validateFiles(files);
      if (validFiles.length > 0) {
        this.uploadedFiles = [...this.uploadedFiles, ...validFiles];
      }
      // 清空input值，允许重复选择同一文件
      e.target.value = '';
    },
    handleEditFileUpload(e) {
      const files = Array.from(e.target.files);
      const validFiles = this.validateFiles(files);
      if (validFiles.length > 0) {
        this.editUploadedFiles = [...this.editUploadedFiles, ...validFiles];
      }
      // 清空input值，允许重复选择同一文件
      e.target.value = '';
    },
    validateFiles(files) {
      const validFiles = [];
      const maxSize = 10 * 1024 * 1024; // 10MB
      const allowedTypes = [
        'application/pdf',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'image/jpeg',
        'image/png',
        'image/gif',
        'image/bmp'
      ];
      
      for (const file of files) {
        if (file.size > maxSize) {
          alert(`文件 "${file.name}" 超过10MB限制，已跳过`);
          continue;
        }
        
        if (!allowedTypes.includes(file.type)) {
          alert(`文件 "${file.name}" 格式不支持，仅支持PDF、Word、Excel、图片格式`);
          continue;
        }
        
        validFiles.push(file);
      }
      
      return validFiles;
    },
    removeEditFile(index) {
      this.editUploadedFiles.splice(index, 1);
    },
    downloadFile(file) {
      // 模拟文件下载
      const link = document.createElement('a');
      link.href = URL.createObjectURL(file);
      link.download = file.name;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(link.href);
    },
    downloadPriceFile(file) {
      // 模拟价格附件下载
      const link = document.createElement('a');
      const blob = new Blob(['模拟文件内容：' + file.name], { type: 'application/octet-stream' });
      link.href = URL.createObjectURL(blob);
      link.download = file.name;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(link.href);
    },
    handleSearch() {
      // 搜索逻辑
      this.currentPage = 1
      console.log('搜索参数：', this.searchParams)
    },
    handleReset() {
      this.searchParams = {
        firstLevelCategory: '',
        secondLevelCategory: '',
        thirdLevelCategory: '',
        fourthLevelCategory: '',
        equipmentName: '',
        model: '',
        specification: '',
        supplier: '',
        projectName: '',
        startDate: '',
        endDate: ''
      }
      this.currentPage = 1
    },
    handleAdd() {
      // 重置表单数据
      this.newEquipment = {
        firstLevelCategory: '',
        secondLevelCategory: '',
        equipmentName: '',
        equipmentCode: '',
        unit: '',
        model: '',
        specification: '',
        exwPrice: '',
        deliveryPrice: '',
        description: ''
      }
      // 显示新增弹窗
      this.showAddModal = true
    },
    handleEdit(item) {
      this.editEquipment = { ...item }
      // 模拟加载当前设备的附件数据
      this.editUploadedFiles = [
        { name: '设备合格证.pdf', size: 1536000 },
        { name: '检验报告.docx', size: 819200 }
      ]
      this.showEditModal = true
    },
    handleDelete(id) {
      if (confirm('确定删除该物资装备吗？')) {
        this.equipmentList = this.equipmentList.filter(item => item.id !== id)
        this.totalItems = this.equipmentList.length
      }
    },
    
    handleWithdraw(item) {
      if (confirm('确定撤回该物资装备的审批申请吗？')) {
        const index = this.equipmentList.findIndex(equip => equip.id === item.id)
        if (index !== -1) {
          this.equipmentList[index].approvalStatus = '未提交'
          alert('撤回成功！')
        }
      }
    },
    handlePriceQuery(item) {
      this.showPriceModal = true
      this.currentPriceEquipment = { ...item }
    },
    handleSave() {
      // 验证必填字段
      const requiredFields = [
        'firstLevelCategory',
        'secondLevelCategory',
        'equipmentName',
        'equipmentCode',
        'model',
        'specification',
        'unit',
        'exwPrice',
        'deliveryPrice'
      ]
      
      for (const field of requiredFields) {
        if (!this.newEquipment[field]) {
          alert(`请填写${this.getFieldLabel(field)}`)
          return
        }
      }
      
      if (this.newEquipment.id) {
        // 编辑模式
        const index = this.equipmentList.findIndex(item => item.id === this.newEquipment.id)
        if (index !== -1) {
          this.equipmentList[index] = {
            ...this.newEquipment,
            exwPrice: parseFloat(this.newEquipment.exwPrice),
            deliveryPrice: parseFloat(this.newEquipment.deliveryPrice)
          }
        }
        alert('编辑成功！')
      } else {
        // 新增模式
        const newId = Math.max(...this.equipmentList.map(item => item.id)) + 1
        const newItem = {
          id: newId,
          ...this.newEquipment,
          exwPrice: parseFloat(this.newEquipment.exwPrice),
          deliveryPrice: parseFloat(this.newEquipment.deliveryPrice)
        }
        
        this.equipmentList.push(newItem)
        this.totalItems = this.equipmentList.length
        alert('新增成功！')
      }
      
      this.closeModal()
    },
    handleEditSave() {
      // 验证必填字段
      const requiredFields = [
        'firstLevelCategory',
        'secondLevelCategory',
        'equipmentName',
        'equipmentCode',
        'model',
        'specification',
        'unit',
        'exwPrice',
        'deliveryPrice'
      ]
      
      for (const field of requiredFields) {
        if (!this.editEquipment[field]) {
          alert(`请填写${this.getFieldLabel(field)}`)
          return
        }
      }
      
      // 更新模式
      const index = this.equipmentList.findIndex(item => item.id === this.editEquipment.id)
      if (index !== -1) {
        this.equipmentList[index] = {
          ...this.editEquipment,
          exwPrice: parseFloat(this.editEquipment.exwPrice),
          deliveryPrice: parseFloat(this.editEquipment.deliveryPrice)
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
    closePriceModal() {
      this.showPriceModal = false
      this.currentPriceEquipment = null
      this.selectedPrices = []
    },
    
    handleAddPrice() {
      alert('新增价格记录')
    },
    
    handleDeletePrices() {
      if (this.selectedPrices.length === 0) {
        alert('请选择要删除的价格记录')
        return
      }
      
      if (confirm(`确定删除选中的 ${this.selectedPrices.length} 条价格记录吗？`)) {
        this.priceHistoryList = this.priceHistoryList.filter(price => 
          !this.selectedPrices.includes(price.id)
        )
        this.selectedPrices = []
        alert('删除成功！')
      }
    },
    
    toggleSelectAll() {
      if (this.isAllSelected) {
        this.selectedPrices = []
      } else {
        this.selectedPrices = this.priceHistoryList
          .filter(price => price.dataSource !== '实际采购价格')
          .map(price => price.id)
      }
    },
    getFieldLabel(field) {
      const labels = {
        firstLevelCategory: '一级分类名称',
        secondLevelCategory: '二级分类名称',
        equipmentName: '物资装备名称',
        equipmentCode: '物资装备编码',
        model: '型号',
        specification: '规格',
        unit: '单位',
        exwPrice: '初始出厂价-EXW',
        deliveryPrice: '初始国内港口车板交货价'
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
    downloadImportTemplate() {
      const headers = ['一级分类名称','二级分类名称','物资装备名称','物资装备编码','单位','型号','规格','出厂价EXW（元）','国内港口车板交货价（元）','数据来源','物资装备说明']
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
          const expected = ['一级分类名称','二级分类名称','物资装备名称','物资装备编码','单位','型号','规格','出厂价EXW（元）','国内港口车板交货价（元）','数据来源','物资装备说明']
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
              firstLevelCategory: (cols[0] || '').trim(),
              secondLevelCategory: (cols[1] || '').trim(),
              equipmentName: (cols[2] || '').trim(),
              equipmentCode: (cols[3] || '').trim(),
              unit: (cols[4] || '').trim(),
              model: (cols[5] || '').trim(),
              specification: (cols[6] || '').trim(),
              exwPrice: parseFloat(cols[7]) || 0,
              deliveryPrice: parseFloat(cols[8]) || 0,
              dataSource: (cols[9] || '').trim() || '日常询价',
              description: (cols[10] || '').trim()
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
    },
    handleFileUpload(e) {
      const files = Array.from(e.target.files);
      this.uploadedFiles = [...this.uploadedFiles, ...files];
      // 清空input值，允许重复选择同一文件
      e.target.value = '';
    },
    removeFile(index) {
      this.uploadedFiles.splice(index, 1);
    },
    formatFileSize(size) {
      if (size < 1024) {
        return size + ' B';
      } else if (size < 1024 * 1024) {
        return (size / 1024).toFixed(2) + ' KB';
      } else {
        return (size / (1024 * 1024)).toFixed(2) + ' MB';
      }
    },

    showMetalPrices() {
      // 模拟获取实时金属价格数据
      this.metalPrices = [
        {
          name: '铜',
          spec: '电解铜',
          unit: '吨',
          price: 72500,
          change: '+2.3%',
          changeType: 'up',
          updateTime: new Date().toLocaleString('zh-CN')
        },
        {
          name: '铜',
          spec: '铜管',
          unit: '吨',
          price: 78300,
          change: '+1.8%',
          changeType: 'up',
          updateTime: new Date().toLocaleString('zh-CN')
        },
        {
          name: '钢材',
          spec: '螺纹钢 HRB400',
          unit: '吨',
          price: 3950,
          change: '-0.5%',
          changeType: 'down',
          updateTime: new Date().toLocaleString('zh-CN')
        },
        {
          name: '钢材',
          spec: '线材 HPB300',
          unit: '吨',
          price: 4120,
          change: '0%',
          changeType: 'stable',
          updateTime: new Date().toLocaleString('zh-CN')
        },
        {
          name: '钢材',
          spec: '热轧板卷',
          unit: '吨',
          price: 4380,
          change: '+0.8%',
          changeType: 'up',
          updateTime: new Date().toLocaleString('zh-CN')
        }
      ]

      // 显示金属价格模态框
      this.showMetalPriceModal = true
    }
  }
}
</script>

<style scoped>
.material-equipment {
  padding: 16px;
  background: #f0f2f5;
  min-height: 100vh;
  box-sizing: border-box;
  width: 100%;
}

/* 确保所有元素在容器内 */
.material-equipment > * {
  max-width: 100%;
  box-sizing: border-box;
}

/* 搜索区域样式 - 使用统一蓝色主题 */
.search-area {
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  border: 1px solid rgba(24, 144, 255, 0.1);
  overflow-x: auto;
}

/* 响应式搜索表单 */
.form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px; /* 增加行间距 */
}

.form-item {
  display: flex;
  align-items: center;
  min-height: 48px; /* 统一表单行高 */
}

.form-item label {
  display: inline-block;
  min-width: 80px; /* 统一标签宽度 */
  text-align: right;
  margin-right: 12px;
  flex-shrink: 0;
  font-size: 14px;
  font-weight: 500;
  color: #333;
  line-height: 1.4;
}

.form-item select,
.form-item input {
  flex: 1;
  min-width: 120px;
  padding: 10px 12px; /* 增加输入框内边距 */
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  height: 40px; /* 设置统一高度 */
  box-sizing: border-box;
}

.button-group {
  margin-top: 20px;
  text-align: center;
  grid-column: 1 / -1;
  display: flex;
  justify-content: center;
  gap: 16px;
}

.button-group button {
  min-width: 90px;
  padding: 10px 20px;
  font-size: 14px;
  height: 40px;
  border-radius: 6px;
  font-weight: 500;
}

@media (max-width: 1200px) {
  .form-grid {
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 10px;
  }
}

@media (max-width: 768px) {
  .form-grid {
    grid-template-columns: 1fr;
    gap: 8px;
  }
  
  .form-item {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .form-item label {
    text-align: left;
    margin-right: 0;
    margin-bottom: 2px;
    width: 100%;
    min-width: auto;
  }
  
  .form-item select,
  .form-item input {
    width: 100%;
    min-width: auto;
  }
  
  .button-group {
    flex-direction: column;
    align-items: center;
    gap: 8px;
  }
  
  .button-group button {
    width: 100%;
    max-width: 180px;
  }
}

@media (max-width: 768px) {
  .material-equipment {
    padding: 12px;
  }
  
  .search-area {
    padding: 16px;
    margin-bottom: 16px;
  }
  
  .search-content .form-grid {
    grid-template-columns: 1fr !important;
    gap: 10px !important;
  }
  
  .form-item {
    flex-direction: column !important;
    align-items: flex-start !important;
  }
  
  .form-item label {
    width: 100% !important;
    text-align: left !important;
    margin-bottom: 6px !important;
    min-width: auto !important;
    margin-right: 0 !important;
  }
  
  .form-item select,
  .form-item input {
    width: 100% !important;
    min-width: auto !important;
  }
  
  .button-group {
    flex-direction: column !important;
    gap: 8px !important;
    width: 100%;
  }
  
  .button-group button {
    width: 100% !important;
    margin: 4px 0 !important;
    min-width: auto !important;
  }
  
  .date-range {
    width: 100% !important;
    min-width: auto !important;
  }
  
  .date-range input {
    width: 45% !important;
    min-width: auto !important;
    height: 40px !important;
    padding: 10px 12px !important;
  }
}

.search-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
  max-width: 100%;
  overflow: hidden;
}

/* 表格容器优化 */
.table-container {
  width: 100%;
  max-width: 100%;
  overflow-x: auto;
}

.data-table {
  width: 100%;
  min-width: fit-content;
  table-layout: auto;
}

/* 响应式表格优化 */
@media (max-width: 1200px) {
  .data-table {
    min-width: 1200px;
  }
  
  .table-container {
    overflow-x: auto;
  }
}

@media (max-width: 768px) {
  .material-equipment {
    padding: 10px;
  }
  
  .search-area {
    padding: 16px;
    margin-bottom: 16px;
  }
  
  .table-area {
    margin: 0 5px;
  }
  
  .data-table th,
  .data-table td {
    padding: 6px 4px;
    font-size: 11px;
  }
  
  .data-table th:nth-child(6),
  .data-table td:nth-child(6) {
    width: 80px;
  }
  
  .data-table th:nth-child(12),
  .data-table td:nth-child(12) {
    width: 100px;
  }
  
  .data-table td:last-child button {
    padding: 3px 6px;
    font-size: 10px;
    min-width: 70px;
  }
}

.search-content {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 20px;
}

.form-rows {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.button-group {
  display: flex;
  gap: 12px;
  align-self: flex-end;
  margin-top: 0;
}

.form-row {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
  align-items: flex-start;
}

.form-grid {
  display: grid !important;
  grid-template-columns: repeat(3, 1fr) !important;
  gap: 24px !important;
  width: 100% !important;
  margin-bottom: 20px !important;
  align-items: start !important;
}

.form-item {
  display: flex !important;
  align-items: center !important;
  min-height: 40px !important;
  flex: 1 !important;
}

.form-item label {
  width: 140px !important;
  text-align: right !important;
  margin-right: 12px !important;
  font-weight: 500 !important;
  color: #333 !important;
  flex-shrink: 0 !important;
}

.form-item input,
.form-item select {
  flex: 1 !important;
  padding: 8px 12px !important;
  border: 1px solid #d9d9d9 !important;
  border-radius: 6px !important;
  font-size: 14px !important;
  min-height: 36px !important;
  box-sizing: border-box !important;
}

.form-item input:focus,
.form-item select:focus {
  outline: none !important;
  border-color: #1890ff !important;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2) !important;
}

.button-row {
  justify-content: flex-end;
  margin-top: 10px;
  width: 100%;
}

.button-group {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  flex: 0 0 auto;
  min-width: 200px;
  margin-left: auto;
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

.modal-footer .btn-primary,
.modal-footer .btn-secondary {
  min-width: 100px;
  height: 44px;
  padding: 0 24px;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.2s;
}

.modal-footer .btn-primary {
  background: #1890ff;
  color: white;
}

.modal-footer .btn-primary:hover {
  background: #40a9ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.modal-footer .btn-secondary {
  background: #f5f5f5;
  color: #333;
  border: 1px solid #d9d9d9;
}

.modal-footer .btn-secondary:hover {
  background: #e6f7ff;
  border-color: #1890ff;
  color: #1890ff;
  transform: translateY(-1px);
}

/* 附件上传样式优化 */
.upload-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.file-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 10px;
}

.file-item {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  background-color: #f8f9fa;
  border-radius: 4px;
  border: 1px solid #e8e8e8;
}

.file-name {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.file-size {
  margin: 0 10px;
  color: #666;
  font-size: 12px;
}

.remove-file {
  cursor: pointer;
  color: #ff4d4f;
  font-size: 16px;
  font-weight: bold;
  padding: 0 5px;
}

.remove-file:hover {
  color: #f5222d;
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
  margin-left: -50px;
  /* 隐藏滚动条但保持滚动功能 */
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE 和 Edge */
}

.modal-content::-webkit-scrollbar {
  display: none; /* Chrome, Safari 和 Opera */
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #f0f0f0;
  background: #fafafa;
  border-radius: 12px 12px 0 0;
}

.modal-header h3 {
  margin: 0;
  color: #333;
  font-size: 18px;
  font-weight: 600;
}

.header-actions {
  display: flex;
  gap: 12px;
  align-items: center;
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
  padding: 24px 32px;
  background: #fafafa;
}

.add-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
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

.modal-footer .btn-primary,
.modal-footer .btn-secondary {
  min-width: 100px;
  height: 44px;
  padding: 0 24px;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  border: none;
  cursor: pointer;
  transition: all 0.2s;
}

.modal-footer .btn-primary {
  background: #1890ff;
  color: white;
}

.modal-footer .btn-primary:hover {
  background: #40a9ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.modal-footer .btn-secondary {
  background: #f5f5f5;
  color: #333;
  border: 1px solid #d9d9d9;
}

.modal-footer .btn-secondary:hover {
  background: #e6f7ff;
  border-color: #1890ff;
  color: #1890ff;
  transform: translateY(-1px);
}

/* 附件上传样式优化 */
.file-input {
  display: none;
}

.upload-btn {
  display: inline-block;
  cursor: pointer;
  margin-bottom: 12px;
}

.upload-btn .upload-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px 20px;
  border-radius: 6px;
  font-weight: 500;
  transition: all 0.2s;
  background: #1890ff;
  color: white;
  border: none;
  cursor: pointer;
}

.upload-btn .upload-button:hover {
  background: #40a9ff;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(24, 144, 255, 0.2);
}

.upload-btn .upload-button::before {
  content: "+";
  font-size: 18px;
  font-weight: bold;
}

/* 价格查询弹窗样式 */
.price-modal {
  width: 90vw !important;
  max-width: 2400px;
}

.equipment-info {
  margin-bottom: 30px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 6px;
}

.equipment-info h4 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
}

.info-item {
  display: flex;
  align-items: center;
}

.info-item label {
  width: 120px;
  font-weight: 500;
  color: #666;
  margin-right: 10px;
  text-align: right;
  justify-content: flex-end;
  display: flex;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-item span {
  color: #333;
  font-weight: normal;
}

.price-history {
  margin-top: 20px;
}

.price-history-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.price-history-header h4 {
  margin: 0;
  color: #333;
  font-size: 16px;
}

.price-history-buttons {
  display: flex;
  gap: 10px;
}

.price-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  border: 1px solid #e8e8e8;
  border-radius: 0;
  overflow: hidden;
}

.price-table th,
.price-table td {
  padding: 12px 8px;
  text-align: center;
  border-bottom: 1px solid #e8e8e8;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.price-table th {
  background: #fafafa;
  font-weight: 600;
  color: #333;
  border-bottom: 2px solid #e8e8e8;
}

.price-table th input[type="checkbox"] {
  margin: 0;
}

.price-table td input[type="checkbox"] {
  margin: 0;
  cursor: pointer;
}

.price-table td input[type="checkbox"]:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.latest-price,
.history-price {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}

/* 审批状态样式 - 只保留文字样式，移除颜色背景 */
.status-unsubmitted,
.status-pending,
.status-approved {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}



/* 价格历史记录附件样式 */
.price-attachments {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.attachment-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 4px 8px;
  background: #f8f9fa;
  border-radius: 4px;
  border: 1px solid #e8e8e8;
  font-size: 12px;
}

.attachment-item .file-name {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #333;
}

.attachment-item .btn-link {
  background: none;
  border: none;
  color: #1890ff;
  cursor: pointer;
  font-size: 12px;
  padding: 2px 6px;
  text-decoration: underline;
}

.attachment-item .btn-link:hover {
  color: #40a9ff;
}
</style>