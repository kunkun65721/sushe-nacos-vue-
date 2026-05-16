<template>
  <div class="main-layout">
    <!-- Sidebar -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <h1>宿舍管理系统</h1>
        <p>{{ isAdmin ? '管理员平台' : '学生平台' }}</p>
      </div>

      <nav class="sidebar-nav">
        <template v-for="item in menuItems" :key="item.path">
          <router-link
            :to="item.path"
            class="nav-item"
            :class="{ active: isActive(item.path) }"
          >
            <span class="material-icons" :style="{ fontVariationSettings: isActive(item.path) ? '\'FILL\' 1' : '\'FILL\' 0' }">
              {{ item.icon }}
            </span>
            <span>{{ item.title }}</span>
          </router-link>
        </template>
      </nav>

      <div class="sidebar-footer">
        <a class="nav-item" @click="handleLogout">
          <span class="material-icons">logout</span>
          <span>退出登录</span>
        </a>
      </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
      <!-- Topbar -->
      <header class="topbar">
        <div class="topbar-left">
          <h2>{{ pageTitle }}</h2>
        </div>
        <div class="topbar-right">
          <el-badge :value="notificationCount" :hidden="notificationCount === 0" :max="99">
            <router-link v-if="isAdmin" to="/admin/notifications" class="topbar-icon" title="通知">
              <span class="material-icons">notifications</span>
            </router-link>
            <router-link v-else to="/student/notifications" class="topbar-icon" title="通知">
              <span class="material-icons">notifications</span>
            </router-link>
          </el-badge>

          <router-link v-if="isAdmin" to="/admin/help" class="topbar-icon" title="帮助">
            <span class="material-icons">help</span>
          </router-link>
          <router-link v-else to="/student/help" class="topbar-icon" title="帮助">
            <span class="material-icons">help</span>
          </router-link>

          <router-link v-if="isAdmin" to="/admin/settings" class="topbar-icon" title="设置">
            <span class="material-icons">settings</span>
          </router-link>
          <router-link v-else to="/student/settings" class="topbar-icon" title="设置">
            <span class="material-icons">settings</span>
          </router-link>

          <router-link v-if="isAdmin" to="/admin/profile" class="user-avatar" title="个人资料">
            <span class="material-icons">person</span>
          </router-link>
          <router-link v-else to="/student/profile" class="user-avatar" title="个人资料">
            <span class="material-icons">person</span>
          </router-link>
        </div>
      </header>

      <!-- Page Content -->
      <div class="page-content">
        <router-view />
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { getAdminNotificationCount } from '@/api/admin'
import { getStudentNotifications } from '@/api/student'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const isAdmin = computed(() => authStore.isAdmin)
const notificationCount = ref(0)

const fetchNotificationCount = async () => {
  if (isAdmin.value) {
    try {
      const count = await getAdminNotificationCount()
      notificationCount.value = count || 0
    } catch {
      notificationCount.value = 0
    }
  } else {
    try {
      const data = await getStudentNotifications()
      const repairCount = data.repairs?.length || 0
      const transferCount = data.transfers?.length || 0
      notificationCount.value = repairCount + transferCount
    } catch {
      notificationCount.value = 0
    }
  }
}

const pageTitle = computed(() => {
  const path = route.path
  if (path.includes('index')) return '概览'
  if (path.includes('students')) return '学生管理'
  if (path.includes('dormitories')) return '宿舍管理'
  if (path.includes('questionnaires')) return '生活方式'
  if (path.includes('allocations')) return '分配管理'
  if (path.includes('transfers')) return '调换管理'
  if (path.includes('repairs')) return '报修管理'
  if (path.includes('knowledge')) return '知识库'
  if (path.includes('ai')) return 'AI匹配'
  if (path.includes('profile')) return '个人资料'
  if (path.includes('questionnaire')) return '生活方式问卷'
  if (path.includes('transfer')) return '调换申请'
  if (path.includes('repair')) return '报修申请'
  if (path.includes('chat')) return 'AI客服'
  return ''
})

const adminMenuItems = [
  { path: '/admin/index', title: '首页', icon: 'dashboard' },
  { path: '/admin/students', title: '学生管理', icon: 'group' },
  { path: '/admin/dormitories', title: '宿舍管理', icon: 'domain' },
  { path: '/admin/questionnaires', title: '生活方式', icon: 'quiz' },
  { path: '/admin/allocations', title: '分配管理', icon: 'assignment_turned_in' },
  { path: '/admin/transfers', title: '调换管理', icon: 'swap_horiz' },
  { path: '/admin/repairs', title: '报修管理', icon: 'construction' },
  { path: '/admin/knowledge-base', title: '知识库', icon: 'library_books' },
  { path: '/admin/ai-recommend', title: 'AI匹配', icon: 'psychology' }
]

const studentMenuItems = [
  { path: '/student/index', title: '首页', icon: 'dashboard' },
  { path: '/student/profile', title: '个人资料', icon: 'person' },
  { path: '/student/questionnaire', title: '生活方式问卷', icon: 'quiz' },
  { path: '/student/allocation', title: '宿舍分配', icon: 'king_bed' },
  { path: '/student/transfer', title: '调换申请', icon: 'swap_horiz' },
  { path: '/student/repair', title: '报修申请', icon: 'build' },
  { path: '/student/ai-chat', title: 'AI客服', icon: 'support_agent' }
]

const menuItems = computed(() => isAdmin.value ? adminMenuItems : studentMenuItems)

const isActive = (path: string) => {
  return route.path === path || route.path.startsWith(path + '/')
}

const handleLogout = async () => {
  await authStore.logout()
  router.push('/login')
}

onMounted(() => {
  fetchNotificationCount()
})
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

.main-layout {
  display: flex;
  min-height: 100vh;
  background: $bg;
  color: $on-surface;
  font-family: 'Barlow', sans-serif;
}

.sidebar {
  width: 260px;
  background: $surface;
  border-right: 1px solid $outline-variant;
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  height: 100vh;
  padding: 16px;
  z-index: 40;

  .sidebar-header {
    margin-bottom: 32px;
    h1 {
      font-size: 18px;
      font-weight: 600;
      color: $on-surface;
    }
    p {
      font-size: 12px;
      color: $on-surface-variant;
      margin-top: 4px;
    }
  }

  .sidebar-nav {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .sidebar-footer {
    margin-top: auto;
  }
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px;
  border-radius: 8px;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: $on-surface-variant;
  text-decoration: none;
  transition: all 0.2s;
  cursor: pointer;

  .material-icons {
    font-size: 20px;
  }

  &:hover {
    background: $surface-high;
    transform: translateX(4px);
  }

  &.active {
    background: $primary-fixed;
    color: $primary;

    .material-icons {
      color: $primary;
    }
  }
}

.main-content {
  flex: 1;
  margin-left: 260px;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.topbar {
  height: 64px;
  background: $surface-lowest;
  border-bottom: 1px solid $outline-variant;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  position: sticky;
  top: 0;
  z-index: 30;

  .topbar-left h2 {
    font-size: 18px;
    font-weight: 400;
    color: $on-surface;
  }

  .topbar-right {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .topbar-icon {
    width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    border: none;
    background: transparent;
    color: $on-surface-variant;
    cursor: pointer;
    transition: all 0.2s;

    .material-icons {
      font-size: 22px;
    }

    &:hover {
      background: $surface-high;
      color: $on-surface;
    }
  }

  .user-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: 1px solid $outline-variant;
    background: $primary-fixed;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    margin-left: 8px;
    transition: opacity 0.2s;

    .material-icons {
      font-size: 18px;
      color: $primary;
    }

    &:hover {
      opacity: 0.8;
    }
  }
}

.page-content {
  padding: 24px;
  max-width: 1600px;
  width: 100%;
  margin: 0 auto;
}
</style>