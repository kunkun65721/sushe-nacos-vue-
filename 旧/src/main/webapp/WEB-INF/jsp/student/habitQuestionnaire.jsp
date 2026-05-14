<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../common/head.jsp" %>
    <title>生活习惯问卷 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="role" value="student"/>
        <jsp:param name="active" value="lifestyle"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../common/topbar.jsp">
            <jsp:param name="role" value="student"/>
            <jsp:param name="active" value="lifestyle"/>
        </jsp:include>
        <div class="p-margin max-w-[700px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">quiz</span> 生活习惯问卷
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">通过分享您的偏好来帮助我们为您匹配合适的室友。</p>
            </div>

            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                <c:if test="${not empty successMessage}">
                    <div class="bg-green-100 text-green-800 rounded-lg p-sm mb-lg font-body-md text-body-md flex items-center gap-sm">
                        <span class="material-symbols-outlined text-[20px]">check_circle</span>
                        ${successMessage}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/student/habitQuestionnaire" method="post" id="questionnaireForm">
                    <!-- Sleep Time -->
                    <div class="mb-lg">
                        <label for="sleepTime" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">bedtime</span> 入睡时间
                        </label>
                        <select id="sleepTime" name="sleepTime" required
                                class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors appearance-none bg-[url('data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%2224%22 height=%2224%22 viewBox=%220 0 24 24%22><path fill=%22%23666%22 d=%22M7 10l5 5 5-5z%22/></svg>')] bg-no-repeat bg-[right_0.5rem_center] bg-[length:20px] pr-2xl">
                            <option value="">请选择入睡时间</option>
                            <option value="21:00" ${questionnaire.sleepTime == '21:00' ? 'selected' : ''}>21:00</option>
                            <option value="21:30" ${questionnaire.sleepTime == '21:30' ? 'selected' : ''}>21:30</option>
                            <option value="22:00" ${questionnaire.sleepTime == '22:00' ? 'selected' : ''}>22:00</option>
                            <option value="22:30" ${questionnaire.sleepTime == '22:30' ? 'selected' : ''}>22:30</option>
                            <option value="23:00" ${questionnaire.sleepTime == '23:00' ? 'selected' : ''}>23:00</option>
                            <option value="23:30" ${questionnaire.sleepTime == '23:30' ? 'selected' : ''}>23:30</option>
                            <option value="00:00" ${questionnaire.sleepTime == '00:00' ? 'selected' : ''}>00:00</option>
                            <option value="00:30" ${questionnaire.sleepTime == '00:30' ? 'selected' : ''}>00:30</option>
                            <option value="01:00" ${questionnaire.sleepTime == '01:00' ? 'selected' : ''}>01:00</option>
                            <option value="01:30" ${questionnaire.sleepTime == '01:30' ? 'selected' : ''}>01:30</option>
                            <option value="02:00" ${questionnaire.sleepTime == '02:00' ? 'selected' : ''}>02:00</option>
                        </select>
                    </div>

                    <!-- Wake Up Time -->
                    <div class="mb-lg">
                        <label for="wakeUpTime" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">wb_sunny</span> 起床时间
                        </label>
                        <select id="wakeUpTime" name="wakeUpTime" required
                                class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors appearance-none bg-[url('data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%2224%22 height=%2224%22 viewBox=%220 0 24 24%22><path fill=%22%23666%22 d=%22M7 10l5 5 5-5z%22/></svg>')] bg-no-repeat bg-[right_0.5rem_center] bg-[length:20px] pr-2xl">
                            <option value="">请选择起床时间</option>
                            <option value="05:00" ${questionnaire.wakeUpTime == '05:00' ? 'selected' : ''}>05:00</option>
                            <option value="05:30" ${questionnaire.wakeUpTime == '05:30' ? 'selected' : ''}>05:30</option>
                            <option value="06:00" ${questionnaire.wakeUpTime == '06:00' ? 'selected' : ''}>06:00</option>
                            <option value="06:30" ${questionnaire.wakeUpTime == '06:30' ? 'selected' : ''}>06:30</option>
                            <option value="07:00" ${questionnaire.wakeUpTime == '07:00' ? 'selected' : ''}>07:00</option>
                            <option value="07:30" ${questionnaire.wakeUpTime == '07:30' ? 'selected' : ''}>07:30</option>
                            <option value="08:00" ${questionnaire.wakeUpTime == '08:00' ? 'selected' : ''}>08:00</option>
                            <option value="08:30" ${questionnaire.wakeUpTime == '08:30' ? 'selected' : ''}>08:30</option>
                            <option value="09:00" ${questionnaire.wakeUpTime == '09:00' ? 'selected' : ''}>09:00</option>
                            <option value="09:30" ${questionnaire.wakeUpTime == '09:30' ? 'selected' : ''}>09:30</option>
                            <option value="10:00" ${questionnaire.wakeUpTime == '10:00' ? 'selected' : ''}>10:00</option>
                        </select>
                    </div>

                    <!-- Smoking -->
                    <div class="mb-lg">
                        <span class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">smoking_rooms</span> 吸烟
                        </span>
                        <div class="flex gap-lg">
                            <label class="flex items-center gap-xs cursor-pointer">
                                <input type="radio" name="smoking" value="0" ${questionnaire.smoking == 0 || empty questionnaire ? 'checked' : ''} class="accent-primary">
                                <span class="font-body-md text-body-md text-on-surface">否</span>
                            </label>
                            <label class="flex items-center gap-xs cursor-pointer">
                                <input type="radio" name="smoking" value="1" ${questionnaire.smoking == 1 ? 'checked' : ''} class="accent-primary">
                                <span class="font-body-md text-body-md text-on-surface">是</span>
                            </label>
                        </div>
                    </div>

                    <!-- Drinking -->
                    <div class="mb-lg">
                        <span class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">local_bar</span> 饮酒
                        </span>
                        <div class="flex gap-lg">
                            <label class="flex items-center gap-xs cursor-pointer">
                                <input type="radio" name="drinking" value="0" ${questionnaire.drinking == 0 || empty questionnaire ? 'checked' : ''} class="accent-primary">
                                <span class="font-body-md text-body-md text-on-surface">否</span>
                            </label>
                            <label class="flex items-center gap-xs cursor-pointer">
                                <input type="radio" name="drinking" value="1" ${questionnaire.drinking == 1 ? 'checked' : ''} class="accent-primary">
                                <span class="font-body-md text-body-md text-on-surface">是</span>
                            </label>
                        </div>
                    </div>

                    <!-- Noise Tolerance -->
                    <div class="mb-lg">
                        <label for="noiseTolerance" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">volume_up</span> 噪音耐受度
                        </label>
                        <select id="noiseTolerance" name="noiseTolerance" required
                                class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors appearance-none bg-[url('data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%2224%22 height=%2224%22 viewBox=%220 0 24 24%22><path fill=%22%23666%22 d=%22M7 10l5 5 5-5z%22/></svg>')] bg-no-repeat bg-[right_0.5rem_center] bg-[length:20px] pr-2xl">
                            <option value="">请选择噪音耐受度</option>
                            <option value="1" ${questionnaire.noiseTolerance == 1 ? 'selected' : ''}>1 - 非常安静，需要完全无噪音</option>
                            <option value="2" ${questionnaire.noiseTolerance == 2 ? 'selected' : ''}>2 - 较安静，偶尔有声音可以接受</option>
                            <option value="3" ${questionnaire.noiseTolerance == 3 ? 'selected' : ''}>3 - 适中，正常生活噪音没问题</option>
                            <option value="4" ${questionnaire.noiseTolerance == 4 ? 'selected' : ''}>4 - 较宽容，不太介意噪音</option>
                            <option value="5" ${questionnaire.noiseTolerance == 5 ? 'selected' : ''}>5 - 非常宽容，完全不在意噪音</option>
                        </select>
                    </div>

                    <!-- Cleanliness -->
                    <div class="mb-lg">
                        <label for="cleanliness" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">cleaning_services</span> 整洁度
                        </label>
                        <select id="cleanliness" name="cleanliness" required
                                class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors appearance-none bg-[url('data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%2224%22 height=%2224%22 viewBox=%220 0 24 24%22><path fill=%22%23666%22 d=%22M7 10l5 5 5-5z%22/></svg>')] bg-no-repeat bg-[right_0.5rem_center] bg-[length:20px] pr-2xl">
                            <option value="">请选择整洁度</option>
                            <option value="1" ${questionnaire.cleanliness == 1 ? 'selected' : ''}>1 - 较随意，不太在意整洁</option>
                            <option value="2" ${questionnaire.cleanliness == 2 ? 'selected' : ''}>2 - 基本整洁，保持大致干净即可</option>
                            <option value="3" ${questionnaire.cleanliness == 3 ? 'selected' : ''}>3 - 适中，一般整洁程度</option>
                            <option value="4" ${questionnaire.cleanliness == 4 ? 'selected' : ''}>4 - 较讲究，比较注重整洁</option>
                            <option value="5" ${questionnaire.cleanliness == 5 ? 'selected' : ''}>5 - 非常讲究，要求整洁有序</option>
                        </select>
                    </div>

                    <!-- Notes -->
                    <div class="mb-lg">
                        <label for="note" class="block font-label-caps text-label-caps text-on-surface-variant mb-xs">
                            <span class="material-symbols-outlined text-[14px] align-middle">sticky_note_2</span> 附加说明
                        </label>
                        <textarea id="note" name="note" rows="4"
                                  class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors resize-none"
                                  placeholder="分享您其他想让我们知道的生活习惯...">${questionnaire.note}</textarea>
                    </div>

                    <div class="text-center">
                        <button type="submit" id="submitBtn" class="px-lg py-sm bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all flex items-center gap-xs mx-auto">
                            <span class="material-symbols-outlined text-[18px]">send</span> 提交问卷
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
    <script>
        document.getElementById('questionnaireForm').addEventListener('submit', function() {
            var btn = document.getElementById('submitBtn');
            btn.innerHTML = '<span class="spinner" style="width:14px;height:14px;border-width:2px;"></span> 提交中...';
            btn.disabled = true;
        });
    </script>
</body>
</html>
