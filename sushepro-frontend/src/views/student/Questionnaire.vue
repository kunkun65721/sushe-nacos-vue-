<template>
  <div class="questionnaire">
    <h2>生活习惯问卷</h2>
    <el-card v-loading="loading">
      <el-form :model="form" label-width="120px" v-if="!submitted">
        <el-form-item label="睡眠时间">
          <el-time-picker v-model="form.sleepTime" placeholder="选择睡眠时间" format="HH:mm" value-format="HH:mm" />
        </el-form-item>
        <el-form-item label="起床时间">
          <el-time-picker v-model="form.wakeUpTime" placeholder="选择起床时间" format="HH:mm" value-format="HH:mm" />
        </el-form-item>
        <el-form-item label="吸烟习惯">
          <el-radio-group v-model="form.smoking">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="0">否</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="饮酒习惯">
          <el-radio-group v-model="form.drinking">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="0">否</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="噪音容忍度">
          <el-select v-model="form.noiseTolerance" placeholder="请选择">
            <el-option label="非常敏感" value="非常敏感" />
            <el-option label="比较敏感" value="比较敏感" />
            <el-option label="一般" value="一般" />
            <el-option label="比较能接受" value="比较能接受" />
            <el-option label="完全能接受" value="完全能接受" />
          </el-select>
        </el-form-item>
        <el-form-item label="清洁要求">
          <el-select v-model="form.cleanliness" placeholder="请选择">
            <el-option label="非常严格" value="非常严格" />
            <el-option label="比较严格" value="比较严格" />
            <el-option label="一般" value="一般" />
            <el-option label="比较随意" value="比较随意" />
            <el-option label="非常随意" value="非常随意" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.note" type="textarea" :rows="3" placeholder="其他生活习惯或特殊要求" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm">提交问卷</el-button>
        </el-form-item>
      </el-form>

      <div v-else>
        <el-result icon="success" title="问卷已提交">
          <template #sub-title>
            <p>您已成功提交生活习惯问卷</p>
          </template>
        </el-result>
        <el-descriptions :column="2" border class="mt-20">
          <el-descriptions-item label="睡眠时间">{{ form.sleepTime }}</el-descriptions-item>
          <el-descriptions-item label="起床时间">{{ form.wakeUpTime }}</el-descriptions-item>
          <el-descriptions-item label="吸烟">{{ form.smoking === 1 ? '是' : '否' }}</el-descriptions-item>
          <el-descriptions-item label="饮酒">{{ form.drinking === 1 ? '是' : '否' }}</el-descriptions-item>
          <el-descriptions-item label="噪音容忍度">{{ form.noiseTolerance }}</el-descriptions-item>
          <el-descriptions-item label="清洁要求">{{ form.cleanliness }}</el-descriptions-item>
          <el-descriptions-item label="备注" :span="2">{{ form.note || '无' }}</el-descriptions-item>
        </el-descriptions>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getStudentQuestionnaire, submitQuestionnaire } from '@/api/student'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const submitted = ref(false)
const form = ref({
  sleepTime: '',
  wakeUpTime: '',
  smoking: 0,
  drinking: 0,
  noiseTolerance: '',
  cleanliness: '',
  note: ''
})

const fetchData = async () => {
  loading.value = true
  try {
    const data = await getStudentQuestionnaire()
    if (data) {
      form.value = { ...data }
      submitted.value = true
    }
  } catch {
    // no questionnaire yet
  } finally {
    loading.value = false
  }
}

const submitForm = async () => {
  loading.value = true
  try {
    await submitQuestionnaire(form.value)
    submitted.value = true
    ElMessage.success('提交成功')
  } catch {
    // error handled
  } finally {
    loading.value = false
  }
}

onMounted(fetchData)
</script>

<style scoped lang="scss">
$on-surface: #191c1d;
$primary: #0058bc;

.questionnaire {
  h2 {
    margin-bottom: 20px;
    color: $on-surface;
    font-family: 'Instrument Serif', serif;
  }
  .mt-20 { margin-top: 20px; }
}
</style>