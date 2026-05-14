<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>审核调换申请 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../../common/sidebar.jsp">
        <jsp:param name="role" value="admin"/>
        <jsp:param name="active" value="transfers"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../../common/topbar.jsp">
            <jsp:param name="role" value="admin"/>
            <jsp:param name="active" value="transfers"/>
        </jsp:include>
        <div class="p-margin max-w-[900px] w-full mx-auto">
            <div class="mb-lg">
                <a href="${pageContext.request.contextPath}/admin/transfer/list" class="inline-flex items-center gap-xs text-on-surface-variant hover:text-primary font-label-caps text-label-caps mb-sm transition-colors">
                    <span class="material-symbols-outlined text-[18px]">arrow_back</span> 返回列表
                </a>
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">swap_horiz</span> 审核调换申请
                </h2>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-gutter">
                <!-- Left: Application Info -->
                <div class="lg:col-span-2 space-y-gutter">
                    <!-- Student Info Card -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">person</span> 申请人信息
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

                    <!-- Current Dormitory Card -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">meeting_room</span> 当前宿舍
                            </h3>
                        </div>
                        <div class="p-md">
                            <c:if test="${not empty allocation}">
                                <div class="flex items-center py-sm border-b border-outline-variant">
                                    <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">房间号</span>
                                    <span class="font-body-md text-body-md text-on-surface font-semibold">${allocation.dormitoryNumber}</span>
                                </div>
                                <div class="flex items-center py-sm border-b border-outline-variant">
                                    <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">类型</span>
                                    <span class="font-body-md text-body-md text-on-surface">${allocation.dormitoryType}</span>
                                </div>
                                <div class="flex items-center py-sm">
                                    <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">楼栋</span>
                                    <span class="font-body-md text-body-md text-on-surface">${allocation.building}</span>
                                </div>
                            </c:if>
                            <c:if test="${empty allocation}">
                                <p class="font-body-md text-body-md text-on-surface-variant">该学生暂无宿舍分配</p>
                            </c:if>
                        </div>
                    </div>

                    <!-- Application Content Card -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">description</span> 申请内容
                            </h3>
                        </div>
                        <div class="p-md">
                            <div class="mb-md">
                                <span class="font-label-caps text-label-caps text-on-surface-variant">意向宿舍</span>
                                <p class="font-body-md text-body-md text-on-surface mt-xs">
                                    <c:choose>
                                        <c:when test="${not empty transfer.targetDormitoryNumber}">${transfer.targetBuilding} ${transfer.targetDormitoryNumber}</c:when>
                                        <c:otherwise><span class="text-on-surface-variant">未指定</span></c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="mb-md">
                                <span class="font-label-caps text-label-caps text-on-surface-variant">申请理由</span>
                                <p class="font-body-md text-body-md text-on-surface mt-xs leading-relaxed whitespace-pre-wrap">${transfer.reason}</p>
                            </div>
                            <c:if test="${not empty transfer.attachment}">
                                <div>
                                    <span class="font-label-caps text-label-caps text-on-surface-variant">附件</span>
                                    <p class="mt-xs">
                                        <a href="${pageContext.request.contextPath}/${transfer.attachment}" target="_blank" class="inline-flex items-center gap-xs px-md py-xs bg-primary-fixed text-primary rounded-lg font-label-caps text-label-caps hover:bg-primary hover:text-on-primary transition-colors">
                                            <span class="material-symbols-outlined text-[18px]">download</span> 下载附件
                                        </a>
                                    </p>
                                </div>
                            </c:if>
                            <div class="mt-md">
                                <span class="font-label-caps text-label-caps text-on-surface-variant">申请时间</span>
                                <p class="font-body-md text-body-md text-on-surface mt-xs">${transfer.applyTime}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Review Panel -->
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
                                <c:when test="${transfer.status == 0}">
                                    <span class="material-symbols-outlined text-[48px] text-yellow-600 mb-sm block">hourglass_top</span>
                                    <p class="font-h3 text-h3 text-yellow-600">待审核</p>
                                </c:when>
                                <c:when test="${transfer.status == 1}">
                                    <span class="material-symbols-outlined text-[48px] text-green-600 mb-sm block">check_circle</span>
                                    <p class="font-h3 text-h3 text-green-600">已通过</p>
                                </c:when>
                                <c:when test="${transfer.status == 2}">
                                    <span class="material-symbols-outlined text-[48px] text-red-600 mb-sm block">cancel</span>
                                    <p class="font-h3 text-h3 text-red-600">已拒绝</p>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${transfer.status == 0}">
                            <!-- Review Form -->
                            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                                <div class="p-md border-b border-outline-variant">
                                    <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                        <span class="material-symbols-outlined text-primary">rate_review</span> 审核操作
                                    </h3>
                                </div>
                                <div class="p-md">
                                    <!-- Approve Form -->
                                    <form id="approveForm" action="${pageContext.request.contextPath}/admin/transfer/approve" method="post">
                                        <input type="hidden" name="id" value="${transfer.id}"/>
                                        <div class="mb-md">
                                            <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">目标宿舍 <span class="text-error">*</span></label>
                                            <select name="targetDormitoryId" required
                                                class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-sm font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors">
                                                <option value="">-- 请选择目标宿舍 --</option>
                                                <c:forEach items="${dormitoryList}" var="d">
                                                    <c:if test="${d.status == 1 && d.currentOccupancy < d.capacity}">
                                                        <option value="${d.id}" ${d.id == transfer.targetDormitoryId ? 'selected' : ''}>
                                                            ${d.building} ${d.dormitoryNumber}（${d.dormitoryType}，空余${d.capacity - d.currentOccupancy}床位）
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-md">
                                            <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">审核意见（可选）</label>
                                            <textarea name="adminComment" rows="2" maxlength="500"
                                                class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-sm font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors resize-none"
                                                placeholder="通过申请的备注..."></textarea>
                                        </div>
                                        <button type="submit" id="approveBtn"
                                            class="w-full py-sm bg-green-600 text-white rounded-lg font-label-caps text-label-caps hover:bg-green-700 transition-all flex items-center justify-center gap-sm mb-sm">
                                            <span class="material-symbols-outlined text-[18px]">check</span> 通过申请
                                        </button>
                                    </form>

                                    <div class="border-t border-outline-variant pt-md">
                                        <form id="rejectForm" action="${pageContext.request.contextPath}/admin/transfer/reject" method="post">
                                            <input type="hidden" name="id" value="${transfer.id}"/>
                                            <div class="mb-md">
                                                <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">拒绝理由 <span class="text-error">*</span></label>
                                                <textarea name="adminComment" rows="2" maxlength="500" required
                                                    class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-sm font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors resize-none"
                                                    placeholder="请填写拒绝理由..."></textarea>
                                            </div>
                                            <button type="submit" id="rejectBtn"
                                                class="w-full py-sm bg-red-600 text-white rounded-lg font-label-caps text-label-caps hover:bg-red-700 transition-all flex items-center justify-center gap-sm">
                                                <span class="material-symbols-outlined text-[18px]">close</span> 拒绝申请
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Review Result -->
                            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                                <div class="p-md border-b border-outline-variant">
                                    <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                        <span class="material-symbols-outlined text-primary">gavel</span> 审核结果
                                    </h3>
                                </div>
                                <div class="p-md">
                                    <div class="mb-md">
                                        <span class="font-label-caps text-label-caps text-on-surface-variant">审核意见</span>
                                        <p class="font-body-md text-body-md text-on-surface mt-xs leading-relaxed">
                                            <c:choose>
                                                <c:when test="${not empty transfer.adminComment}">${transfer.adminComment}</c:when>
                                                <c:otherwise><span class="text-on-surface-variant">无</span></c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <div>
                                        <span class="font-label-caps text-label-caps text-on-surface-variant">审核时间</span>
                                        <p class="font-body-md text-body-md text-on-surface mt-xs">${transfer.reviewTime}</p>
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

            var approveForm = document.getElementById('approveForm');
            if (approveForm) {
                approveForm.addEventListener('submit', function() {
                    var btn = document.getElementById('approveBtn');
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
        });
    </script>
</body>
</html>
