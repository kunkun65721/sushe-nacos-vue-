<template>
  <div class="student-index">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title">首页</h2>
        <p class="page-subtitle">个人首页面板</p>
      </div>
    </div>

    <!-- Bento Grid -->
    <div class="bento-grid">
      <!-- KPI Cards -->
      <div class="kpi-cards">
        <div class="kpi-card">
          <div class="kpi-icon bg-primary-fixed">
            <span class="material-icons">person</span>
          </div>
          <div class="kpi-content">
            <p class="kpi-label">姓名</p>
            <p class="kpi-value">{{ data.student?.name || '-' }}</p>
          </div>
        </div>

        <div class="kpi-card">
          <div class="kpi-icon bg-secondary-fixed">
            <span class="material-icons">king_bed</span>
          </div>
          <div class="kpi-content">
            <p class="kpi-label">宿舍</p>
            <p class="kpi-value">{{ data.allocation?.building || '' }}{{ data.allocation?.dormitoryNumber || '' }}</p>
          </div>
        </div>

        <div class="kpi-card">
          <div class="kpi-icon bg-tertiary-fixed">
            <span class="material-icons">quiz</span>
          </div>
          <div class="kpi-content">
            <p class="kpi-label">问卷状态</p>
            <p class="kpi-value">{{ data.hasQuestionnaire ? '已填写' : '未填写' }}</p>
          </div>
        </div>

        <div class="kpi-card">
          <div class="kpi-icon bg-error-container">
            <span class="material-icons" style="color: #ba1a1a">build</span>
          </div>
          <div class="kpi-content">
            <p class="kpi-label">待处理报修</p>
            <p class="kpi-value">{{ data.pendingRepairs || 0 }}</p>
          </div>
        </div>
      </div>

      <!-- Recent Activities -->
      <div class="activities-card">
        <div class="section-header">
          <h3 class="section-title">最近活动</h3>
        </div>
        <div class="activities-list">
          <div v-for="(activity, index) in data.recentActivities" :key="index" class="activity-item">
            <div class="activity-icon" :class="activity.iconBg">
              <span class="material-icons">{{ activity.icon }}</span>
            </div>
            <div class="activity-content">
              <p class="activity-desc">{{ activity.description }}</p>
              <p class="activity-time">{{ formatTime(activity.time) }}</p>
            </div>
          </div>
          <div v-if="!data.recentActivities?.length" class="no-activity">
            <p>暂无活动记录</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getStudentIndex } from '@/api/student'

const loading = ref(false)
const data = ref<any>({})

const fetchData = async () => {
  loading.value = true
  try {
    data.value = await getStudentIndex()
  } catch {
    // error handled
  } finally {
    loading.value = false
  }
}

const formatTime = (time: string) => {
  if (!time) return ''
  return new Date(time).toLocaleString('zh-CN')
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
$secondary: #00677d;
$secondary-fixed: #b3ebff;
$tertiary: #545c6f;
$tertiary-fixed: #dbe2f9;
$error: #ba1a1a;
$error-container: #ffdad6;
$success: #22c55e;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline: #717786;
$outline-variant: #c1c6d7;

.student-index {
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

.bento-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 24px;
}

.kpi-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
}

.kpi-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 16px;
  display: flex;
  flex-direction: column;
  transition: border-color 0.2s;

  &:hover {
    border-color: $primary;
  }

  .kpi-icon {
    width: 40px;
    height: 40px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16px;

    .material-icons {
      font-size: 20px;
      color: $on-surface;
    }
  }

  .kpi-label {
    font-size: 12px;
    color: $on-surface-variant;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    margin-bottom: 8px;
  }

  .kpi-value {
    font-size: 20px;
    font-weight: 600;
    color: $on-surface;
  }
}

.activities-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 16px;

  .section-header {
    margin-bottom: 16px;

    .section-title {
      font-size: 18px;
      color: $on-surface;
      padding-bottom: 8px;
      border-bottom: 1px solid $outline-variant;
    }
  }

  .activities-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .activity-item {
    display: flex;
    gap: 12px;
    align-items: flex-start;

    .activity-icon {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;

      .material-icons {
        font-size: 16px;
        color: $on-surface-variant;
      }

      &.bg-primary-fixed { background: $primary-fixed; }
      &.bg-secondary-fixed { background: $secondary-fixed; }
      &.bg-tertiary-fixed { background: $tertiary-fixed; }
      &.bg-surface-container { background: $surface-high; }
      &.bg-error-container { background: $error-container; }
    }

    .activity-content {
      .activity-desc {
        font-size: 16px;
        color: $on-surface;
      }

      .activity-time {
        font-size: 10px;
        color: $outline;
        text-transform: uppercase;
        margin-top: 4px;
      }
    }
  }

  .no-activity {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 32px 0;
    color: $on-surface-variant;
  }
}
</style>