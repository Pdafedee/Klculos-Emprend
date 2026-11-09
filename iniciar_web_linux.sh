#!/usr/bin/env bash
# ============================================================
#  Klculos-Emprend :: Arranque en navegador (PC y movil)
#  Uso:   bash iniciar_web_linux.sh
# ============================================================
cd "$(cd "$(dirname "$0")" && pwd)"

if [ ! -x "venv/bin/python" ]; then
    echo ""
    echo " [!] Aun no esta instalado. Primero ejecuta:  bash instalar_linux.sh"
    echo ""
    exit 1
fi

IP=""
if command -v hostname >/dev/null 2>&1; then IP=$(hostname -I 2>/dev/null | awk '{print $1}'); fi
if [ -z "$IP" ] && command -v ipconfig >/dev/null 2>&1; then IP=$(ipconfig getifaddr en0 2>/dev/null); fi

echo ""
echo " =============================================="
echo "  MODO WEB - Klculos-Emprend"
echo "  En este equipo abre:  http://127.0.0.1:8550"
if [ -n "$IP" ]; then
echo "  En tu movil (misma red Wi-Fi) abre:"
echo "    http://${IP}:8550"
else
echo "  En tu movil (misma red Wi-Fi) usa la IP de este"
echo "  equipo (descubrela con: hostname -I)"
fi
echo " =============================================="
echo "  Deja esta terminal abierta mientras usas la app."
echo " =============================================="
echo ""
exec venv/bin/python run.py --web --host 0.0.0.0 --port 8550
