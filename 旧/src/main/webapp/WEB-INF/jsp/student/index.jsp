<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../common/head.jsp" %>
    <title>学生仪表盘 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="role" value="student"/>
        <jsp:param name="active" value="dashboard"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../common/topbar.jsp">
            <jsp:param name="role" value="student"/>
            <jsp:param name="active" value="dashboard"/>
        </jsp:include>
        <div class="p-margin max-w-[1600px] w-full mx-auto space-y-gutter">

            <!-- Header Section -->
            <div class="flex flex-col sm:flex-row justify-between sm:items-end gap-md mb-lg">
                <div>
                    <h2 class="font-h1 text-h1 text-on-surface">欢迎, ${student.name}</h2>
                    <p class="font-body-lg text-body-lg text-on-surface-variant mt-xs">${student.studentId} · ${student.major} · ${student.grade}</p>
                </div>
            </div>

            <!-- Bento Grid -->
            <div class="grid grid-cols-1 md:grid-cols-12 gap-gutter">
                <!-- KPI Cards (Cols 1-8) -->
                <div class="md:col-span-8 grid grid-cols-2 lg:grid-cols-4 gap-gutter">
                    <!-- Room Status -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft hover:border-primary transition-colors flex flex-col justify-between">
                        <div class="flex justify-between items-start mb-md">
                            <span class="p-xs bg-primary-fixed text-primary rounded-lg flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">king_bed</span>
                            </span>
                        </div>
                        <div>
                            <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">宿舍房间</p>
                            <c:choose>
                                <c:when test="${allocation != null}">
                                    <p class="font-data-mono text-[24px] font-semibold text-on-surface">${allocation.building}${allocation.dormitoryNumber}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="font-data-mono text-[24px] font-semibold text-outline">未分配</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Repair Status -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft hover:border-primary transition-colors flex flex-col justify-between">
                        <div class="flex justify-between items-start mb-md">
                            <span class="p-xs bg-error-container text-on-error-container rounded-lg flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">build</span>
                            </span>
                        </div>
                        <div>
                            <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">报修记录</p>
                            <div class="flex items-baseline gap-xs">
                                <p class="font-data-mono text-[32px] font-semibold text-on-surface">${totalRepairs}</p>
                                <c:if test="${pendingRepairs > 0}">
                                    <span class="font-label-caps text-label-caps text-error">${pendingRepairs} 处理中</span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Transfer Status -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft hover:border-primary transition-colors flex flex-col justify-between">
                        <div class="flex justify-between items-start mb-md">
                            <span class="p-xs bg-secondary-fixed text-secondary rounded-lg flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">swap_horiz</span>
                            </span>
                        </div>
                        <div>
                            <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">调换状态</p>
                            <c:choose>
                                <c:when test="${latestTransfer != null}">
                                    <c:choose>
                                        <c:when test="${latestTransfer.status == 0}">
                                            <p class="font-data-mono text-[24px] font-semibold text-on-surface-variant">审核中</p>
                                        </c:when>
                                        <c:when test="${latestTransfer.status == 1}">
                                            <p class="font-data-mono text-[24px] font-semibold text-primary">已通过</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="font-data-mono text-[24px] font-semibold text-error">已拒绝</p>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <p class="font-data-mono text-[24px] font-semibold text-outline">无申请</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Questionnaire Status -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft hover:border-primary transition-colors flex flex-col justify-between">
                        <div class="flex justify-between items-start mb-md">
                            <span class="p-xs bg-tertiary-fixed text-tertiary rounded-lg flex items-center justify-center">
                                <span class="material-symbols-outlined text-[20px]">quiz</span>
                            </span>
                        </div>
                        <div>
                            <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">生活问卷</p>
                            <c:choose>
                                <c:when test="${hasQuestionnaire}">
                                    <p class="font-data-mono text-[24px] font-semibold text-primary">已填写</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="font-data-mono text-[24px] font-semibold text-outline">未填写</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions (Cols 9-12) -->
                <div class="md:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft flex flex-col">
                    <h3 class="font-h3 text-h3 text-on-surface border-b border-outline-variant pb-xs mb-sm">快捷操作</h3>
                    <div class="flex flex-col gap-sm flex-1 justify-center">
                        <a href="${pageContext.request.contextPath}/student/dormitoryAllocation" class="w-full flex items-center justify-between p-sm border border-outline-variant rounded-lg hover:border-primary hover:bg-surface-container transition-all group">
                            <div class="flex items-center gap-sm">
                                <span class="material-symbols-outlined text-outline group-hover:text-primary transition-colors">king_bed</span>
                                <span class="font-body-md text-body-md text-on-surface">宿舍分配</span>
                            </div>
                            <span class="material-symbols-outlined text-outline-variant">chevron_right</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/student/transfer" class="w-full flex items-center justify-between p-sm border border-outline-variant rounded-lg hover:border-primary hover:bg-surface-container transition-all group">
                            <div class="flex items-center gap-sm">
                                <span class="material-symbols-outlined text-outline group-hover:text-primary transition-colors">swap_horiz</span>
                                <span class="font-body-md text-body-md text-on-surface">调换申请</span>
                            </div>
                            <span class="material-symbols-outlined text-outline-variant">chevron_right</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/student/repair" class="w-full flex items-center justify-between p-sm border border-outline-variant rounded-lg hover:border-primary hover:bg-surface-container transition-all group">
                            <div class="flex items-center gap-sm">
                                <span class="material-symbols-outlined text-outline group-hover:text-primary transition-colors">build</span>
                                <span class="font-body-md text-body-md text-on-surface">报修申请</span>
                            </div>
                            <span class="material-symbols-outlined text-outline-variant">chevron_right</span>
                        </a>
                    </div>
                </div>

                <!-- Dormitory Map (Cols 1-8) -->
                <div class="md:col-span-8 bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft flex flex-col">
                    <div class="flex justify-between items-center border-b border-outline-variant pb-xs mb-md">
                        <h3 class="font-h3 text-h3 text-on-surface">宿舍地图</h3>
                    </div>
                    <div class="flex-1 flex items-center justify-center overflow-hidden rounded-lg">
                        <img src="${pageContext.request.contextPath}/images/maps/宿舍地图.jpg" alt="宿舍地图" class="w-full h-full object-contain" style="max-height: 400px;">
                    </div>
                </div>

                <!-- Recent Activities (Cols 9-12) -->
                <div class="md:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft flex flex-col">
                    <div class="flex justify-between items-center border-b border-outline-variant pb-xs mb-sm">
                        <h3 class="font-h3 text-h3 text-on-surface">最近活动</h3>
                    </div>
                    <div class="flex flex-col gap-md overflow-y-auto max-h-[300px] pr-xs">
                        <c:forEach items="${recentActivities}" var="act">
                        <div class="flex gap-sm items-start">
                            <div class="mt-xs p-base ${act.iconBg} rounded-full flex-shrink-0">
                                <span class="material-symbols-outlined text-[16px] text-on-surface-variant">${act.icon}</span>
                            </div>
                            <div>
                                <p class="font-body-md text-body-md text-on-surface">${act.description}</p>
                                <p class="font-label-caps text-[10px] text-outline mt-base">${act.time}</p>
                            </div>
                        </div>
                        </c:forEach>
                        <c:if test="${empty recentActivities}">
                        <div class="flex items-center justify-center py-lg">
                            <p class="font-body-md text-body-md text-on-surface-variant">暂无最近活动</p>
                        </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('.p-margin').classList.add('page-enter');
        });
    </script>
</body>
</html>
