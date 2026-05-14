<template>
  <div class="dormitories">
    <div class="page-header">
      <h2 class="page-title">宿舍管理</h2>
      <p class="page-subtitle">管理宿舍楼栋和房间</p>
    </div>

    <div class="data-card">
      <div class="card-header">
        <el-button type="primary" @click="showAddDialog = true">添加宿舍</el-button>
      </div>

      <el-table :data="dormitories" stripe style="width: 100%">
        <el-table-column prop="building" label="楼栋" width="100" />
        <el-table-column prop="dormitoryNumber" label="房间号" width="100" />
        <el-table-column prop="dormitoryType" label="类型" width="120" />
        <el-table-column prop="capacity" label="容量" width="80" />
        <el-table-column prop="currentOccupancy" label="当前入住" width="100" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <span :class="['status-badge', row.status === 1 ? 'active' : 'inactive']">
              {{ row.status === 1 ? '启用' : '禁用' }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button size="small" type="primary" @click="editDorm(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteDorm(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="showAddDialog" :title="editingDorm ? '编辑宿舍' : '添加宿舍'" width="500px">
      <el-form :model="form" label-width="100px">
        <el-form-item label="楼栋"><el-input v-model="form.building" /></el-form-item>
        <el-form-item label="房间号"><el-input v-model="form.dormitoryNumber" /></el-form-item>
        <el-form-item label="类型">
          <el-select v-model="form.dormitoryType" placeholder="请选择房间类型">
            <el-option label="4人间" value="4人间" />
            <el-option label="6人间" value="6人间" />
          </el-select>
        </el-form-item>
        <el-form-item label="容量"><el-input-number v-model="form.capacity" :min="1" :max="10" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="saveDorm">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getDormitories, addDormitory, updateDormitory, deleteDormitory } from '@/api/admin'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const dormitories = ref<any[]>([])
const showAddDialog = ref(false)
const editingDorm = ref<any>(null)
const form = ref({ building: '', dormitoryNumber: '', dormitoryType: '', capacity: 4 })

const fetchData = async () => {
  loading.value = true
  try {
    dormitories.value = await getDormitories()
  } catch {
    // error handled
  } finally {
    loading.value = false
  }
}

const editDorm = (dorm: any) => {
  editingDorm.value = dorm
  form.value = { ...dorm }
  showAddDialog.value = true
}

const saveDorm = async () => {
  try {
    if (editingDorm.value) {
      await updateDormitory(editingDorm.value.id, form.value)
      ElMessage.success('更新成功')
    } else {
      await addDormitory(form.value)
      ElMessage.success('添加成功')
    }
    showAddDialog.value = false
    editingDorm.value = null
    form.value = { building: '', dormitoryNumber: '', dormitoryType: '', capacity: 4 }
    await fetchData()
  } catch {
    // error handled
  }
}

const deleteDorm = async (id: number) => {
  try {
    await ElMessageBox.confirm('确定删除该宿舍?', '提示', { type: 'warning' })
    await deleteDormitory(id)
    ElMessage.success('删除成功')
    await fetchData()
  } catch {
    // cancelled or error
  }
}

onMounted(fetchData)
</script>

<style scoped lang="scss">
$bg: #f8f9fa;
$surface: #f3f4f5;
$surface-high: #e7e8e9;
$surface-low: #edeeef;
$surface-lowest: #ffffff;
$primary: #0058bc;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline: #717786;
$outline-variant: #c1c6d7;

.dormitories {
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

.data-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 16px;

  .card-header {
    margin-bottom: 16px;
  }
}

.status-badge {
  padding: 4px 12px;
  border-radius: 9999px;
  font-size: 12px;

  &.active {
    background: #dcfce7;
    color: #166534;
  }

  &.inactive {
    background: #f3f4f5;
    color: #414755;
  }
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
  }

  .el-table__body-wrapper tr:hover > td {
    background: $surface-low !important;
  }

  td {
    border-bottom: 1px solid $outline-variant;
  }
}

:deep(.el-dialog) {
  background: $surface-lowest;

  .el-dialog__title {
    color: $on-surface;
  }
}

:deep(.el-form-item__label) {
  color: $on-surface-variant;
}

:deep(.el-input__wrapper) {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  box-shadow: none;

  &:focus-within {
    border-color: $primary;
    box-shadow: 0 0 0 2px rgba(0, 88, 188, 0.15);
  }
}
</style>