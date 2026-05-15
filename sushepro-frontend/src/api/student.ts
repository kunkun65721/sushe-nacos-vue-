import request from './index'

export interface Student {
  id: number
  userId: number
  studentId: string
  name: string
  gender: number
  major: string
  grade: string
  phone: string
  emergencyContact: string
  emergencyPhone: string
  createTime: string
}

export interface HabitQuestionnaire {
  id: number
  studentId: number
  sleepTime: string
  wakeUpTime: string
  smoking: number
  drinking: number
  noiseTolerance: string
  cleanliness: string
  note: string
  createTime: string
}

export interface DormitoryAllocation {
  id: number
  studentId: number
  dormitoryId: number
  building: string
  dormitoryNumber: string
  allocateTime: string
}

export interface DormitoryTransfer {
  id: number
  studentId: number
  currentDormitoryId: number
  targetDormitoryId: number
  reason: string
  attachment?: string
  status: number
  applyTime: string
}

export interface RepairRequest {
  id: number
  studentId: number
  dormitoryId: number
  description: string
  image?: string
  status: number
  createTime: string
}

export const getStudentIndex = () => {
  return request.get('/student/index')
}

export const getStudentProfile = () => {
  return request.get<Student>('/student/profile')
}

export const getStudentQuestionnaire = () => {
  return request.get<HabitQuestionnaire>('/student/questionnaire')
}

export const submitQuestionnaire = (data: HabitQuestionnaire) => {
  return request.post('/student/questionnaire', data)
}

export const getStudentAllocation = () => {
  return request.get<DormitoryAllocation>('/student/allocation')
}

export const getStudentTransfers = () => {
  return request.get<DormitoryTransfer[]>('/student/transfers')
}

export const getStudentDormitories = () => {
  return request.get('/student/dormitories')
}

export const submitTransfer = (data: { reason: string; targetDormitoryId?: number; attachment?: File }) => {
  const formData = new FormData()
  formData.append('reason', data.reason)
  if (data.targetDormitoryId) {
    formData.append('targetDormitoryId', String(data.targetDormitoryId))
  }
  if (data.attachment) {
    formData.append('attachment', data.attachment)
  }
  return request.post('/student/transfers', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export const getStudentRepairs = () => {
  return request.get<RepairRequest[]>('/student/repairs')
}

export const submitRepair = (data: { description: string; image?: File }) => {
  const formData = new FormData()
  formData.append('description', data.description)
  if (data.image) {
    formData.append('image', data.image)
  }
  return request.post('/student/repairs', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export const changePassword = (data: { oldPassword: string; newPassword: string; confirmPassword: string }) => {
  return request.post('/student/password', null, { params: data })
}

export interface StudentNotification {
  type: string
  icon: string
  title: string
  description: string
  link?: string
  time?: string
  status?: number
  adminComment?: string
}

export interface StudentNotificationResponse {
  repairs: StudentNotification[]
  transfers: StudentNotification[]
  allocation?: StudentNotification
}

export const getStudentNotifications = () => {
  return request.get<StudentNotificationResponse>('/student/notifications')
}

export const deleteStudentRepairNotification = (id: number) => {
  return request.delete('/student/notifications/repair/' + id)
}

export const deleteStudentTransferNotification = (id: number) => {
  return request.delete('/student/notifications/transfer/' + id)
}