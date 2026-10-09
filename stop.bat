@echo off
setlocal EnableDelayedExpansion
title FraudGuard - Shutdown

echo ============================================================
echo   FRAUDGUARD: AI-Powered Fraud Detection System
echo   Shutdown Script
echo ============================================================
echo.

:: 1. Detect CATALINA_HOME
if "%CATALINA_HOME%"=="" (
    if exist "C:\Servers\Tomcat" (
        set "CATALINA_HOME=C:\Servers\Tomcat"
    ) else if exist "C:\apache-tomcat" (
        set "CATALINA_HOME=C:\apache-tomcat"
    )
)

:: 2. Check if Tomcat is responding
curl.exe -s -o NUL http://localhost:8080/fraudguard/ >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [INFO] FraudGuard is not running on port 8080.
    echo Cleaning up any lingering Tomcat processes...
    powershell -NoProfile -Command "$p = (Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue).OwningProcess; if ($p) { Stop-Process -Id $p -Force -ErrorAction SilentlyContinue }" >nul 2>&1
    echo [INFO] The application is already stopped.
    goto :end
)

echo [INFO] Detected active FraudGuard instance on port 8080.

:: 3. Trigger graceful shutdown via Tomcat's shutdown.bat
if not "%CATALINA_HOME%"=="" (
    if exist "%CATALINA_HOME%\bin\shutdown.bat" (
        echo [INFO] Sending graceful shutdown signal to Apache Tomcat...
        call "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1
        ping 127.0.0.1 -n 3 >nul
    )
)

:: 4. Verify if port was released, otherwise kill process on port 8080
powershell -NoProfile -Command "$p = (Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue).OwningProcess; if ($p) { Stop-Process -Id $p -Force -ErrorAction SilentlyContinue }" >nul 2>&1
ping 127.0.0.1 -n 2 >nul

curl.exe -s -o NUL http://localhost:8080/fraudguard/ >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo [WARNING] Server port 8080 is still busy. Please check Task Manager.
) else (
    echo [SUCCESS] FraudGuard Apache Tomcat server has been completely stopped.
)

:end
echo.
echo ============================================================
pause
