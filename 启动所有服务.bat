@echo off
chcp 65001 > nul
echo ========================================
echo    宿舍管理系统 一键启动
echo ========================================
echo.

cd /d "%~dp0sushepro-backend"
echo [1/2] 启动后端服务 (Spring Boot)...
start "SushePro-Backend" cmd /k "mvn spring-boot:run"
echo    后端启动中，请等待...

echo.
echo [2/2] 启动前端服务 (Vite)...
cd /d "%~dp0sushepro-frontend"
start "SushePro-Frontend" cmd /k "npm run dev"
echo    前端启动中，请等待...

echo.
echo ========================================
echo    服务地址：
echo    - 前端: http://localhost:5173
echo    - 后端: http://localhost:8080
echo ========================================
echo.
echo 按任意键退出此窗口（服务继续在后台运行）...
pause > nul