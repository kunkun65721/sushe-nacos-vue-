<template>
  <div class="profile">
    <div class="page-header">
      <h2 class="page-title">个人资料</h2>
      <p class="page-subtitle">查看个人基本信息</p>
    </div>

    <div class="info-card">
      <div class="info-grid" v-if="student">
        <div class="info-item">
          <label>学号</label>
          <p>{{ student.studentId }}</p>
        </div>
        <div class="info-item">
          <label>姓名</label>
          <p>{{ student.name }}</p>
        </div>
        <div class="info-item">
          <label>性别</label>
          <p>{{ student.gender === 0 ? '男' : '女' }}</p>
        </div>
        <div class="info-item">
          <label>专业</label>
          <p>{{ student.major }}</p>
        </div>
        <div class="info-item">
          <label>年级</label>
          <p>{{ student.grade }}</p>
        </div>
        <div class="info-item">
          <label>电话</label>
          <p>{{ student.phone }}</p>
        </div>
        <div class="info-item">
          <label>紧急联系人</label>
          <p>{{ student.emergencyContact }}</p>
        </div>
        <div class="info-item">
          <label>紧急联系电话</label>
          <p>{{ student.emergencyPhone }}</p>
        </div>
      </div>
      <div v-else class="no-data">
        <p>暂无数据</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getStudentProfile } from '@/api/student'

const loading = ref(false)
const student = ref<any>(null)

const fetchData = async () => {
  loading.value = true
  try {
    student.value = await getStudentProfile()
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
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline: #717786;
$outline-variant: #c1c6d7;

.profile {
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

.info-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 24px;

  .info-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24px;
  }

  .info-item {
    label {
      display: block;
      font-size: 12px;
      color: $on-surface-variant;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 8px;
    }

    p {
      font-size: 16px;
      color: $on-surface;
    }
  }

  .no-data {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 48px;
    color: $on-surface-variant;
  }
}
</style>