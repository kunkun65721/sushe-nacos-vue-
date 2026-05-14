<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 宿舍管理系统</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;600&family=Instrument+Serif:ital@0;1&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "on-surface-variant": "#c4c7c8",
                        "tertiary-fixed-dim": "#c6c6c7",
                        "error": "#ffb4ab",
                        "primary-fixed-dim": "#c6c6c7",
                        "error-container": "#93000a",
                        "inverse-surface": "#e5e2e1",
                        "surface-dim": "#141313",
                        "on-secondary": "#303030",
                        "outline-variant": "#444748",
                        "tertiary-fixed": "#e2e2e2",
                        "secondary": "#c6c6c6",
                        "on-surface": "#e5e2e1",
                        "on-primary-fixed-variant": "#454747",
                        "surface-container-highest": "#353434",
                        "secondary-fixed": "#e2e2e2",
                        "surface-tint": "#c6c6c7",
                        "primary": "#ffffff",
                        "on-tertiary-container": "#636565",
                        "outline": "#8e9192",
                        "secondary-fixed-dim": "#c6c6c6",
                        "surface-container-low": "#1c1b1b",
                        "primary-container": "#e2e2e2",
                        "on-primary-container": "#636565",
                        "on-primary": "#2f3131",
                        "tertiary": "#ffffff",
                        "on-error-container": "#ffdad6",
                        "on-tertiary-fixed": "#1a1c1c",
                        "on-secondary-fixed": "#1b1b1b",
                        "surface-bright": "#3a3939",
                        "background": "#141313",
                        "inverse-primary": "#5d5f5f",
                        "surface-container-high": "#2a2a2a",
                        "surface-container-lowest": "#0e0e0e",
                        "inverse-on-surface": "#313030",
                        "on-primary-fixed": "#1a1c1c",
                        "on-secondary-container": "#b5b5b5",
                        "on-error": "#690005",
                        "primary-fixed": "#e2e2e2",
                        "on-tertiary-fixed-variant": "#454747",
                        "on-secondary-fixed-variant": "#474747",
                        "surface": "#141313",
                        "secondary-container": "#474747",
                        "tertiary-container": "#e2e2e2",
                        "surface-variant": "#353434",
                        "on-tertiary": "#2f3131",
                        "surface-container": "#201f1f",
                        "on-background": "#e5e2e1"
                    },
                    borderRadius: {
                        DEFAULT: "1rem",
                        lg: "2rem",
                        xl: "3rem",
                        full: "9999px"
                    },
                    spacing: {
                        gutter: "24px",
                        unit: "8px",
                        "margin-page": "64px",
                        "container-max": "1440px"
                    },
                    fontFamily: {
                        "body-lg": ["Barlow"],
                        "headline-lg": ["Instrument Serif"],
                        "display-xl": ["Instrument Serif"],
                        "body-md": ["Barlow"],
                        "label-sm": ["Barlow"],
                        "headline-md": ["Instrument Serif"]
                    },
                    fontSize: {
                        "body-lg": ["18px", { lineHeight: "1.6", letterSpacing: "0.01em", fontWeight: "400" }],
                        "headline-lg": ["48px", { lineHeight: "1.2", fontWeight: "400" }],
                        "display-xl": ["80px", { lineHeight: "1.1", letterSpacing: "-0.02em", fontWeight: "400" }],
                        "body-md": ["16px", { lineHeight: "1.6", fontWeight: "400" }],
                        "label-sm": ["12px", { lineHeight: "1", letterSpacing: "0.1em", fontWeight: "600" }],
                        "headline-md": ["32px", { lineHeight: "1.3", fontWeight: "400" }]
                    }
                }
            }
        }
    </script>
    <style>
        .liquid-glass {
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .text-gradient {
            background: linear-gradient(180deg, #FFFFFF 0%, rgba(255, 255, 255, 0.5) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
    </style>
</head>
<body class="bg-background text-primary antialiased selection:bg-primary selection:text-background min-h-screen flex flex-col font-body-md overflow-x-hidden">

    <!-- ====== Hero Section with Video Background ====== -->
    <section class="relative min-h-screen flex flex-col justify-center items-center px-unit overflow-hidden">

        <!-- Background Video -->
        <div class="absolute inset-0 z-0 overflow-hidden bg-surface-dim">
            <video id="bgVideo" autoplay muted playsinline
                   class="absolute top-0 left-1/2 -translate-x-1/2 w-[120%] h-auto min-h-full object-cover opacity-60">
                <source src="https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260418_080021_d598092b-c4c2-4e53-8e46-94cf9064cd50.mp4" type="video/mp4"/>
            </video>
            <!-- Gradient overlay -->
            <div class="absolute inset-0 bg-gradient-to-b from-background/40 via-transparent to-background"></div>
        </div>

        <!-- Login Card -->
        <div class="relative z-10 w-full max-w-[440px] flex flex-col items-center text-center">

            <!-- White Card -->
            <div class="bg-white rounded-[2.5rem] p-10 w-full shadow-2xl">
                <!-- Title -->
                <h1 class="font-display-xl text-[32px] italic text-neutral-900 mb-2 tracking-tight">宿舍管理系统</h1>
                <p class="font-body-md text-body-md text-neutral-400 mb-8">管理员与学生入口</p>

                <!-- Login Form -->
                <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                    <div class="mb-4">
                        <label for="username" class="block font-label-sm text-label-sm text-neutral-400 uppercase tracking-widest mb-2">
                            <span class="material-symbols-outlined text-[14px] align-middle">person</span> 用户名
                        </label>
                        <input type="text"
                               id="username"
                               name="username"
                               class="w-full bg-neutral-50 border border-neutral-200 rounded-full px-5 py-3.5 font-body-md text-body-md text-neutral-900 placeholder:text-neutral-300 focus:border-neutral-900 focus:bg-white outline-none transition-all duration-300"
                               placeholder="请输入用户名"
                               required
                               autofocus>
                    </div>

                    <div class="mb-6">
                        <label for="password" class="block font-label-sm text-label-sm text-neutral-400 uppercase tracking-widest mb-2">
                            <span class="material-symbols-outlined text-[14px] align-middle">lock</span> 密码
                        </label>
                        <input type="password"
                               id="password"
                               name="password"
                               class="w-full bg-neutral-50 border border-neutral-200 rounded-full px-5 py-3.5 font-body-md text-body-md text-neutral-900 placeholder:text-neutral-300 focus:border-neutral-900 focus:bg-white outline-none transition-all duration-300"
                               placeholder="请输入密码"
                               required>
                    </div>

                    <button type="submit"
                            id="submitBtn"
                            class="w-full bg-neutral-900 text-white rounded-full py-3.5 font-label-sm text-label-sm uppercase tracking-widest hover:bg-neutral-700 transition-colors flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-[18px]">login</span>
                        登录
                    </button>
                </form>

                <!-- Feature tags -->
                <div class="flex flex-wrap justify-center gap-2.5 mt-6">
                    <span class="bg-neutral-100 text-neutral-500 px-4 py-2 rounded-full font-label-sm text-label-sm flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-[14px] text-neutral-400">check_circle</span>
                        智能分配
                    </span>
                    <span class="bg-neutral-100 text-neutral-500 px-4 py-2 rounded-full font-label-sm text-label-sm flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-[14px] text-neutral-400">check_circle</span>
                        生活习惯匹配
                    </span>
                    <span class="bg-neutral-100 text-neutral-500 px-4 py-2 rounded-full font-label-sm text-label-sm flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-[14px] text-neutral-400">check_circle</span>
                        AI智能推荐
                    </span>
                    <span class="bg-neutral-100 text-neutral-500 px-4 py-2 rounded-full font-label-sm text-label-sm flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-[14px] text-neutral-400">check_circle</span>
                        实时数据分析
                    </span>
                </div>
            </div>

            <!-- Footer (outside white card, on video bg) -->
            <p class="font-label-sm text-label-sm text-on-surface-variant/50 uppercase tracking-widest mt-6">
                DMS v1.0 &copy; 2025
            </p>
        </div>
    </section>

    <script>
        // Seamless video loop — reset before browser hits the end to avoid blink
        (function() {
            var video = document.getElementById('bgVideo');
            video.addEventListener('loadedmetadata', function() {
                var duration = video.duration;
                video.addEventListener('timeupdate', function() {
                    if (video.currentTime >= duration - 0.15) {
                        video.currentTime = 0;
                    }
                });
            });
        })();

        document.getElementById('loginForm').addEventListener('submit', function(e) {
            var btn = document.getElementById('submitBtn');
            btn.innerHTML = '<span class="material-symbols-outlined text-[18px] animate-spin">progress_activity</span> 登录中...';
            btn.disabled = true;
            btn.classList.add('opacity-60');
        });
    </script>
</body>
</html>
