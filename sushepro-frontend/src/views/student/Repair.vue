<template>
  <div class="repair">
    <h2>报修申请</h2>
    <el-card v-loading="loading">
      <el-form :model="form" label-width="120px">
        <el-form-item label="报修描述">
          <el-input v-model="form.description" type="textarea" :rows="4" placeholder="请描述需要报修的问题" />
        </el-form-item>
        <el-form-item label="上传图片">
          <el-upload :auto-upload="false" :limit="1" :on-change="handleFileChange">
            <el-button>选择图片</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm">提交报修</el-button>
        </el-form-item>
      </el-form>

      <el-divider />

      <h3>我的报修记录</h3>
      <el-table :data="repairs" stripe class="mt-20">
        <el-table-column prop="createTime" label="申请时间" width="180" />
        <el-table-column prop="description" label="问题描述" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 2 ? 'success' : row.status === 1 ? 'warning' : row.status === 3 ? 'danger' : 'info'">
              {{ statusText[row.status] }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getStudentRepairs, submitRepair } from '@/api/student'
import { ElMessage, type UploadFile } from 'element-plus'

const loading = ref(false)
const form = ref({ description: '', image: undefined as File | undefined })
const repairs = ref<any[]>([])
const statusText: Record<number, string> = { 0: '待处理', 1: '处理中', 2: '已完成', 3: '已拒绝' }

const handleFileChange = (file: UploadFile) => {
  form.value.image = file.raw
}

const fetchData = async () => {
  loading.value = true
  try {
    repairs.value = await getStudentRepairs()
  } catch {
    // error handled
  } finally {
    loading.value = false
  }
}

const submitForm = async () => {
  if (!form.value.description) {
    ElMessage.warning('请输入报修描述')
    return
  }
  loading.value = true
  try {
    await submitRepair(form.value)
    ElMessage.success('提交成功')
    form.value = { description: '', image: undefined }
    await fetchData()
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

.repair {
  h2 {
    margin-bottom: 20px;
    color: $on-surface;
    font-family: 'Instrument Serif', serif;
  }
  h3 { margin: 20px 0; color: $on-surface; }
  .mt-20 { margin-top: 20px; }
}
</style>