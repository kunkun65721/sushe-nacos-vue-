<template>
  <div class="knowledge-base">
    <div class="page-header">
      <div>
        <h2 class="page-title">知识库管理</h2>
        <p class="page-subtitle">管理宿舍管理知识库文档，AI客服将根据知识库内容回答学生问题</p>
      </div>
      <el-button type="primary" @click="showUploadDialog = true">
        <span class="material-icons">upload_file</span>
        上传文档
      </el-button>
    </div>

    <el-card class="filter-card">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-select v-model="filterCategory" placeholder="分类筛选" clearable @change="fetchList">
            <el-option label="全部" value="" />
            <el-option label="规章制度" value="rules" />
            <el-option label="常见问题" value="faq" />
            <el-option label="报修指南" value="repair" />
            <el-option label="其他" value="general" />
          </el-select>
        </el-col>
        <el-col :span="6">
          <el-select v-model="filterStatus" placeholder="状态筛选" clearable @change="fetchList">
            <el-option label="全部" value="" />
            <el-option label="启用" value="1" />
            <el-option label="禁用" value="0" />
          </el-select>
        </el-col>
      </el-row>
    </el-card>

    <el-card class="data-card">
      <el-table :data="documents" stripe style="width: 100%" v-loading="loading">
        <el-table-column prop="title" label="文档标题" min-width="200" show-overflow-tooltip />
        <el-table-column prop="fileName" label="文件名" min-width="150" show-overflow-tooltip />
        <el-table-column prop="fileType" label="类型" width="100">
          <template #default="{ row }">
            <el-tag :type="getFileTypeTag(row.fileType)" size="small">{{ row.fileType?.toUpperCase() }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="category" label="分类" width="100">
          <template #default="{ row }">
            {{ getCategoryText(row.category) }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-switch
              v-model="row.status"
              :active-value="1"
              :inactive-value="0"
              @change="handleStatusChange(row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="visitCount" label="访问" width="70" />
        <el-table-column prop="createTime" label="上传时间" width="160" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" @click="previewDocument(row)">预览</el-button>
            <el-button link type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="fetchList"
          @current-change="fetchList"
        />
      </div>
    </el-card>

    <el-dialog v-model="showUploadDialog" title="上传知识库文档" width="500px">
      <el-form :model="uploadForm" label-width="100px">
        <el-form-item label="文档标题">
          <el-input v-model="uploadForm.title" placeholder="请输入文档标题（可选）" />
        </el-form-item>
        <el-form-item label="文档分类">
          <el-select v-model="uploadForm.category" placeholder="请选择分类">
            <el-option label="规章制度" value="rules" />
            <el-option label="常见问题" value="faq" />
            <el-option label="报修指南" value="repair" />
            <el-option label="其他" value="general" />
          </el-select>
        </el-form-item>
        <el-form-item label="上传文件">
          <el-upload
            ref="uploadRef"
            :auto-upload="false"
            :limit="1"
            :on-change="handleFileChange"
            :before-remove="handleFileRemove"
            accept=".pdf,.doc,.docx,.xls,.xlsx,.txt"
          >
            <el-button>选择文件</el-button>
            <template #tip>
              <div class="el-upload__tip">
                支持 PDF、Word、Excel、TXT 格式，单文件不超过 10MB
              </div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="closeUploadDialog">取消</el-button>
        <el-button type="primary" @click="handleUpload" :loading="uploading">上传</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getKnowledgeBaseList, uploadKnowledgeBase, deleteKnowledgeBase, updateKnowledgeBaseStatus } from '@/api/knowledgeBase'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { UploadInstance } from 'element-plus'

interface KnowledgeDocument {
  id: number
  title: string
  fileName: string
  filePath: string
  fileType: string
  fileSize: number
  contentSummary?: string
  category: string
  status: number
  visitCount: number
  createTime: string
}

const loading = ref(false)
const uploading = ref(false)
const showUploadDialog = ref(false)
const uploadRef = ref<UploadInstance>()
const documents = ref<KnowledgeDocument[]>([])

const filterCategory = ref('')
const filterStatus = ref<string>('')

const pagination = reactive({
  page: 1,
  size: 20,
  total: 0
})

const uploadForm = reactive({
  title: '',
  category: 'general',
  file: null as File | null
})

const getFileTypeTag = (type: string | undefined) => {
  if (!type) return 'info'
  const map: Record<string, string> = {
    pdf: 'danger',
    doc: 'primary',
    docx: 'primary',
    xls: 'success',
    xlsx: 'success',
    txt: 'warning'
  }
  return map[type.toLowerCase()] || 'info'
}

const getCategoryText = (category: string) => {
  const map: Record<string, string> = {
    rules: '规章制度',
    faq: '常见问题',
    repair: '报修指南',
    general: '其他'
  }
  return map[category] || category
}

const handleFileChange = (file: any) => {
  uploadForm.file = file.raw
  if (!uploadForm.title) {
    const name = file.name || ''
    uploadForm.title = name.replace(/\.[^.]+$/, '')
  }
}

const handleFileRemove = () => {
  uploadForm.file = null
  return true
}

const closeUploadDialog = () => {
  showUploadDialog.value = false
  uploadForm.title = ''
  uploadForm.category = 'general'
  uploadForm.file = null
  uploadRef.value?.clearFiles()
}

const handleUpload = async () => {
  if (!uploadForm.file) {
    ElMessage.warning('请选择要上传的文件')
    return
  }

  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('file', uploadForm.file)
    formData.append('title', uploadForm.title)
    formData.append('category', uploadForm.category)

    await uploadKnowledgeBase(formData)
    ElMessage.success('上传成功')
    closeUploadDialog()
    fetchList()
  } catch (error: any) {
    ElMessage.error(error?.message || '上传失败')
  } finally {
    uploading.value = false
  }
}

const handleStatusChange = async (doc: KnowledgeDocument) => {
  try {
    await updateKnowledgeBaseStatus(doc.id, doc.status)
    ElMessage.success('状态更新成功')
  } catch {
    doc.status = doc.status === 1 ? 0 : 1
    ElMessage.error('状态更新失败')
  }
}

const handleDelete = async (doc: KnowledgeDocument) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除文档"${doc.title}"吗？删除后无法恢复。`,
      '确认删除',
      { type: 'warning' }
    )
    await deleteKnowledgeBase(doc.id)
    ElMessage.success('删除成功')
    fetchList()
  } catch {
    // cancelled or error
  }
}

const previewDocument = (doc: KnowledgeDocument) => {
  // 拼接正确的访问 URL
  const fileName = doc.filePath.split(/[/\\]/).pop()
  const url = `/api/uploads/knowledge/${fileName}`
  window.open(url, '_blank')
}

const fetchList = async () => {
  loading.value = true
  try {
    const params: any = {
      page: pagination.page,
      size: pagination.size
    }
    if (filterCategory.value) {
      params.category = filterCategory.value
    }
    if (filterStatus.value !== '') {
      params.status = Number(filterStatus.value)
    }

    const res = await getKnowledgeBaseList(params)
    documents.value = res.list || []
    pagination.total = res.total || 0
  } catch {
    ElMessage.error('获取列表失败')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchList()
})
</script>

<style scoped lang="scss">
.knowledge-base {
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
  }

  .filter-card {
    margin-bottom: 16px;
  }

  .data-card {
    .pagination-wrapper {
      display: flex;
      justify-content: flex-end;
      margin-top: 16px;
    }
  }

  .el-upload__tip {
    color: var(--el-text-color-secondary);
    font-size: 12px;
    margin-top: 8px;
  }
}

.material-icons {
  font-size: 18px;
  margin-right: 4px;
  vertical-align: middle;
}
</style>