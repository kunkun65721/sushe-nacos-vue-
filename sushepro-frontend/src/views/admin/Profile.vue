<template>
  <div class="profile">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title flex items-center gap-sm">
          <span class="material-icons">person</span> 个人资料
        </h2>
        <p class="page-subtitle">查看您的账户信息。</p>
      </div>
    </div>

    <!-- Profile Card -->
    <div class="profile-card">
      <div class="profile-header">
        <div class="avatar">
          <span class="material-icons">shield_person</span>
        </div>
        <h3 class="username">{{ authStore.user?.username }}</h3>
        <p class="role">系统管理员</p>
      </div>

      <div class="profile-info">
        <div class="info-row">
          <span class="material-icons">person</span>
          <span class="info-label">用户名</span>
          <span class="info-value">{{ authStore.user?.username }}</span>
        </div>
        <div class="info-row">
          <span class="material-icons">admin_panel_settings</span>
          <span class="info-label">角色</span>
          <span class="info-value">管理员</span>
        </div>
        <div class="info-row">
          <span class="material-icons">calendar_today</span>
          <span class="info-label">创建时间</span>
          <span class="info-value">{{ authStore.user?.createTime || '未知' }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
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

.profile {
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

.profile-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  overflow: hidden;
}

.profile-header {
  background: $primary;
  color: #ffffff;
  padding: 32px;
  text-align: center;

  .avatar {
    width: 100px;
    height: 100px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 16px;

    .material-icons {
      font-size: 56px;
    }
  }

  .username {
    font-size: 32px;
    font-weight: 400;
    font-family: 'Instrument Serif', serif;
    margin-bottom: 8px;
  }

  .role {
    font-size: 16px;
    opacity: 0.8;
  }
}

.profile-info {
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
      width: 100px;
    }

    .info-value {
      font-size: 14px;
      color: $on-surface;
    }
  }
}
</style>