<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../common/head.jsp" %>
    <title>我的资料 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="role" value="student"/>
        <jsp:param name="active" value="profile"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../common/topbar.jsp">
            <jsp:param name="role" value="student"/>
            <jsp:param name="active" value="profile"/>
        </jsp:include>
        <div class="p-margin max-w-[700px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">person</span> 我的资料
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">查看您的个人信息。</p>
            </div>

            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                <!-- Avatar Section -->
                <div class="bg-primary text-on-primary p-lg text-center">
                    <div class="w-[100px] h-[100px] bg-on-primary bg-opacity-20 rounded-full flex items-center justify-center mx-auto mb-md">
                        <span class="material-symbols-outlined text-[56px]">school</span>
                    </div>
                    <h3 class="font-h2 text-h2">${student.name}</h3>
                    <p class="font-body-lg text-body-lg opacity-80">${student.studentId} 学号</p>
                </div>

                <!-- Info Items -->
                <div class="p-lg">
                    <div class="flex items-center py-sm border-b border-outline-variant hover:bg-surface-container rounded-lg px-sm transition-colors">
                        <span class="material-symbols-outlined text-[24px] text-primary mr-md">wc</span>
                        <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">性别</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.gender == 0 ? '男' : '女'}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant hover:bg-surface-container rounded-lg px-sm transition-colors">
                        <span class="material-symbols-outlined text-[24px] text-primary mr-md">school</span>
                        <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">专业</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.major}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant hover:bg-surface-container rounded-lg px-sm transition-colors">
                        <span class="material-symbols-outlined text-[24px] text-primary mr-md">workspace_premium</span>
                        <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">年级</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.grade}</span>
                    </div>
                    <div class="flex items-center py-sm hover:bg-surface-container rounded-lg px-sm transition-colors">
                        <span class="material-symbols-outlined text-[24px] text-primary mr-md">call</span>
                        <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">电话</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.phone}</span>
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
