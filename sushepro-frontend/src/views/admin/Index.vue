<template>
  <div class="admin-index">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title">概览</h2>
        <p class="page-subtitle">系统状态和关键指标总览。</p>
      </div>
    </div>

    <!-- Bento Grid -->
    <div class="bento-grid">
      <!-- KPI Cards -->
      <div class="kpi-cards">
        <div class="kpi-card">
          <div class="kpi-icon bg-primary-fixed">
            <span class="material-icons">groups</span>
          </div>
          <div class="kpi-content">
            <p class="kpi-label">学生总数</p>
            <p class="kpi-value">{{ data.totalStudents || 0 }}</p>
          </div>
        </div>

        <div class="kpi-card">
          <div class="kpi-icon bg-secondary-fixed">
            <span class="material-icons">meeting_room</span>
          </div>
          <div class="kpi-content">
            <p class="kpi-label">入住率</p>
            <p class="kpi-value">{{ data.occupancyRate || 0 }}%</p>
          </div>
        </div>

        <div class="kpi-card">
          <div class="kpi-icon bg-tertiary-fixed">
            <span class="material-icons">assignment</span>
          </div>
          <div class="kpi-content">
            <p class="kpi-label">待处理分配申请</p>
            <p class="kpi-value">{{ data.pendingAllocations || 0 }}</p>
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

      <!-- Quick Actions -->
      <div class="quick-actions">
        <h3 class="section-title">快捷操作</h3>
        <router-link to="/admin/allocations" class="action-item">
          <div class="action-left">
            <span class="material-icons">assignment_turned_in</span>
            <span>分配管理</span>
          </div>
          <span class="material-icons">chevron_right</span>
        </router-link>
        <router-link to="/admin/transfers" class="action-item">
          <div class="action-left">
            <span class="material-icons">swap_horiz</span>
            <span>调换管理</span>
          </div>
          <span class="material-icons">chevron_right</span>
        </router-link>
        <router-link to="/admin/repairs" class="action-item">
          <div class="action-left">
            <span class="material-icons">construction</span>
            <span>报修管理</span>
          </div>
          <span class="material-icons">chevron_right</span>
        </router-link>
      </div>

      <!-- Dormitory Map -->
      <div class="map-card">
        <div class="section-header">
          <h3 class="section-title">宿舍地图</h3>
        </div>
        <div class="map-container">
          <img :src="dormitoryMap" alt="宿舍地图" />
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
              <p class="activity-time">{{ activity.relativeTime }}</p>
            </div>
          </div>
          <div v-if="!data.recentActivities?.length" class="no-activity">
            <p>暂无最近活动</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getAdminIndex } from '@/api/admin'
import dormitoryMap from '@/assets/maps/dormitory-map.jpg'

const loading = ref(false)
const data = ref<any>({})

const fetchData = async () => {
  loading.value = true
  try {
    data.value = await getAdminIndex()
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

.admin-index {
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
  grid-template-columns: repeat(12, 1fr);
  gap: 24px;
}

.kpi-cards {
  grid-column: span 8;
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
    font-size: 32px;
    font-weight: 600;
    color: $on-surface;
    font-family: 'Roboto Mono', monospace;
  }
}

.quick-actions {
  grid-column: span 4;
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 16px;

  .section-title {
    font-size: 18px;
    color: $on-surface;
    padding-bottom: 8px;
    border-bottom: 1px solid $outline-variant;
    margin-bottom: 16px;
  }

  .action-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px;
    border: 1px solid $outline-variant;
    border-radius: 8px;
    text-decoration: none;
    transition: all 0.2s;
    margin-bottom: 8px;

    &:hover {
      border-color: $primary;
      background: $surface;

      .material-icons:first-child {
        color: $primary;
      }
    }

    .action-left {
      display: flex;
      align-items: center;
      gap: 12px;
      color: $on-surface;
      font-size: 16px;

      .material-icons {
        color: $outline;
        transition: color 0.2s;
      }
    }

    .material-icons:last-child {
      color: $outline-variant;
    }
  }
}

.map-card {
  grid-column: span 8;
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

  .map-container {
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    overflow: hidden;

    img {
      width: 100%;
      height: 400px;
      object-fit: contain;
    }
  }
}

.activities-card {
  grid-column: span 4;
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 16px;
  max-height: 400px;
  overflow-y: auto;

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