<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../common/head.jsp" %>
    <title>个人资料 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="role" value="admin"/>
        <jsp:param name="active" value="profile"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../common/topbar.jsp">
            <jsp:param name="role" value="admin"/>
            <jsp:param name="active" value="profile"/>
        </jsp:include>
        <div class="p-margin max-w-[700px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">person</span> 个人资料
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">查看您的账户信息。</p>
            </div>

            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                <div class="bg-primary text-on-primary p-lg text-center">
                    <div class="w-[100px] h-[100px] bg-on-primary bg-opacity-20 rounded-full flex items-center justify-center mx-auto mb-md">
                        <span class="material-symbols-outlined text-[56px]">shield_person</span>
                    </div>
                    <h3 class="font-h2 text-h2">${user.username}</h3>
                    <p class="font-body-lg text-body-lg opacity-80">系统管理员</p>
                </div>

                <div class="p-lg">
                    <div class="flex items-center py-sm border-b border-outline-variant hover:bg-surface-container rounded-lg px-sm transition-colors">
                        <span class="material-symbols-outlined text-[24px] text-primary mr-md">person</span>
                        <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">用户名</span>
                        <span class="font-body-md text-body-md text-on-surface">${user.username}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant hover:bg-surface-container rounded-lg px-sm transition-colors">
                        <span class="material-symbols-outlined text-[24px] text-primary mr-md">admin_panel_settings</span>
                        <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">角色</span>
                        <span class="font-body-md text-body-md text-on-surface">管理员</span>
                    </div>
                    <div class="flex items-center py-sm hover:bg-surface-container rounded-lg px-sm transition-colors">
                        <span class="material-symbols-outlined text-[24px] text-primary mr-md">calendar_today</span>
                        <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">创建时间</span>
                        <span class="font-body-md text-body-md text-on-surface">${user.createTime}</span>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('main .p-margin').classList.add('page-enter');
        });
    </script>
</body>
</html>
