@echo off
chcp 65001 > nul
echo ========================================
echo    SushePro One-Click Startup
echo ========================================
echo.

cd /d "%~dp0sushepro-backend"
echo [1/2] Starting Backend (Spring Boot)...
start "SushePro-Backend" cmd /k "mvn spring-boot:run"

cd /d "%~dp0sushepro-frontend"
echo [2/2] Starting Frontend (Vite)...
start "SushePro-Frontend" cmd /k "npm run dev"

echo.
echo ========================================
echo    Access:
echo    - Frontend: http://localhost:5173
echo    - Backend:  http://localhost:8080
echo ========================================
pause