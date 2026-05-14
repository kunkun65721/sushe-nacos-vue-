<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="../common/head.jsp" %>
    <title>AI客服 - 宿舍管理系统</title>
</head>
<body class="bg-background text-on-background min-h-screen flex font-body-md">
    <jsp:include page="../common/sidebar.jsp">
        <jsp:param name="role" value="student"/>
        <jsp:param name="active" value="chat"/>
    </jsp:include>
    <main class="flex-1 md:ml-[260px] flex flex-col h-screen">
        <jsp:include page="../common/topbar.jsp">
            <jsp:param name="role" value="student"/>
            <jsp:param name="active" value="chat"/>
        </jsp:include>
        <!-- Chat area -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Header -->
            <div class="px-lg py-md border-b border-outline-variant bg-surface-container-lowest">
                <div class="flex items-center gap-sm">
                    <span class="p-sm bg-primary-fixed text-primary rounded-xl">
                        <span class="material-symbols-outlined text-[28px]">support_agent</span>
                    </span>
                    <div>
                        <h2 class="font-h3 text-h3 text-on-surface">AI客服</h2>
                        <p class="font-body-sm text-body-sm text-on-surface-variant">询问任何关于宿舍的问题，AI助手将为您解答</p>
                    </div>
                    <button id="clearChatBtn" class="ml-auto px-md py-xs text-label-caps font-label-caps text-on-surface-variant hover:text-error hover:bg-error-container rounded-lg transition-colors flex items-center gap-xs">
                        <span class="material-symbols-outlined text-[18px]">delete_sweep</span>
                        清空对话
                    </button>
                </div>
            </div>

            <!-- Messages container -->
            <div id="chatMessages" class="flex-1 overflow-y-auto px-lg py-md space-y-md">
                <c:choose>
                    <c:when test="${empty chatHistory}">
                        <div id="welcomeMessage" class="flex gap-sm">
                            <span class="w-8 h-8 rounded-full bg-primary-container flex items-center justify-center shrink-0 mt-1">
                                <span class="material-symbols-outlined text-on-primary-container text-[18px]">support_agent</span>
                            </span>
                            <div class="bg-surface-container rounded-xl rounded-bl-sm px-md py-sm max-w-[75%] shadow-soft">
                                <p class="font-body-md text-body-md text-on-surface">你好，${student.name}！</p>
                                <p class="font-body-md text-body-md text-on-surface mt-xs">我是宿舍管理AI客服助手，可以帮你解答以下问题：</p>
                                <ul class="list-disc list-inside mt-sm space-y-xs text-body-sm text-on-surface-variant">
                                    <li>宿舍设施和房型介绍</li>
                                    <li>宿舍管理规定和作息时间</li>
                                    <li>宿舍分配流程</li>
                                    <li>生活习惯问卷填写</li>
                                    <li>宿舍调换政策</li>
                                </ul>
                                <p class="font-body-sm text-body-sm text-on-surface-variant mt-sm">请问有什么可以帮助你的？</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${chatHistory}" var="msg">
                            <c:choose>
                                <c:when test="${msg.role == 'user'}">
                                    <div class="flex justify-end gap-sm">
                                        <div class="bg-primary text-on-primary rounded-xl rounded-br-sm px-md py-sm max-w-[75%] shadow-soft">
                                            <p class="font-body-md text-body-md whitespace-pre-wrap">${msg.content}</p>
                                        </div>
                                        <span class="w-8 h-8 rounded-full bg-tertiary-container flex items-center justify-center shrink-0 mt-1">
                                            <span class="material-symbols-outlined text-on-tertiary-container text-[18px]">person</span>
                                        </span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="flex gap-sm">
                                        <span class="w-8 h-8 rounded-full bg-primary-container flex items-center justify-center shrink-0 mt-1">
                                            <span class="material-symbols-outlined text-on-primary-container text-[18px]">support_agent</span>
                                        </span>
                                        <div class="bg-surface-container rounded-xl rounded-bl-sm px-md py-sm max-w-[75%] shadow-soft">
                                            <p class="font-body-md text-body-md whitespace-pre-wrap">${msg.content}</p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

                <!-- Typing indicator (hidden by default) -->
                <div id="typingIndicator" class="flex gap-sm hidden">
                    <span class="w-8 h-8 rounded-full bg-primary-container flex items-center justify-center shrink-0 mt-1">
                        <span class="material-symbols-outlined text-on-primary-container text-[18px]">support_agent</span>
                    </span>
                    <div class="bg-surface-container rounded-xl rounded-bl-sm px-md py-sm shadow-soft">
                        <div class="flex gap-1">
                            <span class="w-2 h-2 bg-on-surface-variant rounded-full animate-bounce" style="animation-delay: 0ms;"></span>
                            <span class="w-2 h-2 bg-on-surface-variant rounded-full animate-bounce" style="animation-delay: 150ms;"></span>
                            <span class="w-2 h-2 bg-on-surface-variant rounded-full animate-bounce" style="animation-delay: 300ms;"></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Input bar -->
            <div class="border-t border-outline-variant bg-surface p-md">
                <div class="max-w-[900px] mx-auto flex gap-sm">
                    <input
                        id="messageInput"
                        type="text"
                        placeholder="输入你的问题..."
                        autocomplete="off"
                        class="flex-1 bg-surface-container-lowest border border-outline-variant rounded-lg px-md py-sm font-body-md text-body-md text-on-surface placeholder:text-on-surface-variant focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-colors"
                    />
                    <button
                        id="sendBtn"
                        class="px-lg py-sm bg-primary text-on-primary rounded-lg font-label-caps text-label-caps hover:bg-primary-dark active:scale-95 transition-all flex items-center gap-xs disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        <span class="material-symbols-outlined text-[18px]">send</span>
                        发送
                    </button>
                </div>
            </div>
        </div>
    </main>

    <script>
    (function() {
        var chatMessages = document.getElementById('chatMessages');
        var messageInput = document.getElementById('messageInput');
        var sendBtn = document.getElementById('sendBtn');
        var clearChatBtn = document.getElementById('clearChatBtn');
        var typingIndicator = document.getElementById('typingIndicator');
        var welcomeMessage = document.getElementById('welcomeMessage');
        var isLoading = false;

        sendBtn.addEventListener('click', sendMessage);

        messageInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        function sendMessage() {
            var text = messageInput.value.trim();
            if (!text || isLoading) return;

            // Remove welcome message if present
            if (welcomeMessage) {
                welcomeMessage.remove();
                welcomeMessage = null;
            }

            // Add user bubble
            appendMessage('user', text);
            messageInput.value = '';
            messageInput.focus();

            // Show typing indicator
            showTyping();
            isLoading = true;
            sendBtn.disabled = true;

            var formData = new URLSearchParams();
            formData.append('message', text);

            fetch('${pageContext.request.contextPath}/student/chat/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(function(resp) { return resp.json(); })
            .then(function(data) {
                hideTyping();
                isLoading = false;
                sendBtn.disabled = false;
                if (data.success) {
                    appendMessage('assistant', data.reply);
                } else {
                    appendMessage('assistant', '❌ 抱歉，请求失败：' + (data.error || '未知错误'));
                }
            })
            .catch(function(err) {
                hideTyping();
                isLoading = false;
                sendBtn.disabled = false;
                appendMessage('assistant', '❌ 网络错误，请检查网络连接后重试。');
            });
        }

        function appendMessage(role, content) {
            var wrapper = document.createElement('div');
            wrapper.className = 'flex gap-sm' + (role === 'user' ? ' justify-end' : '');

            if (role === 'user') {
                // User bubble (right-aligned)
                var bubble = document.createElement('div');
                bubble.className = 'bg-primary text-on-primary rounded-xl rounded-br-sm px-md py-sm max-w-[75%] shadow-soft';
                var text = document.createElement('p');
                text.className = 'font-body-md text-body-md whitespace-pre-wrap';
                text.textContent = content;
                bubble.appendChild(text);
                wrapper.appendChild(bubble);

                var avatar = document.createElement('span');
                avatar.className = 'w-8 h-8 rounded-full bg-tertiary-container flex items-center justify-center shrink-0 mt-1';
                avatar.innerHTML = '<span class="material-symbols-outlined text-on-tertiary-container text-[18px]">person</span>';
                wrapper.appendChild(avatar);
            } else {
                // AI bubble (left-aligned)
                var avatar = document.createElement('span');
                avatar.className = 'w-8 h-8 rounded-full bg-primary-container flex items-center justify-center shrink-0 mt-1';
                avatar.innerHTML = '<span class="material-symbols-outlined text-on-primary-container text-[18px]">support_agent</span>';
                wrapper.appendChild(avatar);

                var bubble = document.createElement('div');
                bubble.className = 'bg-surface-container rounded-xl rounded-bl-sm px-md py-sm max-w-[75%] shadow-soft';
                var text = document.createElement('p');
                text.className = 'font-body-md text-body-md whitespace-pre-wrap';
                text.textContent = content;
                bubble.appendChild(text);
                wrapper.appendChild(bubble);
            }

            chatMessages.appendChild(wrapper);
            scrollToBottom();
        }

        function showTyping() {
            typingIndicator.classList.remove('hidden');
            scrollToBottom();
        }

        function hideTyping() {
            typingIndicator.classList.add('hidden');
        }

        function scrollToBottom() {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        // Clear chat
        clearChatBtn.addEventListener('click', function() {
            if (!confirm('确定要清除所有聊天记录吗？')) return;

            fetch('${pageContext.request.contextPath}/student/chat/clear', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
            }).then(function(resp) { return resp.json(); })
            .then(function(data) {
                if (data.success) {
                    // Remove all messages except typing indicator
                    while (chatMessages.firstChild) {
                        if (chatMessages.firstChild === typingIndicator) {
                            break;
                        }
                        chatMessages.removeChild(chatMessages.firstChild);
                    }
                    // Re-add welcome message
                    var wrapper = document.createElement('div');
                    wrapper.id = 'welcomeMessage';
                    wrapper.className = 'flex gap-sm';
                    wrapper.innerHTML = '<span class="w-8 h-8 rounded-full bg-primary-container flex items-center justify-center shrink-0 mt-1">' +
                        '<span class="material-symbols-outlined text-on-primary-container text-[18px]">support_agent</span></span>' +
                        '<div class="bg-surface-container rounded-xl rounded-bl-sm px-md py-sm max-w-[75%] shadow-soft">' +
                        '<p class="font-body-md text-body-md text-on-surface">你好，${student.name}！</p>' +
                        '<p class="font-body-md text-body-md text-on-surface mt-xs">我是宿舍管理AI客服助手，有什么可以帮你的？</p>' +
                        '</div>';
                    chatMessages.insertBefore(wrapper, typingIndicator);
                    welcomeMessage = document.getElementById('welcomeMessage');
                }
            });
        });

        // Focus input on load
        messageInput.focus();
    })();
    </script>
</body>
</html>
