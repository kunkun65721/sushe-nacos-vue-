<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>处理报修 - 宿舍管理系统</title>
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
        <div class="p-margin max-w-[900px] w-full mx-auto">
            <div class="mb-lg">
                <a href="${pageContext.request.contextPath}/admin/repair/list" class="inline-flex items-center gap-xs text-on-surface-variant hover:text-primary font-label-caps text-label-caps mb-sm transition-colors">
                    <span class="material-symbols-outlined text-[18px]">arrow_back</span> 返回列表
                </a>
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">construction</span> 处理报修
                </h2>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-gutter">
                <!-- Left: Repair Info -->
                <div class="lg:col-span-2 space-y-gutter">
                    <!-- Student Info Card -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">person</span> 报修人信息
                            </h3>
                        </div>
                        <div class="p-md">
                            <div class="grid grid-cols-2 gap-sm">
                                <div>
                                    <span class="font-label-caps text-label-caps text-on-surface-variant">姓名</span>
                                    <p class="font-body-md text-body-md text-on-surface font-semibold">${student.name}</p>
                                </div>
                                <div>
                                    <span class="font-label-caps text-label-caps text-on-surface-variant">学号</span>
                                    <p class="font-body-md text-body-md text-on-surface">${student.studentId}</p>
                                </div>
                                <div>
                                    <span class="font-label-caps text-label-caps text-on-surface-variant">专业</span>
                                    <p class="font-body-md text-body-md text-on-surface">${student.major}</p>
                                </div>
                                <div>
                                    <span class="font-label-caps text-label-caps text-on-surface-variant">年级</span>
                                    <p class="font-body-md text-body-md text-on-surface">${student.grade}</p>
                                </div>
                                <div>
                                    <span class="font-label-caps text-label-caps text-on-surface-variant">性别</span>
                                    <p class="font-body-md text-body-md text-on-surface">${student.gender == 0 ? '男' : '女'}</p>
                                </div>
                                <div>
                                    <span class="font-label-caps text-label-caps text-on-surface-variant">电话</span>
                                    <p class="font-body-md text-body-md text-on-surface">${student.phone}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Dormitory Info Card -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">meeting_room</span> 报修宿舍
                            </h3>
                        </div>
                        <div class="p-md">
                            <c:if test="${not empty repair.dormitoryNumber}">
                                <div class="flex items-center py-sm border-b border-outline-variant">
                                    <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">房间号</span>
                                    <span class="font-body-md text-body-md text-on-surface font-semibold">${repair.dormitoryNumber}</span>
                                </div>
                                <div class="flex items-center py-sm">
                                    <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">楼栋</span>
                                    <span class="font-body-md text-body-md text-on-surface">${repair.building}</span>
                                </div>
                            </c:if>
                            <c:if test="${empty repair.dormitoryNumber}">
                                <p class="font-body-md text-body-md text-on-surface-variant">暂无宿舍信息</p>
                            </c:if>
                        </div>
                    </div>

                    <!-- Repair Content Card -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">description</span> 报修内容
                            </h3>
                        </div>
                        <div class="p-md">
                            <div class="mb-md">
                                <span class="font-label-caps text-label-caps text-on-surface-variant">问题描述</span>
                                <p class="font-body-md text-body-md text-on-surface mt-xs leading-relaxed whitespace-pre-wrap">${repair.description}</p>
                            </div>
                            <c:if test="${not empty repair.image}">
                                <div class="mb-md">
                                    <span class="font-label-caps text-label-caps text-on-surface-variant">现场照片</span>
                                    <p class="mt-xs">
                                        <a href="${pageContext.request.contextPath}/${repair.image}" target="_blank" class="inline-flex items-center gap-xs px-md py-xs bg-primary-fixed text-primary rounded-lg font-label-caps text-label-caps hover:bg-primary hover:text-on-primary transition-colors">
                                            <span class="material-symbols-outlined text-[18px]">image</span> 查看照片
                                        </a>
                                    </p>
                                </div>
                            </c:if>
                            <div>
                                <span class="font-label-caps text-label-caps text-on-surface-variant">提交时间</span>
                                <p class="font-body-md text-body-md text-on-surface mt-xs">${repair.createTime}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Process Panel -->
                <div class="space-y-gutter">
                    <!-- Status Card -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">info</span> 状态
                            </h3>
                        </div>
                        <div class="p-md text-center">
                            <c:choose>
                                <c:when test="${repair.status == 0}">
                                    <span class="material-symbols-outlined text-[48px] text-yellow-600 mb-sm block">pending</span>
                                    <p class="font-h3 text-h3 text-yellow-600">待处理</p>
                                </c:when>
                                <c:when test="${repair.status == 1}">
                                    <span class="material-symbols-outlined text-[48px] text-blue-600 mb-sm block">engineering</span>
                                    <p class="font-h3 text-h3 text-blue-600">处理中</p>
                                </c:when>
                                <c:when test="${repair.status == 2}">
                                    <span class="material-symbols-outlined text-[48px] text-green-600 mb-sm block">check_circle</span>
                                    <p class="font-h3 text-h3 text-green-600">已完成</p>
                                </c:when>
                                <c:when test="${repair.status == 3}">
                                    <span class="material-symbols-outlined text-[48px] text-red-600 mb-sm block">cancel</span>
                                    <p class="font-h3 text-h3 text-red-600">已拒绝</p>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${repair.status == 0}">
                            <!-- Process Form for Pending -->
                            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                                <div class="p-md border-b border-outline-variant">
                                    <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                        <span class="material-symbols-outlined text-primary">rate_review</span> 处理操作
                                    </h3>
                                </div>
                                <div class="p-md">
                                    <!-- Mark as Processing -->
                                    <form id="processForm" action="${pageContext.request.contextPath}/admin/repair/process" method="post">
                                        <input type="hidden" name="id" value="${repair.id}"/>
                                        <div class="mb-md">
                                            <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">备注（可选）</label>
                                            <textarea name="adminComment" rows="2" maxlength="500"
                                                class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-sm font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors resize-none"
                                                placeholder="处理备注..."></textarea>
                                        </div>
                                        <button type="submit" id="processBtn"
                                            class="w-full py-sm bg-blue-600 text-white rounded-lg font-label-caps text-label-caps hover:bg-blue-700 transition-all flex items-center justify-center gap-sm mb-sm">
                                            <span class="material-symbols-outlined text-[18px]">engineering</span> 标记处理中
                                        </button>
                                    </form>

                                    <div class="border-t border-outline-variant pt-md">
                                        <form id="rejectForm" action="${pageContext.request.contextPath}/admin/repair/reject" method="post">
                                            <input type="hidden" name="id" value="${repair.id}"/>
                                            <div class="mb-md">
                                                <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">拒绝理由</label>
                                                <textarea name="adminComment" rows="2" maxlength="500"
                                                    class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-sm font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors resize-none"
                                                    placeholder="请填写拒绝理由（可选）..."></textarea>
                                            </div>
                                            <button type="submit" id="rejectBtn"
                                                class="w-full py-sm bg-red-600 text-white rounded-lg font-label-caps text-label-caps hover:bg-red-700 transition-all flex items-center justify-center gap-sm">
                                                <span class="material-symbols-outlined text-[18px]">close</span> 拒绝报修
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${repair.status == 1}">
                            <!-- Process Form for In-Progress -->
                            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                                <div class="p-md border-b border-outline-variant">
                                    <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                        <span class="material-symbols-outlined text-primary">rate_review</span> 处理操作
                                    </h3>
                                </div>
                                <div class="p-md">
                                    <form id="completeForm" action="${pageContext.request.contextPath}/admin/repair/complete" method="post">
                                        <input type="hidden" name="id" value="${repair.id}"/>
                                        <div class="mb-md">
                                            <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">完成备注</label>
                                            <textarea name="adminComment" rows="2" maxlength="500"
                                                class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-sm font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors resize-none"
                                                placeholder="维修完成说明...">${repair.adminComment}</textarea>
                                        </div>
                                        <button type="submit" id="completeBtn"
                                            class="w-full py-sm bg-green-600 text-white rounded-lg font-label-caps text-label-caps hover:bg-green-700 transition-all flex items-center justify-center gap-sm">
                                            <span class="material-symbols-outlined text-[18px]">check</span> 标记已完成
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Result Display -->
                            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                                <div class="p-md border-b border-outline-variant">
                                    <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                        <span class="material-symbols-outlined text-primary">gavel</span> 处理结果
                                    </h3>
                                </div>
                                <div class="p-md">
                                    <div class="mb-md">
                                        <span class="font-label-caps text-label-caps text-on-surface-variant">处理意见</span>
                                        <p class="font-body-md text-body-md text-on-surface mt-xs leading-relaxed">
                                            <c:choose>
                                                <c:when test="${not empty repair.adminComment}">${repair.adminComment}</c:when>
                                                <c:otherwise><span class="text-on-surface-variant">无</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div>
                                        <span class="font-label-caps text-label-caps text-on-surface-variant">处理时间</span>
                                        <p class="font-body-md text-body-md text-on-surface mt-xs">${repair.updateTime}</p>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('main .p-margin').classList.add('page-enter');

            var processForm = document.getElementById('processForm');
            if (processForm) {
                processForm.addEventListener('submit', function() {
                    var btn = document.getElementById('processBtn');
                    btn.innerHTML = '<span class="spinner" style="width:14px;height:14px;border-width:2px;"></span> 处理中...';
                    btn.disabled = true;
                });
            }
            var rejectForm = document.getElementById('rejectForm');
            if (rejectForm) {
                rejectForm.addEventListener('submit', function() {
                    var btn = document.getElementById('rejectBtn');
                    btn.innerHTML = '<span class="spinner" style="width:14px;height:14px;border-width:2px;"></span> 处理中...';
                    btn.disabled = true;
                });
            }
            var completeForm = document.getElementById('completeForm');
            if (completeForm) {
                completeForm.addEventListener('submit', function() {
                    var btn = document.getElementById('completeBtn');
                    btn.innerHTML = '<span class="spinner" style="width:14px;height:14px;border-width:2px;"></span> 处理中...';
                    btn.disabled = true;
                });
            }
        });
    </script>
</body>
</html>
