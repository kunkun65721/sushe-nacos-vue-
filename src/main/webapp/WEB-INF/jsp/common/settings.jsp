<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="head.jsp" %>
    <title>设置 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="role" value="${role}"/>
        <jsp:param name="active" value="settings"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="topbar.jsp">
            <jsp:param name="role" value="${role}"/>
            <jsp:param name="active" value="settings"/>
        </jsp:include>
        <div class="p-margin max-w-[500px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">settings</span> 设置
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">修改您的账户密码。</p>
            </div>

            <c:if test="${not empty error}">
                <div class="bg-error-container text-on-error-container font-body-md text-body-md p-md rounded-lg mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined">error</span> ${error}
                </div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="bg-primary-fixed text-on-primary-fixed-variant font-body-md text-body-md p-md rounded-lg mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined">check_circle</span> ${success}
                </div>
            </c:if>

            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                <form method="post" action="">
                    <div class="mb-md">
                        <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">旧密码</label>
                        <input type="password" name="oldPassword" required class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors" placeholder="请输入当前密码"/>
                    </div>
                    <div class="mb-md">
                        <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">新密码</label>
                        <input type="password" name="newPassword" required class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors" placeholder="请输入新密码"/>
                    </div>
                    <div class="mb-lg">
                        <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">确认新密码</label>
                        <input type="password" name="confirmPassword" required class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors" placeholder="请再次输入新密码"/>
                    </div>
                    <button type="submit" class="w-full bg-primary text-on-primary font-label-caps text-label-caps py-sm rounded-lg hover:opacity-90 transition-opacity active:scale-95">保存修改</button>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
