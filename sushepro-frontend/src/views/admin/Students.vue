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
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" text @click="viewDetail(row.id)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 学生详情模态框 -->
    <el-dialog v-model="dialogVisible" title="学生详情" width="700px">
      <el-tabs v-if="studentDetail">
        <!-- 基本信息 -->
        <el-tab-pane label="基本信息" name="basic">
          <el-descriptions :column="2" border>
            <el-descriptions-item label="学号">{{ studentDetail.student?.studentId }}</el-descriptions-item>
            <el-descriptions-item label="姓名">{{ studentDetail.student?.name }}</el-descriptions-item>
            <el-descriptions-item label="性别">{{ studentDetail.student?.gender === 0 ? '男' : '女' }}</el-descriptions-item>
            <el-descriptions-item label="专业">{{ studentDetail.student?.major }}</el-descriptions-item>
            <el-descriptions-item label="年级">{{ studentDetail.student?.grade }}</el-descriptions-item>
            <el-descriptions-item label="电话">{{ studentDetail.student?.phone }}</el-descriptions-item>
          </el-descriptions>
        </el-tab-pane>

        <!-- 问卷调查 -->
        <el-tab-pane label="问卷调查" name="questionnaire">
          <div v-if="studentDetail.questionnaire">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="睡觉时间">{{ studentDetail.questionnaire.sleepTime || '未填写' }}</el-descriptions-item>
              <el-descriptions-item label="起床时间">{{ studentDetail.questionnaire.wakeUpTime || '未填写' }}</el-descriptions-item>
              <el-descriptions-item label="是否抽烟">{{ studentDetail.questionnaire.smoking === 1 ? '是' : '否' }}</el-descriptions-item>
              <el-descriptions-item label="是否喝酒">{{ studentDetail.questionnaire.drinking === 1 ? '是' : '否' }}</el-descriptions-item>
              <el-descriptions-item label="噪音容忍度">{{ studentDetail.questionnaire.noiseTolerance || '未填写' }}</el-descriptions-item>
              <el-descriptions-item label="清洁要求">{{ studentDetail.questionnaire.cleanliness || '未填写' }}</el-descriptions-item>
            </el-descriptions>
            <el-form-item label="备注" style="margin-top: 16px;">
              <span>{{ studentDetail.questionnaire.note || '无' }}</span>
            </el-form-item>
          </div>
          <el-empty v-else description="该学生尚未填写问卷" />
        </el-tab-pane>

        <!-- 宿舍分配 -->
        <el-tab-pane label="宿舍分配" name="allocation">
          <div v-if="studentDetail.allocation">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="宿舍楼">{{ studentDetail.allocation.building }}</el-descriptions-item>
              <el-descriptions-item label="房间号">{{ studentDetail.allocation.dormitoryNumber }}</el-descriptions-item>
              <el-descriptions-item label="入住时间">{{ studentDetail.allocation.allocateTime }}</el-descriptions-item>
            </el-descriptions>
          </div>
          <el-empty v-else description="该学生尚未分配宿舍" />
        </el-tab-pane>
      </el-tabs>
      <template #footer>
        <el-button @click="dialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getStudents, getStudentDetail } from '@/api/admin'

const loading = ref(false)
const students = ref<any[]>([])
const dialogVisible = ref(false)
const studentDetail = ref<any>(null)

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

const viewDetail = async (id: number) => {
  try {
    studentDetail.value = await getStudentDetail(id)
    dialogVisible.value = true
  } catch {
    // error handled
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