<template>
  <div class="allocation">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title flex items-center gap-sm">
          <span class="material-icons">king_bed</span> 宿舍分配
        </h2>
        <p class="page-subtitle">查看您的宿舍及房间详细信息。</p>
      </div>
    </div>

    <!-- Allocated Room -->
    <div v-if="allocation" class="allocation-card">
      <div class="card-header">
        <span class="material-icons">meeting_room</span>
        <h3>{{ allocation.dormitoryNumber }}</h3>
        <p>您的已分配房间</p>
      </div>

      <div class="card-info">
        <div class="info-row">
          <span class="material-icons">domain</span>
          <span class="info-label">房间号</span>
          <span class="info-value">{{ allocation.dormitoryNumber }}</span>
        </div>
        <div class="info-row">
          <span class="material-icons">category</span>
          <span class="info-label">房间类型</span>
          <span class="info-value">{{ allocation.dormitoryType }}</span>
        </div>
        <div class="info-row">
          <span class="material-icons">apartment</span>
          <span class="info-label">楼栋</span>
          <span class="info-value">{{ allocation.building }}</span>
        </div>
        <div class="info-row">
          <span class="material-icons">calendar_today</span>
          <span class="info-label">分配日期</span>
          <span class="info-value">{{ allocation.allocateTime }}</span>
        </div>
      </div>
    </div>

    <!-- No Allocation -->
    <div v-else class="no-allocation">
      <span class="material-icons">bedroom_parent</span>
      <h3>暂无分配</h3>
      <p>请先完成生活习惯问卷。系统将根据您的偏好为您匹配合适的室友。</p>
      <router-link to="/student/questionnaire" class="btn-primary">
        <span class="material-icons">quiz</span>
        填写问卷
      </router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getStudentAllocation } from '@/api/student'

const loading = ref(false)
const allocation = ref<any>(null)

const fetchData = async () => {
  loading.value = true
  try {
    allocation.value = await getStudentAllocation()
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
$primary-fixed: #d8e2ff;
$on-primary-fixed-variant: #004493;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline: #717786;
$outline-variant: #c1c6d7;

.allocation {
  animation: fadeIn 0.3s ease;
  max-width: 700px;
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

    .material-icons {
      color: $primary;
    }
  }

  .page-subtitle {
    font-size: 18px;
    color: $on-surface-variant;
    margin-top: 8px;
  }
}

.allocation-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  overflow: hidden;
}

.card-header {
  background: $primary;
  color: #ffffff;
  padding: 32px;
  text-align: center;

  .material-icons {
    font-size: 48px;
    margin-bottom: 8px;
  }

  h3 {
    font-size: 32px;
    font-weight: 400;
    font-family: 'Instrument Serif', serif;
    margin-bottom: 8px;
  }

  p {
    font-size: 16px;
    opacity: 0.8;
  }
}

.card-info {
  padding: 16px;

  .info-row {
    display: flex;
    align-items: center;
    padding: 12px;
    border-radius: 8px;
    transition: background 0.2s;

    &:hover {
      background: $surface-high;
    }

    &:not(:last-child) {
      border-bottom: 1px solid $outline-variant;
    }

    .material-icons {
      font-size: 24px;
      color: $primary;
      margin-right: 16px;
    }

    .info-label {
      font-size: 12px;
      color: $on-surface-variant;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      width: 120px;
    }

    .info-value {
      font-size: 14px;
      color: $on-surface;
      font-weight: 500;
    }
  }
}

.no-allocation {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 48px;
  text-align: center;

  .material-icons {
    font-size: 56px;
    color: $outline-variant;
    margin-bottom: 16px;
  }

  h3 {
    font-size: 24px;
    color: $on-surface;
    margin-bottom: 8px;
  }

  p {
    font-size: 14px;
    color: $on-surface-variant;
    margin-bottom: 24px;
    line-height: 1.5;
  }

  .btn-primary {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 24px;
    background: $primary;
    color: #ffffff;
    border-radius: 8px;
    text-decoration: none;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    transition: background 0.2s;

    .material-icons {
      font-size: 18px;
    }

    &:hover {
      background: $on-primary-fixed-variant;
    }
  }
}
</style>