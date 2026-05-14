<template>
  <div class="questionnaires">
    <h2>问卷管理</h2>
    <el-card v-loading="loading">
      <el-table :data="students" stripe>
        <el-table-column prop="studentId" label="学号" width="150" />
        <el-table-column prop="name" label="姓名" width="100" />
        <el-table-column prop="major" label="专业" />
        <el-table-column label="问卷状态" width="120">
          <template #default="{ row }">
            <el-tag :type="questionnaires[row.id] ? 'success' : 'info'">
              {{ questionnaires[row.id] ? '已填写' : '未填写' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template #default="{ row }">
            <el-button v-if="questionnaires[row.id]" size="small" @click="viewDetail(row.id)">查看</el-button>
            <span v-else>-</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="showDetail" title="问卷详情" width="600px">
      <el-descriptions :column="2" border v-if="detail">
        <el-descriptions-item label="睡眠时间">{{ detail.sleepTime }}</el-descriptions-item>
        <el-descriptions-item label="起床时间">{{ detail.wakeUpTime }}</el-descriptions-item>
        <el-descriptions-item label="吸烟">{{ detail.smoking === 1 ? '是' : '否' }}</el-descriptions-item>
        <el-descriptions-item label="饮酒">{{ detail.drinking === 1 ? '是' : '否' }}</el-descriptions-item>
        <el-descriptions-item label="噪音容忍度" :span="2">{{ detail.noiseTolerance }}</el-descriptions-item>
        <el-descriptions-item label="清洁要求" :span="2">{{ detail.cleanliness }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detail.note || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getQuestionnaires, getQuestionnaireDetail } from '@/api/admin'

const loading = ref(false)
const students = ref<any[]>([])
const questionnaires = ref<Record<number, any>>({})
const showDetail = ref(false)
const detail = ref<any>(null)

const fetchData = async () => {
  loading.value = true
  try {
    const data: any = await getQuestionnaires()
    students.value = data.students || []
    questionnaires.value = data.questionnaires || {}
  } catch {
    // error handled
  } finally {
    loading.value = false
  }
}

const viewDetail = async (studentId: number) => {
  try {
    const data: any = await getQuestionnaireDetail(studentId)
    detail.value = data.questionnaire
    showDetail.value = true
  } catch {
    // error handled
  }
}

onMounted(fetchData)
</script>

<style scoped lang="scss">
$on-surface: #191c1d;
$on-surface-variant: #414755;

.questionnaires {
  h2 {
    margin-bottom: 20px;
    color: $on-surface;
    font-family: 'Instrument Serif', serif;
  }
}
</style>