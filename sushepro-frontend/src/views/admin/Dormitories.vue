<template>
  <div class="dormitories">
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h2 class="page-title">宿舍管理</h2>
          <p class="page-subtitle">管理系统内所有宿舍楼栋和房间信息</p>
        </div>
        <div class="header-icon">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
            <polyline points="9,22 9,12 15,12 15,22"/>
          </svg>
        </div>
      </div>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-icon blue">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="9" rx="1"/>
            <rect x="14" y="3" width="7" height="5" rx="1"/>
            <rect x="14" y="12" width="7" height="9" rx="1"/>
            <rect x="3" y="16" width="7" height="5" rx="1"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ dormitories.length }}</span>
          <span class="stat-label">宿舍总数</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon green">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M22 11.08V12a10 10 0 11-5.93-9.14"/>
            <polyline points="22,4 12,14.01 9,11.01"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ activeCount }}</span>
          <span class="stat-label">启用中</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon orange">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M23 21v-2a4 4 0 00-3-3.87"/>
            <path d="M16 3.13a4 4 0 010 7.75"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ totalCapacity }}</span>
          <span class="stat-label">总床位数</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon purple">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
            <circle cx="12" cy="7" r="4"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ totalOccupancy }}</span>
          <span class="stat-label">已入住</span>
        </div>
      </div>
    </div>

    <div class="data-card">
      <div class="card-header">
        <div class="card-title-row">
          <h3 class="card-title">宿舍列表</h3>
          <span class="card-count">{{ dormitories.length }} 条记录</span>
        </div>
        <div class="card-actions">
          <div class="search-box">
            <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="11" cy="11" r="8"/>
              <path d="M21 21l-4.35-4.35"/>
            </svg>
            <input v-model="searchKeyword" placeholder="搜索宿舍..." class="search-input" />
          </div>
          <el-button type="primary" @click="showAddDialog = true" class="add-btn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="5" x2="12" y2="19"/>
              <line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            添加宿舍
          </el-button>
        </div>
      </div>

      <div v-if="!loading && filteredDormitories.length === 0" class="empty-state">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
          <polyline points="9,22 9,12 15,12 15,22"/>
        </svg>
        <p>暂无宿舍数据</p>
      </div>

      <el-table v-else :data="filteredDormitories" stripe class="dormitory-table" v-loading="loading" :table-layout="'auto'">
        <el-table-column prop="building" label="楼栋" min-width="120">
          <template #default="{ row }">
            <div class="building-cell">
              <span class="building-icon">🏢</span>
              {{ row.building }}
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="dormitoryNumber" label="房间号" min-width="120">
          <template #default="{ row }">
            <span class="room-number">{{ row.dormitoryNumber }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="dormitoryType" label="类型" min-width="120">
          <template #default="{ row }">
            <span :class="['type-badge', row.dormitoryType]">
              {{ row.dormitoryType }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="capacity" label="容量" min-width="100" align="center">
          <template #default="{ row }">
            <div class="capacity-cell">
              <span class="capacity-value">{{ row.currentOccupancy || 0 }}</span>
              <span class="capacity-separator">/</span>
              <span class="capacity-total">{{ row.capacity }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="入住率" min-width="160">
          <template #default="{ row }">
            <div class="occupancy-bar">
              <div class="occupancy-track">
                <div class="occupancy-fill" :style="{ width: getOccupancyRate(row) + '%' }"></div>
              </div>
              <span class="occupancy-text">{{ getOccupancyRate(row) }}%</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" min-width="120" align="center">
          <template #default="{ row }">
            <span :class="['status-badge', row.status === 1 ? 'active' : 'inactive']">
              <span class="status-dot"></span>
              {{ row.status === 1 ? '启用' : '禁用' }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="180" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button size="small" type="primary" plain @click="editDorm(row)" class="edit-btn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/>
                  <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/>
                </svg>
                编辑
              </el-button>
              <el-button size="small" type="danger" plain @click="deleteDorm(row.id)" class="delete-btn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <polyline points="3,6 5,6 21,6"/>
                  <path d="M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/>
                </svg>
                删除
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="showAddDialog" :title="editingDorm ? '编辑宿舍' : '添加宿舍'" width="500px" class="dorm-dialog">
      <div class="dialog-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
          <polyline points="9,22 9,12 15,12 15,22"/>
        </svg>
      </div>
      <el-form :model="form" label-position="top" class="dorm-form">
        <el-form-item label="楼栋">
          <el-input v-model="form.building" placeholder="例如：1号楼" />
        </el-form-item>
        <el-form-item label="房间号">
          <el-input v-model="form.dormitoryNumber" placeholder="例如：101" />
        </el-form-item>
        <el-form-item label="房间类型">
          <el-select v-model="form.dormitoryType" placeholder="请选择房间类型" style="width: 100%">
            <el-option label="4人间" value="4人间">
              <span>4人间 👥</span>
            </el-option>
            <el-option label="6人间" value="6人间">
              <span>6人间 👥👥</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="床位容量">
          <el-input-number v-model="form.capacity" :min="1" :max="10" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="closeDialog" class="cancel-btn">取消</el-button>
        <el-button type="primary" @click="saveDorm" class="save-btn">
          {{ editingDorm ? '保存修改' : '添加宿舍' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getDormitories, addDormitory, updateDormitory, deleteDormitory } from '@/api/admin'
import { ElMessage, ElMessageBox } from 'element-plus'

const loading = ref(false)
const dormitories = ref<any[]>([])
const showAddDialog = ref(false)
const editingDorm = ref<any>(null)
const searchKeyword = ref('')
const form = ref({ building: '', dormitoryNumber: '', dormitoryType: '', capacity: 4 })

const activeCount = computed(() => dormitories.value.filter(d => d.status === 1).length)
const totalCapacity = computed(() => dormitories.value.reduce((sum, d) => sum + (d.capacity || 0), 0))
const totalOccupancy = computed(() => dormitories.value.reduce((sum, d) => sum + (d.currentOccupancy || 0), 0))

const filteredDormitories = computed(() => {
  if (!searchKeyword.value) return dormitories.value
  const keyword = searchKeyword.value.toLowerCase()
  return dormitories.value.filter(d =>
    d.building.toLowerCase().includes(keyword) ||
    d.dormitoryNumber.toLowerCase().includes(keyword)
  )
})

const getOccupancyRate = (row: any) => {
  if (!row.capacity) return 0
  return Math.round(((row.currentOccupancy || 0) / row.capacity) * 100)
}

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

const closeDialog = () => {
  showAddDialog.value = false
  editingDorm.value = null
  form.value = { building: '', dormitoryNumber: '', dormitoryType: '', capacity: 4 }
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
    closeDialog()
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
$blue: #3b82f6;
$green: #22c55e;
$orange: #f59e0b;
$purple: #8b5cf6;

.dormitories {
  animation: fadeIn 0.4s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

.page-header {
  margin-bottom: 28px;

  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
  }

  .header-text {
    .page-title {
      font-size: 32px;
      font-weight: 600;
      color: $on-surface;
      font-family: 'Inter', -apple-system, sans-serif;
      letter-spacing: -0.5px;
    }

    .page-subtitle {
      font-size: 15px;
      color: $on-surface-variant;
      margin-top: 6px;
      font-weight: 400;
    }
  }

  .header-icon {
    width: 56px;
    height: 56px;
    background: linear-gradient(135deg, $primary 0%, #1d4ed8 100%);
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 12px rgba(0, 88, 188, 0.3);

    svg {
      width: 28px;
      height: 28px;
      color: white;
    }
  }
}

.stats-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;

  .stat-card {
    background: $surface-lowest;
    border: 1px solid $outline-variant;
    border-radius: 16px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 16px;
    transition: all 0.2s ease;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
    }

    .stat-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;

      svg {
        width: 24px;
        height: 24px;
      }

      &.blue {
        background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
        svg { color: $blue; }
      }

      &.green {
        background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
        svg { color: $green; }
      }

      &.orange {
        background: linear-gradient(135deg, #ffedd5 0%, #fed7aa 100%);
        svg { color: $orange; }
      }

      &.purple {
        background: linear-gradient(135deg, #ede9fe 0%, #ddd6fe 100%);
        svg { color: $purple; }
      }
    }

    .stat-info {
      display: flex;
      flex-direction: column;
      gap: 2px;

      .stat-value {
        font-size: 26px;
        font-weight: 700;
        color: $on-surface;
        line-height: 1.2;
      }

      .stat-label {
        font-size: 13px;
        color: $on-surface-variant;
        font-weight: 500;
      }
    }
  }
}

.data-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    flex-wrap: wrap;
    gap: 16px;

    .card-title-row {
      display: flex;
      align-items: center;
      gap: 12px;

      .card-title {
        font-size: 18px;
        font-weight: 600;
        color: $on-surface;
      }

      .card-count {
        background: $surface-low;
        color: $on-surface-variant;
        padding: 4px 12px;
        border-radius: 9999px;
        font-size: 12px;
        font-weight: 500;
      }
    }

    .card-actions {
      display: flex;
      align-items: center;
      gap: 12px;

      .search-box {
        position: relative;
        display: flex;
        align-items: center;

        .search-icon {
          position: absolute;
          left: 12px;
          width: 18px;
          height: 18px;
          color: $outline;
        }

        .search-input {
          padding: 10px 12px 10px 40px;
          border: 1px solid $outline-variant;
          border-radius: 10px;
          font-size: 14px;
          width: 220px;
          background: $surface-lowest;
          color: $on-surface;
          transition: all 0.2s ease;

          &::placeholder {
            color: $outline;
          }

          &:focus {
            outline: none;
            border-color: $primary;
            box-shadow: 0 0 0 3px rgba(0, 88, 188, 0.12);
          }
        }
      }

      .add-btn {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 10px 20px;
        border-radius: 10px;
        font-weight: 500;
        background: linear-gradient(135deg, $primary 0%, #1d4ed8 100%);
        border: none;
        box-shadow: 0 2px 8px rgba(0, 88, 188, 0.3);
        transition: all 0.2s ease;

        svg {
          width: 18px;
          height: 18px;
        }

        &:hover {
          transform: translateY(-1px);
          box-shadow: 0 4px 12px rgba(0, 88, 188, 0.4);
        }
      }
    }
  }
}

.empty-state {
  text-align: center;
  padding: 48px 24px;
  color: $on-surface-variant;

  svg {
    width: 64px;
    height: 64px;
    margin-bottom: 16px;
    opacity: 0.5;
  }

  p {
    font-size: 15px;
  }
}

.dormitory-table {
  :deep(.el-table__header-wrapper th) {
    background: $surface-low;
    color: $on-surface-variant;
    border-bottom: none;
    font-weight: 600;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    padding: 14px 16px;
  }

  :deep(.el-table__body-wrapper tr) {
    transition: background 0.15s ease;

    &:hover > td {
      background: $surface-low !important;
    }
  }

  :deep(.el-table__body-wrapper td) {
    border-bottom: 1px solid $surface-high;
    padding: 16px;
  }
}

.building-cell {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 500;
  color: $on-surface;

  .building-icon {
    font-size: 18px;
  }
}

.room-number {
  font-weight: 600;
  color: $on-surface;
  font-family: 'JetBrains Mono', monospace;
}

.type-badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 500;

  &.四人间 {
    background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
    color: #1e40af;
  }

  &.六人间 {
    background: linear-gradient(135deg, #ede9fe 0%, #ddd6fe 100%);
    color: #6d28d9;
  }
}

.capacity-cell {
  font-family: 'JetBrains Mono', monospace;
  font-size: 14px;

  .capacity-value {
    font-weight: 600;
    color: $primary;
  }

  .capacity-separator {
    color: $outline;
    margin: 0 2px;
  }

  .capacity-total {
    color: $on-surface-variant;
  }
}

.occupancy-bar {
  display: flex;
  align-items: center;
  gap: 10px;

  .occupancy-track {
    flex: 1;
    height: 6px;
    background: $surface-high;
    border-radius: 3px;
    overflow: hidden;
    max-width: 80px;

    .occupancy-fill {
      height: 100%;
      background: linear-gradient(90deg, $green 0%, #86efac 100%);
      border-radius: 3px;
      transition: width 0.3s ease;
    }
  }

  .occupancy-text {
    font-size: 13px;
    font-weight: 500;
    color: $on-surface-variant;
    min-width: 36px;
  }
}

.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 9999px;
  font-size: 13px;
  font-weight: 500;

  .status-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
  }

  &.active {
    background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
    color: #166534;

    .status-dot {
      background: $green;
      box-shadow: 0 0 6px $green;
    }
  }

  &.inactive {
    background: $surface-low;
    color: $on-surface-variant;

    .status-dot {
      background: $outline;
    }
  }
}

.action-buttons {
  display: flex;
  gap: 8px;

  .edit-btn, .delete-btn {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 14px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 500;
    border: 1px solid;
    transition: all 0.2s ease;

    svg {
      width: 14px;
      height: 14px;
    }
  }

  .edit-btn {
    background: transparent;
    border-color: $outline-variant;
    color: $on-surface-variant;

    &:hover {
      background: $primary;
      border-color: $primary;
      color: white;
    }
  }

  .delete-btn {
    background: transparent;
    border-color: #fecaca;
    color: #dc2626;

    &:hover {
      background: #dc2626;
      border-color: #dc2626;
      color: white;
    }
  }
}

.dorm-dialog {
  :deep(.el-dialog) {
    border-radius: 20px;
    overflow: hidden;
  }

  :deep(.el-dialog__header) {
    background: linear-gradient(135deg, $primary 0%, #1d4ed8 100%);
    padding: 24px;
    margin: 0;

    .el-dialog__title {
      color: white;
      font-weight: 600;
      font-size: 18px;
    }
  }

  :deep(.el-dialog__body) {
    padding: 32px 24px;
  }

  :deep(.el-dialog__footer) {
    padding: 16px 24px 24px;
    border-top: 1px solid $surface-high;
  }

  .dialog-icon {
    text-align: center;
    margin-bottom: 20px;

    svg {
      width: 48px;
      height: 48px;
      color: $primary;
    }
  }

  .dorm-form {
    :deep(.el-form-item__label) {
      color: $on-surface;
      font-weight: 500;
      padding-bottom: 8px;
    }

    :deep(.el-input__wrapper),
    :deep(.el-select__wrapper) {
      background: $surface-lowest;
      border: 1px solid $outline-variant;
      box-shadow: none;
      border-radius: 10px;
      padding: 4px 12px;

      &:focus-within {
        border-color: $primary;
        box-shadow: 0 0 0 3px rgba(0, 88, 188, 0.12);
      }
    }
  }

  .cancel-btn {
    padding: 12px 24px;
    border-radius: 10px;
    border: 1px solid $outline-variant;
    color: $on-surface-variant;
    font-weight: 500;

    &:hover {
      background: $surface-low;
    }
  }

  .save-btn {
    padding: 12px 28px;
    border-radius: 10px;
    background: linear-gradient(135deg, $primary 0%, #1d4ed8 100%);
    border: none;
    color: white;
    font-weight: 500;
    box-shadow: 0 2px 8px rgba(0, 88, 188, 0.3);

    &:hover {
      box-shadow: 0 4px 12px rgba(0, 88, 188, 0.4);
    }
  }
}

@media (max-width: 1200px) {
  .stats-row {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .stats-row {
    grid-template-columns: 1fr;
  }

  .data-card .card-header {
    flex-direction: column;
    align-items: stretch;
  }

  .data-card .card-actions {
    flex-direction: column;

    .search-box .search-input {
      width: 100%;
    }
  }
}
</style>