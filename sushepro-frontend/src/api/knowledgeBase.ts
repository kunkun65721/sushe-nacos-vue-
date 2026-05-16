import request from './index'

export interface KnowledgeBase {
  id: number
  title: string
  fileName: string
  filePath: string
  fileType: string
  fileSize: number
  contentSummary?: string
  status: number
  category: string
  visitCount: number
  createTime: string
  updateTime?: string
}

export interface KnowledgeBaseListResponse {
  list: KnowledgeBase[]
  total: number
  page: number
  size: number
}

export interface KnowledgeBaseListParams {
  category?: string
  status?: number
  page?: number
  size?: number
}

export const getKnowledgeBaseList = (params: KnowledgeBaseListParams) => {
  return request.get<KnowledgeBaseListResponse>('/admin/knowledge-base/list', { params })
}

export const getKnowledgeBaseDetail = (id: number) => {
  return request.get<KnowledgeBase>('/admin/knowledge-base/' + id)
}

export const uploadKnowledgeBase = (formData: FormData) => {
  return request.post('/admin/knowledge-base/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export const deleteKnowledgeBase = (id: number) => {
  return request.delete('/admin/knowledge-base/' + id)
}

export const updateKnowledgeBaseStatus = (id: number, status: number) => {
  return request.put('/admin/knowledge-base/' + id + '/status', null, { params: { status } })
}