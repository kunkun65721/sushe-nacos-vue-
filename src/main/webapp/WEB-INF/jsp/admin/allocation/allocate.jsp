<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>分配房间 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../../common/sidebar.jsp">
        <jsp:param name="role" value="admin"/>
        <jsp:param name="active" value="assignments"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../../common/topbar.jsp">
            <jsp:param name="role" value="admin"/>
            <jsp:param name="active" value="assignments"/>
        </jsp:include>
        <div class="p-margin max-w-[700px] w-full mx-auto">
            <div class="flex items-center gap-sm mb-lg">
                <a href="javascript:history.back()" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-lg transition-colors">
                    <span class="material-symbols-outlined">arrow_back</span>
                </a>
                <div>
                    <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">bed</span> 分配房间
                    </h2>
                    <p class="font-body-md text-body-md text-on-surface-variant mt-xs">为该学生分配宿舍房间。</p>
                </div>
            </div>

            <!-- Student Info -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft mb-gutter">
                <h3 class="font-h3 text-h3 text-on-surface border-b border-outline-variant pb-xs mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">person</span> 学生信息
                </h3>
                <div class="grid grid-cols-2 gap-sm">
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[80px] font-label-caps text-label-caps text-on-surface-variant">姓名:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.name}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[80px] font-label-caps text-label-caps text-on-surface-variant">学号:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.studentId}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[80px] font-label-caps text-label-caps text-on-surface-variant">专业:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.major}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[80px] font-label-caps text-label-caps text-on-surface-variant">年级:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.grade}</span>
                    </div>
                </div>
            </div>

            <!-- Room Selection -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                <h3 class="font-h3 text-h3 text-on-surface border-b border-outline-variant pb-xs mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">meeting_room</span> 选择房间
                </h3>
                <form action="${pageContext.request.contextPath}/admin/allocation/allocate" method="post" id="allocateForm">
                    <input type="hidden" name="studentId" value="${student.id}">
                    <div class="mb-lg">
                        <label for="dormitoryId" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">domain</span> 选择宿舍
                        </label>
                        <select id="dormitoryId" name="dormitoryId" required class="form-select">
                            <option value="">选择房间...</option>
                            <c:forEach items="${dormitoryList}" var="dormitory">
                                <option value="${dormitory.id}">
                                    ${dormitory.dormitoryNumber} (${dormitory.dormitoryType}, ${dormitory.building}, ${dormitory.currentOccupancy}/${dormitory.capacity})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="flex justify-end gap-sm">
                        <a href="javascript:history.back()" class="px-md py-xs border border-outline-variant text-on-surface-variant rounded-lg font-label-caps text-label-caps hover:bg-surface-container transition-all flex items-center gap-xs">
                            <span class="material-symbols-outlined text-[18px]">arrow_back</span> 返回
                        </a>
                        <button type="submit" id="submitBtn" class="px-md py-xs bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all flex items-center gap-xs">
                            <span class="material-symbols-outlined text-[18px]">bed</span> 分配房间
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    <script>
        document.getElementById('allocateForm').addEventListener('submit', function(e) {
            var btn = document.getElementById('submitBtn');
            btn.innerHTML = '<span class="spinner" style="width:14px;height:14px;border-width:2px;"></span> 分配中...';
            btn.disabled = true;
        });
    </script>
</body>
</html>
