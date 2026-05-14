<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>生活习惯问卷 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../../common/sidebar.jsp">
        <jsp:param name="role" value="admin"/>
        <jsp:param name="active" value="lifestyle"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../../common/topbar.jsp">
            <jsp:param name="role" value="admin"/>
            <jsp:param name="active" value="lifestyle"/>
        </jsp:include>
        <div class="p-margin max-w-[1600px] w-full mx-auto">
            <div class="flex justify-between items-center mb-lg">
                <div>
                    <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">quiz</span> 生活习惯问卷
                    </h2>
                    <p class="font-body-md text-body-md text-on-surface-variant mt-xs">查看学生生活习惯问卷提交情况。</p>
                </div>
            </div>
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead>
                            <tr class="border-b-2 border-outline-variant">
                                <th class="px-md py-sm font-label-caps text-label-caps text-on-surface-variant">ID</th>
                                <th class="px-md py-sm font-label-caps text-label-caps text-on-surface-variant">姓名</th>
                                <th class="px-md py-sm font-label-caps text-label-caps text-on-surface-variant">学号</th>
                                <th class="px-md py-sm font-label-caps text-label-caps text-on-surface-variant">状态</th>
                                <th class="px-md py-sm font-label-caps text-label-caps text-on-surface-variant">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${studentList}" var="student">
                                <tr class="border-b border-outline-variant hover:bg-surface-container transition-colors">
                                    <td class="px-md py-sm font-body-md text-body-md text-on-surface">${student.id}</td>
                                    <td class="px-md py-sm font-body-md text-body-md text-on-surface font-semibold">${student.name}</td>
                                    <td class="px-md py-sm font-body-md text-body-md text-on-surface">${student.studentId}</td>
                                    <td class="px-md py-sm">
                                        <c:choose>
                                            <c:when test="${questionnaireStatusMap[student.id]}">
                                                <span class="inline-flex items-center gap-xs px-sm py-base bg-green-100 text-green-800 rounded-full font-label-caps text-[11px]">
                                                    <span class="material-symbols-outlined text-[14px]">check_circle</span> 已提交
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center gap-xs px-sm py-base bg-red-100 text-red-800 rounded-full font-label-caps text-[11px]">
                                                    <span class="material-symbols-outlined text-[14px]">cancel</span> 未提交
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-md py-sm">
                                        <a href="${pageContext.request.contextPath}/admin/habitQuestionnaire/detail?studentId=${student.id}" class="p-xs bg-primary-fixed text-primary rounded-lg hover:bg-primary hover:text-on-primary transition-colors inline-flex items-center gap-xs">
                                            <span class="material-symbols-outlined text-[18px]">visibility</span>
                                            <span class="font-label-caps text-label-caps">查看</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
