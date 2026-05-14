<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>分配管理 - 宿舍管理系统</title>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link href="${pageContext.request.contextPath}/WEB-INF/css/style.css" rel="stylesheet">
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
        <div class="p-margin max-w-[1600px] w-full mx-auto">
            <div class="flex justify-between items-center mb-lg">
                <div>
                    <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">assignment_turned_in</span> 分配管理
                    </h2>
                    <p class="font-body-md text-body-md text-on-surface-variant mt-xs">查看和管理所有宿舍分配。</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/allocation/allocate" class="px-md py-xs bg-primary text-on-primary rounded-DEFAULT font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all flex items-center gap-xs">
                    <span class="material-symbols-outlined text-[18px]">add</span> 新分配
                </a>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-2 gap-gutter mb-gutter">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">分配总数</p>
                    <p class="font-data-mono text-[28px] font-semibold text-on-surface">
                        <c:choose><c:when test="${not empty allocationList}">${allocationList.size()}</c:when><c:otherwise>0</c:otherwise></c:choose>
                    </p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                    <p class="font-label-caps text-label-caps text-on-surface-variant mb-base">最近分配</p>
                    <p class="font-data-mono text-[14px] font-semibold text-on-surface">
                        <c:if test="${not empty allocationList}">${allocationList[0].allocateTime}</c:if>
                        <c:if test="${empty allocationList}">无数据</c:if>
                    </p>
                </div>
            </div>

            <!-- DataTable -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                <div class="p-md">
                    <table id="allocationTable" class="w-full text-left">
                        <thead>
                            <tr>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">ID</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">学号</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">房间</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">类型</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">楼栋</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">日期</th>
                                <th class="font-label-caps text-label-caps text-on-surface-variant">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${allocationList}" var="allocation">
                                <tr>
                                    <td class="font-data-mono text-data-mono text-primary">#${allocation.id}</td>
                                    <td class="font-body-md text-body-md text-on-surface">
                                        <div class="flex items-center gap-sm">
                                            <span class="material-symbols-outlined text-primary text-[20px]">person</span>
                                            ${allocation.studentId}
                                        </div>
                                    </td>
                                    <td class="font-body-md text-body-md text-on-surface font-semibold">${allocation.dormitoryNumber}</td>
                                    <td>
                                        <span class="inline-flex px-sm py-base bg-green-100 text-green-800 rounded-full font-label-caps text-[11px]">${allocation.dormitoryType}</span>
                                    </td>
                                    <td>
                                        <span class="inline-flex px-sm py-base bg-blue-100 text-blue-800 rounded-full font-label-caps text-[11px]">${allocation.building}</span>
                                    </td>
                                    <td class="font-body-md text-body-md text-on-surface">${allocation.allocateTime}</td>
                                    <td>
                                        <div class="flex gap-xs">
                                            <button class="p-xs bg-primary-fixed text-primary rounded-lg hover:bg-primary hover:text-on-primary transition-colors" title="查看">
                                                <span class="material-symbols-outlined text-[18px]">visibility</span>
                                            </button>
                                            <button class="p-xs bg-secondary-fixed text-secondary rounded-lg hover:bg-secondary hover:text-on-secondary transition-colors" title="编辑">
                                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                            </button>
                                            <button class="p-xs bg-error-container text-on-error-container rounded-lg hover:bg-error hover:text-on-error transition-colors" title="删除">
                                                <span class="material-symbols-outlined text-[18px]">delete</span>
                                            </button>
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
            $('#allocationTable').DataTable({
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
