@echo off
REM ============================================================
REM  Klculos-Emprend :: Empaquetar ejecutable de Windows (.exe)
REM  Genera dist\Klculos-Emprend.exe — no necesita Python en la
REM  PC destino. Ejecutarlo en Windows con el proyecto ya instalado
REM  (instalar_windows.bat) y con buena señal la primera vez.
REM ============================================================
chcp 65001 >nul
title Klculos-Emprend - Empaquetador
cd /d "%~dp0"

if not exist "venv\Scripts\python.exe" (
    echo.
    echo  [!] Primero instala la aplicacion: doble clic en instalar_windows.bat
    echo.
    pause
    exit /b 1
)

echo.
echo  ==============================================
echo   EMPAQUETADO DE EJECUTABLE (.exe) - Klculos-Emprend
echo  ==============================================
echo   1) Instala PyInstaller en el entorno virtual...
venv\Scripts\python.exe -m pip install pyinstaller
if errorlevel 1 goto :fallo

echo   2) Empaquetando (5-15 minutos la primera vez)...
echo      Al final el .exe queda en la carpeta dist\
venv\Scripts\python.exe -m PyInstaller --onefile --name "Klculos-Emprend" ^
    --collect-all flet --collect-all flet_desktop --collect-all flet_runtime ^
    --hidden-import "PIL._tkinter_finder" ^
    run.py
if errorlevel 1 goto :fallo

echo.
echo  ==============================================
echo   LISTO: dist\Klculos-Emprend.exe
echo   Copia ese archivo a cualquier Windows y haz doble clic.
echo   Los datos se guardan en una carpeta "data" junto al .exe.
echo   Nota: compila en Windows para Windows (no hay compilacion cruzada).
echo  ==============================================
echo.
pause
exit /b 0

:fallo
echo.
echo  [X] El empaquetado fallo. Causas tipicas:
echo      - Sin internet (PyInstaller no se descargo): usa la Opcion F offline.
echo      - Antivirus bloqueando: agrega exclusion para esta carpeta.
echo      - Detalle completo: docs\EJECUTABLE_WINDOWS.md
echo.
pause
exit /b 1
