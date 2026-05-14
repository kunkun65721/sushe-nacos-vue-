<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../common/head.jsp" %>
    <title>报修申请 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="role" value="student"/>
        <jsp:param name="active" value="repair"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../common/topbar.jsp">
            <jsp:param name="role" value="student"/>
            <jsp:param name="active" value="repair"/>
        </jsp:include>
        <div class="p-margin max-w-[800px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">build</span> 报修申请
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">提交宿舍设施报修并查看处理进度。</p>
            </div>

            <c:choose>
                <c:when test="${allocation == null}">
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-xl shadow-soft text-center">
                        <span class="material-symbols-outlined text-[56px] text-outline mb-md">error_outline</span>
                        <h3 class="font-h3 text-h3 text-on-surface mb-sm">无法提交报修</h3>
                        <p class="font-body-md text-body-md text-on-surface-variant mb-lg">您尚未分配宿舍，请先等待管理员分配宿舍后再提交报修。</p>
                        <a href="${pageContext.request.contextPath}/student/dormitoryAllocation" class="inline-flex items-center gap-xs px-md py-xs bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all">
                            <span class="material-symbols-outlined text-[18px]">king_bed</span> 查看宿舍分配
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- 当前宿舍信息 -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden mb-gutter">
                        <div class="bg-primary text-on-primary p-md text-center">
                            <span class="material-symbols-outlined text-[40px] mb-sm">meeting_room</span>
                            <h3 class="font-h3 text-h3">${allocation.dormitoryNumber}</h3>
                            <p class="font-body-md text-body-md opacity-80">当前宿舍</p>
                        </div>
                        <div class="p-md">
                            <div class="flex items-center py-sm border-b border-outline-variant">
                                <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">房间类型</span>
                                <span class="font-body-md text-body-md text-on-surface">${allocation.dormitoryType}</span>
                            </div>
                            <div class="flex items-center py-sm border-b border-outline-variant">
                                <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">楼栋</span>
                                <span class="font-body-md text-body-md text-on-surface">${allocation.building}</span>
                            </div>
                            <div class="flex items-center py-sm">
                                <span class="font-label-caps text-label-caps text-on-surface-variant w-[100px]">分配日期</span>
                                <span class="font-body-md text-body-md text-on-surface">${allocation.allocateTime}</span>
                            </div>
                        </div>
                    </div>

                    <!-- 提交报修表单 -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden mb-gutter">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">edit_note</span> 提交报修
                            </h3>
                        </div>
                        <div class="p-md">
                            <form id="repairForm" action="${pageContext.request.contextPath}/student/repair" method="post" enctype="multipart/form-data">
                                <div class="mb-md">
                                    <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">问题描述 <span class="text-error">*</span></label>
                                    <textarea name="description" rows="4" maxlength="500" required
                                        class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-sm font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors resize-none"
                                        placeholder="请详细描述需要报修的问题，例如：空调不制冷、水管漏水等..."></textarea>
                                    <p class="font-body-sm text-[12px] text-on-surface-variant mt-xs">最多500字</p>
                                </div>
                                <div class="mb-md">
                                    <label class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">现场照片（可选）</label>
                                    <div class="border border-dashed border-outline-variant rounded-lg p-md text-center bg-surface-container-lowest">
                                        <span class="material-symbols-outlined text-[40px] text-outline mb-sm block">add_a_photo</span>
                                        <p class="font-body-md text-body-md text-on-surface-variant mb-sm">点击上传现场照片</p>
                                        <p class="font-body-sm text-[12px] text-on-surface-variant mb-sm">支持图片格式，单文件不超过10MB</p>
                                        <input type="file" name="image" id="imageInput" accept="image/*"
                                            class="block w-full font-body-md text-body-md text-on-surface file:mr-md file:py-xs file:px-md file:rounded-lg file:border-0 file:bg-primary file:text-on-primary file:font-label-caps file:text-label-caps hover:file:bg-on-primary-fixed-variant file:cursor-pointer file:transition-colors"/>
                                        <p id="fileNameDisplay" class="font-body-md text-body-md text-primary mt-sm hidden"></p>
                                    </div>
                                </div>
                                <div class="flex justify-end">
                                    <button type="submit" id="submitBtn"
                                        class="inline-flex items-center gap-xs px-lg py-sm bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all">
                                        <span class="material-symbols-outlined text-[18px]">send</span> 提交报修
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- 报修历史 -->
                    <div class="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-soft overflow-hidden">
                        <div class="p-md border-b border-outline-variant">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm">
                                <span class="material-symbols-outlined text-primary">history</span> 报修记录
                            </h3>
                        </div>
                        <c:choose>
                            <c:when test="${empty repairList}">
                                <div class="p-xl text-center">
                                    <span class="material-symbols-outlined text-[40px] text-outline mb-sm block">inbox</span>
                                    <p class="font-body-md text-body-md text-on-surface-variant">暂无报修记录</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="overflow-x-auto">
                                    <table class="w-full">
                                        <thead>
                                            <tr class="border-b border-outline-variant">
                                                <th class="font-label-caps text-label-caps text-on-surface-variant text-left p-sm">提交时间</th>
                                                <th class="font-label-caps text-label-caps text-on-surface-variant text-left p-sm">问题描述</th>
                                                <th class="font-label-caps text-label-caps text-on-surface-variant text-left p-sm">照片</th>
                                                <th class="font-label-caps text-label-caps text-on-surface-variant text-left p-sm">状态</th>
                                                <th class="font-label-caps text-label-caps text-on-surface-variant text-left p-sm">管理员回复</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${repairList}" var="r">
                                                <tr class="border-b border-outline-variant hover:bg-surface-container transition-colors">
                                                    <td class="p-sm font-body-md text-body-md text-on-surface">${r.createTime}</td>
                                                    <td class="p-sm font-body-md text-body-md text-on-surface max-w-[200px] truncate" title="${r.description}">${r.description}</td>
                                                    <td class="p-sm">
                                                        <c:if test="${not empty r.image}">
                                                            <a href="${pageContext.request.contextPath}/${r.image}" target="_blank" class="inline-flex items-center gap-xs text-primary hover:text-on-primary-fixed-variant font-label-caps text-label-caps">
                                                                <span class="material-symbols-outlined text-[18px]">image</span>查看
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${empty r.image}"><span class="text-on-surface-variant">-</span></c:if>
                                                    </td>
                                                    <td class="p-sm">
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
                                                    <td class="p-sm font-body-md text-body-md text-on-surface max-w-[200px] truncate" title="${r.adminComment}">
                                                        <c:choose>
                                                            <c:when test="${not empty r.adminComment}">${r.adminComment}</c:when>
                                                            <c:otherwise><span class="text-on-surface-variant">-</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelector('main .p-margin').classList.add('page-enter');

            var fileInput = document.getElementById('imageInput');
            var fileNameDisplay = document.getElementById('fileNameDisplay');
            if (fileInput && fileNameDisplay) {
                fileInput.addEventListener('change', function() {
                    if (this.files && this.files.length > 0) {
                        fileNameDisplay.textContent = '已选择：' + this.files[0].name;
                        fileNameDisplay.classList.remove('hidden');
                    } else {
                        fileNameDisplay.classList.add('hidden');
                    }
                });
            }

            var form = document.getElementById('repairForm');
            if (form) {
                form.addEventListener('submit', function() {
                    var btn = document.getElementById('submitBtn');
                    btn.innerHTML = '<span class="spinner" style="width:14px;height:14px;border-width:2px;"></span> 提交中...';
                    btn.disabled = true;
                });
            }
        });
    </script>
</body>
</html>
