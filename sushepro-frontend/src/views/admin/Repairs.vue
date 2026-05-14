<template>
  <div class="repairs">
    <div class="page-header">
      <h2 class="page-title">报修管理</h2>
      <p class="page-subtitle">查看和处理学生的宿舍报修申请</p>
    </div>

    <el-card class="filter-card">
      <el-radio-group v-model="statusFilter" @change="fetchData">
        <el-radio-button :value="undefined">全部</el-radio-button>
        <el-radio-button :value="0">待处理</el-radio-button>
        <el-radio-button :value="1">处理中</el-radio-button>
        <el-radio-button :value="2">已完成</el-radio-button>
        <el-radio-button :value="3">已拒绝</el-radio-button>
      </el-radio-group>
    </el-card>

    <el-card class="data-card">
      <el-table :data="repairs" stripe style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="studentNumber" label="学号" width="120" />
        <el-table-column prop="studentName" label="姓名" width="100" />
        <el-table-column label="宿舍" width="150">
          <template #default="{ row }">{{ row.building }} {{ row.dormitoryNumber }}</template>
        </el-table-column>
        <el-table-column prop="description" label="问题描述" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="statusTag[row.status]">{{ statusText[row.status] }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="提交时间" width="160" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="showDetail(row)">详情</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="showDetailDialog" title="报修详情" width="600px">
      <div v-if="selectedRepair">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="学号">{{ selectedRepair.studentNumber }}</el-descriptions-item>
          <el-descriptions-item label="姓名">{{ selectedRepair.studentName }}</el-descriptions-item>
          <el-descriptions-item label="宿舍">{{ selectedRepair.building }} {{ selectedRepair.dormitoryNumber }}</el-descriptions-item>
          <el-descriptions-item label="提交时间">{{ selectedRepair.createTime }}</el-descriptions-item>
          <el-descriptions-item label="问题描述" :span="2">{{ selectedRepair.description || '无' }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="statusTag[selectedRepair.status]">{{ statusText[selectedRepair.status] }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="处理时间">{{ selectedRepair.updateTime || '待处理' }}</el-descriptions-item>
          <el-descriptions-item v-if="selectedRepair.adminComment" label="处理意见" :span="2">{{ selectedRepair.adminComment }}</el-descriptions-item>
          <el-descriptions-item v-if="selectedRepair.image" label="现场照片" :span="2">
            <el-image
              v-if="selectedRepair.image"
              :src="getImageUrl(selectedRepair.image)"
              :preview-src-list="[getImageUrl(selectedRepair.image)]"
              fit="cover"
              style="width: 120px; height: 90px; border-radius: 4px; cursor: pointer;"
            />
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <el-button @click="showDetailDialog = false">关闭</el-button>
        <template v-if="selectedRepair">
          <template v-if="selectedRepair.status === 0">
            <el-button type="warning" @click="showProcessDialog">标记处理中</el-button>
            <el-button type="danger" @click="showRejectDialog">拒绝</el-button>
          </template>
          <template v-else-if="selectedRepair.status === 1">
            <el-button type="success" @click="handleComplete(selectedRepair.id)">标记已完成</el-button>
          </template>
        </template>
      </template>
    </el-dialog>

    <el-dialog v-model="showProcess" title="标记处理中" width="500px">
      <el-form :model="processForm" label-width="100px">
        <el-form-item label="备注">
          <el-input v-model="processForm.adminComment" type="textarea" :rows="2" placeholder="可选" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showProcess = false">取消</el-button>
        <el-button type="primary" @click="handleProcess" :loading="loading">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="showReject" title="拒绝报修" width="500px">
      <el-form :model="rejectForm" label-width="100px">
        <el-form-item label="拒绝理由">
          <el-input v-model="rejectForm.adminComment" type="textarea" :rows="3" placeholder="请输入拒绝理由" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showReject = false">取消</el-button>
        <el-button type="danger" @click="handleReject" :loading="loading">确定拒绝</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getRepairs, processRepair, completeRepair, rejectRepair, deleteRepair } from '@/api/admin'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const repairs = ref<any[]>([])
const statusFilter = ref<number | undefined>(undefined)

const showDetailDialog = ref(false)
const showProcess = ref(false)
const showReject = ref(false)
const selectedRepair = ref<any>(null)
const processForm = ref({ id: 0, adminComment: '' })
const rejectForm = ref({ id: 0, adminComment: '' })

const statusText: Record<number, string> = { 0: '待处理', 1: '处理中', 2: '已完成', 3: '已拒绝' }
const statusTag: Record<number, string> = { 0: 'warning', 1: 'primary', 2: 'success', 3: 'danger' }

const fetchData = async () => {
  try {
    repairs.value = await getRepairs(statusFilter.value)
  } catch { /* ignore */ }
}

const showDetail = (row: any) => {
  selectedRepair.value = row
  showDetailDialog.value = true
}

const showProcessDialog = () => {
  showDetailDialog.value = false
  processForm.value = { id: selectedRepair.value.id, adminComment: '' }
  showProcess.value = true
}

const showRejectDialog = () => {
  showDetailDialog.value = false
  rejectForm.value = { id: selectedRepair.value.id, adminComment: '' }
  showReject.value = true
}

const handleProcess = async () => {
  try {
    await processRepair(processForm.value.id, processForm.value.adminComment)
    ElMessage.success('已标记为处理中')
    showProcess.value = false
    await fetchData()
  } catch { /* ignore */ }
}

const handleComplete = async (id: number) => {
  try {
    await completeRepair(id)
    ElMessage.success('已标记为完成')
    showDetailDialog.value = false
    await fetchData()
  } catch { /* ignore */ }
}

const handleReject = async () => {
  try {
    await rejectRepair(rejectForm.value.id, rejectForm.value.adminComment)
    ElMessage.success('已拒绝')
    showReject.value = false
    await fetchData()
  } catch { /* ignore */ }
}

const getImageUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  return '/api/' + (path.startsWith('/') ? path.slice(1) : path)
}

const handleDelete = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定删除该报修记录吗？', '提示', { type: 'warning' })
    await deleteRepair(id)
    ElMessage.success('删除成功')
    await fetchData()
  } catch { /* cancelled or error */ }
}

onMounted(fetchData)
</script>

<style scoped lang="scss">
$bg: #f8f9fa;
$surface: #f3f4f5;
$surface-low: #edeeef;
$surface-lowest: #ffffff;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline-variant: #c1c6d7;

.repairs {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

.page-header {
  margin-bottom: 24px;

  .page-title {
    font-size: 32px;
    font-weight: 400;
    color: $on-surface;
    font-family: 'Instrument Serif', serif;
  }

  .page-subtitle {
    font-size: 18px;
    color: $on-surface-variant;
    margin-top: 8px;
  }
}

.filter-card {
  margin-bottom: 16px;
}

.data-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
}

:deep(.el-table) {
  background: transparent;
  color: $on-surface;

  .el-table__header-wrapper th {
    background: $surface-low;
    color: $on-surface-variant;
    border-bottom: 2px solid $outline-variant;
    font-weight: 600;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .el-table__body-wrapper tr:hover > td {
    background: $surface-low !important;
  }

  td {
    border-bottom: 1px solid $outline-variant;
  }
}
</style>