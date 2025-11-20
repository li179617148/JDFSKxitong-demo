<template>
  <div class="expert-management">
    <!-- 查询筛选模块 -->
    <div class="card filter-card">
      <div class="filter-grid">
        <!-- 第一行 -->
        <div class="filter-item">
          <label>姓名：</label>
          <input v-model="filters.name" type="text" placeholder="请输入姓名" />
        </div>
        <div class="filter-item">
          <label>执业资格：</label>
          <select v-model="filters.qualification">
            <option value="">全部</option>
            <option v-for="q in options.qualifications" :key="q" :value="q">{{ q }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>职称：</label>
          <select v-model="filters.title">
            <option value="">全部</option>
            <option v-for="t in options.titles" :key="t" :value="t">{{ t }}</option>
          </select>
        </div>

        <!-- 第二行 -->
        <div class="filter-item">
          <label>专家分类：</label>
          <select v-model="filters.expertClassification">
            <option value="">全部</option>
            <option v-for="c in options.expertClassifications" :key="c" :value="c">{{ c }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>业务领域：</label>
          <select v-model="filters.businessField">
            <option value="">全部</option>
            <option v-for="f in options.businessFields" :key="f" :value="f">{{ f }}</option>
          </select>
        </div>
        <div class="filter-item">
          <label>专业方向：</label>
          <select v-model="filters.specialty">
            <option value="">全部</option>
            <option v-for="s in options.specialties" :key="s" :value="s">{{ s }}</option>
          </select>
        </div>

        <!-- 第三行 -->
        <div class="filter-item">
          <label>出生日期：</label>
          <input v-model="filters.birthDate" type="date" />
        </div>
        <div class="filter-item">
          <label>参与项目名称：</label>
          <select v-model="filters.projectName">
            <option value="">全部</option>
            <option v-for="project in projectList" :key="project.id" :value="project.projectName">{{ project.projectName }}</option>
          </select>
        </div>
        <div class="filter-item">
          <!-- 空白占位 -->
        </div>
      </div>
      <div class="filter-actions" style="justify-content: flex-end">
        <button class="btn-primary" @click="handleQuery">查询</button>
        <button class="btn-secondary" @click="handleReset">重置</button>
      </div>
    </div>

    <!-- 列表模块 -->
    <div class="card list-card">
      <div class="list-header">
        <h4>专家列表</h4>
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
              <th>姓名</th>
              <th>所属单位</th>
              <th>职称</th>
              <th>专家分类</th>
              <th>最高学历</th>
              <th>出生日期</th>
              <th>提交人</th>
              <th>审批状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, idx) in displayList" :key="row.id">
              <td>{{ idx + 1 }}</td>
              <td>{{ row.name }}</td>
              <td>{{ row.workUnit }}</td>
              <td>{{ row.title }}</td>
              <td>{{ row.expertClassification || '-' }}</td>
              <td>{{ row.highestEducation }}</td>
              <td>{{ row.birthDate }}</td>
              <td>{{ row.submitter }}</td>
              <td>
                <span>{{ getStatusText(row.status) }}</span>
              </td>
              <td>
                <template v-if="row.status === 'draft'">
                  <button class="btn-primary" @click="handleEdit(row)">编辑</button>
        <button class="btn-success" @click="handleView(row)">查看</button>
        <button class="btn-danger" @click="handleDelete(row)">删除</button>
                </template>
                <template v-else>
                  <button class="btn-success" @click="handleView(row)">查看</button>
                </template>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="pagination">
        <button class="btn-secondary" @click="prevPage" :disabled="currentPage === 1">上一页</button>
        <span>第 {{ currentPage }} 页 / 共 {{ totalPages }} 页</span>
        <button class="btn-secondary" @click="nextPage" :disabled="currentPage === totalPages">下一页</button>
      </div>
    </div>

    <!-- 新增专家弹窗 -->
    <div v-if="showAddModal" class="modal-overlay">
      <div class="modal-content" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>新增专家信息</h3>
          <div class="header-actions">
            <button class="btn-primary" @click="handleAddSubmit">提交</button>
            <button class="btn-primary" @click="handleAddSave">暂存</button>
            <button class="btn-secondary" @click="showAddModal = false">取消</button>
          </div>
        </div>
        <div class="modal-body">
          <div class="registration-form">
            <!-- 基本信息（含照片） -->
            <div class="form-section">
              <h4 class="section-title">基本信息</h4>
              <div class="head-grid">
                <div class="photo-section">
                  <div class="photo-frame" @click="$refs.addPhotoInput.click()">
                    <div class="photo-placeholder">点击上传照片</div>
                    <img v-if="addForm.photo" :src="addForm.photo" alt="专家照片" class="photo-preview">
                  </div>
                  <input ref="addPhotoInput" type="file" @change="handlePhotoUpload" accept="image/*" class="photo-upload">
                </div>
                <div class="form-grid">
                  <div class="form-group">
                    <label><span class="required">*</span>姓名：</label>
                    <input v-model="addForm.name" type="text" placeholder="请输入姓名">
                  </div>
                  <div class="form-group">
                    <label><span class="required">*</span>性别：</label>
                    <select v-model="addForm.gender">
                      <option value="男">男</option>
                      <option value="女">女</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label><span class="required">*</span>国籍：</label>
                    <input v-model="addForm.nationality" type="text" placeholder="请输入国籍">
                  </div>
                  <div class="form-group">
                    <label><span class="required">*</span>出生日期：</label>
                    <input v-model="addForm.birthDate" type="date">
                  </div>
                  <div class="form-group">
                    <label><span class="required">*</span>联系方式：</label>
                    <input v-model="addForm.phone" type="tel" placeholder="请输入联系电话">
                  </div>
                  <div class="form-group">
                    <label>海外工作年限：</label>
                    <input v-model="addForm.overseasYears" type="number" min="0" placeholder="请输入年限">
                  </div>
                </div>
              </div>
            </div>

            <!-- 工作信息区域 -->
            <div class="form-section">
              <h4 class="section-title">工作信息</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label><span class="required">*</span>工作单位：</label>
                  <input v-model="addForm.workUnit" type="text" placeholder="请输入工作单位">
                </div>
                <div class="form-group">
                  <label>职务：</label>
                  <input v-model="addForm.position" type="text" placeholder="请输入职务">
                </div>
                <div class="form-group">
                  <label><span class="required">*</span>职称：</label>
                  <select v-model="addForm.title">
                    <option value="">请选择</option>
                    <option v-for="t in options.titles" :key="t" :value="t">{{ t }}</option>
                  </select>
                </div>
                <div class="form-group">
                  <label><span class="required">*</span>专家分类：</label>
                  <select v-model="addForm.expertClassification">
                    <option value="">请选择</option>
                    <option v-for="c in options.expertClassifications" :key="c" :value="c">{{ c }}</option>
                  </select>
                </div>
                <div class="form-group business-field full-width">
                  <label><span class="required">*</span>业务领域：</label>
                  <div class="specialty-checkbox">
                    <label v-for="(field, index) in options.businessFields" :key="index">
                      <input type="checkbox" v-model="addForm.businessField" :value="field">
                      {{ field }}
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <!-- 教育信息区域 -->
            <div class="form-section">
              <h4 class="section-title">教育信息</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label><span class="required">*</span>最高学历：</label>
                  <select v-model="addForm.highestEducation">
                    <option value="">请选择</option>
                    <option value="博士">博士</option>
                    <option value="硕士">硕士</option>
                    <option value="本科">本科</option>
                    <option value="大专">大专</option>
                  </select>
                </div>
                <div class="form-group">
                  <label><span class="required">*</span>毕业院校：</label>
                  <input v-model="addForm.graduateSchool" type="text" placeholder="请输入毕业院校">
                </div>
                <div class="form-group">
                  <label><span class="required">*</span>专业名称：</label>
                  <input v-model="addForm.major" type="text" placeholder="请输入专业名称">
                </div>
              </div>
            </div>

            <!-- 专业资格区域 -->
            <div class="form-section">
              <h4 class="section-title">专业资格</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label><span class="required">*</span>执业资格：</label>
                  <select v-model="addForm.qualification">
                    <option value="">请选择</option>
                    <option v-for="q in options.qualifications" :key="q" :value="q">{{ q }}</option>
                  </select>
                </div>
                <div class="form-group full-width">
                  <label><span class="required">*</span>专业方向：</label>
                  <div class="specialty-checkbox">
                    <label v-for="(spec, index) in specialtyOptions" :key="index">
                      <input type="checkbox" v-model="addForm.specialties" :value="spec.value">
                      {{ spec.label }}
                      <input v-if="spec.value === '其他' && addForm.specialties.includes('其他')" 
                             v-model="addForm.otherSpecialty" type="text" placeholder="请输入其他专业方向">
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <!-- 证明材料区域 -->
            <div class="form-section">
              <h4 class="section-title"><span class="required">*</span>证明材料</h4>
              <div class="attachment-area">
                <div class="attachment-list">
                  <div v-for="(file, index) in addForm.attachments" :key="index" class="attachment-item">
                    <span>{{ file.name }}</span>
                    <button @click="removeAttachment(index)">×</button>
                  </div>
                </div>
                <label class="upload-btn">
                  <input type="file" multiple @change="handleAttachmentUpload">
                  上传附件
                </label>
              </div>
            </div>

            <!-- 工作总结区域 -->
            <div class="form-section">
              <h4 class="section-title">工作能力介绍</h4>
              <textarea v-model="addForm.summary" placeholder="请输入工作能力介绍内容" class="summary-textarea"></textarea>
            </div>

            <!-- 参与项目信息区域 -->
            <div class="form-section">
              <div class="section-header">
                <h4 class="section-title">参与项目信息</h4>
              </div>
              <div class="project-textarea">
                <textarea 
                  v-model="addForm.participatingProjects" 
                  placeholder="请输入专家参与的项目信息，多个项目请用逗号或换行分隔"
                  class="project-textarea-input"
                  rows="4"
                ></textarea>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 编辑专家弹窗 -->
    <div v-if="showEditModal" class="modal-overlay">
      <div class="modal-content" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>编辑专家信息</h3>
          <div class="header-actions">
            <button class="btn-primary" @click="handleEditSubmit">提交</button>
            <button class="btn-primary" @click="handleEditSave">暂存</button>
            <button class="btn-secondary" @click="showEditModal = false">取消</button>
          </div>
        </div>
        <div class="modal-body">
          <div class="registration-form">
            <!-- 基本信息（含照片） -->
            <div class="form-section">
              <h4 class="section-title">基本信息</h4>
              <div class="head-grid">
                <div class="photo-section">
                  <div class="photo-frame" @click="$refs.editPhotoInput.click()">
                    <div class="photo-placeholder">点击上传照片</div>
                    <img v-if="editForm.photo" :src="editForm.photo" alt="专家照片" class="photo-preview">
                  </div>
                  <input ref="editPhotoInput" type="file" @change="handlePhotoUpload" accept="image/*" class="photo-upload">
                </div>
                <div class="form-grid">
                  <div class="form-group">
                    <label><span class="required">*</span>姓名</label>
                    <input v-model="editForm.name" type="text" placeholder="请输入姓名">
                  </div>
                  <div class="form-group">
                    <label><span class="required">*</span>性别</label>
                    <select v-model="editForm.gender">
                      <option value="男">男</option>
                      <option value="女">女</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label><span class="required">*</span>国籍</label>
                    <input v-model="editForm.nationality" type="text" placeholder="请输入国籍">
                  </div>
                  <div class="form-group">
                    <label><span class="required">*</span>出生日期</label>
                    <input v-model="editForm.birthDate" type="date">
                  </div>
                  <div class="form-group">
                    <label><span class="required">*</span>联系方式</label>
                    <input v-model="editForm.phone" type="tel" placeholder="请输入联系电话">
                  </div>
                  <div class="form-group">
                    <label>海外工作年限：</label>
                    <input v-model="editForm.overseasYears" type="number" min="0" placeholder="请输入年限">
                  </div>
                </div>
              </div>
            </div>

            <!-- 工作信息区域 -->
            <div class="form-section">
              <h4 class="section-title">工作信息</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label><span class="required">*</span>工作单位</label>
                  <input v-model="editForm.workUnit" type="text" placeholder="请输入工作单位">
                </div>
                <div class="form-group">
                  <label>职务：</label>
                  <input v-model="editForm.position" type="text" placeholder="请输入职务">
                </div>
                <div class="form-group">
                  <label><span class="required">*</span>职称</label>
                  <select v-model="editForm.title">
                    <option value="">请选择</option>
                    <option v-for="t in options.titles" :key="t" :value="t">{{ t }}</option>
                  </select>
                </div>
                <div class="form-group">
                  <label><span class="required">*</span>专家分类：</label>
                  <select v-model="editForm.expertClassification">
                    <option value="">请选择</option>
                    <option v-for="c in options.expertClassifications" :key="c" :value="c">{{ c }}</option>
                  </select>
                </div>
                <div class="form-group business-field full-width">
                  <label><span class="required">*</span>业务领域</label>
                  <div class="specialty-checkbox">
                    <label v-for="(field, index) in options.businessFields" :key="index">
                      <input type="checkbox" v-model="editForm.businessField" :value="field">
                      {{ field }}
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <!-- 教育信息区域 -->
            <div class="form-section">
              <h4 class="section-title">教育信息</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label><span class="required">*</span>最高学历</label>
                  <select v-model="editForm.highestEducation">
                    <option value="">请选择</option>
                    <option value="博士">博士</option>
                    <option value="硕士">硕士</option>
                    <option value="本科">本科</option>
                    <option value="大专">大专</option>
                  </select>
                </div>
                <div class="form-group">
                  <label><span class="required">*</span>毕业院校</label>
                  <input v-model="editForm.graduateSchool" type="text" placeholder="请输入毕业院校">
                </div>
                <div class="form-group">
                  <label><span class="required">*</span>专业名称</label>
                  <input v-model="editForm.major" type="text" placeholder="请输入专业名称">
                </div>
              </div>
            </div>

            <!-- 专业资格区域 -->
            <div class="form-section">
              <h4 class="section-title">专业资格</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label><span class="required">*</span>执业资格</label>
                  <select v-model="editForm.qualification">
                    <option value="">请选择</option>
                    <option v-for="q in options.qualifications" :key="q" :value="q">{{ q }}</option>
                  </select>
                </div>
                <div class="form-group full-width">
                  <label><span class="required">*</span>专业方向</label>
                  <div class="specialty-checkbox">
                    <label v-for="(spec, index) in specialtyOptions" :key="index">
                      <input type="checkbox" v-model="editForm.specialties" :value="spec.value">
                      {{ spec.label }}
                      <input v-if="spec.value === '其他' && editForm.specialties.includes('其他')" 
                             v-model="editForm.otherSpecialty" type="text" placeholder="请输入其他专业方向">
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <!-- 证明材料区域 -->
            <div class="form-section">
              <h4 class="section-title"><span class="required">*</span>证明材料</h4>
              <div class="attachment-area">
                <div class="attachment-list">
                  <div v-for="(file, index) in editForm.attachments" :key="index" class="attachment-item">
                    <span>{{ file.name }}</span>
                    <button @click="removeAttachment(index)">×</button>
                  </div>
                </div>
                <label class="upload-btn">
                  <input type="file" multiple @change="handleAttachmentUpload">
                  上传附件
                </label>
              </div>
            </div>

            <!-- 工作总结区域 -->
            <div class="form-section">
              <h4 class="section-title">工作能力介绍</h4>
              <textarea v-model="editForm.summary" placeholder="请输入工作能力介绍内容" class="summary-textarea"></textarea>
            </div>

            <!-- 关联项目信息区域 -->
            <div class="form-section">
              <div class="section-header">
                <h4 class="section-title">参与项目信息</h4>
              </div>
              <div class="project-textarea">
                <textarea 
                  v-model="editForm.participatingProjects" 
                  placeholder="请输入专家参与的项目信息，多个项目请用逗号或换行分隔"
                  class="project-textarea-input"
                  rows="4"
                ></textarea>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 查看专家信息弹窗 -->
    <div v-if="showViewModal" class="modal-overlay">
      <div class="modal-content" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>专家信息查看</h3>
          <div class="header-actions">
            <button class="btn-secondary" @click="showViewModal = false">关闭</button>
          </div>
        </div>
        <div class="modal-body">
          <div class="registration-form">
            <!-- 基本信息（含照片，只读） -->
            <div class="form-section">
              <h4 class="section-title">基本信息</h4>
              <div class="head-grid">
                <div class="photo-section">
                  <div class="photo-frame">
                    <img v-if="viewData.photo" :src="viewData.photo" alt="专家照片" class="photo-preview">
                    <div v-else class="photo-placeholder">暂无照片</div>
                  </div>
                </div>
                <div class="form-grid">
                  <div class="form-group">
                    <label>姓名：</label>
                    <input v-model="viewData.name" type="text" disabled>
                  </div>
                  <div class="form-group">
                    <label>性别：</label>
                    <select v-model="viewData.gender" disabled>
                      <option value="男">男</option>
                      <option value="女">女</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label>国籍：</label>
                    <input v-model="viewData.nationality" type="text" disabled>
                  </div>
                  <div class="form-group">
                    <label>出生日期：</label>
                    <input v-model="viewData.birthDate" type="date" disabled>
                  </div>
                  <div class="form-group">
                    <label>联系方式：</label>
                    <input v-model="viewData.phone" type="tel" disabled>
                  </div>
                  <div class="form-group">
                    <label>海外工作年限：</label>
                    <input v-model="viewData.overseasYears" type="number" min="0" disabled>
                  </div>
                </div>
              </div>
            </div>

            <!-- 工作信息（只读） -->
            <div class="form-section">
              <h4 class="section-title">工作信息</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label>工作单位：</label>
                  <input v-model="viewData.workUnit" type="text" disabled>
                </div>
                <div class="form-group">
                  <label>职务：</label>
                  <input v-model="viewData.position" type="text" disabled>
                </div>
                <div class="form-group">
                  <label>职称：</label>
                  <select v-model="viewData.title" disabled>
                    <option v-for="t in options.titles" :key="t" :value="t">{{ t }}</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>专家分类：</label>
                  <select v-model="viewData.expertClassification" disabled>
                    <option value="">{{ viewData.expertClassification || '未设置' }}</option>
                    <option v-for="c in options.expertClassifications" :key="c" :value="c">{{ c }}</option>
                  </select>
                </div>
                <div class="form-group business-field full-width">
                  <label>业务领域：</label>
                  <div class="specialty-checkbox">
                    <label v-for="(field, index) in options.businessFields" :key="index">
                      <input type="checkbox" :checked="Array.isArray(viewData.businessField) ? viewData.businessField.includes(field) : (viewData.businessField === field)" disabled>
                      {{ field }}
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <!-- 教育信息（只读） -->
            <div class="form-section">
              <h4 class="section-title">教育信息</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label>最高学历：</label>
                  <select v-model="viewData.highestEducation" disabled>
                    <option value="博士">博士</option>
                    <option value="硕士">硕士</option>
                    <option value="本科">本科</option>
                    <option value="大专">大专</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>毕业院校：</label>
                  <input v-model="viewData.graduateSchool" type="text" disabled>
                </div>
                <div class="form-group">
                  <label>专业名称：</label>
                  <input v-model="viewData.major" type="text" disabled>
                </div>
              </div>
            </div>

            <!-- 专业资格（只读） -->
            <div class="form-section">
              <h4 class="section-title">专业资格</h4>
              <div class="form-grid">
                <div class="form-group">
                  <label>执业资格：</label>
                  <select v-model="viewData.qualification" disabled>
                    <option v-for="q in options.qualifications" :key="q" :value="q">{{ q }}</option>
                  </select>
                </div>
                <div class="form-group full-width">
                  <label>专业方向：</label>
                  <div class="specialty-checkbox">
                    <label v-for="(spec, index) in specialtyOptions" :key="index">
                      <input type="checkbox" :checked="Array.isArray(viewData.specialties) ? viewData.specialties.includes(spec.value) : (viewData.specialty === spec.value)" disabled>
                      {{ spec.label }}
                      <input v-if="spec.value === '其他' && ((Array.isArray(viewData.specialties) && viewData.specialties.includes('其他')) || viewData.specialty === '其他')" 
                             v-model="viewData.otherSpecialty" type="text" disabled placeholder="其他专业方向">
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <!-- 证明材料（只读） -->
            <div class="form-section">
              <h4 class="section-title">证明材料</h4>
              <div class="attachment-area">
                <div class="attachment-list">
                  <div v-if="Array.isArray(viewData.attachments) && viewData.attachments.length > 0">
                    <div v-for="(file, index) in viewData.attachments" :key="index" class="attachment-item">
                      <span>{{ file.name }}</span>
                    </div>
                  </div>
                  <div v-else class="attachment-item">
                    <span>暂无附件</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 工作总结（只读） -->
            <div class="form-section">
              <h4 class="section-title">工作能力介绍</h4>
              <textarea v-model="viewData.summary" class="summary-textarea" disabled></textarea>
            </div>

            <!-- 参与项目信息（只读） -->
            <div class="form-section">
              <h4 class="section-title">参与项目信息</h4>
              <div class="project-textarea">
                <textarea 
                  v-model="viewData.participatingProjects" 
                  placeholder="暂无参与项目信息"
                  class="project-textarea-input"
                  rows="4"
                  readonly
                ></textarea>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 项目选择弹窗 -->
    <div v-if="showProjectSelectModal" class="modal-overlay">
      <div class="modal-content" style="width: 1800px; max-height: 90vh;">
        <div class="modal-header">
          <h3>选择关联项目</h3>
          <div class="header-actions">
            <button class="btn-primary" @click="confirmProjectSelection">确认选择</button>
            <button class="btn-secondary" @click="showProjectSelectModal = false">取消</button>
          </div>
        </div>
        <div class="modal-body">
          <div class="project-select-content">
            <!-- 搜索筛选 -->
            <div class="search-section">
              <input v-model="projectSearch" type="text" placeholder="搜索项目名称" class="search-input">
              <button class="btn-primary" @click="searchProjects">搜索</button>
            </div>
            
            <!-- 项目列表 -->
            <div class="project-table-wrapper">
              <table class="data-table">
                <thead>
                  <tr>
                    <th width="50">
                      <input type="checkbox" v-model="selectAllProjects" @change="toggleSelectAllProjects">
                    </th>
                    <th>项目名称</th>
                    <th>区域机构</th>
                    <th>项目类别</th>
                    <th>施工类型</th>
                    <th>合同金额(万元)</th>
                    <th>产业链</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="project in filteredProjects" :key="project.id">
                    <td>
                      <input type="checkbox" v-model="selectedProjects" :value="project">
                    </td>
                    <td>{{ project.projectName }}</td>
                    <td>{{ project.region }}</td>
                    <td>{{ project.category }}</td>
                    <td>{{ project.constructionType }}</td>
                    <td>{{ project.contractAmount }}</td>
                    <td>{{ project.industryChain }}</td>
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
import '../assets/styles/button-styles.css';
export default {
  name: 'ExpertManagement',
  data() {
    return {
      showAddModal: false,
      showEditModal: false,
      specialtyOptions: [
        { value: '港口工艺', label: '港口工艺' },
        { value: '火力发电', label: '火力发电' },
        { value: '光伏发电', label: '光伏发电' },
        { value: '风力发电', label: '风力发电' },
        { value: '固废处理', label: '固废处理' },
        { value: '供配电', label: '供配电' },
        { value: '暖通', label: '暖通' },
        { value: '给排水', label: '给排水' },
        { value: '消防', label: '消防' },
        { value: '管网', label: '管网' },
        { value: '其他', label: '其他' }
      ],
      addForm: {
        name: '',
        gender: '男',
        nationality: '',
        birthDate: '',
        phone: '',
        overseasYears: '',
        workUnit: '',
        position: '',
        title: '',
        expertClassification: '', // 专家分类
        businessField: [], // 改为数组以支持多选
        highestEducation: '',
        graduateSchool: '',
        major: '',
        qualification: '',
        specialties: [],
        otherSpecialty: '',
        attachments: [],
        summary: '',
        photo: '',
        status: 'draft',
        participatingProjects: '' // 参与项目信息
      },
      editForm: {
        id: null,
        name: '',
        gender: '男',
        nationality: '',
        birthDate: '',
        phone: '',
        overseasYears: '',
        workUnit: '',
        position: '',
        title: '',
        expertClassification: '', // 专家分类
        businessField: [], // 改为数组以支持多选
        highestEducation: '',
        graduateSchool: '',
        major: '',
        qualification: '',
        specialties: [],
        otherSpecialty: '',
        attachments: [],
        summary: '',
        photo: '',
        status: 'draft',
        participatingProjects: '' // 参与项目信息
      },
      filters: {
        name: '',
        qualification: '',
        title: '',
        expertClassification: '',
        businessField: '',
        birthDate: '',
        specialty: '',
        projectName: ''
      },
      displayList: [],
      mockData: [],
      currentPage: 1,
      pageSize: 10,
      showViewModal: false,
      viewData: {},
      // 关联项目信息相关数据
      showProjectSelectModal: false,
      projectSearch: '',
      selectedProjects: [],
      selectAllProjects: false,
      // 项目数据（模拟项目维护列表数据）
      projectList: [
        {
          id: 1,
          projectName: '北京地铁10号线项目',
          region: '北京分公司',
          category: '轨道交通',
          constructionType: '新建',
          contractAmount: 8500,
          industryChain: '轨道交通产业链'
        },
        {
          id: 2,
          projectName: '上海浦东机场扩建项目',
          region: '上海分公司',
          category: '机场建设',
          constructionType: '扩建',
          contractAmount: 12000,
          industryChain: '机场建设产业链'
        },
        {
          id: 3,
          projectName: '广州南站枢纽工程',
          region: '广州分公司',
          category: '铁路枢纽',
          constructionType: '新建',
          contractAmount: 9500,
          industryChain: '铁路建设产业链'
        },
        {
          id: 4,
          projectName: '深圳前海金融中心',
          region: '深圳分公司',
          category: '商业建筑',
          constructionType: '新建',
          contractAmount: 6800,
          industryChain: '商业地产产业链'
        },
        {
          id: 5,
          projectName: '成都天府国际机场',
          region: '成都分公司',
          category: '机场建设',
          constructionType: '新建',
          contractAmount: 15000,
          industryChain: '机场建设产业链'
        }
      ],
      options: {
        qualifications: ['高级工程师', '工程师', '助理工程师', '技术员'],
        titles: ['教授', '副教授', '讲师', '助教'],
        expertClassifications: ['系统内', '系统外', '外部专家', '特邀专家', '顾问专家', '合作专家', '临时专家'],
        businessFields: ['港口', '建筑', '道桥', '轨道', '生态环保', '城市综合开发', '管网', '绿色电力', '其他'],
        specialties: ['结构设计', '施工管理', '设备安装', '电气设计', '软件开发']
      }
    }
  },
  created() {
    // 初始化数据
    if (!this.mockData || this.mockData.length === 0) {
      this.mockData = [
        {
          id: 1,
          name: '张教授',
          workUnit: '清华大学建筑学院',
          title: '教授',
          expertClassification: '系统内',
          qualification: '高级工程师',
          highestEducation: '博士',
          birthDate: '1975-03-15',
          specialties: ['结构设计'],
          businessField: ['建筑'],
          submitter: '管理员',
          status: 'approved'
        },
        {
          id: 2,
          name: '李工程师',
          workUnit: '中交集团',
          title: '工程师',
          expertClassification: '系统外',
          qualification: '工程师',
          highestEducation: '硕士',
          birthDate: '1980-07-22',
          specialties: ['施工管理'],
          businessField: ['道桥'],
          submitter: '管理员',
          status: 'pending'
        },
        {
          id: 3,
          name: '王专家',
          workUnit: '上海建筑设计研究院',
          title: '高级工程师',
          expertClassification: '外部专家',
          qualification: '高级工程师',
          highestEducation: '博士',
          birthDate: '1978-11-08',
          specialties: ['结构设计', '建筑设计'],
          businessField: ['建筑'],
          submitter: '管理员',
          status: 'approved'
        },
        {
          id: 4,
          name: '刘顾问',
          workUnit: '国家工程咨询中心',
          title: '教授级高级工程师',
          expertClassification: '特邀专家',
          qualification: '高级工程师',
          highestEducation: '博士',
          birthDate: '1965-05-12',
          specialties: ['项目管理', '工程咨询'],
          businessField: ['轨道'],
          submitter: '管理员',
          status: 'approved'
        },
        {
          id: 5,
          name: '陈工程师',
          workUnit: '同济大学',
          title: '副教授',
          expertClassification: '顾问专家',
          qualification: '高级工程师',
          highestEducation: '博士',
          birthDate: '1972-09-20',
          specialties: ['结构设计', '材料科学'],
          businessField: ['建筑'],
          submitter: '管理员',
          status: 'draft'
        },
        {
          id: 6,
          name: '赵博士',
          workUnit: '中建技术中心',
          title: '高级工程师',
          expertClassification: '合作专家',
          qualification: '高级工程师',
          highestEducation: '博士',
          birthDate: '1982-12-08',
          specialties: ['绿色建筑', 'BIM技术'],
          businessField: ['绿色电力'],
          submitter: '管理员',
          status: 'approved'
        },
        {
          id: 7,
          name: '孙经理',
          workUnit: '中铁设计院',
          title: '工程师',
          expertClassification: '临时专家',
          qualification: '工程师',
          highestEducation: '硕士',
          birthDate: '1988-04-15',
          specialties: ['桥梁设计'],
          businessField: ['道桥'],
          submitter: '管理员',
          status: 'pending'
        },
        {
          id: 8,
          name: '周教授',
          workUnit: '东南大学',
          title: '教授',
          expertClassification: '系统内',
          qualification: '高级工程师',
          highestEducation: '博士',
          birthDate: '1968-09-25',
          specialties: ['港口工程', '海岸工程'],
          businessField: ['港口'],
          submitter: '管理员',
          status: 'approved'
        },
        {
          id: 9,
          name: '吴总工',
          workUnit: '中交第一航务工程院',
          title: '教授级高级工程师',
          expertClassification: '系统内',
          qualification: '高级工程师',
          highestEducation: '硕士',
          birthDate: '1970-06-18',
          specialties: ['港口工艺', '航道工程'],
          businessField: ['港口'],
          submitter: '管理员',
          status: 'approved'
        },
        {
          id: 10,
          name: '郑研究员',
          workUnit: '交通部规划研究院',
          title: '研究员',
          expertClassification: '特邀专家',
          qualification: '高级工程师',
          highestEducation: '博士',
          birthDate: '1976-11-30',
          specialties: ['交通规划', '物流系统'],
          businessField: ['轨道'],
          submitter: '管理员',
          status: 'approved'
        },
        {
          id: 11,
          name: '王高工',
          workUnit: '中建八局技术中心',
          title: '高级工程师',
          expertClassification: '合作专家',
          qualification: '高级工程师',
          highestEducation: '本科',
          birthDate: '1979-02-14',
          specialties: ['生态修复', '环境工程'],
          businessField: ['生态环保'],
          submitter: '管理员',
          status: 'pending'
        },
        {
          id: 12,
          name: '李顾问',
          workUnit: '国家发改委能源研究所',
          title: '研究员',
          expertClassification: '顾问专家',
          qualification: '高级工程师',
          highestEducation: '博士',
          birthDate: '1973-07-22',
          specialties: ['新能源', '绿色电力'],
          businessField: ['绿色电力'],
          submitter: '管理员',
          status: 'approved'
        }
      ]
    }
    this.displayList = [...this.mockData]
  },
  computed: {
    totalPages() {
      return Math.ceil(this.displayList.length / this.pageSize)
    },
    // 过滤项目列表
    filteredProjects() {
      if (!this.projectSearch) {
        return this.projectList
      }
      return this.projectList.filter(project => 
        project.projectName.toLowerCase().includes(this.projectSearch.toLowerCase())
      )
    }
  },
  methods: {
    handleQuery() {
      console.log('执行查询:', this.filters)
      // 执行筛选逻辑
      this.displayList = this.mockData.filter(expert => {
        return (
          (!this.filters.name || expert.name.includes(this.filters.name)) &&
          (!this.filters.qualification || expert.qualification === this.filters.qualification) &&
          (!this.filters.title || expert.title === this.filters.title) &&
          (!this.filters.expertClassification || expert.expertClassification === this.filters.expertClassification) &&
          (!this.filters.businessField || (expert.businessField && expert.businessField.includes(this.filters.businessField))) &&
          (!this.filters.birthDate || expert.birthDate === this.filters.birthDate) &&
          (!this.filters.specialty || (expert.specialties && expert.specialties.includes(this.filters.specialty))) &&
          (!this.filters.projectName || expert.participatingProjects.includes(this.filters.projectName))
        )
      })
      this.currentPage = 1
    },
    handleReset() {
      this.filters = {
        name: '',
        qualification: '',
        title: '',
        expertClassification: '',
        businessField: '',
        birthDate: '',
        specialty: '',
        projectName: ''
      }
      // 重置后显示所有数据
      this.displayList = [...this.mockData]
      this.currentPage = 1
    },
    handleAdd() {
      // 初始化登记表结构
      this.addForm = {
        name: '',
        gender: '男',
        nationality: '',
        birthDate: '',
        phone: '',
        overseasYears: '',
        workUnit: '',
        position: '',
        title: '',
        businessField: '',
        highestEducation: '',
        graduateSchool: '',
        major: '',
        qualification: '',
        specialties: [],
        otherSpecialty: '',
        attachments: [],
        summary: '',
        photo: '',
        status: 'draft'
      }
      this.showAddModal = true
    },
    handleEdit(row) {
      // 用该行数据预填登记表，兼容旧字段
      this.editForm = {
        id: row.id || null,
        name: row.name || '',
        gender: row.gender || '男',
        nationality: row.nationality || '',
        birthDate: row.birthDate || '',
        phone: row.phone || '',
        overseasYears: row.overseasYears || '',
        workUnit: row.workUnit || '',
        position: row.position || '',
        title: row.title || '',
        expertClassification: row.expertClassification || '',
        businessField: row.businessField || '',
        highestEducation: row.highestEducation || '',
        graduateSchool: row.graduateSchool || '',
        major: row.major || '',
        qualification: row.qualification || '',
        specialties: Array.isArray(row.specialties) ? row.specialties : (row.specialty ? [row.specialty] : []),
        otherSpecialty: row.otherSpecialty || '',
        attachments: Array.isArray(row.attachments) ? row.attachments : [],
        summary: row.summary || '',
        photo: row.photo || '',
        status: row.status || 'draft',
        participatingProjects: row.participatingProjects || ''
      }
      this.showEditModal = true
    },
    handlePhotoUpload(event) {
      const file = event.target.files[0]
      if (file) {
        const reader = new FileReader()
        reader.onload = (e) => {
          if (this.showAddModal) {
            this.addForm.photo = e.target.result
          } else if (this.showEditModal) {
            this.editForm.photo = e.target.result
          }
        }
        reader.readAsDataURL(file)
      }
    },
    handleAttachmentUpload(event) {
      const files = Array.from(event.target.files)
      files.forEach(file => {
        const reader = new FileReader()
        reader.onload = (e) => {
          if (this.showAddModal) {
            this.addForm.attachments.push({
              name: file.name,
              content: e.target.result
            })
          } else if (this.showEditModal) {
            this.editForm.attachments.push({
              name: file.name,
              content: e.target.result
            })
          }
        }
        reader.readAsDataURL(file)
      })
    },
    removeAttachment(index) {
      if (this.showAddModal) {
        this.addForm.attachments.splice(index, 1)
      } else if (this.showEditModal) {
        this.editForm.attachments.splice(index, 1)
      }
    },
    handleAddSubmit() {
      // 验证必填字段（按登记表要求）
      const requiredFields = [
        'name','gender','nationality','birthDate','phone',
        'workUnit','title','expertClassification',
        'highestEducation','graduateSchool','major',
        'qualification'
      ]
      const missingFields = requiredFields.filter(field => !this.addForm[field])
      const businessFieldValid = Array.isArray(this.addForm.businessField) && this.addForm.businessField.length > 0
      const specialtyValid = Array.isArray(this.addForm.specialties) && this.addForm.specialties.length > 0
      const attachmentValid = Array.isArray(this.addForm.attachments) && this.addForm.attachments.length > 0
      if (missingFields.length > 0 || !businessFieldValid || !specialtyValid || !attachmentValid) {
        alert('请填写所有必填字段，至少选择一个业务领域和一个专业方向且上传证明材料')
        return
      }

      // 生成新ID
      const newId = this.displayList.length > 0 
        ? Math.max(...this.displayList.map(e => e.id)) + 1 
        : 1

      // 添加到列表
      const newExpert = {
        id: newId,
        ...this.addForm,
        status: 'pending', // 提交后状态变为审批中
        submitter: '当前用户' // 这里应该替换为实际的当前用户
      }
      this.displayList.push(newExpert)
      this.showAddModal = false
      alert('专家信息已提交审批')
    },
    handleAddSave() {
      // 验证必填字段（暂存也需基本完整）
      const requiredFields = [
        'name','gender','nationality','birthDate','phone',
        'workUnit','title','expertClassification',
        'highestEducation','graduateSchool','major',
        'qualification'
      ]
      const missingFields = requiredFields.filter(field => !this.addForm[field])
      const businessFieldValid = Array.isArray(this.addForm.businessField) && this.addForm.businessField.length > 0
      const specialtyValid = Array.isArray(this.addForm.specialties) && this.addForm.specialties.length > 0
      const attachmentValid = Array.isArray(this.addForm.attachments) && this.addForm.attachments.length > 0
      if (missingFields.length > 0 || !businessFieldValid || !specialtyValid || !attachmentValid) {
        alert('请填写所有必填字段，至少选择一个业务领域和一个专业方向且上传证明材料')
        return
      }

      // 生成新ID
      const newId = this.displayList.length > 0 
        ? Math.max(...this.displayList.map(e => e.id)) + 1 
        : 1

      // 添加到列表
      const newExpert = {
        id: newId,
        ...this.addForm,
        status: 'draft', // 暂存保持未提交状态
        submitter: ''
      }
      this.displayList.push(newExpert)
      this.showAddModal = false
      alert('专家信息已暂存')
    },
    handleEditSubmit() {
      // 验证必填字段（按登记表要求）
      const requiredFields = [
        'name','gender','nationality','birthDate','phone',
        'workUnit','title','expertClassification',
        'highestEducation','graduateSchool','major',
        'qualification'
      ]
      const missingFields = requiredFields.filter(field => !this.editForm[field])
      const businessFieldValid = Array.isArray(this.editForm.businessField) && this.editForm.businessField.length > 0
      const specialtyValid = Array.isArray(this.editForm.specialties) && this.editForm.specialties.length > 0
      const attachmentValid = Array.isArray(this.editForm.attachments) && this.editForm.attachments.length > 0
      if (missingFields.length > 0 || !businessFieldValid || !specialtyValid || !attachmentValid) {
        alert('请填写所有必填字段，至少选择一个业务领域和一个专业方向且上传证明材料')
        return
      }

      // 更新列表中的专家信息
      const index = this.displayList.findIndex(e => e.id === this.editForm.id)
      if (index !== -1) {
        this.displayList[index] = {
          ...this.editForm,
          status: 'pending', // 提交后状态变为审批中
          submitter: '当前用户' // 这里应该替换为实际的当前用户
        }
      }
      this.showEditModal = false
      alert('专家信息已提交审批')
    },
    handleEditSave() {
      // 验证必填字段（暂存也需基本完整）
      const requiredFields = [
        'name','gender','nationality','birthDate','phone',
        'workUnit','title','expertClassification',
        'highestEducation','graduateSchool','major',
        'qualification'
      ]
      const missingFields = requiredFields.filter(field => !this.editForm[field])
      const businessFieldValid = Array.isArray(this.editForm.businessField) && this.editForm.businessField.length > 0
      const specialtyValid = Array.isArray(this.editForm.specialties) && this.editForm.specialties.length > 0
      const attachmentValid = Array.isArray(this.editForm.attachments) && this.editForm.attachments.length > 0
      if (missingFields.length > 0 || !businessFieldValid || !specialtyValid || !attachmentValid) {
        alert('请填写所有必填字段，至少选择一个业务领域和一个专业方向且上传证明材料')
        return
      }

      // 更新列表中的专家信息
      const index = this.displayList.findIndex(e => e.id === this.editForm.id)
      if (index !== -1) {
        this.displayList[index] = {
          ...this.editForm,
          status: 'draft' // 暂存保持未提交状态
        }
      }
      this.showEditModal = false
      alert('专家信息已暂存')
    },
    handleView(row) {
      this.viewData = { ...row }
      this.showViewModal = true
    },
    handleDelete(row) {
      console.log('删除专家:', row)
    },
    handleExport() {
      console.log('导出数据')
    },
    prevPage() {
      if (this.currentPage > 1) this.currentPage--
    },
    nextPage() {
      if (this.currentPage < this.totalPages) this.currentPage++
    },
    getStatusClass(status) {
      const statusMap = {
        draft: 'status-draft',
        pending: 'status-pending',
        approved: 'status-approved',
        rejected: 'status-rejected'
      }
      return statusMap[status] || 'status-draft'
    },
    getStatusText(status) {
      const statusTextMap = {
        draft: '未提交',
        pending: '审批中',
        approved: '已审批',
        rejected: '已驳回'
      }
      return statusTextMap[status] || '未提交'
    },
    
    // 关联项目信息相关方法
    searchProjects() {
      // 搜索项目逻辑
      console.log('搜索项目:', this.projectSearch)
    },
    
    toggleSelectAllProjects() {
      if (this.selectAllProjects) {
        this.selectedProjects = [...this.filteredProjects]
      } else {
        this.selectedProjects = []
      }
    },
    
    confirmProjectSelection() {
      // 防止重复添加
      const currentProjects = this.showAddModal ? this.addForm.relatedProjects : this.editForm.relatedProjects
      const existingIds = currentProjects ? currentProjects.map(p => p.id) : []
      
      const newProjects = this.selectedProjects.filter(project => 
        !existingIds.includes(project.id)
      )
      
      if (newProjects.length > 0) {
        if (this.showAddModal) {
          this.addForm.relatedProjects = [...(this.addForm.relatedProjects || []), ...newProjects]
        } else if (this.showEditModal) {
          this.editForm.relatedProjects = [...(this.editForm.relatedProjects || []), ...newProjects]
        }
      }
      
      this.showProjectSelectModal = false
      this.selectedProjects = []
      this.selectAllProjects = false
      this.projectSearch = ''
    },
    
    removeRelatedProject(index) {
      if (this.showAddModal) {
        this.addForm.relatedProjects.splice(index, 1)
      } else if (this.showEditModal) {
        this.editForm.relatedProjects.splice(index, 1)
      }
    }
  },
  mounted() {
    // 使用created()中已经初始化的数据，不需要重复设置
    // this.displayList 在 created() 中已经通过 this.displayList = [...this.mockData] 设置了
  }
}
</script>

<style scoped>
/* 基础样式 */
.expert-management {
  font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
  background: #f0f2f5;
  min-height: 100vh;
  padding: 20px;
  overflow-y: auto;
}

/* 卡片样式 - 现代化设计 */
.card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  margin-bottom: 24px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.12);
}

.filter-card {
  padding: 24px;
}

.list-card {
  padding: 0;
}

/* 筛选模块样式 - 现代化 */
.filter-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

@media (max-width: 1200px) {
  .filter-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .filter-grid {
    grid-template-columns: 1fr;
  }
}

.filter-item {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: nowrap;
}

.filter-item label {
  min-width: 100px;
  text-align: right;
  color: #2c3e50;
  font-weight: 600;
  white-space: nowrap;
  font-size: 14px;
}

.filter-item input,
.filter-item select {
  flex: 1;
  padding: 12px 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  font-size: 14px;
  background: #fff;
  transition: all 0.3s ease;
}

.filter-item input:focus,
.filter-item select:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
}

.filter-item select {
  appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 16px center;
  background-size: 14px;
  padding-right: 48px;
}

.filter-actions {
  display: flex;
  gap: 16px;
  justify-content: flex-end;
}

/* 按钮样式 - 现代化 */
.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  min-width: 100px;
}

.btn.primary {
  background: #1890ff;
  color: white;
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.btn.success {
  background: linear-gradient(135deg, #27ae60, #229954);
  color: white;
  box-shadow: 0 4px 12px rgba(39, 174, 96, 0.3);
}

.btn.default {
  background: linear-gradient(135deg, #95a5a6, #7f8c8d);
  color: white;
  box-shadow: 0 4px 12px rgba(149, 165, 166, 0.3);
}

.btn.export {
  background: linear-gradient(135deg, #9b59b6, #8e44ad);
  color: white;
  box-shadow: 0 4px 12px rgba(155, 89, 182, 0.3);
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.btn:active {
  transform: translateY(0);
}

/* 列表头部样式 */
.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #f0f0f0;
  background: linear-gradient(135deg, #f8f9fa, #e9ecef);
}

.list-header h4 {
  margin: 0;
  color: #2c3e50;
  font-size: 18px;
  font-weight: 700;
}

.header-actions {
  display: flex;
  gap: 16px;
}



/* 状态标签样式 - 现代化 */
.status-tag {
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.status-draft {
  background: linear-gradient(135deg, #bdc3c7, #95a5a6);
  color: white;
}

.status-pending {
  background: linear-gradient(135deg, #f39c12, #e67e22);
  color: white;
}

.status-approved {
  background: linear-gradient(135deg, #27ae60, #229954);
  color: white;
}

.status-rejected {
  background: linear-gradient(135deg, #e74c3c, #c0392b);
  color: white;
}



/* 分页样式 - 现代化 */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  gap: 16px;
  background: #f8f9fa;
}

.pagination button {
  padding: 10px 20px;
  border: 2px solid #1890ff;
  background: white;
  color: #1890ff;
  cursor: pointer;
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.pagination button:hover:not(:disabled) {
  background: #1890ff;
  color: white;
  transform: translateY(-1px);
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

/* 弹窗样式 - 现代化 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(4px);
}

.modal-content {
  background: white;
  border-radius: 16px;
  width: 90%;
  max-width: 1200px;
  max-height: 90vh;
  overflow: hidden; /* 隐藏整个弹窗的滚动条 */
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.2);
  /* 隐藏滚动条 - Webkit浏览器 */
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE/Edge */
}

.modal-content::-webkit-scrollbar {
  display: none; /* Chrome, Safari, Opera */
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 32px;
  border-bottom: 1px solid #e8e8e8;
  background: #fafafa;
  border-radius: 16px 16px 0 0;
}

.modal-header h3 {
  margin: 0;
  color: #333;
  font-size: 20px;
  font-weight: 700;
}

.close-btn {
  background: none;
  border: none;
  font-size: 28px;
  cursor: pointer;
  color: #666;
  transition: all 0.3s ease;
}

.close-btn:hover {
  transform: rotate(90deg);
  color: #1890ff;
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
  overflow-y: auto;
  /* 隐藏滚动条 - Webkit浏览器 */
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE/Edge */
}

.modal-body::-webkit-scrollbar {
  display: none; /* Chrome, Safari, Opera */
}

.modal-footer {
  padding: 24px 32px;
  border-top: 1px solid #f0f0f0;
  display: flex;
  justify-content: center;
  gap: 16px;
  background: #f8f9fa;
  border-radius: 0 0 16px 16px;
}

/* 登记表样式 - 现代化 */
.registration-form {
  display: block;
  /* 隐藏滚动条 - Webkit浏览器 */
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* IE/Edge */
}

.registration-form::-webkit-scrollbar {
  display: none; /* Chrome, Safari, Opera */
}

.head-grid {
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 24px;
}

.photo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.photo-frame {
  width: 200px;
  height: 260px;
  border: 3px dashed #bdc3c7;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  position: relative;
  margin-bottom: 16px;
  transition: all 0.3s ease;
  cursor: pointer;
}

.photo-frame:hover {
  border-color: #3498db;
  transform: scale(1.02);
}

.photo-preview {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
}

.photo-placeholder {
  color: #7f8c8d;
  font-size: 14px;
  text-align: center;
  padding: 20px;
}

.photo-upload {
  display: none;
}

.form-section {
  margin-bottom: 24px;
  background: white;
  border: 1px solid #e8ecef;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.form-section:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.section-title {
  font-size: 18px;
  color: #2c3e50;
  margin: 0 0 20px 0;
  padding-bottom: 12px;
  border-bottom: 2px solid #3498db;
  font-weight: 700;
}

.required {
  color: #e74c3c;
  margin-right: 4px;
  font-weight: bold;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 16px;
}

.form-group {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.form-group.business-field {
  align-items: flex-start;
}

.form-group.business-field label {
  padding-top: 8px;
}

.form-group label {
  display: inline-flex;
  align-items: center;
  justify-content: flex-end;
  text-align: right;
  margin: 0;
  min-width: 120px;
  font-weight: 600;
  color: #2c3e50;
  white-space: nowrap;
  font-size: 14px;
}

.form-group input,
.form-group select,
.form-group textarea {
  flex: 1;
  min-width: 0;
  padding: 12px 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s ease;
  background: #f8f9fa;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
  background: white;
}

.form-group.full-width {
  grid-column: 1 / -1;
}

.specialty-checkbox {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.specialty-checkbox label {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 8px 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  background: #f8f9fa;
  transition: all 0.3s ease;
  min-width: auto;
}

.specialty-checkbox label:hover {
  border-color: #1890ff;
  background: #e6f7ff;
}

.specialty-checkbox input[type="checkbox"] {
  width: auto;
  margin-right: 8px;
}

.attachment-area {
  border: 2px dashed #bdc3c7;
  border-radius: 8px;
  padding: 20px;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.attachment-area:hover {
  border-color: #1890ff;
  background: #e6f7ff;
}

.attachment-list {
  margin-bottom: 16px;
}

.attachment-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  background: white;
  border-radius: 6px;
  margin-bottom: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  border: 1px solid #e8ecef;
}

.attachment-item button {
  background: none;
  border: none;
  color: #e74c3c;
  cursor: pointer;
  font-size: 18px;
  transition: all 0.3s ease;
}

.attachment-item button:hover {
  transform: scale(1.2);
}

.upload-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: #1890ff;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.upload-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(24, 144, 255, 0.3);
}

.upload-btn input {
  display: none;
}

.summary-textarea {
  width: 100%;
  min-height: 120px;
  padding: 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  resize: vertical;
  line-height: 1.6;
  font-size: 14px;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.summary-textarea:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
  background: white;
}

/* 关联项目信息样式 */
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
  position: relative;
}

.section-header .section-title {
  margin: 0;
  padding-bottom: 12px;
  border-bottom: 2px solid #3498db;
  flex: 1;
  margin-right: 16px;
}

.project-list {
  margin-top: 16px;
}

.project-list .data-table {
  width: 100%;
  margin-bottom: 16px;
}

.project-list .data-table th,
.project-list .data-table td {
  padding: 12px 16px;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
}

.project-list .data-table th {
  background: #f8f9fa;
  color: #2c3e50;
  font-weight: 600;
}

.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: #7f8c8d;
  border: 2px dashed #bdc3c7;
  border-radius: 8px;
  background: #f8f9fa;
}

/* 项目选择弹窗样式 */
.project-select-content {
  max-height: 500px;
  overflow-y: auto;
}

.search-section {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  align-items: center;
}

.search-input {
  flex: 1;
  padding: 12px 16px;
  border: 2px solid #e8ecef;
  border-radius: 8px;
  font-size: 14px;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.search-input:focus {
  border-color: #1890ff;
  box-shadow: 0 0 0 3px rgba(24, 144, 255, 0.1);
  outline: none;
  background: white;
}

.project-table-wrapper {
  max-height: 400px;
  overflow-y: auto;
  border: 1px solid #e8ecef;
  border-radius: 8px;
}

.project-table-wrapper .data-table {
  width: 100%;
  border-collapse: collapse;
}

.project-table-wrapper .data-table th,
.project-table-wrapper .data-table td {
  padding: 12px 16px;
  border-bottom: 1px solid #f0f0f0;
}

.project-table-wrapper .data-table th {
  background: #f8f9fa;
  position: sticky;
  top: 0;
  z-index: 1;
  color: #2c3e50; /* 改为黑色文字 */
}

/* 响应式设计 */
@media (max-width: 768px) {
  .filter-grid {
    grid-template-columns: 1fr;
  }
  
  .head-grid {
    grid-template-columns: 1fr;
  }
  
  .form-grid {
    grid-template-columns: 1fr;
  }
  
  .modal-content {
    width: 95%;
    margin: 20px;
  }
  
  .list-header {
    flex-direction: column;
    gap: 16px;
    align-items: flex-start;
  }
  
  .header-actions {
    width: 100%;
    justify-content: space-between;
  }
  
  .btn {
    min-width: auto;
    flex: 1;
  }
}

/* 参与项目信息文本框样式 */
.project-textarea {
  margin-top: 10px;
}

.project-textarea-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  font-size: 14px;
  line-height: 1.5;
  resize: vertical;
  min-height: 80px;
}

.project-textarea-input:focus {
  outline: none;
  border-color: #1890ff;
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}

.project-textarea-input[readonly] {
  background-color: #f5f5f5;
  color: #666;
  cursor: not-allowed;
}
</style>