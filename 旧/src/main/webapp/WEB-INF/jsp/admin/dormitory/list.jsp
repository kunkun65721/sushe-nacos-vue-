<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>宿舍管理 - 宿舍管理系统</title>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link href="${pageContext.request.contextPath}/WEB-INF/css/style.css" rel="stylesheet">
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../../common/sidebar.jsp">
        <jsp:param name="role" value="admin"/>
        <jsp:param name="active" value="dormitories"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../../common/topbar.jsp">
            <jsp:param name="role" value="admin"/>
            <jsp:param name="active" value="dormitories"/>
        </jsp:include>
        <div class="p-margin max-w-[1600px] w-full mx-auto">
            <div class="flex justify-between items-center mb-lg">
                <div>
                    <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">domain</span> 宿舍管理
                    </h2>
                    <p class="font-body-md text-body-md text-on-surface-variant mt-xs">管理所有宿舍房间和楼栋。</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/dormitory/add" class="px-md py-xs bg-primary text-on-primary rounded-DEFAULT font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all flex items-center gap-xs">
                    <span class="material-symbols-outlined text-[18px]">add</span> 添加宿舍
                </a>
            </div>

            <!-- Stats Cards -->
            <c:set var="totalCap" value="0"/>
            <c:set var="totalOcc" value="0"/>
            <c:set var="availBeds" value="0"/>
            <c:forEach items="${dormitoryList}" var="d">
                <c:set var="totalCap" value="${totalCap + d.capacity}"/>
                <c:set var="totalOcc" value="${totalOcc + d.currentOccupancy}"/>
            </c:forEach>
            <c:set var="availBeds" value="${totalCap - totalOcc}"/>

            <div class="grid grid-cols-2 lg:grid-cols-5 gap-gutter mb-gutter">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">房间总数</p>
                    <p class="font-data-mono text-[28px] font-semibold text-on-surface">${dormitoryList.size()}</p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">总容量</p>
                    <p class="font-data-mono text-[28px] font-semibold text-on-surface">${totalCap}</p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">已入住</p>
                    <p class="font-data-mono text-[28px] font-semibold text-on-surface">${totalOcc}</p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">可用床位</p>
                    <p class="font-data-mono text-[28px] font-semibold text-on-surface">${availBeds}</p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">入住率</p>
                    <p class="font-data-mono text-[28px] font-semibold text-on-surface">
                        <c:choose>
                            <c:when test="${totalCap > 0}">${Math.round((totalOcc * 100) / totalCap)}%</c:when>
                            <c:otherwise>0%</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <!-- DataTable -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                <div class="p-md">
                    <table id="dormitoryTable" class="w-full text-left">
                        <thead>
                            <tr>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">房间号</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">类型</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">容量</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">入住情况</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">状态</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${dormitoryList}" var="dormitory">
                                <tr>
                                    <td class="font-body-md text-body-md text-on-surface">
                                        <div class="flex items-center gap-sm">
                                            <span class="material-symbols-outlined text-primary text-[20px]">door_front</span>
                                            <div>
                                                <p class="font-semibold">${dormitory.dormitoryNumber}</p>
                                                <p class="text-[12px] text-on-surface-variant">${dormitory.building}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="font-body-md text-body-md text-on-surface">${dormitory.dormitoryType}</td>
                                    <td class="font-body-md text-body-md text-on-surface">${dormitory.capacity}</td>
                                    <td class="font-body-md text-body-md text-on-surface">
                                        <div class="flex items-center gap-sm">
                                            <div class="progress w-[80px]">
                                                <div class="progress-bar bg-${dormitory.currentOccupancy <= dormitory.capacity * 0.5 ? 'primary' : (dormitory.currentOccupancy <= dormitory.capacity * 0.8 ? 'secondary' : 'error')}" style="width: ${dormitory.currentOccupancy * 100 / dormitory.capacity}%"></div>
                                            </div>
                                            <span class="text-[12px]">${dormitory.currentOccupancy}/${dormitory.capacity}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="inline-flex items-center gap-xs px-sm py-base rounded-full font-label-caps text-[11px] ${dormitory.status == 1 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                            <span class="material-symbols-outlined text-[14px]">${dormitory.status == 1 ? 'check_circle' : 'cancel'}</span>
                                            ${dormitory.status == 1 ? '启用' : '禁用'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="flex gap-xs">
                                            <a href="${pageContext.request.contextPath}/admin/dormitory/edit?id=${dormitory.id}" class="p-xs bg-primary-fixed text-primary rounded-lg hover:bg-primary hover:text-on-primary transition-colors">
                                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/dormitory/delete?id=${dormitory.id}" class="p-xs bg-error-container text-on-error-container rounded-lg hover:bg-error hover:text-on-error transition-colors" onclick="return confirm('确定删除此宿舍?')">
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
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#dormitoryTable').DataTable({
                language: { url: 'https://cdn.datatables.net/plug-ins/1.13.7/i18n/zh-CN.json' },
                order: [[0, 'desc']],
                pageLength: 10,
                responsive: true
            });
        });
    </script>
</body>
</html>
