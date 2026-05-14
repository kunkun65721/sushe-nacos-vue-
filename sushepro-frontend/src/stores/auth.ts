import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login as apiLogin, logout as apiLogout, getCurrentUser } from '@/api/auth'
import type { LoginRequest, LoginResponse, User } from '@/api/auth'

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(localStorage.getItem('token'))
  const user = ref<User | null>(null)

  const isLoggedIn = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.role === 1)
  const isStudent = computed(() => user.value?.role === 0)

  const login = async (data: LoginRequest) => {
    const response = await apiLogin(data)
    const loginData = response as unknown as LoginResponse
    token.value = loginData.token
    localStorage.setItem('token', loginData.token)
    user.value = {
      id: loginData.id,
      username: loginData.username,
      role: loginData.role === 'admin' ? 1 : 0
    }
    return loginData
  }

  const logout = async () => {
    try {
      await apiLogout()
    } catch {
      // ignore error
    }
    token.value = null
    user.value = null
    localStorage.removeItem('token')
  }

  const fetchUser = async () => {
    if (!token.value) return
    try {
      const userData = await getCurrentUser()
      user.value = userData
    } catch {
      token.value = null
      user.value = null
      localStorage.removeItem('token')
    }
  }

  return {
    token,
    user,
    isLoggedIn,
    isAdmin,
    isStudent,
    login,
    logout,
    fetchUser
  }
})