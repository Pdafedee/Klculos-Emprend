@echo off
REM ============================================================
REM  Klculos-Emprend - Instalador para Windows (doble clic)
REM  Crea el entorno virtual e instala las dependencias.
REM ============================================================
chcp 65001 >nul
title Klculos-Emprend - Instalador
cd /d "%~dp0"

echo.
echo  ==============================================
echo   Klculos-Emprend :: INSTALACION (Windows)
echo  ==============================================
echo.

REM --- 1. Localizar Python 3 ---
set "PY=python"
%PY% --version >nul 2>nul
if errorlevel 1 (
    set "PY=py -3"
    %PY% --version >nul 2>nul
)
if errorlevel 1 (
    echo  [X] No encontre Python 3 en este equipo.
    echo      1^) Instala Python desde https://www.python.org/downloads/
    echo      2^) IMPORTANTE: marca la casilla "Add python.exe to PATH"
    echo      3^) Vuelve a ejecutar este archivo.
    echo.
    pause
    exit /b 1
)
echo  [1/4] Python encontrado:
%PY% --version

REM --- 2. Crear el entorno virtual ---
if exist "venv\Scripts\python.exe" (
    echo  [2/4] El entorno virtual ya existe (venv\). Se reutiliza.
) else (
    echo  [2/4] Creando entorno virtual (carpeta venv\)...
    %PY% -m venv venv
    if errorlevel 1 (
        echo  [X] No pude crear el entorno virtual. Revisa que Python
        echo      quedo bien instalado y vuelve a intentarlo.
        pause
        exit /b 1
    )
)

REM --- 3. Actualizar pip e instalar dependencias ---
echo  [3/4] Instalando dependencias (flet, openai, reportlab, docx,
echo        qrcode, cryptography^). Puede tardar unos minutos...
venv\Scripts\python.exe -m pip install --upgrade pip
if errorlevel 1 goto :fallo_pip
venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 goto :fallo_pip

REM --- 4. Aviso si la version de Python no tiene soporte de escritorio ---
venv\Scripts\python.exe -c "import sys; sys.exit(0 if sys.version_info >= (3,14) else 1)"
if not errorlevel 1 (
    echo.
    echo  [!] AVISO: instalaste con Python 3.14 o superior. La app arrancara
    echo      igual, pero la ventana nativa puede fallar; en ese caso la app
    echo      se abre sola en el navegador, sin perder nada.
    echo      Para la ventana nativa: instala Python 3.12 desde python.org y
    echo      ejecuta:  py -3.12 -m venv venv  ^  reinstallar dependencias.
    echo.
)

REM --- 5. Listo ---
echo  [4/4] Instalacion completada.
echo.
echo  ==============================================
echo   INSTALACION LISTA
echo   Ahora haz doble clic en:  iniciar_windows.bat
echo  ==============================================
echo.
pause
exit /b 0

:fallo_pip
echo.
echo  [X] La instalacion de paquetes fallo. Causas tipicas:
echo      - Sin internet o señal muy lenta: usa la Opcion F
echo        "Instalacion sin internet" de docs\INSTALACION.md
echo      - Antivirus o proxy bloqueando: revisa la documentacion.
echo.
pause
exit /b 1
