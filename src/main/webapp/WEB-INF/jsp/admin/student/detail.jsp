<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>学生详情 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../../common/sidebar.jsp">
        <jsp:param name="role" value="admin"/>
        <jsp:param name="active" value="students"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../../common/topbar.jsp">
            <jsp:param name="role" value="admin"/>
            <jsp:param name="active" value="students"/>
        </jsp:include>
        <div class="p-margin max-w-[1000px] w-full mx-auto">
            <div class="flex items-center gap-sm mb-lg">
                <a href="${pageContext.request.contextPath}/admin/student/list" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-lg transition-colors">
                    <span class="material-symbols-outlined">arrow_back</span>
                </a>
                <div>
                    <h2 class="font-h2 text-h2 text-on-surface">学生详情</h2>
                    <p class="font-body-md text-body-md text-on-surface-variant mt-xs">${student.name} - ${student.studentId}</p>
                </div>
            </div>

            <!-- Basic Info -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft mb-gutter">
                <h3 class="font-h3 text-h3 text-on-surface border-b border-outline-variant pb-xs mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">badge</span> 基本信息
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">person</span>姓名:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.name}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">wc</span>性别:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.gender == 0 ? '男' : '女'}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">school</span>专业:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.major}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">workspace_premium</span>年级:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.grade}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">credit_card</span>学号:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.studentId}</span>
                    </div>
                    <div class="flex items-center py-sm border-b border-outline-variant">
                        <span class="w-[100px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">call</span>电话:</span>
                        <span class="font-body-md text-body-md text-on-surface">${student.phone}</span>
                    </div>
                </div>
            </div>

            <!-- Lifestyle Questionnaire -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft mb-gutter">
                <h3 class="font-h3 text-h3 text-on-surface border-b border-outline-variant pb-xs mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">quiz</span> 生活习惯问卷
                </h3>
                <c:if test="${questionnaire != null}">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">bedtime</span>入睡时间:</span>
                            <span class="font-body-md text-body-md text-on-surface">${questionnaire.sleepTime}</span>
                        </div>
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">wb_sunny</span>起床时间:</span>
                            <span class="font-body-md text-body-md text-on-surface">${questionnaire.wakeUpTime}</span>
                        </div>
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">smoking_rooms</span>吸烟:</span>
                            <span class="font-body-md text-body-md text-on-surface">${questionnaire.smoking == 0 ? '否' : '是'}</span>
                        </div>
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">local_bar</span>饮酒:</span>
                            <span class="font-body-md text-body-md text-on-surface">${questionnaire.drinking == 0 ? '否' : '是'}</span>
                        </div>
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">volume_up</span>噪音耐受度:</span>
                            <span class="font-body-md text-body-md text-on-surface">${questionnaire.noiseTolerance}</span>
                        </div>
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">cleaning_services</span>整洁度:</span>
                            <span class="font-body-md text-body-md text-on-surface">${questionnaire.cleanliness}</span>
                        </div>
                        <div class="flex items-center py-sm col-span-2 border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">sticky_note_2</span>备注:</span>
                            <span class="font-body-md text-body-md text-on-surface">${questionnaire.note != null ? questionnaire.note : '无'}</span>
                        </div>
                    </div>
                </c:if>
                <c:if test="${questionnaire == null}">
                    <div class="bg-error-container text-on-error-container rounded-lg p-sm font-body-md text-body-md flex items-center gap-xs">
                        <span class="material-symbols-outlined text-[18px]">error</span>
                        该学生尚未提交生活习惯问卷。
                    </div>
                </c:if>
            </div>

            <!-- Dormitory Allocation -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                <h3 class="font-h3 text-h3 text-on-surface border-b border-outline-variant pb-xs mb-md flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">king_bed</span> 宿舍分配
                </h3>
                <c:if test="${allocation != null}">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-sm">
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">domain</span>房间:</span>
                            <span class="font-body-md text-body-md text-on-surface">${allocation.dormitoryNumber}</span>
                        </div>
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">category</span>类型:</span>
                            <span class="font-body-md text-body-md text-on-surface">${allocation.dormitoryType}</span>
                        </div>
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">apartment</span>楼栋:</span>
                            <span class="font-body-md text-body-md text-on-surface">${allocation.building}</span>
                        </div>
                        <div class="flex items-center py-sm border-b border-outline-variant">
                            <span class="w-[120px] font-label-caps text-label-caps text-on-surface-variant flex items-center gap-xs"><span class="material-symbols-outlined text-[16px] text-primary">calendar_today</span>日期:</span>
                            <span class="font-body-md text-body-md text-on-surface">${allocation.allocateTime}</span>
                        </div>
                    </div>
                </c:if>
                <c:if test="${allocation == null}">
                    <div class="bg-error-container text-on-error-container rounded-lg p-sm font-body-md text-body-md flex items-center gap-xs mb-md">
                        <span class="material-symbols-outlined text-[18px]">error</span>
                        该学生尚未分配宿舍。
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/allocation/allocate?studentId=${student.id}" class="inline-flex items-center gap-xs px-md py-xs bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all">
                        <span class="material-symbols-outlined text-[18px]">bed</span> 分配房间
                    </a>
                </c:if>
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
