<template>
  <div class="settings">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h2 class="page-title flex items-center gap-sm">
          <span class="material-icons">settings</span> 系统设置
        </h2>
        <p class="page-subtitle">管理您的系统设置和偏好。</p>
      </div>
    </div>

    <!-- Settings Sections -->
    <div class="settings-content">
      <div class="settings-section">
        <h3 class="section-title">
          <span class="material-icons">palette</span> 界面设置
        </h3>
        <div class="setting-item">
          <div class="setting-info">
            <p class="setting-label">深色模式</p>
            <p class="setting-desc">启用深色主题</p>
          </div>
          <el-switch />
        </div>
      </div>

      <div class="settings-section">
        <h3 class="section-title">
          <span class="material-icons">info</span> 关于
        </h3>
        <div class="about-info">
          <p>宿舍管理系统 v1.0</p>
          <p>构建更美好的宿舍生活体验</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped lang="scss">
$bg: #f8f9fa;
$surface: #f3f4f5;
$surface-high: #e7e8e9;
$surface-low: #edeeef;
$surface-lowest: #ffffff;
$primary: #0058bc;
$primary-fixed: #d8e2ff;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline: #717786;
$outline-variant: #c1c6d7;

.settings {
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

.settings-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.settings-section {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 24px;

  .section-title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 18px;
    font-weight: 600;
    color: $on-surface;
    margin-bottom: 16px;

    .material-icons {
      color: $primary;
      font-size: 24px;
    }
  }
}

.setting-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 0;
  border-bottom: 1px solid $outline-variant;

  &:last-child {
    border-bottom: none;
  }

  .setting-info {
    .setting-label {
      font-size: 14px;
      font-weight: 500;
      color: $on-surface;
    }

    .setting-desc {
      font-size: 12px;
      color: $on-surface-variant;
      margin-top: 4px;
    }
  }
}

.about-info {
  font-size: 14px;
  color: $on-surface-variant;

  p:first-child {
    font-weight: 500;
    color: $on-surface;
    margin-bottom: 4px;
  }
}
</style>