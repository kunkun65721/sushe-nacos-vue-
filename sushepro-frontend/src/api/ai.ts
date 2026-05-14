import request from './index'

export interface ChatMessage {
  role: 'user' | 'assistant'
  content: string
}

export interface ChatRequest {
  message: string
  chatHistory?: ChatMessage[]
}

export const chat = (data: ChatRequest) => {
  return request.post('/ai/chat', data)
}