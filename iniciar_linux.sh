#!/usr/bin/env bash
# ============================================================
#  Klculos-Emprend :: Arranque en escritorio (Linux / macOS)
#  Uso:   bash iniciar_linux.sh
# ============================================================
cd "$(cd "$(dirname "$0")" && pwd)"

if [ ! -x "venv/bin/python" ]; then
    echo ""
    echo " [!] Aun no esta instalado. Primero ejecuta:  bash instalar_linux.sh"
    echo ""
    exit 1
fi

echo " Iniciando Klculos-Emprend (ventana de escritorio)..."
exec venv/bin/python run.py
