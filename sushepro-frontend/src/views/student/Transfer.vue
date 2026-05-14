<template>
  <div class="transfer">
    <h2>宿舍调换申请</h2>
    <el-card v-loading="loading">
      <el-form :model="form" label-width="120px">
        <el-form-item label="当前宿舍">
          <el-input :value="currentDorm" disabled />
        </el-form-item>
        <el-form-item label="目标宿舍">
          <el-select v-model="form.targetDormitoryId" placeholder="请选择目标宿舍">
            <el-option v-for="d in dormitories" :key="d.id" :label="d.building + d.dormitoryNumber" :value="d.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="调换原因">
          <el-input v-model="form.reason" type="textarea" :rows="4" placeholder="请输入调换原因" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm">提交申请</el-button>
        </el-form-item>
      </el-form>

      <el-divider />

      <h3>我的调换申请</h3>
      <el-table :data="transfers" stripe class="mt-20">
        <el-table-column prop="applyTime" label="申请时间" width="180" />
        <el-table-column prop="reason" label="调换原因" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : row.status === 2 ? 'danger' : 'warning'">
              {{ row.status === 0 ? '待审核' : row.status === 1 ? '已通过' : '已拒绝' }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getStudentTransfers, submitTransfer, getStudentDormitories, getStudentAllocation } from '@/api/student'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const form = ref({ reason: '', targetDormitoryId: undefined as number | undefined })
const transfers = ref<any[]>([])
const dormitories = ref<any[]>([])
const allocation = ref<any>(null)

const currentDorm = computed(() => {
  if (!allocation.value) return '未分配'
  return (allocation.value.building || '') + (allocation.value.dormitoryNumber || '')
})

const fetchData = async () => {
  loading.value = true
  try {
    const [transferData, dormData, allocData] = await Promise.all([
      getStudentTransfers(),
      getStudentDormitories(),
      getStudentAllocation()
    ])
    transfers.value = transferData || []
    dormitories.value = dormData || []
    allocation.value = allocData
  } catch {
    // error handled
  } finally {
    loading.value = false
  }
}

const submitForm = async () => {
  if (!form.value.reason) {
    ElMessage.warning('请输入调换原因')
    return
  }
  loading.value = true
  try {
    await submitTransfer(form.value)
    ElMessage.success('提交成功')
    form.value = { reason: '', targetDormitoryId: undefined }
    await fetchData()
  } catch {
    // error handled
  } finally {
    loading.value = false
  }
}

onMounted(fetchData)
</script>

<style scoped lang="scss">
$on-surface: #191c1d;
$primary: #0058bc;

.transfer {
  h2 {
    margin-bottom: 20px;
    color: $on-surface;
    font-family: 'Instrument Serif', serif;
  }
  h3 { margin: 20px 0; color: $on-surface; }
  .mt-20 { margin-top: 20px; }
}
</style>