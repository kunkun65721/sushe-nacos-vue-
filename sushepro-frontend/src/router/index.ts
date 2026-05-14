import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const routes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/login/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    component: () => import('@/components/layout/MainLayout.vue'),
    redirect: '/student/index',
    children: [
      {
        path: 'student/index',
        name: 'StudentIndex',
        component: () => import('@/views/student/Index.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'student/profile',
        name: 'StudentProfile',
        component: () => import('@/views/student/Profile.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'student/questionnaire',
        name: 'StudentQuestionnaire',
        component: () => import('@/views/student/Questionnaire.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'student/transfer',
        name: 'StudentTransfer',
        component: () => import('@/views/student/Transfer.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'student/repair',
        name: 'StudentRepair',
        component: () => import('@/views/student/Repair.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'student/ai-chat',
        name: 'StudentAIChat',
        component: () => import('@/views/student/AIChat.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'admin/index',
        name: 'AdminIndex',
        component: () => import('@/views/admin/Index.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/students',
        name: 'AdminStudents',
        component: () => import('@/views/admin/Students.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/dormitories',
        name: 'AdminDormitories',
        component: () => import('@/views/admin/Dormitories.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/questionnaires',
        name: 'AdminQuestionnaires',
        component: () => import('@/views/admin/Questionnaires.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/allocations',
        name: 'AdminAllocations',
        component: () => import('@/views/admin/Allocations.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/transfers',
        name: 'AdminTransfers',
        component: () => import('@/views/admin/Transfers.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/repairs',
        name: 'AdminRepairs',
        component: () => import('@/views/admin/Repairs.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/ai-recommend',
        name: 'AdminAIRecommend',
        component: () => import('@/views/admin/AIRecommend.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/notifications',
        name: 'AdminNotifications',
        component: () => import('@/views/admin/Notifications.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/help',
        name: 'AdminHelp',
        component: () => import('@/views/admin/Help.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/settings',
        name: 'AdminSettings',
        component: () => import('@/views/admin/Settings.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/profile-page',
        name: 'AdminProfilePage',
        component: () => import('@/views/admin/Profile.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'admin/profile',
        name: 'AdminProfile',
        component: () => import('@/views/admin/Profile.vue'),
        meta: { requiresAuth: true, role: 'admin' }
      },
      {
        path: 'student/notifications',
        name: 'StudentNotifications',
        component: () => import('@/views/student/Notifications.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'student/help',
        name: 'StudentHelp',
        component: () => import('@/views/student/Help.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'student/settings',
        name: 'StudentSettings',
        component: () => import('@/views/student/Settings.vue'),
        meta: { requiresAuth: true, role: 'student' }
      },
      {
        path: 'student/allocation',
        name: 'StudentAllocation',
        component: () => import('@/views/student/Allocation.vue'),
        meta: { requiresAuth: true, role: 'student' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()

  if (to.meta.requiresAuth && !authStore.isLoggedIn) {
    next('/login')
  } else if (to.path === '/login' && authStore.isLoggedIn) {
    next(authStore.isAdmin ? '/admin/index' : '/student/index')
  } else if (to.meta.role && authStore.user) {
    const userRole = authStore.isAdmin ? 'admin' : 'student'
    if (userRole !== to.meta.role) {
      next(userRole === 'admin' ? '/admin/index' : '/student/index')
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router