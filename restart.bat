@echo off
title FraudGuard - Restart

echo ============================================================
echo   FRAUDGUARD: AI-Powered Fraud Detection System
echo   Restarting Application...
echo ============================================================
echo.

call "%~dp0stop.bat"
timeout /t 2 /nobreak >nul
echo.
echo Starting FraudGuard...
call "%~dp0start.bat"
