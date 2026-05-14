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
  createTime: string
}

export interface Dormitory {
  id: number
  building: string
  dormitoryNumber: string
  dormitoryType: string
  capacity: number
  currentOccupancy: number
  status: number
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
}

export interface DormitoryAllocation {
  id: number
  studentId: number
  studentName: string
  dormitoryId: number
  building: string
  dormitoryNumber: string
  allocateTime: string
}

export interface DormitoryTransfer {
  id: number
  studentId: number
  studentName: string
  currentDormitoryId: number
  targetDormitoryId: number
  reason: string
  attachment?: string
  status: number
  applyTime: string
  adminComment?: string
}

export interface RepairRequest {
  id: number
  studentId: number
  studentName: string
  building?: string
  dormitoryNumber?: string
  description: string
  image?: string
  status: number
  createTime: string
  adminComment?: string
}

export const getAdminIndex = () => {
  return request.get('/admin/index')
}

export const getStudents = () => {
  return request.get<Student[]>('/admin/students')
}

export const getStudentDetail = (id: number) => {
  return request.get('/admin/students/' + id)
}

export const getDormitories = () => {
  return request.get<Dormitory[]>('/admin/dormitories')
}

export const addDormitory = (data: Dormitory) => {
  return request.post('/admin/dormitories', data)
}

export const updateDormitory = (id: number, data: Dormitory) => {
  return request.put('/admin/dormitories/' + id, data)
}

export const deleteDormitory = (id: number) => {
  return request.delete('/admin/dormitories/' + id)
}

export const getQuestionnaires = () => {
  return request.get('/admin/questionnaires')
}

export const getQuestionnaireDetail = (studentId: number) => {
  return request.get('/admin/questionnaires/' + studentId)
}

export const getAllocations = () => {
  return request.get<DormitoryAllocation[]>('/admin/allocations')
}

export const allocateDormitory = (studentId: number, dormitoryId: number) => {
  return request.post('/admin/allocations', null, { params: { studentId, dormitoryId } })
}

export const getTransfers = (status?: number) => {
  return request.get('/admin/transfers', { params: status !== undefined ? { status } : {} })
}

export const getTransferDetail = (id: number) => {
  return request.get('/admin/transfers/' + id)
}

export const approveTransfer = (id: number, targetDormitoryId: number, adminComment?: string) => {
  return request.put('/admin/transfers/' + id + '/approve', null, { params: { targetDormitoryId, adminComment } })
}

export const rejectTransfer = (id: number, adminComment: string) => {
  return request.put('/admin/transfers/' + id + '/reject', null, { params: { adminComment } })
}

export const deleteTransfer = (id: number) => {
  return request.delete('/admin/transfers/' + id)
}

export const getRepairs = (status?: number) => {
  return request.get('/admin/repairs', { params: status !== undefined ? { status } : {} })
}

export const getRepairDetail = (id: number) => {
  return request.get('/admin/repairs/' + id)
}

export const processRepair = (id: number, adminComment?: string) => {
  return request.put('/admin/repairs/' + id + '/process', null, { params: { adminComment } })
}

export const completeRepair = (id: number, adminComment?: string) => {
  return request.put('/admin/repairs/' + id + '/complete', null, { params: { adminComment } })
}

export const rejectRepair = (id: number, adminComment?: string) => {
  return request.put('/admin/repairs/' + id + '/reject', null, { params: { adminComment } })
}

export const deleteRepair = (id: number) => {
  return request.delete('/admin/repairs/' + id)
}

export const aiRecommend = (studentId: number, remark?: string) => {
  return request.post('/admin/ai/recommend', null, { params: { studentId, remark } })
}

export const changePassword = (data: { oldPassword: string; newPassword: string; confirmPassword: string }) => {
  return request.post('/admin/password', null, { params: data })
}

export interface AdminNotification {
  type: string
  icon: string
  title: string
  description: string
  link?: string
  time?: string
}

export const getAdminNotifications = () => {
  return request.get<AdminNotification[]>('/admin/notifications')
}