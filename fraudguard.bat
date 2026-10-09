@echo off
setlocal EnableDelayedExpansion
title FraudGuard - Management Console

:menu
cls
echo ================================================================
echo        FRAUDGUARD: AI-Powered Fraud Detection System
echo                  Management & Control Console
echo ================================================================
echo.

:: Check status
curl.exe -s -o NUL http://localhost:8080/fraudguard/ >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo   [STATUS] Server is ACTIVE on port 8080 (http://localhost:8080/fraudguard/)
) else (
    echo   [STATUS] Server is currently STOPPED
)

echo.
echo   [1] Start FraudGuard (Launch Tomcat + Open in Browser)
echo   [2] Stop FraudGuard  (Gracefully Shutdown Server)
echo   [3] Restart FraudGuard
echo   [4] Open Dashboard in Browser
echo   [5] Rebuild and Redeploy with Maven
echo   [6] View Access URLs & Credentials
echo   [0] Exit
echo.
echo ================================================================
set /p choice="Enter choice [0-6]: "

if "%choice%"=="1" (
    echo.
    call "%~dp0start.bat"
    goto :menu
)
if "%choice%"=="2" (
    echo.
    call "%~dp0stop.bat"
    goto :menu
)
if "%choice%"=="3" (
    echo.
    call "%~dp0restart.bat"
    goto :menu
)
if "%choice%"=="4" (
    echo.
    start http://localhost:8080/fraudguard/
    goto :menu
)
if "%choice%"=="5" (
    echo.
    echo Building with Maven...
    cd /d "%~dp0"
    call mvn clean compile war:exploded -DskipTests
    if exist "%CATALINA_HOME%\webapps\fraudguard" (
        xcopy /s /e /y /q "%~dp0target\fraudguard\*" "%CATALINA_HOME%\webapps\fraudguard\" >nul
        echo [OK] Synced latest build to Tomcat.
    )
    pause
    goto :menu
)
if "%choice%"=="6" (
    cls
    echo ================================================================
    echo   PORTAL ACCESS & DEMO CREDENTIALS
    echo ================================================================
    echo.
    echo   Portal URLs:
    echo     - Home / Landing:    http://localhost:8080/fraudguard/
    echo     - Login:             http://localhost:8080/fraudguard/login
    echo     - Admin Dashboard:   http://localhost:8080/fraudguard/admin/dashboard
    echo     - Alerts Triage:     http://localhost:8080/fraudguard/admin/alerts
    echo     - All Transactions:  http://localhost:8080/fraudguard/admin/transactions
    echo     - Customer Portal:   http://localhost:8080/fraudguard/dashboard
    echo     - Transfer Money:    http://localhost:8080/fraudguard/transaction/new
    echo.
    echo   Demo User Accounts (Password is case-sensitive):
    echo     - Super Admin:       superadmin   /  Admin@123
    echo     - Operations Admin:  admin        /  Admin@123
    echo     - Security Analyst:  analyst      /  Analyst@123
    echo     - Customer (INR):    john_doe     /  Customer@123
    echo     - Customer (INR):    jane_smith   /  Customer@123
    echo.
    echo ================================================================
    pause
    goto :menu
)
if "%choice%"=="0" (
    exit /b 0
)

goto :menu
