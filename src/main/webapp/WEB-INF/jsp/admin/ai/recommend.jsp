<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../../common/head.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.5.0/dist/echarts.min.js"></script>
    <title>AI推荐 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../../common/sidebar.jsp">
        <jsp:param name="role" value="admin"/>
        <jsp:param name="active" value="ai"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col min-h-screen">
        <jsp:include page="../../common/topbar.jsp">
            <jsp:param name="role" value="admin"/>
            <jsp:param name="active" value="ai"/>
        </jsp:include>
        <div class="p-margin max-w-[800px] w-full mx-auto">
            <div class="mb-lg text-center">
                <span class="material-symbols-outlined text-[56px] text-primary mb-md">psychology</span>
                <h2 class="font-h1 text-h1 text-on-surface">AI房间推荐</h2>
                <p class="font-body-lg text-body-lg text-on-surface-variant mt-xs">输入学号，基于生活习惯数据获取智能宿舍匹配。</p>
            </div>

            <!-- Input Form -->
            <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft mb-gutter">
                <form id="recommendForm" action="${pageContext.request.contextPath}/admin/ai/recommend" method="post">
                    <label for="studentId" class="block font-label-caps text-label-caps text-on-surface-variant mb-sm">
                        <span class="material-symbols-outlined text-[14px] align-middle">person_search</span> 学号
                    </label>
                    <div class="flex gap-sm">
                        <input type="number" id="studentId" name="studentId"
                               class="flex-1 bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors"
                               placeholder="如 2023001" required min="1">
                        <button type="submit" class="px-md py-xs bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all flex items-center gap-xs">
                            <span class="material-symbols-outlined text-[18px]">search</span> 获取推荐
                        </button>
                    </div>
                    <label for="remark" class="block font-label-caps text-label-caps text-on-surface-variant mb-sm mt-md">
                        <span class="material-symbols-outlined text-[14px] align-middle">edit_note</span> 备注
                    </label>
                    <input type="text" id="remark" name="remark"
                           class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg px-sm py-xs font-body-md text-body-md text-on-surface focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors"
                           placeholder="楼层要求等（可选）">
                    <p class="font-body-md text-[12px] text-outline mt-sm">
                        <span class="material-symbols-outlined text-[14px] align-middle">info</span> 系统将分析生活习惯问卷数据进行智能匹配。
                    </p>
                </form>
            </div>

            <!-- Loading -->
            <div id="loadingSpinner" class="hidden text-center py-lg">
                <div class="spinner mx-auto mb-md"></div>
                <p class="font-body-md text-body-md text-on-surface-variant">AI正在分析数据并生成推荐...</p>
            </div>

            <!-- Result -->
            <c:if test="${not empty recommendation}">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-lg shadow-soft border-l-4 border-l-secondary page-enter">
                    <div class="text-center mb-lg">
                        <span class="material-symbols-outlined text-[40px] text-secondary">lightbulb</span>
                        <h3 class="font-h2 text-h2 text-on-surface mt-sm">AI推荐结果</h3>
                        <p class="font-body-md text-body-md text-on-surface-variant">基于智能算法分析:</p>
                    </div>
                    <div class="bg-surface-container rounded-lg p-md mb-lg">
                        <div class="font-body-md text-body-md text-on-surface recommendation-text">${recommendation}</div>
                    </div>

                    <c:if test="${not empty scoresJson}">
                        <div class="bg-surface-container rounded-lg p-md mb-lg">
                            <h4 class="font-label-caps text-label-caps text-on-surface-variant mb-sm text-center">
                                <span class="material-symbols-outlined text-[16px] align-middle">radar</span> 六维匹配度分析
                            </h4>
                            <div id="radarChart" style="width: 100%; height: 380px;"></div>
                        </div>
                        <script>
                            (function() {
                                var chartDom = document.getElementById('radarChart');
                                var myChart = echarts.init(chartDom);
                                var scoresJson = ${scoresJson};
                                var dimensions = Object.keys(scoresJson);
                                var values = Object.values(scoresJson);

                                var option = {
                                    tooltip: {
                                        trigger: 'item',
                                        formatter: function(params) {
                                            return params.name + ': ' + params.value + ' 分';
                                        }
                                    },
                                    legend: {
                                        data: ['匹配度'],
                                        bottom: 0,
                                        textStyle: { color: '#414755', fontSize: 12 }
                                    },
                                    radar: {
                                        center: ['50%', '50%'],
                                        radius: '65%',
                                        indicator: dimensions.map(function(name) {
                                            return { name: name, max: 100 };
                                        }),
                                        axisName: {
                                            color: '#414755',
                                            fontSize: 12,
                                            borderRadius: 3,
                                            padding: [2, 5]
                                        },
                                        splitArea: {
                                            areaStyle: {
                                                color: ['rgba(0, 88, 188, 0.02)', 'rgba(0, 88, 188, 0.04)']
                                            }
                                        },
                                        splitLine: {
                                            lineStyle: { color: 'rgba(0, 88, 188, 0.15)' }
                                        },
                                        axisLine: {
                                            lineStyle: { color: 'rgba(0, 88, 188, 0.3)' }
                                        }
                                    },
                                    series: [{
                                        name: '匹配度',
                                        type: 'radar',
                                        data: [{
                                            value: values,
                                            name: '维度匹配度',
                                            areaStyle: {
                                                color: 'rgba(0, 88, 188, 0.2)'
                                            },
                                            lineStyle: {
                                                color: '#0058bc',
                                                width: 2
                                            },
                                            itemStyle: {
                                                color: '#0058bc'
                                            }
                                        }],
                                        symbol: 'circle',
                                        symbolSize: 6
                                    }]
                                };

                                myChart.setOption(option);

                                window.addEventListener('resize', function() {
                                    myChart.resize();
                                });
                            })();
                        </script>
                    </c:if>

                    <div class="flex gap-sm justify-center">
                        <button onclick="copyRecommendation()" class="px-md py-xs border border-outline-variant text-on-surface-variant rounded-lg font-label-caps text-label-caps hover:bg-surface-container transition-all flex items-center gap-xs">
                            <span class="material-symbols-outlined text-[18px]">content_copy</span> 复制结果
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/ai/recommend" class="px-md py-xs bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-on-primary-fixed-variant transition-all flex items-center gap-xs">
                            <span class="material-symbols-outlined text-[18px]">refresh</span> 新推荐
                        </a>
                    </div>
                </div>
            </c:if>

            <!-- Feature Cards -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-gutter mt-xl pt-lg border-t border-outline-variant">
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft text-center">
                    <span class="material-symbols-outlined text-[32px] text-primary mb-sm">psychology</span>
                    <h4 class="font-h3 text-h3 text-on-surface mb-xs">智能匹配</h4>
                    <p class="font-body-md text-body-md text-on-surface-variant">基于机器学习的生活习惯分析算法。</p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft text-center">
                    <span class="material-symbols-outlined text-[32px] text-secondary mb-sm">account_tree</span>
                    <h4 class="font-h3 text-h3 text-on-surface mb-xs">多维度</h4>
                    <p class="font-body-md text-body-md text-on-surface-variant">综合考虑作息、习惯、偏好等多维度因素。</p>
                </div>
                <div class="bg-surface-container-lowest border border-outline-variant rounded-xl p-md shadow-soft text-center">
                    <span class="material-symbols-outlined text-[32px] text-tertiary mb-sm">trending_up</span>
                    <h4 class="font-h3 text-h3 text-on-surface mb-xs">持续学习</h4>
                    <p class="font-body-md text-body-md text-on-surface-variant">系统通过反馈持续优化推荐结果。</p>
                </div>
            </div>
        </div>
    </main>
    <script>
        document.getElementById('recommendForm').addEventListener('submit', function() {
            document.getElementById('loadingSpinner').classList.remove('hidden');
        });
        function copyRecommendation() {
            var text = document.querySelector('.recommendation-text').innerText;
            navigator.clipboard.writeText(text).then(function() {
                var div = document.createElement('div');
                div.className = 'fixed top-4 right-4 bg-green-100 text-green-800 rounded-lg px-md py-sm font-body-md text-body-md shadow-soft z-50 toast-enter';
                div.innerHTML = '<span class="material-symbols-outlined text-[16px] align-middle">check_circle</span> 已复制到剪贴板!';
                document.body.appendChild(div);
                setTimeout(function() { div.remove(); }, 3000);
            });
        }
    </script>
</body>
</html>
