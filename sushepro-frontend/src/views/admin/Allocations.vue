<template>
  <div class="allocations">
    <div class="page-header">
      <div class="header-content">
        <div class="header-text">
          <h2 class="page-title">宿舍分配</h2>
          <p class="page-subtitle">查看和管理学生宿舍分配记录</p>
        </div>
        <div class="header-icon">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <path d="M16 21v-2a4 4 0 00-4-4H6a4 4 0 00-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M22 21v-2a4 4 0 00-3-3.87"/>
            <path d="M16 3.13a4 4 0 010 7.75"/>
          </svg>
        </div>
      </div>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-icon blue">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M23 21v-2a4 4 0 00-3-3.87"/>
            <path d="M16 3.13a4 4 0 010 7.75"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ allocations.length }}</span>
          <span class="stat-label">分配总数</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon green">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
            <line x1="16" y1="2" x2="16" y2="6"/>
            <line x1="8" y1="2" x2="8" y2="6"/>
            <line x1="3" y1="10" x2="21" y2="10"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-value">{{ todayCount }}</span>
          <span class="stat-label">今日分配</span>
        </div>
      </div>
    </div>

    <div class="data-card">
      <div class="card-header">
        <div class="card-title-row">
          <h3 class="card-title">分配记录</h3>
          <span class="card-count">{{ allocations.length }} 条记录</span>
        </div>
        <div class="search-box">
          <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"/>
            <path d="M21 21l-4.35-4.35"/>
          </svg>
          <input v-model="searchKeyword" placeholder="搜索学生姓名..." class="search-input" />
        </div>
      </div>

      <div v-if="!loading && filteredAllocations.length === 0" class="empty-state">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path d="M16 21v-2a4 4 0 00-4-4H6a4 4 0 00-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <path d="M22 21v-2a4 4 0 00-3-3.87"/>
          <path d="M16 3.13a4 4 0 010 7.75"/>
        </svg>
        <p>暂无分配记录</p>
      </div>

      <el-table v-else :data="filteredAllocations" stripe class="allocation-table" v-loading="loading" :table-layout="'auto'">
        <el-table-column label="学生" min-width="180">
          <template #default="{ row }">
            <div class="student-cell">
              <div class="student-avatar">
                {{ getAvatarText(row.studentName) }}
              </div>
              <span class="student-name">{{ row.studentName }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="building" label="楼栋" min-width="140">
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
        <el-table-column label="分配时间" min-width="200">
          <template #default="{ row }">
            <div class="time-cell">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/>
                <polyline points="12,6 12,12 16,14"/>
              </svg>
              <span>{{ formatTime(row.allocateTime) }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="状态" min-width="140">
          <template #default="{ row }">
            <span :class="['status-badge', isToday(row.allocateTime) ? 'active' : 'inactive']">
              <span class="status-dot"></span>
              {{ isToday(row.allocateTime) ? '今日分配' : '历史记录' }}
            </span>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getAllocations } from '@/api/admin'

const loading = ref(false)
const allocations = ref<any[]>([])
const searchKeyword = ref('')

const todayCount = computed(() => {
  return allocations.value.filter(a => isToday(a.allocateTime)).length
})

const filteredAllocations = computed(() => {
  if (!searchKeyword.value) return allocations.value
  const keyword = searchKeyword.value.toLowerCase()
  return allocations.value.filter(a => a.studentName.toLowerCase().includes(keyword))
})

const getAvatarText = (name: string) => {
  return name ? name.charAt(0).toUpperCase() : '?'
}

const formatTime = (time: string) => {
  if (!time) return '-'
  const date = new Date(time)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const isToday = (time: string) => {
  if (!time) return false
  const date = new Date(time)
  const today = new Date()
  return date.toDateString() === today.toDateString()
}

const fetchData = async () => {
  loading.value = true
  try {
    const response = await getAllocations()
    console.log('API response:', JSON.stringify(response, null, 2))
    allocations.value = response || []
  } catch {
    // error handled
  } finally {
    loading.value = false
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

.allocations {
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
    background: linear-gradient(135deg, $purple 0%, #7c3aed 100%);
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);

    svg {
      width: 28px;
      height: 28px;
      color: white;
    }
  }
}

.stats-row {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-bottom: 24px;
  max-width: 500px;

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

.allocation-table {
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

.student-cell {
  display: flex;
  align-items: center;
  gap: 12px;

  .student-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, $primary 0%, #1d4ed8 100%);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 14px;
    flex-shrink: 0;
  }

  .student-name {
    font-weight: 500;
    color: $on-surface;
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

.time-cell {
  display: flex;
  align-items: center;
  gap: 8px;
  color: $on-surface-variant;
  font-size: 14px;

  svg {
    width: 16px;
    height: 16px;
    flex-shrink: 0;
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
</style>