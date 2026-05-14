<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav class="hidden md:flex flex-col bg-surface-container-low border-r border-outline-variant fixed left-0 top-0 h-full w-[260px] p-md z-40">
    <div class="mb-xl">
        <h1 class="font-h3 text-h3 text-on-surface">宿舍管理系统</h1>
        <p class="font-label-caps text-label-caps text-on-surface-variant mt-xs">
            <c:choose>
                <c:when test="${param.role == 'admin'}">管理员平台</c:when>
                <c:otherwise>学生平台</c:otherwise>
            </c:choose>
        </p>
    </div>
    <div class="flex-1 space-y-sm">
        <c:choose>
            <c:when test="${param.role == 'admin'}">
                <a class="flex items-center gap-sm p-sm ${param.active == 'dashboard' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/admin/index">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'dashboard' ? '1' : '0'};">dashboard</span>
                    首页
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'students' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/admin/student/list">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'students' ? '1' : '0'};">group</span>
                    学生管理
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'dormitories' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/admin/dormitory/list">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'dormitories' ? '1' : '0'};">domain</span>
                    宿舍管理
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'lifestyle' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/admin/habitQuestionnaire/list">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'lifestyle' ? '1' : '0'};">quiz</span>
                    生活方式
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'assignments' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/admin/allocation/list">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'assignments' ? '1' : '0'};">assignment_turned_in</span>
                    分配管理
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'transfers' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/admin/transfer/list">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'transfers' ? '1' : '0'};">swap_horiz</span>
                    调换管理
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'repairs' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/admin/repair/list">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'repairs' ? '1' : '0'};">construction</span>
                    报修管理
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'ai' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/admin/ai/recommend">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'ai' ? '1' : '0'};">psychology</span>
                    AI匹配
                </a>
            </c:when>
            <c:otherwise>
                <a class="flex items-center gap-sm p-sm ${param.active == 'dashboard' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/student/index">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'dashboard' ? '1' : '0'};">dashboard</span>
                    首页
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'profile' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/student/profile">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'profile' ? '1' : '0'};">person</span>
                    个人资料
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'lifestyle' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/student/habitQuestionnaire">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'lifestyle' ? '1' : '0'};">quiz</span>
                    生活方式问卷
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'allocation' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/student/dormitoryAllocation">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'allocation' ? '1' : '0'};">king_bed</span>
                    宿舍分配
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'transfer' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/student/transfer">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'transfer' ? '1' : '0'};">swap_horiz</span>
                    调换申请
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'repair' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/student/repair">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'repair' ? '1' : '0'};">build</span>
                    报修申请
                </a>
                <a class="flex items-center gap-sm p-sm ${param.active == 'chat' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant hover:bg-surface-container-high'} rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/student/aiChat">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' ${param.active == 'chat' ? '1' : '0'};">support_agent</span>
                    AI客服
                </a>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="mt-auto">
        <a class="flex items-center gap-sm p-sm text-on-tertiary-fixed-variant hover:bg-surface-container-high rounded-lg font-label-caps text-label-caps transition-all hover:translate-x-1 duration-200" href="${pageContext.request.contextPath}/logout">
            <span class="material-symbols-outlined">logout</span>
            退出登录
        </a>
    </div>
</nav>
