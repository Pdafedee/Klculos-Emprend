#!/usr/bin/env python3
"""Lanzador de Klculos-Emprend (multiplataforma, sin Docker).

Uso:
    python run.py              → ventana de escritorio (Windows/Mac/Linux);
                                 si el cliente de escritorio falla, rescata
                                 automáticamente en modo navegador
    python run.py --web        → navegador en red local (PC y móvil)
    python run.py --web --port 8550 --host 0.0.0.0
    python run.py --doctor     → diagnóstico de la instalación
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

# Asegura imports del proyecto tanto como script como módulo
sys.path.insert(0, str(Path(__file__).resolve().parent))

_PY_MIN = (3, 10)      # mínimo absoluto
_PY_DESKTOP_MAX = (3, 14)  # 3.14+: cliente de escritorio de Flet sin soporte oficial


def _avisos_python() -> None:
    """Valida la versión de Python antes de arrancar (con guía clara)."""
    if sys.version_info < _PY_MIN:
        sys.exit(
            f"\n[X] Se requiere Python {_PY_MIN[0]}.{_PY_MIN[1]} o superior "
            f"(tienes {sys.version.split()[0]}).\n"
            "    1) Instala Python desde https://www.python.org/downloads/\n"
            "       (en Windows marca la casilla 'Add python.exe to PATH').\n"
            "    2) Vuelve a ejecutar instalar_windows.bat / instalar_linux.sh\n"
        )
    if sys.version_info >= _PY_DESKTOP_MAX:
        print(
            f"\n[!] Aviso: Python {sys.version.split()[0]} aún no tiene soporte oficial "
            "del cliente de escritorio de Flet 0.28.x."
        )
        print("    • La app funcionará igual: si la ventana nativa falla, se abre sola en el navegador.")
        print("    • Para la ventana nativa: instala Python 3.12 y recrea el entorno:")
        print("        py -3.12 -m venv venv   →   activar venv   →   instalar dependencias\n")


def _problemas_cliente_desktop() -> list[str]:
    """Detecta problemas del paquete flet-desktop (lista vacía = todo bien)."""
    problemas: list[str] = []
    try:
        import flet_desktop  # noqa: F401
    except Exception as e:  # pragma: no cover - depende del equipo
        problemas.append(f"flet-desktop no se puede importar ({e}).")
        return problemas
    if getattr(flet_desktop, "version", None) is None:
        problemas.append(
            "flet-desktop está roto o mezclado con otra versión "
            "(falta el módulo 'version'). Causa típica: restos de una "
            "instalación 'pip install --user' que tapa la nueva, o Python 3.14."
        )
    return problemas


def _curar_flet_desktop() -> None:
    """Instrucciones de limpieza para una instalación rota de flet-desktop."""
    print("\n    Solución definitiva (copia y pega estos comandos):\n")
    print("      pip uninstall flet flet-desktop -y")
    print("      pip uninstall flet flet-desktop -y --user      :: (Windows; si existiera)")
    print("      python -m venv venv")
    print("      venv\\Scripts\\activate            (Windows)")
    print("      source venv/bin/activate          (macOS / Linux)")
    print("      python -m pip install -r requirements.txt")
    print("\n    Recomendado: Python 3.12 dentro del venv (py -3.12 -m venv venv).\n")


def _arrancar_web(host: str, port: int, motivo: str = "") -> None:
    """Arranca el modo navegador (PC y móvil) con mensaje claro."""
    import flet as ft

    from app.main import main

    print(f"\nKlculos-Emprend en MODO NAVEGADOR: http://127.0.0.1:{port}")
    print("  • En tu móvil (misma red Wi-Fi): http://IP-DE-ESTE-EQUIPO:%d" % port)
    print("  • Deja esta ventana abierta mientras usas la app.")
    if motivo:
        print(f"  • Motivo del cambio de modo: {motivo}")
    try:
        ft.app(main, view=ft.AppView.WEB_BROWSER, host=host, port=port)
    except OSError as e:
        sys.exit(
            f"\n[X] No pude abrir el servidor web ({e}).\n"
            f"    Si el puerto {port} está ocupado prueba: "
            f"python run.py --web --port {port + 10}\n"
        )


def _doctor() -> None:
    """Diagnóstico completo de la instalación (python run.py --doctor)."""
    import importlib
    import importlib.util

    print("\n=== Diagnóstico de instalación — Klculos-Emprend ===\n")

    v = f"{sys.version_info[0]}.{sys.version_info[1]}.{sys.version_info[2]}"
    if sys.version_info < _PY_MIN:
        print(f"  Python {v}                [X] demasiado antiguo (mínimo 3.10)")
    elif sys.version_info >= _PY_DESKTOP_MAX:
        print(f"  Python {v}                [!] sin soporte oficial de escritorio (usa 3.10–3.13)")
    else:
        print(f"  Python {v}                [OK]")

    en_venv = sys.prefix != getattr(sys, "base_prefix", sys.prefix)
    print(f"  Entorno virtual activo    {'[OK]' if en_venv else '[—] no (recomendado usar venv)'}")

    requeridos = {
        "flet": ">=0.25,<0.29",
        "openai": ">=1.30 (opcional: motor IA local funciona sin él)",
        "reportlab": ">=4.0",
        "docx": ">=1.1 (paquete python-docx)",
        "qrcode": ">=7.4",
        "cryptography": ">=42.0",
    }
    for paquete, req in requeridos.items():
        try:
            mod = importlib.import_module(paquete)
            ver = getattr(mod, "version", None)
            ver = getattr(ver, "version", None) or getattr(mod, "__version__", "?")
            print(f"  {paquete:<13} {ver:<12} [OK] ({req})")
        except Exception:
            print(f"  {paquete:<13} {'FALTA':<12} [X] instala: pip install -r requirements.txt")

    try:
        import flet_desktop

        ver_fd = getattr(getattr(flet_desktop, "version", None), "version", "?")
        ok_fd = getattr(flet_desktop, "version", None) is not None
        print(f"  flet-desktop    {ver_fd:<12} {'[OK]' if ok_fd else '[X] roto/mixto: ver guía abajo'}")
    except Exception as e:
        print(f"  flet-desktop    FALTA         [X] ({e})")

    data_dir = Path(__file__).resolve().parent / "data"
    print(f"  Carpeta data/             {'existe' if data_dir.exists() else 'se creará al primer arranque'}")

    print("\n  Si algo aparece [X]: usa los comandos de docs/INSTALACION.md §13")
    print("  o reejecuta instalar_windows.bat / bash instalar_linux.sh\n")


def main_cli() -> None:
    parser = argparse.ArgumentParser(
        prog="Klculos-Emprend",
        description="Inteligencia financiera para tu emprendimiento (10 indicadores decisivos)")
    parser.add_argument("--web", action="store_true",
                        help="servir en el navegador en vez de ventana nativa")
    parser.add_argument("--host", default="0.0.0.0", help="host para modo web (default 0.0.0.0)")
    parser.add_argument("--port", type=int, default=8550, help="puerto para modo web (default 8550)")
    parser.add_argument("--doctor", action="store_true",
                        help="diagnosticar la instalación y salir")
    args = parser.parse_args()

    _avisos_python()

    if args.doctor:
        _doctor()
        return

    if args.web:
        _arrancar_web(args.host, args.port)
        return

    # Modo escritorio con rescate automático hacia el navegador
    problemas = _problemas_cliente_desktop()
    if problemas:
        print("\n[X] El cliente de escritorio tiene problemas detectados ANTES de arrancar:")
        for p in problemas:
            print("    -", p)
        _curar_flet_desktop()
        print("    Continuando en MODO NAVEGADOR (mismas funciones, mismos datos)...")
        _arrancar_web(args.host, args.port, motivo="cliente de escritorio roto")
        return

    try:
        import flet as ft

        from app.main import main

        ft.app(main, view=ft.AppView.FLET_APP)
    except KeyboardInterrupt:
        raise
    except Exception as e:  # noqa: BLE001 - rescate deliberado
        print(f"\n[X] La ventana de escritorio no pudo abrirse ({type(e).__name__}: {e})")
        if isinstance(e, AttributeError) or "version" in str(e).lower():
            print("    Es el error conocido de flet-desktop roto/mixto (típico con")
            print("    Python 3.14 o instalaciones duplicadas con pip --user).")
            _curar_flet_desktop()
        print("\n    Rescate automático: la app continúa en MODO NAVEGADOR.")
        print("    (Mismas funciones y mismos datos; el navegador ya lo tienes.)")
        _arrancar_web(args.host, args.port,
                      motivo="la ventana nativa falló; usa Python 3.12 en un venv para recuperarla")


if __name__ == "__main__":
    main_cli()
