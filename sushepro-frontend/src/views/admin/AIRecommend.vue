<template>
  <div class="ai-recommend">
    <!-- Header -->
    <div class="page-header">
      <div class="header-content">
        <span class="material-symbols-outlined text-[56px] text-primary">psychology</span>
        <div>
          <h2 class="page-title">AI房间推荐</h2>
          <p class="page-subtitle">输入学号，基于生活习惯数据获取智能宿舍匹配。</p>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
      <!-- Input Form Card -->
      <div class="input-card">
        <el-form :model="form" label-position="top">
          <el-form-item label="选择学生">
            <el-select v-model="form.studentId" placeholder="请选择学生" filterable @change="onStudentChange" class="w-full">
              <el-option v-for="s in students" :key="s.id" :label="s.name + ' (' + s.studentId + ')'" :value="s.id" />
            </el-select>
          </el-form-item>
          <el-form-item label="附加要求">
            <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="管理员的特殊要求（可选）" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="getRecommendation" :loading="loading" class="btn-primary">
              <span class="material-symbols-outlined text-[18px]">search</span> 获取推荐
            </el-button>
          </el-form-item>
        </el-form>
        <p class="hint-text flex items-center gap-xs">
          <span class="material-symbols-outlined text-[14px]">info</span> 系统将分析生活习惯问卷数据进行智能匹配。
        </p>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="loading-card">
        <div class="spinner mx-auto mb-md"></div>
        <p class="font-body-md text-body-md text-on-surface-variant">AI正在分析数据并生成推荐...</p>
      </div>

      <!-- Result Card -->
      <div v-if="result && !loading" class="result-card">
        <div class="result-header">
          <span class="material-symbols-outlined text-[40px] text-secondary">lightbulb</span>
          <div>
            <h3 class="font-h2 text-h2 text-on-surface">AI推荐结果</h3>
            <p class="font-body-md text-body-md text-on-surface-variant">基于智能算法分析:</p>
          </div>
        </div>

        <div class="result-content">
          <pre class="recommendation-text">{{ result.recommendation }}</pre>
        </div>

        <!-- Radar Chart -->
        <div v-if="result.scores" class="radar-section">
          <div class="radar-header">
            <span class="material-symbols-outlined text-[20px]">radar</span>
            <h4>六维匹配度分析</h4>
          </div>
          <div ref="radarChartRef" style="width: 100%; height: 380px;"></div>
        </div>

        <div class="result-actions">
          <el-button @click="copyRecommendation" class="btn-outline">
            <span class="material-symbols-outlined text-[18px]">content_copy</span> 复制结果
          </el-button>
          <el-button @click="resetForm" type="primary" class="btn-primary">
            <span class="material-symbols-outlined text-[18px]">refresh</span> 新推荐
          </el-button>
        </div>
      </div>

      <!-- Feature Cards -->
      <div class="feature-cards">
        <div class="feature-card">
          <span class="material-symbols-outlined text-[32px] text-primary">group</span>
          <h4>智能匹配</h4>
          <p>基于机器学习的生活习惯分析算法</p>
        </div>
        <div class="feature-card">
          <span class="material-symbols-outlined text-[32px] text-secondary">domain</span>
          <h4>多维度</h4>
          <p>综合考虑作息、习惯、偏好等多维度因素</p>
        </div>
        <div class="feature-card">
          <span class="material-symbols-outlined text-[32px] text-tertiary">quiz</span>
          <h4>问卷支撑</h4>
          <p>基于生活习惯问卷数据匹配</p>
        </div>
        <div class="feature-card">
          <span class="material-symbols-outlined text-[32px] text-quaternary">assignment_turned_in</span>
          <h4>自动分配</h4>
          <p>AI自动推荐最优宿舍方案</p>
        </div>
        <div class="feature-card">
          <span class="material-symbols-outlined text-[32px] text-quinary">swap_horiz</span>
          <h4>调换支持</h4>
          <p>支持宿舍调换场景推荐</p>
        </div>
        <div class="feature-card">
          <span class="material-symbols-outlined text-[32px] text-senary">construction</span>
          <h4>持续优化</h4>
          <p>系统通过反馈持续优化结果</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import * as echarts from 'echarts'
import { getStudents, aiRecommend } from '@/api/admin'

const loading = ref(false)
const students = ref<any[]>([])
const form = ref({ studentId: undefined as number | undefined, remark: '' })
const result = ref<any>(null)
const radarChartRef = ref<HTMLElement | null>(null)

const fetchStudents = async () => {
  try {
    students.value = await getStudents()
  } catch { /* ignore */ }
}

const onStudentChange = () => {
  result.value = null
}

const initRadarChart = (scores: Record<string, number>) => {
  nextTick(() => {
    if (!radarChartRef.value) return
    const chart = echarts.init(radarChartRef.value)
    const dimensions = Object.keys(scores)
    const values = Object.values(scores)

    const option = {
      tooltip: {
        trigger: 'item',
        formatter: (params: any) => params.name + ': ' + params.value + ' 分'
      },
      legend: {
        data: ['匹配度'],
        bottom: 0,
        textStyle: { color: '#414755', fontSize: 12 }
      },
      radar: {
        center: ['50%', '50%'],
        radius: '65%',
        indicator: dimensions.map((name) => ({ name, max: 100 })),
        axisName: {
          color: '#414755',
          fontSize: 12,
          borderRadius: 3,
          padding: [2, 5]
        },
        splitArea: {
          areaStyle: { color: ['rgba(0, 88, 188, 0.02)', 'rgba(0, 88, 188, 0.04)'] }
        },
        splitLine: { lineStyle: { color: 'rgba(0, 88, 188, 0.15)' } },
        axisLine: { lineStyle: { color: 'rgba(0, 88, 188, 0.3)' } }
      },
      series: [{
        name: '匹配度',
        type: 'radar',
        data: [{
          value: values,
          name: '维度匹配度',
          areaStyle: { color: 'rgba(0, 88, 188, 0.2)' },
          lineStyle: { color: '#0058bc', width: 2 },
          itemStyle: { color: '#0058bc' }
        }],
        symbol: 'circle',
        symbolSize: 6
      }]
    }

    chart.setOption(option)
    window.addEventListener('resize', () => chart.resize())
  })
}

const getRecommendation = async () => {
  if (!form.value.studentId) return
  loading.value = true
  try {
    result.value = await aiRecommend(form.value.studentId, form.value.remark)
    if (result.value.scores) {
      nextTick(() => initRadarChart(result.value.scores))
    }
  } catch {
    // error handled
  } finally {
    loading.value = false
  }
}

const copyRecommendation = () => {
  if (!result.value) return
  navigator.clipboard.writeText(result.value.recommendation).then(() => {
    ElMessage.success('已复制到剪贴板!')
  })
}

const resetForm = () => {
  form.value = { studentId: undefined, remark: '' }
  result.value = null
}

onMounted(fetchStudents)
</script>

<style scoped lang="scss">
$bg: #f8f9fa;
$surface: #f3f4f5;
$surface-high: #e7e8e9;
$surface-low: #edeeef;
$surface-lowest: #ffffff;
$primary: #0058bc;
$primary-fixed: #d8e2ff;
$secondary: #00677d;
$secondary-fixed: #b3ebff;
$tertiary: #545c6f;
$tertiary-fixed: #dbe2f9;
$error: #ba1a1a;
$error-container: #ffdad6;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline: #717786;
$outline-variant: #c1c6d7;
$quaternary: #7d5700;
$quaternary-fixed: #ffdcba;
$quinary: #385997;
$quinary-fixed: #c9d8f0;
$senary: #a83c39;
$senary-fixed: #f9d0cf;

.ai-recommend {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

.page-header {
  margin-bottom: 24px;

  .header-content {
    display: flex;
    align-items: center;
    gap: 16px;

    .material-symbols-outlined {
      color: $primary;
    }
  }

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

.main-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
  width: 100%;
}

.input-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 20px;
  width: 100%;

  .hint-text {
    font-size: 12px;
    color: $outline;
    margin-top: 12px;
  }
}

.loading-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 40px;
  text-align: center;
}

.result-card {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 12px;
  padding: 24px;
  border-left: 4px solid $secondary;
  animation: fadeIn 0.3s ease;

  .result-header {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid $outline-variant;

    .material-symbols-outlined {
      color: $secondary;
    }
  }

  .result-content {
    background: $surface;
    border-radius: 8px;
    padding: 16px;
    margin-bottom: 24px;

    .recommendation-text {
      white-space: pre-wrap;
      font-family: inherit;
      font-size: 16px;
      line-height: 1.6;
      color: $on-surface;
    }
  }

  .radar-section {
    background: $surface;
    border-radius: 8px;
    padding: 16px;
    margin-bottom: 24px;

    .radar-header {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      margin-bottom: 16px;

      .material-symbols-outlined {
        color: $primary;
      }

      h4 {
        font-size: 16px;
        font-weight: 500;
        color: $on-surface;
      }
    }
  }

  .result-actions {
    display: flex;
    gap: 12px;
    justify-content: center;
  }
}

.feature-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;

  .feature-card {
    background: $surface-lowest;
    border: 1px solid $outline-variant;
    border-radius: 12px;
    padding: 16px;
    text-align: center;
    transition: border-color 0.2s;

    &:hover {
      border-color: $primary;
    }

    .material-symbols-outlined {
      margin-bottom: 8px;
    }

    h4 {
      font-size: 14px;
      font-weight: 500;
      color: $on-surface;
      margin-bottom: 4px;
    }

    p {
      font-size: 12px;
      color: $on-surface-variant;
    }
  }

  .text-primary { color: $primary; }
  .text-secondary { color: $secondary; }
  .text-tertiary { color: $tertiary; }
  .text-quaternary { color: $quaternary; }
  .text-quinary { color: $quinary; }
  .text-senary { color: $senary; }
}

.btn-primary {
  background: $primary;
  border-color: $primary;
  color: #fff;
  display: flex;
  align-items: center;
  gap: 8px;

  &:hover {
    background: #004493;
    border-color: #004493;
  }
}

.btn-outline {
  background: transparent;
  border: 1px solid $outline-variant;
  color: $on-surface;
  display: flex;
  align-items: center;
  gap: 8px;

  &:hover {
    border-color: $primary;
    background: $surface;
  }
}

.spinner {
  border: 3px solid rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  border-top: 3px solid $primary;
  width: 36px;
  height: 36px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>