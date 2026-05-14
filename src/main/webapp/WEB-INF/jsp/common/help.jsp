<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="head.jsp" %>
    <title>帮助中心 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="role" value="${role}"/>
        <jsp:param name="active" value="help"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="topbar.jsp">
            <jsp:param name="role" value="${role}"/>
            <jsp:param name="active" value="help"/>
        </jsp:include>
        <div class="p-margin max-w-[900px] w-full mx-auto">
            <div class="mb-lg">
                <h2 class="font-h2 text-h2 text-on-surface flex items-center gap-sm">
                    <span class="material-symbols-outlined text-primary">help</span> 帮助中心
                </h2>
                <p class="font-body-md text-body-md text-on-surface-variant mt-xs">了解如何使用宿舍管理系统的各项功能。</p>
            </div>

            <div class="space-y-md">
                <c:choose>
                    <c:when test="${role == 'admin'}">
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">dashboard</span> 首页面板
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">首页展示系统概览数据，包括学生总数、宿舍入住率、待分配学生数、待处理报修数，以及最近活动记录。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">group</span> 学生管理
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">查看所有学生信息，点击学生可查看详情，包括生活习惯问卷、宿舍分配情况。在详情页可为学生分配宿舍。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">domain</span> 宿舍管理
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">管理宿舍楼栋和房间信息，可添加、编辑、删除宿舍。查看每个宿舍的入住情况。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">quiz</span> 生活问卷
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">查看学生提交的生活习惯问卷，了解学生的作息习惯、兴趣爱好等，辅助宿舍分配决策。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">assignment_turned_in</span> 分配管理
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">查看所有宿舍分配记录，为未分配宿舍的学生分配房间。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">swap_horiz</span> 调换管理
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">审核学生的宿舍调换申请，可批准或拒绝，批准时指定目标宿舍。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">construction</span> 报修管理
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">处理学生的报修申请，可标记为处理中、已完成或拒绝。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">psychology</span> AI匹配
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">使用AI算法根据学生生活习惯推荐最合适的宿舍分配方案。</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">dashboard</span> 首页面板
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">首页展示您的个人信息概览和宿舍相关状态。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">person</span> 我的资料
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">查看您的个人基本信息，包括姓名、学号、性别、专业、年级和联系方式。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">quiz</span> 生活问卷
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">填写您的生活习惯问卷，包括作息时间、兴趣爱好等，系统将根据您的习惯匹配合适的室友和宿舍。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">king_bed</span> 宿舍分配
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">查看您的宿舍分配结果，包括楼栋、房间号等信息。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">swap_horiz</span> 调换申请
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">提交宿舍调换申请，填写调换原因，可选择目标宿舍。查看申请审核状态。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">build</span> 报修申请
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">提交宿舍设施报修申请，描述故障情况。查看报修处理进度。</p>
                        </div>
                        <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft">
                            <h3 class="font-h3 text-h3 text-on-surface flex items-center gap-sm mb-sm">
                                <span class="material-symbols-outlined text-primary">support_agent</span> AI客服
                            </h3>
                            <p class="font-body-md text-body-md text-on-surface-variant">与AI客服对话，获取宿舍相关问题的即时解答和帮助。</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="bg-primary-fixed border border-primary rounded-xl p-lg">
                    <h3 class="font-h3 text-h3 text-on-primary-fixed-variant flex items-center gap-sm mb-sm">
                        <span class="material-symbols-outlined">contact_support</span> 需要更多帮助？
                    </h3>
                    <p class="font-body-md text-body-md text-on-primary-fixed-variant">如有其他问题，请联系宿舍管理处。</p>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
