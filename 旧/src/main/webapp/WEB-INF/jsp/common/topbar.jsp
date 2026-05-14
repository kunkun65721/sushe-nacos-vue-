<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header class="flex justify-between items-center w-full px-lg py-sm sticky top-0 z-50 bg-surface border-b border-outline-variant shadow-soft">
    <div class="flex items-center gap-md w-1/3">
        <button class="md:hidden p-xs text-on-surface-variant hover:bg-surface-container rounded-lg transition-colors" onclick="document.getElementById('mobileSidebar').classList.toggle('hidden')">
            <span class="material-symbols-outlined">menu</span>
        </button>
        <form action="${pageContext.request.contextPath}/search" method="get" class="relative w-full max-w-md hidden sm:block">
            <span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-outline">search</span>
            <input name="keyword" class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg pl-[40px] pr-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors" placeholder="搜索..." type="text"/>
        </form>
    </div>
    <div class="flex items-center gap-sm">
        <c:choose>
            <c:when test="${param.role == 'admin'}">
                <a href="${pageContext.request.contextPath}/admin/notifications" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-full transition-colors active:scale-95 inline-flex items-center justify-center" title="通知">
                    <span class="material-symbols-outlined">notifications</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/help" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-full transition-colors active:scale-95 inline-flex items-center justify-center" title="帮助">
                    <span class="material-symbols-outlined">help</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/settings" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-full transition-colors active:scale-95 inline-flex items-center justify-center" title="设置">
                    <span class="material-symbols-outlined">settings</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/profile" class="w-8 h-8 rounded-full border border-outline-variant ml-sm bg-primary-container flex items-center justify-center hover:opacity-80 transition-opacity" title="个人资料">
                    <span class="material-symbols-outlined text-on-primary-container text-[18px]">person</span>
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/student/notifications" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-full transition-colors active:scale-95 inline-flex items-center justify-center" title="通知">
                    <span class="material-symbols-outlined">notifications</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/help" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-full transition-colors active:scale-95 inline-flex items-center justify-center" title="帮助">
                    <span class="material-symbols-outlined">help</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/settings" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-full transition-colors active:scale-95 inline-flex items-center justify-center" title="设置">
                    <span class="material-symbols-outlined">settings</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/profile" class="w-8 h-8 rounded-full border border-outline-variant ml-sm bg-primary-container flex items-center justify-center hover:opacity-80 transition-opacity" title="个人资料">
                    <span class="material-symbols-outlined text-on-primary-container text-[18px]">person</span>
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</header>
<!-- Mobile sidebar overlay -->
<div id="mobileSidebar" class="hidden fixed inset-0 z-50 md:hidden">
    <div class="absolute inset-0 bg-black bg-opacity-50" onclick="document.getElementById('mobileSidebar').classList.add('hidden')"></div>
    <div class="absolute left-0 top-0 h-full w-[260px] bg-surface-container-low border-r border-outline-variant p-md overflow-y-auto">
        <div class="flex justify-between items-center mb-xl">
            <div>
                <h1 class="font-h3 text-h3 text-on-surface">宿舍管理系统</h1>
                <p class="font-label-caps text-label-caps text-on-surface-variant mt-xs">菜单</p>
            </div>
            <button class="p-xs text-on-surface-variant hover:bg-surface-container rounded-lg" onclick="document.getElementById('mobileSidebar').classList.add('hidden')">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <div class="space-y-sm">
            <c:choose>
                <c:when test="${param.role == 'admin'}">
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'dashboard' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/admin/index"><span class="material-symbols-outlined">dashboard</span>首页</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'students' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/admin/student/list"><span class="material-symbols-outlined">group</span>学生管理</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'dormitories' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/admin/dormitory/list"><span class="material-symbols-outlined">domain</span>宿舍管理</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'lifestyle' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/admin/habitQuestionnaire/list"><span class="material-symbols-outlined">quiz</span>生活问卷</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'assignments' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/admin/allocation/list"><span class="material-symbols-outlined">assignment_turned_in</span>分配管理</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'transfers' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/admin/transfer/list"><span class="material-symbols-outlined">swap_horiz</span>调换管理</a>
                    <a class="flex items-center gap-sm p-sm text-on-tertiary-fixed-variant rounded-lg font-label-caps text-label-caps" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-outlined">logout</span>退出登录</a>
                </c:when>
                <c:otherwise>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'dashboard' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/student/index"><span class="material-symbols-outlined">dashboard</span>首页</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'profile' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/student/profile"><span class="material-symbols-outlined">person</span>我的资料</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'lifestyle' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/student/habitQuestionnaire"><span class="material-symbols-outlined">quiz</span>生活问卷</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'allocation' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/student/dormitoryAllocation"><span class="material-symbols-outlined">king_bed</span>宿舍分配</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'transfer' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/student/transfer"><span class="material-symbols-outlined">swap_horiz</span>调换申请</a>
                    <a class="flex items-center gap-sm p-sm rounded-lg font-label-caps text-label-caps ${param.active == 'chat' ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'text-on-tertiary-fixed-variant'}" href="${pageContext.request.contextPath}/student/aiChat"><span class="material-symbols-outlined">support_agent</span>AI客服</a>
                    <a class="flex items-center gap-sm p-sm text-on-tertiary-fixed-variant rounded-lg font-label-caps text-label-caps" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-outlined">logout</span>退出登录</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
