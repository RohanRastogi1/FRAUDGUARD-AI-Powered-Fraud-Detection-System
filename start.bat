@echo off
setlocal EnableDelayedExpansion
title FraudGuard - AI-Powered Fraud Detection System

echo ============================================================
echo   FRAUDGUARD: AI-Powered Fraud Detection System
echo   Startup Script (Apache Tomcat + Real-Time Telemetry)
echo ============================================================
echo.

:: 1. Detect JAVA_HOME
if "%JAVA_HOME%"=="" (
    if exist "C:\Program Files\Eclipse Adoptium\jdk-25.0.4.101-hotspot" (
        set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-25.0.4.101-hotspot"
    ) else if exist "C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot" (
        set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot"
    ) else if exist "C:\Program Files\Java\jdk-21" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-21"
    ) else (
        for /f "tokens=*" %%i in ('where java 2^>nul') do (
            set "JAVA_BIN=%%~dpi"
            set "JAVA_HOME=!JAVA_BIN:\bin\=!"
            goto :java_found
        )
    )
)
:java_found

if "%JAVA_HOME%"=="" (
    echo [ERROR] JAVA_HOME is not set and Java JDK was not automatically found.
    echo Please install Java JDK 17+ or set JAVA_HOME.
    pause
    exit /b 1
)

echo [OK] Using JAVA_HOME: %JAVA_HOME%

:: 2. Detect CATALINA_HOME
if "%CATALINA_HOME%"=="" (
    if exist "C:\Servers\Tomcat" (
        set "CATALINA_HOME=C:\Servers\Tomcat"
    ) else if exist "C:\apache-tomcat" (
        set "CATALINA_HOME=C:\apache-tomcat"
    ) else (
        echo [ERROR] CATALINA_HOME is not set and C:\Servers\Tomcat was not found.
        echo Please set CATALINA_HOME to your Apache Tomcat root directory.
        pause
        exit /b 1
    )
)

if "%CATALINA_BASE%"=="" (
    set "CATALINA_BASE=%CATALINA_HOME%"
)

echo [OK] Using CATALINA_HOME: %CATALINA_HOME%

:: 3. Check and sync FraudGuard deployment in Tomcat
set "APP_DIR=%~dp0"
if not exist "%CATALINA_HOME%\webapps\fraudguard\WEB-INF\web.xml" (
    echo.
    echo [INFO] FraudGuard webapp not detected in Tomcat webapps. Deploying now...
    if exist "%APP_DIR%target\fraudguard" (
        xcopy /s /e /y /q "%APP_DIR%target\fraudguard\*" "%CATALINA_HOME%\webapps\fraudguard\" >nul
        echo [OK] Exploded webapp deployed to %CATALINA_HOME%\webapps\fraudguard
    ) else (
        echo [INFO] Building project with Maven...
        cd /d "%APP_DIR%"
        call mvn compile war:exploded -DskipTests
        xcopy /s /e /y /q "%APP_DIR%target\fraudguard\*" "%CATALINA_HOME%\webapps\fraudguard\" >nul
        echo [OK] Build completed and deployed.
    )
) else (
    :: Synchronize latest UI and webapp updates
    xcopy /s /e /y /q "%APP_DIR%src\main\webapp\*" "%CATALINA_HOME%\webapps\fraudguard\" >nul 2>&1
)

:: 4. Check if FraudGuard is already running
curl.exe -s -o NUL http://localhost:8080/fraudguard/ >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo.
    echo [INFO] FraudGuard is ALREADY RUNNING on http://localhost:8080/fraudguard/
    echo Opening application in browser...
    start http://localhost:8080/fraudguard/
    goto :show_credentials
)

:: 5. Launch Apache Tomcat in a visible, dedicated command window
echo.
echo [INFO] Starting Apache Tomcat server in a dedicated window...
cd /d "%CATALINA_HOME%\bin"
start "Tomcat - FraudGuard AI System" cmd /k "title Tomcat - FraudGuard AI System && catalina.bat run"

echo [INFO] Waiting for FraudGuard to initialize on port 8080...
cd /d "%APP_DIR%"

set /a attempts=0
:wait_loop
ping 127.0.0.1 -n 3 >nul
curl.exe -s -o NUL http://localhost:8080/fraudguard/ >nul 2>&1
if %ERRORLEVEL% equ 0 goto :started
set /a attempts+=1
if %attempts% lss 12 goto :wait_loop

echo [INFO] Opening application in browser...

:started
echo.
echo ============================================================
echo   [SUCCESS] FRAUDGUARD IS RUNNING!
echo ============================================================
echo.
start http://localhost:8080/fraudguard/

:show_credentials
echo   Portal URLs:
echo     - Customer Portal:  http://localhost:8080/fraudguard/
echo     - Admin Dashboard:  http://localhost:8080/fraudguard/admin/dashboard
echo     - Alerts Triage:    http://localhost:8080/fraudguard/admin/alerts
echo     - Transactions:     http://localhost:8080/fraudguard/admin/transactions
echo.
echo   Demo Login Accounts:
echo     - Super Admin:      superadmin  /  Admin@123
echo     - Operations Admin: admin       /  Admin@123
echo     - Security Analyst: analyst     /  Analyst@123
echo     - Customer:         john_doe    /  Customer@123
echo.
echo   To stop the server at any time, double-click: stop.bat
echo ============================================================
echo.
pause
