<template>
  <div class="students">
    <div class="page-header">
      <h2 class="page-title">学生管理</h2>
      <p class="page-subtitle">查看和管理所有学生信息</p>
    </div>

    <div class="data-card">
      <el-table :data="students" stripe style="width: 100%" table-layout="fixed">
        <el-table-column prop="studentId" label="学号" width="150" />
        <el-table-column prop="name" label="姓名" width="100" />
        <el-table-column prop="gender" label="性别" width="80">
          <template #default="{ row }">{{ row.gender === 0 ? '男' : '女' }}</template>
        </el-table-column>
        <el-table-column prop="major" label="专业" />
        <el-table-column prop="grade" label="年级" width="100" />
        <el-table-column prop="phone" label="电话" width="150" />
      </el-table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getStudents } from '@/api/admin'

const loading = ref(false)
const students = ref<any[]>([])

const fetchData = async () => {
  loading.value = true
  try {
    students.value = await getStudents()
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

.students {
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

.data-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 16px;
}

:deep(.el-table) {
  background: transparent;
  color: $on-surface;

  .el-table__header-wrapper th {
    background: $surface-low;
    color: $on-surface-variant;
    border-bottom: 2px solid $outline-variant;
    font-weight: 600;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .el-table__body-wrapper tr {
    background: transparent;

    &:hover > td {
      background: $surface-low !important;
    }

    td {
      border-bottom: 1px solid $outline-variant;
    }
  }
}
</style>