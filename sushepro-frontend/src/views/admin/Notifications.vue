<template>
  <div class="notifications">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title flex items-center gap-sm">
          <span class="material-icons">notifications</span> 通知中心
        </h2>
        <p class="page-subtitle">查看系统通知和待处理事项。</p>
      </div>
    </div>

    <!-- Notifications List -->
    <div class="notifications-list">
      <template v-if="notifications.length > 0">
        <div v-for="(item, index) in notifications" :key="index" :class="['notification-card', item.type]">
          <div class="notification-icon">
            <span class="material-icons">{{ item.icon }}</span>
          </div>
          <div class="notification-content">
            <h3 class="notification-title">{{ item.title }}</h3>
            <p class="notification-desc">{{ item.description }}</p>
            <p v-if="item.time" class="notification-time">{{ item.time }}</p>
          </div>
          <span v-if="item.link" class="material-icons arrow">chevron_right</span>
        </div>
      </template>
      <div v-else class="empty-state">
        <span class="material-icons">notifications_off</span>
        <p>暂无新的通知</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getAdminNotifications } from '@/api/admin'

const loading = ref(false)
const notifications = ref<any[]>([])

const fetchData = async () => {
  loading.value = true
  try {
    notifications.value = await getAdminNotifications()
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
$error: #ba1a1a;
$error-container: #ffdad6;

.notifications {
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

.notifications-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.notification-card {
  display: flex;
  align-items: center;
  gap: 16px;
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 20px;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    transform: translateX(4px);
  }

  &.warning {
    .notification-icon {
      background: #fef3c7;
      color: #92400e;
    }
  }

  &.info {
    .notification-icon {
      background: $primary-fixed;
      color: $primary;
    }
  }

  &.success {
    .notification-icon {
      background: #dcfce7;
      color: #166534;
    }
  }

  .notification-icon {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;

    .material-icons {
      font-size: 24px;
    }
  }

  .notification-content {
    flex: 1;

    .notification-title {
      font-size: 18px;
      font-weight: 600;
      color: $on-surface;
      margin-bottom: 4px;
    }

    .notification-desc {
      font-size: 14px;
      color: $on-surface-variant;
    }

    .notification-time {
      font-size: 12px;
      color: $outline;
      text-transform: uppercase;
      margin-top: 4px;
    }
  }

  .arrow {
    color: $outline;
    font-size: 24px;
  }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 64px;
  color: $outline-variant;

  .material-icons {
    font-size: 64px;
    margin-bottom: 16px;
  }

  p {
    font-size: 18px;
    color: $on-surface-variant;
  }
}
</style>