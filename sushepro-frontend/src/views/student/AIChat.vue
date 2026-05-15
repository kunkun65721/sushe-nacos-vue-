<template>
  <div class="ai-chat">
    <!-- Header -->
    <div class="page-header">
      <div class="header-content">
        <span class="material-symbols-outlined text-[56px] text-primary">support_agent</span>
        <div>
          <h2 class="page-title">AI客服</h2>
          <p class="page-subtitle">询问任何关于宿舍的问题，AI助手将为您解答</p>
        </div>
        <el-button class="clear-btn" @click="clearChat">
          <span class="material-symbols-outlined text-[18px]">delete_sweep</span>
          清空对话
        </el-button>
      </div>
    </div>

    <!-- Chat area -->
    <div class="chat-container">
      <div class="chat-messages" ref="messagesRef">
        <!-- Welcome message -->
        <div v-if="messages.length === 0" class="welcome-message">
          <span class="avatar">
            <span class="material-symbols-outlined">support_agent</span>
          </span>
          <div class="bubble assistant">
            <p class="text-on-surface">你好！</p>
            <p class="text-on-surface">我是宿舍管理AI客服助手，可以帮你解答以下问题：</p>
            <ul class="text-on-surface-variant">
              <li>宿舍设施和房型介绍</li>
              <li>宿舍管理规定和作息时间</li>
              <li>宿舍分配流程</li>
              <li>生活习惯问卷填写</li>
              <li>宿舍调换政策</li>
            </ul>
            <p class="text-on-surface-variant">请问有什么可以帮助你的？</p>
          </div>
        </div>

        <!-- Messages -->
        <div v-for="(msg, index) in messages" :key="index" :class="['message', msg.role]">
          <template v-if="msg.role === 'user'">
            <div class="bubble user">
              <p>{{ msg.content }}</p>
            </div>
            <span class="avatar user-avatar">
              <span class="material-symbols-outlined">person</span>
            </span>
          </template>
          <template v-else>
            <span class="avatar">
              <span class="material-symbols-outlined">support_agent</span>
            </span>
            <div class="bubble assistant">
              <p>{{ msg.content }}</p>
            </div>
          </template>
        </div>

        <!-- Typing indicator -->
        <div v-if="loading" class="message assistant">
          <span class="avatar">
            <span class="material-symbols-outlined">support_agent</span>
          </span>
          <div class="bubble assistant typing">
            <div class="dot"></div>
            <div class="dot"></div>
            <div class="dot"></div>
          </div>
        </div>
      </div>

      <!-- Input bar -->
      <div class="input-bar">
        <el-input
          v-model="inputMessage"
          placeholder="输入你的问题..."
          @keyup.enter="sendMessage"
          :disabled="loading"
          class="chat-input"
        />
        <el-button type="primary" @click="sendMessage" :loading="loading" class="send-btn">
          <span class="material-symbols-outlined text-[18px]">send</span>
          发送
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, nextTick, onMounted } from 'vue'
import { chat, clearChat as clearChatApi } from '@/api/ai'
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
  if (!inputMessage.value.trim() || loading.value) return

  const userMessage = inputMessage.value.trim()
  messages.value.push({ role: 'user', content: userMessage })
  inputMessage.value = ''
  loading.value = true
  scrollToBottom()

  try {
    const chatHistory = messages.value.slice(-20).map(m => ({ role: m.role, content: m.content }))
    const result = await chat({ message: userMessage, chatHistory })
    const response = (result as any).response || (result as any).reply
    messages.value.push({ role: 'assistant', content: response })
  } catch {
    ElMessage.error('发送失败，请重试')
  } finally {
    loading.value = false
    scrollToBottom()
  }
}

const clearChat = async () => {
  try {
    await clearChatApi()
    messages.value = []
    ElMessage.success('对话已清空')
  } catch {
    messages.value = []
  }
}

onMounted(() => {
  scrollToBottom()
})
</script>

<style scoped lang="scss">
$bg: #f8f9fa;
$surface: #f3f4f5;
$surface-high: #e7e8e9;
$surface-low: #edeeef;
$surface-lowest: #ffffff;
$primary: #0058bc;
$primary-fixed: #d8e2ff;
$on-surface: #191c1d;
$on-surface-variant: #414755;
$outline: #717786;
$outline-variant: #c1c6d7;

.ai-chat {
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
    padding: 20px 24px;
    background: $surface-lowest;
    border: 1px solid $outline-variant;
    border-radius: 16px;

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

  .clear-btn {
    margin-left: auto;
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 16px;
    background: transparent;
    border: 1px solid $outline-variant;
    color: $on-surface-variant;
    border-radius: 8px;
    transition: all 0.2s;

    &:hover {
      border-color: #ba1a1a;
      color: #ba1a1a;
      background: #ffdad6;
    }
  }
}

.chat-container {
  background: $surface-lowest;
  border: 1px solid $outline-variant;
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  height: calc(100vh - 220px);
  overflow: hidden;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.welcome-message, .message {
  display: flex;
  gap: 12px;
  align-items: flex-start;
}

.message.user {
  flex-direction: row-reverse;

  .bubble {
    background: $primary !important;
    color: $surface-lowest !important;
    border-radius: 18px 18px 4px 18px !important;
  }

  .user-avatar {
    background: #f3e8fd;
    .material-symbols-outlined {
      color: #7c3aed;
    }
  }
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: $primary-fixed;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;

  .material-symbols-outlined {
    font-size: 20px;
    color: $primary;
  }
}

.bubble {
  max-width: 70%;
  padding: 12px 16px;
  background: $surface;
  border-radius: 18px 18px 18px 4px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);

  p {
    font-size: 15px;
    line-height: 1.6;
    white-space: pre-wrap;
  }

  ul {
    list-style: disc;
    list-style-position: inside;
    margin-top: 8px;
    font-size: 14px;
  }

  li {
    margin-top: 4px;
  }
}

.bubble.typing {
  display: flex;
  gap: 4px;
  align-items: center;
  padding: 16px 20px;

  .dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: $outline;
    animation: bounce 1.4s infinite ease-in-out;

    &:nth-child(1) { animation-delay: 0ms; }
    &:nth-child(2) { animation-delay: 150ms; }
    &:nth-child(3) { animation-delay: 300ms; }
  }
}

@keyframes bounce {
  0%, 80%, 100% { transform: scale(0.8); opacity: 0.5; }
  40% { transform: scale(1); opacity: 1; }
}

.input-bar {
  display: flex;
  gap: 12px;
  padding: 16px 24px;
  border-top: 1px solid $outline-variant;
  background: $surface;

  .chat-input {
    flex: 1;
  }

  .send-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 12px 24px;
    background: $primary;
    border-color: $primary;
    color: #fff;

    &:hover {
      background: #004493;
      border-color: #004493;
    }
  }
}

.text-on-surface {
  color: $on-surface;
}

.text-on-surface-variant {
  color: $on-surface-variant;
  font-size: 14px;
}
</style>