<template>
  <div class="ai-chat">
    <h2>AI客服</h2>
    <el-card class="chat-card">
      <div class="chat-messages" ref="messagesRef">
        <div v-for="(msg, index) in messages" :key="index" :class="['message', msg.role]">
          <div class="message-content">{{ msg.content }}</div>
        </div>
        <div v-if="loading" class="message assistant">
          <div class="message-content">思考中...</div>
        </div>
      </div>
      <div class="chat-input">
        <el-input v-model="inputMessage" placeholder="输入您的问题" @keyup.enter="sendMessage" :disabled="loading" />
        <el-button type="primary" @click="sendMessage" :loading="loading">发送</el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, nextTick } from 'vue'
import { chat } from '@/api/ai'
import { ElMessage } from 'element-plus'

interface Message {
  role: 'user' | 'assistant'
  content: string
}

const messagesRef = ref<HTMLElement>()
const inputMessage = ref('')
const messages = ref<Message[]>([])
const loading = ref(false)

const scrollToBottom = () => {
  nextTick(() => {
    if (messagesRef.value) {
      messagesRef.value.scrollTop = messagesRef.value.scrollHeight
    }
  })
}

const sendMessage = async () => {
  if (!inputMessage.value.trim()) return

  const userMessage = inputMessage.value.trim()
  messages.value.push({ role: 'user', content: userMessage })
  inputMessage.value = ''
  loading.value = true
  scrollToBottom()

  try {
    const chatHistory = messages.value.map(m => ({ role: m.role, content: m.content }))
    const result = await chat({ message: userMessage, chatHistory })
    const response = (result as any).response
    messages.value.push({ role: 'assistant', content: response })
  } catch {
    ElMessage.error('发送失败，请重试')
  } finally {
    loading.value = false
    scrollToBottom()
  }
}
</script>

<style scoped lang="scss">
$on-surface: #191c1d;
$primary: #0058bc;
$surface-low: #f3f4f5;

.ai-chat {
  h2 {
    margin-bottom: 20px;
    color: $on-surface;
    font-family: 'Instrument Serif', serif;
  }
  .chat-card {
    height: calc(100vh - 200px);
    display: flex;
    flex-direction: column;
    background: #ffffff;
    border: 1px solid #c1c6d7;
    border-radius: 12px;
    .chat-messages {
      flex: 1;
      overflow-y: auto;
      padding: 10px;
      .message {
        margin-bottom: 15px;
        display: flex;
        &.user { justify-content: flex-end; }
        .message-content {
          max-width: 70%;
          padding: 10px 15px;
          border-radius: 10px;
          background: $surface-low;
        }
        &.user .message-content { background: $primary; color: #fff; }
        &.assistant .message-content { background: $surface-low; }
      }
    }
    .chat-input {
      display: flex;
      gap: 10px;
      padding-top: 10px;
      border-top: 1px solid #c1c6d7;
    }
  }
}
</style>