<template>
  <div class="allocations">
    <h2>宿舍分配</h2>
    <el-card v-loading="loading">
      <el-table :data="allocations" stripe>
        <el-table-column prop="studentName" label="学生姓名" width="120" />
        <el-table-column prop="building" label="楼栋" width="100" />
        <el-table-column prop="dormitoryNumber" label="房间号" width="100" />
        <el-table-column prop="allocateTime" label="分配时间" width="180" />
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getAllocations } from '@/api/admin'

const loading = ref(false)
const allocations = ref<any[]>([])

const fetchData = async () => {
  loading.value = true
  try {
    allocations.value = await getAllocations()
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

.allocations {
  h2 {
    margin-bottom: 20px;
    color: $on-surface;
    font-family: 'Instrument Serif', serif;
  }
}
</style>