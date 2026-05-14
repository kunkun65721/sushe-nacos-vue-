<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <title>添加宿舍 - 宿舍管理系统</title>
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
        <div class="p-margin max-w-[600px] w-full mx-auto">
            <div class="flex items-center gap-sm mb-lg">
                <a href="${pageContext.request.contextPath}/admin/dormitory/list" class="p-xs text-on-surface-variant hover:bg-surface-container rounded-lg transition-colors">
                    <span class="material-symbols-outlined">arrow_back</span>
                </a>
                <div>
                    <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                        <span class="material-symbols-outlined text-primary">add_circle</span> 添加宿舍
                    </h2>
                    <p class="font-body-md text-body-md text-on-surface-variant mt-xs">在系统中注册新的宿舍房间。</p>
                </div>
            </div>
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft">
                <form action="${pageContext.request.contextPath}/admin/dormitory/add" method="post" id="dormitoryForm">
                    <div class="mb-md">
                        <label for="dormitoryNumber" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">tag</span> 房间号
                        </label>
                        <input type="text" id="dormitoryNumber" name="dormitoryNumber" required
                               class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors"
                               placeholder="如 A101">
                    </div>
                    <div class="mb-md">
                        <label for="dormitoryType" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">category</span> 房间类型
                        </label>
                        <select id="dormitoryType" name="dormitoryType" required class="form-select">
                            <option value="">选择类型...</option>
                            <option value="4人间">4人间</option>
                            <option value="6人间">6人间</option>
                            <option value="8人间">8人间</option>
                            <option value="其他">其他</option>
                        </select>
                    </div>
                    <div class="mb-md">
                        <label for="capacity" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">groups</span> 容量
                        </label>
                        <input type="number" id="capacity" name="capacity" required
                               class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors"
                               placeholder="输入容量">
                    </div>
                    <div class="mb-md">
                        <label for="building" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">apartment</span> 楼栋
                        </label>
                        <input type="text" id="building" name="building" required
                               class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors"
                               placeholder="如 A栋">
                    </div>
                    <div class="mb-lg">
                        <label for="status" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">toggle_on</span> 状态
                        </label>
                        <select id="status" name="status" required class="form-select">
                            <option value="1">启用</option>
                            <option value="0">禁用</option>
                        </select>
                    </div>
                    <div class="flex justify-end gap-sm">
                        <a href="${pageContext.request.contextPath}/admin/dormitory/list" class="px-md py-xs border border-outline-variant text-on-surface-variant rounded-lg font-label-caps text-label-caps hover:bg-surface-container transition-all flex items-center gap-xs">
                            <span class="material-symbols-outlined text-[18px]">arrow_back</span> 取消
                        </a>
                        <button type="submit" id="submitBtn" class="px-md py-xs bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all flex items-center gap-xs">
                            <span class="material-symbols-outlined text-[18px]">save</span> 保存
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    <script>
        document.getElementById('dormitoryForm').addEventListener('submit', function() {
            var btn = document.getElementById('submitBtn');
            btn.innerHTML = '<span class="spinner" style="width:14px;height:14px;border-width:2px;"></span> 保存中...';
            btn.disabled = true;
        });
    </script>
</body>
</html>
