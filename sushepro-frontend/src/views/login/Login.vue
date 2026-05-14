<template>
  <div class="login-page">
    <div class="video-bg">
      <video autoplay muted playsinline loop>
        <source src="https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260418_080021_d598092b-c4c2-4e53-8e46-94cf9064cd50.mp4" type="video/mp4"/>
      </video>
      <div class="gradient-overlay"></div>
    </div>

    <div class="login-card">
      <div class="card-content">
        <h1 class="title">宿舍管理系统</h1>
        <p class="subtitle">管理员与学生入口</p>

        <el-form :model="loginForm" @submit.prevent="handleLogin">
          <div class="form-group">
            <label class="label">
              <span class="material-icons">person</span> 用户名
            </label>
            <el-input
              v-model="loginForm.username"
              placeholder="请输入用户名"
              size="large"
              :prefix-icon="User"
            />
          </div>

          <div class="form-group">
            <label class="label">
              <span class="material-icons">lock</span> 密码
            </label>
            <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="请输入密码"
              size="large"
              :prefix-icon="Lock"
              show-password
            />
          </div>

          <el-button
            type="primary"
            size="large"
            native-type="submit"
            :loading="loading"
            class="submit-btn"
          >
            <span class="material-icons">{{ loading ? 'progress_activity' : 'login' }}</span>
            {{ loading ? '登录中...' : '登录' }}
          </el-button>
        </el-form>

        <div class="tags">
          <span class="tag">
            <span class="material-icons">check_circle</span> 智能分配
          </span>
          <span class="tag">
            <span class="material-icons">check_circle</span> 生活习惯匹配
          </span>
          <span class="tag">
            <span class="material-icons">check_circle</span> AI智能推荐
          </span>
          <span class="tag">
            <span class="material-icons">check_circle</span> 实时数据分析
          </span>
        </div>
      </div>

      <p class="footer">DMS v1.0 &copy; 2025</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'

const router = useRouter()
const authStore = useAuthStore()

const loginForm = ref({
  username: '',
  password: ''
})
const loading = ref(false)

const handleLogin = async () => {
  if (!loginForm.value.username || !loginForm.value.password) {
    ElMessage.warning('请输入用户名和密码')
    return
  }

  loading.value = true
  try {
    const result = await authStore.login(loginForm.value)
    ElMessage.success('登录成功')
    if (result.role === 'admin') {
      router.push('/admin/index')
    } else {
      router.push('/student/index')
    }
  } catch {
    // error shown by interceptor
  } finally {
    loading.value = false
  }
}
</script>

<style scoped lang="scss">
.login-page {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  background: #141313;
  overflow: hidden;
}

.video-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  video {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 100vw;
    height: 100vh;
    object-fit: cover;
    opacity: 0.6;
    animation: videoSpeed 10s linear infinite;
  }

  @keyframes videoSpeed {
    0% { transform: translate(-50%, -50%) scale(1); }
    50% { transform: translate(-50%, -50%) scale(1.1); }
    100% { transform: translate(-50%, -50%) scale(1); }
  }
  .gradient-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to bottom, rgba(20,19,19,0.4) 0%, transparent 50%, rgba(20,19,19,1) 100%);
  }
}

.login-card {
  position: relative;
  z-index: 10;
  width: 100%;
  max-width: 440px;
  display: flex;
  flex-direction: column;
  align-items: center;

  .card-content {
    background: #fff;
    border-radius: 2.5rem;
    padding: 40px;
    width: 100%;
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);

    .title {
      font-size: 32px;
      font-weight: 400;
      font-style: italic;
      color: #1a1a1a;
      text-align: center;
      margin-bottom: 8px;
      letter-spacing: -0.02em;
    }

    .subtitle {
      font-size: 16px;
      color: #9ca3af;
      text-align: center;
      margin-bottom: 32px;
    }

    .form-group {
      margin-bottom: 16px;

      .label {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 12px;
        color: #9ca3af;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        margin-bottom: 8px;

        .material-icons {
          font-size: 14px;
        }
      }
    }

    .submit-btn {
      width: 100%;
      border-radius: 9999px;
      background: #1a1a1a;
      border: none;
      color: #fff;
      font-size: 12px;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      height: 52px;
      margin-top: 8px;

      .material-icons {
        font-size: 18px;
        margin-right: 8px;
      }

      &:hover {
        background: #374151;
      }

      &:disabled {
        opacity: 0.6;
      }
    }

    .tags {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 10px;
      margin-top: 24px;

      .tag {
        display: flex;
        align-items: center;
        gap: 4px;
        background: #f3f4f6;
        color: #6b7280;
        padding: 8px 16px;
        border-radius: 9999px;
        font-size: 12px;

        .material-icons {
          font-size: 14px;
          color: #9ca3af;
        }
      }
    }
  }

  .footer {
    font-size: 12px;
    color: rgba(196, 199, 200, 0.5);
    text-transform: uppercase;
    letter-spacing: 0.1em;
    margin-top: 24px;
  }
}

:deep(.el-input__wrapper) {
  border-radius: 9999px;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  box-shadow: none;
  padding: 4px 20px;

  &:focus-within {
    background: #fff;
    border-color: #1a1a1a;
  }
}

:deep(.el-input__inner) {
  font-size: 16px;
}
</style>