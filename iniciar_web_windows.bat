@echo off
REM ============================================================
REM  Klculos-Emprend - Arranque en navegador (PC y movil)
REM ============================================================
chcp 65001 >nul
title Klculos-Emprend (modo web)
cd /d "%~dp0"

if not exist "venv\Scripts\python.exe" (
    echo.
    echo  [!] Aun no esta instalado. Primero haz doble clic en:
    echo        instalar_windows.bat
    echo.
    pause
    exit /b 1
)

echo.
echo  ==============================================
echo   MODO WEB - Klculos-Emprend
echo   En este equipo abre:  http://127.0.0.1:8550
echo   En tu movil (misma red Wi-Fi) abre:
echo     http://IP-DE-ESTE-EQUIPO:8550
echo   (Descubre la IP con: ipconfig - busca "IPv4"^)
echo  ==============================================
echo   Deja esta ventana abierta mientras usas la app.
echo  ==============================================
echo.
venv\Scripts\python.exe run.py --web --host 0.0.0.0 --port 8550
echo.
echo  Servidor web detenido.
pause
