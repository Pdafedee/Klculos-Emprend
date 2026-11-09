#!/usr/bin/env bash
# ============================================================
#  Klculos-Emprend :: Instalador para Linux / macOS (terminal)
#  Uso:   bash instalar_linux.sh
# ============================================================
set -e
cd "$(cd "$(dirname "$0")" && pwd)"

echo ""
echo " =============================================="
echo "  Klculos-Emprend :: INSTALACION (Linux/macOS)"
echo " =============================================="
echo ""

# --- 1. Localizar Python 3 ---
if command -v python3 >/dev/null 2>&1; then
    PY=python3
else
    echo " [X] No encontre python3. Instalalo asi:"
    echo "     Debian/Ubuntu/Mint :  sudo apt install python3 python3-venv python3-pip"
    echo "     Fedora             :  sudo dnf install python3"
    echo "     macOS              :  brew install python3   (o descarga python.org)"
    exit 1
fi
echo " [1/4] Python encontrado: $($PY --version)"

# --- 2. Crear el entorno virtual ---
if [ -x "venv/bin/python" ]; then
    echo " [2/4] El entorno virtual ya existe (venv/). Se reutiliza."
else
    echo " [2/4] Creando entorno virtual (carpeta venv/)..."
    $PY -m venv venv
fi

# --- 3. Instalar dependencias ---
echo " [3/4] Instalando dependencias (flet, openai, reportlab, docx, qrcode, cryptography)..."
venv/bin/python -m pip install --upgrade pip
venv/bin/python -m pip install -r requirements.txt

# --- 4. Listo ---
echo " [4/4] Instalacion completada."
echo ""
echo " =============================================="
echo "  INSTALACION LISTA"
echo "  Para arrancar:   bash iniciar_linux.sh        (ventana de escritorio)"
echo "  En navegador:    bash iniciar_web_linux.sh    (PC y movil)"
echo " =============================================="
echo ""
