@echo off
REM ============================================================
REM  Klculos-Emprend - Arranque en escritorio (doble clic)
REM ============================================================
chcp 65001 >nul
title Klculos-Emprend
cd /d "%~dp0"

if not exist "venv\Scripts\python.exe" (
    echo.
    echo  [!] Aun no esta instalado. Primero haz doble clic en:
    echo        instalar_windows.bat
    echo.
    pause
    exit /b 1
)

echo  Iniciando Klculos-Emprend (ventana de escritorio)...
echo  (Si la ventana nativa falla, la app se abre sola en el navegador.
echo   Si aparece un aviso del Firewall, es normal al primer arranque^)
echo.
venv\Scripts\python.exe run.py
if errorlevel 1 (
    echo.
    echo  [X] La aplicacion cerro con error. Intenta el modo web con:
    echo        iniciar_web_windows.bat
    echo.
    pause
)
