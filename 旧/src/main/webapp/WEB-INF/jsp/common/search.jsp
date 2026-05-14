<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="head.jsp" %>
    <title>搜索结果 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="role" value="${role}"/>
        <jsp:param name="active" value=""/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="topbar.jsp">
            <jsp:param name="role" value="${role}"/>
            <jsp:param name="active" value=""/>
        </jsp:include>
        <div class="p-margin max-w-[700px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">search</span> 搜索结果
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">"<span class="text-on-surface font-semibold">${keyword}</span>" 的搜索结果。</p>
            </div>

            <c:choose>
                <c:when test="${not empty results && fn:length(results) > 0}">
                    <div class="space-y-sm">
                        <c:forEach items="${results}" var="item">
                            <a href="${pageContext.request.contextPath}${item.path}" class="flex items-center gap-md bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft hover:shadow-expand transition-all hover:translate-x-1 duration-200">
                                <div class="w-10 h-10 bg-primary-fixed rounded-full flex items-center justify-center flex-shrink-0">
                                    <span class="material-symbols-outlined text-on-primary-fixed-variant">${item.icon}</span>
                                </div>
                                <div class="flex-1">
                                    <h3 class="font-h3 text-h3 text-on-surface">${item.name}</h3>
                                    <p class="font-body-md text-body-md text-on-surface-variant">${item.description}</p>
                                </div>
                                <span class="material-symbols-outlined text-outline">chevron_right</span>
                            </a>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-xxl">
                        <span class="material-symbols-outlined text-[64px] text-outline-variant">search_off</span>
                        <p class="font-body-lg text-body-lg text-on-surface-variant mt-md">未找到与 "${keyword}" 相关的功能</p>
                        <p class="font-body-md text-body-md text-on-surface-variant mt-sm">请尝试其他关键词</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</body>
</html>
