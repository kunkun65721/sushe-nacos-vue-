<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../common/head.jsp" %>
    <title>宿舍分配 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="role" value="student"/>
        <jsp:param name="active" value="allocation"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../common/topbar.jsp">
            <jsp:param name="role" value="student"/>
            <jsp:param name="active" value="allocation"/>
        </jsp:include>
        <div class="p-margin max-w-[700px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">king_bed</span> 宿舍分配
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">查看您的宿舍及房间详细信息。</p>
            </div>

            <c:choose>
                <c:when test="${allocation != null}">
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="bg-primary text-on-primary p-lg text-center">
                            <span class="material-symbols-outlined text-[48px] mb-sm">meeting_room</span>
                            <h3 class="font-h2 text-h2">${allocation.dormitoryNumber}</h3>
                            <p class="font-body-md text-body-md opacity-80">您的已分配房间</p>
                        </div>
                        <div class="p-lg">
                            <div class="flex items-center py-sm border-b border-outline-variant hover:bg-surface-container rounded-lg px-sm transition-colors">
                                <span class="material-symbols-outlined text-[24px] text-primary mr-md">domain</span>
                                <span class="font-label-caps text-label-caps text-on-surface-variant w-[120px]">房间号</span>
                                <span class="font-body-md text-body-md text-on-surface font-semibold">${allocation.dormitoryNumber}</span>
                            </div>
                            <div class="flex items-center py-sm border-b border-outline-variant hover:bg-surface-container rounded-lg px-sm transition-colors">
                                <span class="material-symbols-outlined text-[24px] text-primary mr-md">category</span>
                                <span class="font-label-caps text-label-caps text-on-surface-variant w-[120px]">房间类型</span>
                                <span class="font-body-md text-body-md text-on-surface">${allocation.dormitoryType}</span>
                            </div>
                            <div class="flex items-center py-sm border-b border-outline-variant hover:bg-surface-container rounded-lg px-sm transition-colors">
                                <span class="material-symbols-outlined text-[24px] text-primary mr-md">apartment</span>
                                <span class="font-label-caps text-label-caps text-on-surface-variant w-[120px]">楼栋</span>
                                <span class="font-body-md text-body-md text-on-surface">${allocation.building}</span>
                            </div>
                            <div class="flex items-center py-sm hover:bg-surface-container rounded-lg px-sm transition-colors">
                                <span class="material-symbols-outlined text-[24px] text-primary mr-md">calendar_today</span>
                                <span class="font-label-caps text-label-caps text-on-surface-variant w-[120px]">分配日期</span>
                                <span class="font-body-md text-body-md text-on-surface">${allocation.allocateTime}</span>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-xl shadow-soft text-center">
                        <span class="material-symbols-outlined text-[56px] text-outline mb-md">bedroom_parent</span>
                        <h3 class="font-h3 text-h3 text-on-surface mb-sm">暂无分配</h3>
                        <p class="font-body-md text-body-md text-on-surface-variant mb-lg">请先完成生活习惯问卷。系统将根据您的偏好为您匹配合适的室友。</p>
                        <a href="${pageContext.request.contextPath}/student/habitQuestionnaire" class="inline-flex items-center gap-xs px-md py-xs bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all">
                            <span class="material-symbols-outlined text-[18px]">quiz</span> 填写问卷
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('main .p-margin').classList.add('page-enter');
        });
    </script>
</body>
</html>
