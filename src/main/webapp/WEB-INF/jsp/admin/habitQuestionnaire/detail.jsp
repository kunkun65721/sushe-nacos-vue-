<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>问卷详情 - 宿舍管理系统</title>
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
        <div class="p-margin max-w-[900px] w-full mx-auto">
            <div class="flex items-center gap-sm mb-lg">
                <a href="${pageContext.request.contextPath}/admin/habitQuestionnaire/list" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-lg transition-colors">
                    <span class="material-symbols-outlined">arrow_back</span>
                </a>
                <div>
                    <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">quiz</span> 问卷详情
                    </h2>
                    <p class="font-body-md text-body-md text-on-surface-variant mt-xs">查看学生生活习惯问卷。</p>
                </div>
            </div>

            <!-- Student Info -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft mb-gutter">
                <h3 class="font-h3 text-h3 text-on-surface border-b border-outline-variant pb-xs mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">person</span> 学生信息
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant">姓名:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.name}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant">学号:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.studentId}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant">专业:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.major}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant">年级:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.grade}</span>
                    </div>
                </div>
            </div>

            <!-- Questionnaire Data -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                <h3 class="font-h3 text-h3 text-on-surface border-b border-outline-variant pb-xs mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">clipboard_check</span> 生活习惯回答
                </h3>
                <c:choose>
                    <c:when test="${questionnaire != null}">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
                            <div class="flex items-center py-sm border-b border-outline-variant">
                                <span class="w-[130px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">bedtime</span>入睡时间:</span>
                                <span class="font-body-md text-body-md text-on-surface">${questionnaire.sleepTime}</span>
                            </div>
                            <div class="flex items-center py-sm border-b border-outline-variant">
                                <span class="w-[130px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">wb_sunny</span>起床时间:</span>
                                <span class="font-body-md text-body-md text-on-surface">${questionnaire.wakeUpTime}</span>
                            </div>
                            <div class="flex items-center py-sm border-b border-outline-variant">
                                <span class="w-[130px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">smoking_rooms</span>吸烟:</span>
                                <span class="font-body-md text-body-md text-on-surface">
                                    <span class="inline-flex px-sm py-base rounded-full font-label-caps text-[11px] ${questionnaire.smoking == 0 ? 'bg-green-100 text-green-800' : 'bg-orange-100 text-orange-800'}">${questionnaire.smoking == 0 ? '否' : '是'}</span>
                                </span>
                            </div>
                            <div class="flex items-center py-sm border-b border-outline-variant">
                                <span class="w-[130px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">local_bar</span>饮酒:</span>
                                <span class="font-body-md text-body-md text-on-surface">
                                    <span class="inline-flex px-sm py-base rounded-full font-label-caps text-[11px] ${questionnaire.drinking == 0 ? 'bg-green-100 text-green-800' : 'bg-orange-100 text-orange-800'}">${questionnaire.drinking == 0 ? '否' : '是'}</span>
                                </span>
                            </div>
                            <div class="flex items-center py-sm border-b border-outline-variant">
                                <span class="w-[130px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">volume_up</span>噪音:</span>
                                <span class="font-body-md text-body-md text-on-surface">${questionnaire.noiseTolerance}</span>
                            </div>
                            <div class="flex items-center py-sm border-b border-outline-variant">
                                <span class="w-[130px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">cleaning_services</span>整洁度:</span>
                                <span class="font-body-md text-body-md text-on-surface">${questionnaire.cleanliness}</span>
                            </div>
                            <div class="flex items-center py-sm col-span-2 border-b border-outline-variant">
                                <span class="w-[130px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">sticky_note_2</span>备注:</span>
                                <span class="font-body-md text-body-md text-on-surface"><c:choose><c:when test="${not empty questionnaire.note}">${questionnaire.note}</c:when><c:otherwise>无</c:otherwise></c:choose></span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-lg">
                            <span class="material-symbols-outlined text-[48px] text-outline mb-md">error_outline</span>
                            <p class="font-h3 text-h3 text-on-surface-variant">未找到问卷数据</p>
                            <p class="font-body-md text-body-md text-outline mt-xs">该学生尚未提交生活习惯问卷。</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="mt-md">
                <a href="${pageContext.request.contextPath}/admin/habitQuestionnaire/list" class="inline-flex items-center gap-xs px-md py-xs bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all">
                    <span class="material-symbols-outlined text-[18px]">list</span> 返回列表
                </a>
            </div>
        </div>
    </main>
</body>
</html>
