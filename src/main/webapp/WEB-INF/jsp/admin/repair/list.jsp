<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>报修管理 - 宿舍管理系统</title>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link href="${pageContext.request.contextPath}/WEB-INF/css/style.css" rel="stylesheet">
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../../common/sidebar.jsp">
        <jsp:param name="role" value="admin"/>
        <jsp:param name="active" value="repairs"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../../common/topbar.jsp">
            <jsp:param name="role" value="admin"/>
            <jsp:param name="active" value="repairs"/>
        </jsp:include>
        <div class="p-margin max-w-[1600px] w-full mx-auto">
            <div class="flex justify-between items-center mb-lg">
                <div>
                    <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">construction</span> 报修管理
                    </h2>
                    <p class="font-body-md text-body-md text-on-surface-variant mt-xs">查看和处理学生的宿舍报修申请。</p>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="grid grid-cols-4 gap-gutter mb-gutter">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">待处理</p>
                    <p class="font-data-mono text-[28px] font-semibold text-yellow-600">
                        <c:set var="pending" value="0"/>
                        <c:forEach items="${repairList}" var="r"><c:if test="${r.status == 0}"><c:set var="pending" value="${pending + 1}"/></c:if></c:forEach>
                        ${pending}
                    </p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">处理中</p>
                    <p class="font-data-mono text-[28px] font-semibold text-blue-600">
                        <c:set var="processing" value="0"/>
                        <c:forEach items="${repairList}" var="r"><c:if test="${r.status == 1}"><c:set var="processing" value="${processing + 1}"/></c:if></c:forEach>
                        ${processing}
                    </p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">已完成</p>
                    <p class="font-data-mono text-[28px] font-semibold text-green-600">
                        <c:set var="completed" value="0"/>
                        <c:forEach items="${repairList}" var="r"><c:if test="${r.status == 2}"><c:set var="completed" value="${completed + 1}"/></c:if></c:forEach>
                        ${completed}
                    </p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">报修总数</p>
                    <p class="font-data-mono text-[28px] font-semibold text-on-surface">
                        <c:choose><c:when test="${not empty repairList}">${repairList.size()}</c:when><c:otherwise>0</c:otherwise></c:choose>
                    </p>
                </div>
            </div>

            <!-- Status Filter Tabs -->
            <div class="flex gap-sm mb-gutter">
                <a href="${pageContext.request.contextPath}/admin/repair/list" class="px-md py-xs rounded-full font-label-caps text-label-caps transition-all ${statusFilter == -1 ? 'bg-primary text-on-primary' : 'bg-surface-container-lowest text-on-surface-variant border border-outline-variant hover:bg-surface-container-high'}">全部</a>
                <a href="${pageContext.request.contextPath}/admin/repair/list?status=0" class="px-md py-xs rounded-full font-label-caps text-label-caps transition-all ${statusFilter == 0 ? 'bg-yellow-600 text-white' : 'bg-surface-container-lowest text-on-surface-variant border border-outline-variant hover:bg-surface-container-high'}">待处理</a>
                <a href="${pageContext.request.contextPath}/admin/repair/list?status=1" class="px-md py-xs rounded-full font-label-caps text-label-caps transition-all ${statusFilter == 1 ? 'bg-blue-600 text-white' : 'bg-surface-container-lowest text-on-surface-variant border border-outline-variant hover:bg-surface-container-high'}">处理中</a>
                <a href="${pageContext.request.contextPath}/admin/repair/list?status=2" class="px-md py-xs rounded-full font-label-caps text-label-caps transition-all ${statusFilter == 2 ? 'bg-green-600 text-white' : 'bg-surface-container-lowest text-on-surface-variant border border-outline-variant hover:bg-surface-container-high'}">已完成</a>
                <a href="${pageContext.request.contextPath}/admin/repair/list?status=3" class="px-md py-xs rounded-full font-label-caps text-label-caps transition-all ${statusFilter == 3 ? 'bg-red-600 text-white' : 'bg-surface-container-lowest text-on-surface-variant border border-outline-variant hover:bg-surface-container-high'}">已拒绝</a>
            </div>

            <!-- DataTable -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                <div class="p-md">
                    <table id="repairTable" class="w-full text-left">
                        <thead>
                            <tr>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">ID</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">学号</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">姓名</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">宿舍</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">问题描述</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">状态</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">提交时间</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${repairList}" var="r">
                                <tr>
                                    <td class="font-data-mono text-data-mono text-primary">#${r.id}</td>
                                    <td class="font-body-md text-body-md text-on-surface">${r.studentNumber}</td>
                                    <td class="font-body-md text-body-md text-on-surface font-semibold">${r.studentName}</td>
                                    <td class="font-body-md text-body-md text-on-surface">${r.building} ${r.dormitoryNumber}</td>
                                    <td class="font-body-md text-body-md text-on-surface max-w-[180px] truncate" title="${r.description}">${r.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status == 0}">
                                                <span class="inline-flex px-sm py-base bg-yellow-100 text-yellow-800 rounded-full font-label-caps text-[11px]">待处理</span>
                                            </c:when>
                                            <c:when test="${r.status == 1}">
                                                <span class="inline-flex px-sm py-base bg-blue-100 text-blue-800 rounded-full font-label-caps text-[11px]">处理中</span>
                                            </c:when>
                                            <c:when test="${r.status == 2}">
                                                <span class="inline-flex px-sm py-base bg-green-100 text-green-800 rounded-full font-label-caps text-[11px]">已完成</span>
                                            </c:when>
                                            <c:when test="${r.status == 3}">
                                                <span class="inline-flex px-sm py-base bg-red-100 text-red-800 rounded-full font-label-caps text-[11px]">已拒绝</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="font-body-md text-body-md text-on-surface">${r.createTime}</td>
                                    <td>
                                        <div class="flex gap-xs">
                                            <a href="${pageContext.request.contextPath}/admin/repair/detail?id=${r.id}" class="p-xs bg-primary-fixed text-primary rounded-lg hover:bg-primary hover:text-on-primary transition-colors" title="查看">
                                                <span class="material-symbols-outlined text-[18px]">visibility</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/repair/delete?id=${r.id}" onclick="return confirm('确定删除该报修记录吗？')" class="p-xs bg-error-container text-on-error-container rounded-lg hover:bg-error hover:text-on-error transition-colors" title="删除">
                                                <span class="material-symbols-outlined text-[18px]">delete</span>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#repairTable').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/zh-CN.json' },
                pageLength: 10,
                lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "全部"]],
                order: [[0, 'desc']],
                responsive: true
            });
        });
    </script>
</body>
</html>
