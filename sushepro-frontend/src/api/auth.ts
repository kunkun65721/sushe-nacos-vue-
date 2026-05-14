import request from './index'

export interface LoginRequest {
  username: string
  password: string
}

export interface LoginResponse {
  token: string
  id: number
  username: string
  role: string
}

export interface User {
  id: number
  username: string
  password?: string
  role: number
  createTime?: string
}

export const login = (data: LoginRequest) => {
  return request.post<LoginResponse>('/auth/login', data)
}

export const logout = () => {
  return request.post('/auth/logout')
}

export const getCurrentUser = () => {
  return request.get<User>('/auth/me')
}

export const searchFeatures = (keyword: string) => {
  return request.get('/auth/search', { params: { keyword } })
}