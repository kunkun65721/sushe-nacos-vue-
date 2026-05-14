<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="head.jsp" %>
    <title>通知中心 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="role" value="${role}"/>
        <jsp:param name="active" value="notifications"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="topbar.jsp">
            <jsp:param name="role" value="${role}"/>
            <jsp:param name="active" value="notifications"/>
        </jsp:include>
        <div class="p-margin max-w-[900px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">notifications</span> 通知中心
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">查看系统通知和待处理事项。</p>
            </div>

            <c:choose>
                <c:when test="${role == 'admin'}">
                    <div class="space-y-md">
                        <c:if test="${pendingRepairs > 0}">
                            <a href="${pageContext.request.contextPath}/admin/repair/list?status=0" class="block bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft hover:shadow-expand transition-all hover:translate-x-1 duration-200">
                                <div class="flex items-center gap-md">
                                    <div class="w-12 h-12 bg-error-container rounded-full flex items-center justify-center flex-shrink-0">
                                        <span class="material-symbols-outlined text-error">build</span>
                                    </div>
                                    <div class="flex-1">
                                        <h3 class="font-h3 text-h3 text-on-surface">待处理报修</h3>
                                        <p class="font-body-md text-body-md text-on-surface-variant">有 <span class="text-error font-semibold">${pendingRepairs}</span> 条报修请求等待处理</p>
                                    </div>
                                    <span class="material-symbols-outlined text-outline">chevron_right</span>
                                </div>
                            </a>
                        </c:if>
                        <c:if test="${pendingTransfers > 0}">
                            <a href="${pageContext.request.contextPath}/admin/transfer/list?status=0" class="block bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft hover:shadow-expand transition-all hover:translate-x-1 duration-200">
                                <div class="flex items-center gap-md">
                                    <div class="w-12 h-12 bg-tertiary-fixed rounded-full flex items-center justify-center flex-shrink-0">
                                        <span class="material-symbols-outlined text-on-tertiary-fixed-variant">swap_horiz</span>
                                    </div>
                                    <div class="flex-1">
                                        <h3 class="font-h3 text-h3 text-on-surface">待审核调换</h3>
                                        <p class="font-body-md text-body-md text-on-surface-variant">有 <span class="text-primary font-semibold">${pendingTransfers}</span> 条调换申请等待审核</p>
                                    </div>
                                    <span class="material-symbols-outlined text-outline">chevron_right</span>
                                </div>
                            </a>
                        </c:if>
                        <c:if test="${recentAllocations != null && !recentAllocations.isEmpty()}">
                            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                                <h3 class="font-h3 text-h3 text-on-surface mb-md">最近分配记录</h3>
                                <div class="space-y-sm">
                                    <c:forEach items="${recentAllocations}" var="a">
                                        <div class="flex items-center gap-sm py-sm border-b border-outline-variant last:border-b-0">
                                            <span class="material-symbols-outlined text-primary">king_bed</span>
                                            <span class="font-body-md text-body-md text-on-surface flex-1">${a.studentName} 被分配到 ${a.building}${a.dormitoryNumber} 房间</span>
                                            <span class="font-label-caps text-label-caps text-on-surface-variant">${a.allocateTime}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${(pendingRepairs == null || pendingRepairs == 0) && (pendingTransfers == null || pendingTransfers == 0) && (recentAllocations == null || recentAllocations.isEmpty())}">
                            <div class="text-center py-xxl">
                                <span class="material-symbols-outlined text-[64px] text-outline-variant">notifications_off</span>
                                <p class="font-body-lg text-body-lg text-on-surface-variant mt-md">暂无新的通知</p>
                            </div>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-md">
                        <c:choose>
                            <c:when test="${repairList != null && !repairList.isEmpty()}">
                                <c:forEach items="${repairList}" var="r">
                                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                                        <div class="flex items-center gap-md">
                                            <div class="w-12 h-12 ${r.status == 2 ? 'bg-error-container' : r.status == 1 ? 'bg-primary-fixed' : 'bg-surface-container'} rounded-full flex items-center justify-center flex-shrink-0">
                                                <span class="material-symbols-outlined ${r.status == 2 ? 'text-error' : r.status == 1 ? 'text-primary' : 'text-on-surface-variant'}">build</span>
                                            </div>
                                            <div class="flex-1">
                                                <h3 class="font-h3 text-h3 text-on-surface">报修申请 - ${r.status == 0 ? '待处理' : r.status == 1 ? '处理中' : r.status == 2 ? '已完成' : '已拒绝'}</h3>
                                                <p class="font-body-md text-body-md text-on-surface-variant">${r.description}</p>
                                                <p class="font-label-caps text-label-caps text-outline mt-xs">${r.createTime}</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-xxl">
                                    <span class="material-symbols-outlined text-[64px] text-outline-variant">notifications_off</span>
                                    <p class="font-body-lg text-body-lg text-on-surface-variant mt-md">暂无通知</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${transferList != null && !transferList.isEmpty()}">
                            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                                <h3 class="font-h3 text-h3 text-on-surface mb-md">调换申请状态</h3>
                                <c:forEach items="${transferList}" var="t">
                                    <div class="flex items-center gap-sm py-sm border-b border-outline-variant last:border-b-0">
                                        <span class="material-symbols-outlined ${t.status == 1 ? 'text-primary' : t.status == 2 ? 'text-error' : 'text-on-surface-variant'}">swap_horiz</span>
                                        <span class="font-body-md text-body-md text-on-surface flex-1">${t.reason}</span>
                                        <span class="px-sm py-xs rounded-full font-label-caps text-label-caps ${t.status == 0 ? 'bg-surface-container text-on-surface-variant' : t.status == 1 ? 'bg-primary-fixed text-on-primary-fixed-variant' : 'bg-error-container text-on-error-container'}">${t.status == 0 ? '待审核' : t.status == 1 ? '已通过' : '已拒绝'}</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <c:if test="${allocation != null}">
                            <a href="${pageContext.request.contextPath}/student/dormitoryAllocation" class="block bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft hover:shadow-expand transition-all hover:translate-x-1 duration-200">
                                <div class="flex items-center gap-md">
                                    <div class="w-12 h-12 bg-primary-fixed rounded-full flex items-center justify-center flex-shrink-0">
                                        <span class="material-symbols-outlined text-on-primary-fixed-variant">king_bed</span>
                                    </div>
                                    <div class="flex-1">
                                        <h3 class="font-h3 text-h3 text-on-surface">宿舍分配结果</h3>
                                        <p class="font-body-md text-body-md text-on-surface-variant">${allocation.building} ${allocation.dormitoryNumber} 房间</p>
                                    </div>
                                    <span class="material-symbols-outlined text-outline">chevron_right</span>
                                </div>
                            </a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</body>
</html>
