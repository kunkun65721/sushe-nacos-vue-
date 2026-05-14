<template>
  <div class="transfers">
    <div class="page-header">
      <h2 class="page-title">调换管理</h2>
      <p class="page-subtitle">审核和管理学生的宿舍调换申请</p>
    </div>

    <el-card class="filter-card">
      <el-radio-group v-model="statusFilter" @change="fetchData">
        <el-radio-button :value="undefined">全部</el-radio-button>
        <el-radio-button :value="0">待审核</el-radio-button>
        <el-radio-button :value="1">已通过</el-radio-button>
        <el-radio-button :value="2">已拒绝</el-radio-button>
      </el-radio-group>
    </el-card>

    <el-card class="data-card">
      <el-table :data="transfers" stripe style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="studentNumber" label="学号" width="120" />
        <el-table-column prop="studentName" label="姓名" width="100" />
        <el-table-column label="当前宿舍" width="150">
          <template #default="{ row }">{{ row.currentBuilding }} {{ row.currentDormitoryNumber }}</template>
        </el-table-column>
        <el-table-column label="意向宿舍" width="150">
          <template #default="{ row }">{{ row.targetBuilding }} {{ row.targetDormitoryNumber }}</template>
        </el-table-column>
        <el-table-column prop="reason" label="理由" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="statusTag[row.status]">{{ statusText[row.status] }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="applyTime" label="申请时间" width="160" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="showDetail(row)">详情</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="showDetailDialog" title="调换申请详情" width="600px">
      <div v-if="selectedTransfer">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="学号">{{ selectedTransfer.studentNumber }}</el-descriptions-item>
          <el-descriptions-item label="姓名">{{ selectedTransfer.studentName }}</el-descriptions-item>
          <el-descriptions-item label="当前宿舍">{{ selectedTransfer.currentBuilding }} {{ selectedTransfer.currentDormitoryNumber }}</el-descriptions-item>
          <el-descriptions-item label="意向宿舍">{{ selectedTransfer.targetBuilding }} {{ selectedTransfer.targetDormitoryNumber }}</el-descriptions-item>
          <el-descriptions-item label="理由">{{ selectedTransfer.reason || '无' }}</el-descriptions-item>
          <el-descriptions-item label="申请时间">{{ selectedTransfer.applyTime }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="statusTag[selectedTransfer.status]">{{ statusText[selectedTransfer.status] }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item v-if="selectedTransfer.adminComment" label="审核意见" :span="2">{{ selectedTransfer.adminComment }}</el-descriptions-item>
          <el-descriptions-item v-if="selectedTransfer.attachment" label="附件" :span="2">
            <a :href="getAttachmentUrl(selectedTransfer.attachment)" target="_blank" style="color: #0058bc; display: flex; align-items: center; gap: 4px;">
              <span style="font-size: 12px;">点击下载附件</span>
            </a>
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <el-button @click="showDetailDialog = false">关闭</el-button>
        <template v-if="selectedTransfer && selectedTransfer.status === 0">
          <el-button type="success" @click="showApproveDialog">通过</el-button>
          <el-button type="danger" @click="showRejectDialog">拒绝</el-button>
        </template>
      </template>
    </el-dialog>

    <el-dialog v-model="showApprove" title="通过申请" width="500px">
      <el-form :model="approveForm" label-width="100px">
        <el-form-item label="目标宿舍">
          <el-select v-model="approveForm.targetDormitoryId" placeholder="请选择目标宿舍" style="width: 100%">
            <el-option v-for="d in dormitories" :key="d.id" :label="d.building + d.dormitoryNumber" :value="d.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="审核意见">
          <el-input v-model="approveForm.adminComment" type="textarea" :rows="2" placeholder="可选" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showApprove = false">取消</el-button>
        <el-button type="success" @click="handleApprove" :loading="loading">确定通过</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="showReject" title="拒绝申请" width="500px">
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
import { getTransfers, getDormitories, approveTransfer, rejectTransfer, deleteTransfer } from '@/api/admin'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const transfers = ref<any[]>([])
const dormitories = ref<any[]>([])
const statusFilter = ref<number | undefined>(undefined)

const showDetailDialog = ref(false)
const showApprove = ref(false)
const showReject = ref(false)
const selectedTransfer = ref<any>(null)
const approveForm = ref({ id: 0, targetDormitoryId: undefined as number | undefined, adminComment: '' })
const rejectForm = ref({ id: 0, adminComment: '' })

const statusText: Record<number, string> = { 0: '待审核', 1: '已通过', 2: '已拒绝' }
const statusTag: Record<number, string> = { 0: 'warning', 1: 'success', 2: 'danger' }

const fetchData = async () => {
  try {
    transfers.value = await getTransfers(statusFilter.value)
  } catch { /* ignore */ }
}

const loadDormitories = async () => {
  try {
    dormitories.value = await getDormitories()
  } catch { /* ignore */ }
}

const showDetail = (row: any) => {
  selectedTransfer.value = row
  showDetailDialog.value = true
}

const showApproveDialog = () => {
  showDetailDialog.value = false
  approveForm.value = { id: selectedTransfer.value.id, targetDormitoryId: undefined, adminComment: '' }
  showApprove.value = true
}

const showRejectDialog = () => {
  showDetailDialog.value = false
  rejectForm.value = { id: selectedTransfer.value.id, adminComment: '' }
  showReject.value = true
}

const handleApprove = async () => {
  if (!approveForm.value.targetDormitoryId) {
    ElMessage.warning('请选择目标宿舍')
    return
  }
  try {
    await approveTransfer(approveForm.value.id, approveForm.value.targetDormitoryId, approveForm.value.adminComment)
    ElMessage.success('操作成功')
    showApprove.value = false
    await fetchData()
  } catch { /* ignore */ }
}

const handleReject = async () => {
  if (!rejectForm.value.adminComment) {
    ElMessage.warning('请输入拒绝理由')
    return
  }
  try {
    await rejectTransfer(rejectForm.value.id, rejectForm.value.adminComment)
    ElMessage.success('操作成功')
    showReject.value = false
    await fetchData()
  } catch { /* ignore */ }
}

const getAttachmentUrl = (path: string) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  return '/api/' + (path.startsWith('/') ? path.slice(1) : path)
}

const handleDelete = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定删除该申请记录吗？', '提示', { type: 'warning' })
    await deleteTransfer(id)
    ElMessage.success('删除成功')
    await fetchData()
  } catch { /* cancelled or error */ }
}

onMounted(() => { fetchData(); loadDormitories() })
</script>

<style scoped lang="scss">
$bg: #f8f9fa;
$surface: #f3f4f5;
$surface-low: #edeeef;
$surface-lowest: #ffffff;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline-variant: #c1c6d7;

.transfers {
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