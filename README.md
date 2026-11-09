# Klculos-Emprend

**Plataforma de inteligencia financiera para emprendedores**, construida en Python + Flet + IA (OpenAI en modo híbrido). Automatiza el análisis de **ganancias y pérdidas** (Estado de Resultados completo en cascada) y los **16 indicadores decisivos** para el destino de tu emprendimiento, con **sistema integrado de alertas en tiempo real**, **monedas (CUP por defecto + 23 mundiales con tasas en línea)**, **espacios de trabajo multi-negocio con asistente**, **multi-usuario con 5 roles y permisos**, **multi-tarea en segundo plano**, **salvas de configuración**, **ejecutable de Windows (.exe)**, micro-apps, enjambre de agentes IA, arquitectura por capas (divide y vencerás), JSON cifrado extremo a extremo, blockchain embebida y migración automática a SQL. Funciona offline y en zonas de poca señal, en escritorio o móvil, sin Docker.

**Pensada para el TCP, MIPYMES o nuevo actor económico sin habilidades contables:** cada número viene con explicación en lenguaje simple, semáforo y acción concreta. La vista **Guía** integrada enseña a usarla y a leer los números.

---

## 1. Arranque rápido

```bash
pip install -r requirements.txt

python run.py              # ventana de escritorio (Windows / macOS / Linux)
python run.py --web        # navegador en la red local (también desde el móvil)
python run.py --web --port 8550 --host 0.0.0.0
```

**Primer uso:** crea tu cuenta (email + nombre del emprendimiento) y define tu **contraseña maestra**. Esa contraseña deriva la clave de cifrado E2E (PBKDF2-SHA256, 200 000 iteraciones) — no se guarda en ningún sitio y no existe recuperación. Con la cuenta creada, el sistema siembra automáticamente la demo **"Cafetería El Andén"** (12 meses de historia) para que veas todo funcionando.

**Accesos siguientes:** email → código de validación de 6 dígitos (por correo si configuraste SMTP; sin señal, el QR + código aparecen en pantalla, modo offline) → contraseña maestra para desbloquear los datos.

---

## 2. Arquitectura (divide y vencerás, por capas)

```
CAPA 5 · UI Flet (micro-apps visuales)      app/ui/  → 14 vistas + componentes
CAPA 4 · Servicios                          app/services/  → auth QR/email, SMTP,
                                              exportador PDF/DOC/TXT
CAPA 3 · IA (enjambre, teoría de enjambre)  app/ai/  → 5 agentes paralelos + OpenAI
                                              híbrido + heurística local
CAPA 2 · Datos (persistencia y seguridad)   app/data/ → JSON atómico cifrado E2E,
                                              blockchain embebida, repositorios CRUD,
                                              migrador SQLite/MySQL/PostgreSQL
CAPA 1 · Núcleo de dominio                  app/core/ → modelos, periodos, motor
                                              financiero (P&G en cascada, clasificación
                                              fijo/variable, punto de equilibrio),
                                              catálogo de 16 indicadores,
                                              micro-calculadoras, motor de alertas,
                                              cuadro de mando integral
```

El problema grande ("¿cómo está mi negocio?") se divide en 16 cálculos atómicos que se ejecutan **en paralelo** (`ThreadPoolExecutor`) y en 5 agentes IA que vuelan **en paralelo**; sus hallazgos se fusionan por **votos ponderados con reputación** (refuerzo por consenso, teoría de enjambre).

### Motor financiero avanzado (`app/core/finanzas.py`)

Clasifica cada categoría de gasto (costo de venta/producción, variable, fijo,
financiero, impuesto) por palabras clave y arma la cascada:

```
Ventas − Costo de ventas = UTILIDAD BRUTA
       − variables de venta − fijos operativos = UTILIDAD OPERATIVA
       − gastos financieros = UAI − impuestos = UTILIDAD NETA
```

más el **Punto de Equilibrio completo**: ventas mínimas y unidades, margen de
contribución, cobertura, margen de seguridad y días para cubrirlo.

### Los 16 indicadores decisivos (catálogo editable en `app/core/indicators/catalog.py`)

| # | Indicador | Fórmula | Umbral óptimo |
|---|-----------|---------|---------------|
| 1 | Margen Bruto | (Ventas − Costo de ventas) / Ventas | ≥ 40 % |
| 2 | Margen Operativo | Utilidad operativa / Ventas | ≥ 18 % |
| 3 | Margen Neto | Utilidad neta / Ventas | ≥ 15 % |
| 4 | Cobertura del Punto de Equilibrio | Ventas / Ventas de equilibrio | ≥ 1.3× |
| 5 | Margen de Seguridad del PE | (Ventas − Ventas del PE) / Ventas | ≥ 25 % |
| 6 | Flujo de Caja Neto | (Ingresos − Gastos − ΔInventario) / Ingresos | ≥ 10 % |
| 7 | ROI Anualizado | Utilidad anualizada / Activos totales | ≥ 20 % |
| 8 | Ratio de Costo de Ventas | Costo de ventas / Ingresos | ≤ 60 % |
| 9 | Ratio de Gastos Fijos | Gastos fijos / Ingresos | ≤ 30 % |
| 10 | Carga Financiera | Gastos financieros / Ingresos | ≤ 5 % |
| 11 | Presión Fiscal | Impuestos / Ingresos | ≤ 15 % |
| 12 | Rotación de Inventario | Costo anualizado / Inventario promedio | ≥ 12× |
| 13 | Capital de Trabajo | Activos corrientes / Pasivos corrientes | ≥ 2.0× |
| 14 | CAC vs Ticket | CAC de adquisición / Ticket promedio | ≤ 20 % |
| 15 | Ratio LTV/CAC | Valor de vida del cliente / CAC | ≥ 3.0× |
| 16 | Crecimiento de Ventas | Δ vs periodo comparable anterior | ≥ 10 % |

Cada indicador tiene semáforo (verde/amarillo/rojo), score 0–100, brecha y **acción correctiva** por nivel — esa base de conocimiento es la que usa el agente Estratega. Para calibrar con el ebook original solo hay que editar `catalog.py`.

### Sistema integrado de alertas en tiempo real (`app/core/alertas.py`)

16 reglas que se **reevalúan con cada interacción** (movimientos CRUD, cambio
de periodo, apertura de vistas): pérdidas, caja negativa, ventas bajo el punto
de equilibrio, colchón fino, deuda pesada, presión fiscal, picos de gastos,
caída de ventas, fuga de clientes, inventario lento, liquidez, tendencias a
la baja, ritmo insuficiente y refuerzo positivo. Cada alerta trae severidad,
mensaje, acción sugerida y botón **"Ir a actuar"** que navega a la vista de
corrección. Deduplicación anti-ruido (regla+periodo), resolución automática,
persistencia sellada en la cadena y sincronizada a SQLite. Detalle completo en
`docs/MODELO_FINANCIERO.md`.

---

## 3. Enjambre de agentes IA (híbrido OpenAI + local)

| Agente | Rol |
|--------|-----|
| **Analista Financiero** | Interpreta ganancias, pérdidas, márgenes y estructura de gastos |
| **Predictor de Escenarios** | Regresión lineal: proyecta ventas y utilidad a 3 meses con confianza (r²) |
| **Radar de Tendencias** | Alzas/bajas, medias móviles y anomalías por z-score |
| **Estratega del Negocio** | Convierte indicadores débiles en un plan de 90 días priorizado |
| **Auditor de Integridad** | Vigila el blockchain y la calidad de los datos (meses sin datos, montos negativos) |

**Modo híbrido:** si hay `OPENAI_API_KEY` (en Ajustes o variable de entorno) y señal, un LLM redacta la síntesis ejecutiva; si falla o estás sin señal, el motor heurístico local (regresión, z-score, plantillas) produce el veredicto sin detener la app. El interruptor **"Modo bajo consumo"** en Ajustes desactiva toda llamada externa.

---

## 4. Seguridad y datos

- **Cifrado E2E:** todos los JSON del negocio (`empresa`, `movimientos`, `parametros`, `snapshots`, `blockchain`) viajan cifrados con Fernet; la clave se deriva de tu contraseña maestra y **nunca se guarda**. En disco no hay nada legible.
- **Blockchain embebida:** cada operación CRUD se sella en `data/blockchain.json` con SHA-256 encadenado, prueba de trabajo (`000`) y raíz de Merkle global. La vista **Cadena** detecta manipulaciones al instante (prueba forense de gestión).
- **Persistencia y migración:** JSON nativo (atómico, sobrevive cortes de energía) → **SQLite `Klculos_Emp.db` automática** (sincroniza al cambiar la huella de datos) → MySQL/PostgreSQL **preparados**: instala el driver (`mysql-connector-python` o `psycopg2-binary`) y llena `config/settings.json → bases_datos`.
- **Login:** código de 6 dígitos por email (SMTP con contraseña de aplicación) o modo offline (QR en pantalla) + contraseña maestra.

---

## 5. Micro-apps (vistas del dashboard)

**Panel** (salud global + campana de alertas + 16 KPI + gráficos) · **Movimientos** (CRUD ingresos/gastos) · **Parámetros** (inventario, clientes, marketing, capital, financieros, impuestos) · **Finanzas** (Estado de Resultados en cascada + desglose fijo/variable + Punto de Equilibrio, con referencia en la 2ª moneda) · **Alertas** (centro de mando en tiempo real con "Ir a actuar") · **Enjambre IA** (análisis y predicciones) · **Cuadro Mando** (BSC 4 perspectivas) · **Reportes** (previsualización + PDF/DOC/TXT) · **Espacios** (multi-negocio + asistente de alta en 4 pasos) · **Cadena** (blockchain) · **Guía** (instructivo integrado: pasos, glosario, fórmulas, FAQ) · **Ajustes** (empresa, monedas/tasas, IA, SMTP, salvas, motores, sesión).

Los reportes se generan por **semanal, mensual, trimestral, semestral, nonestre (9 meses, Ene–Sep) y anual**, con vista previa en texto y exportación PDF (ReportLab), DOC (python-docx) y TXT — incluyen el Estado de Resultados detallado, el punto de equilibrio, el desglose fijo/variable y las alertas activas. Por defecto se guardan en `data/exportes/`.

## 6. Documentación

| Documento | Audiencia |
|---|---|
| `docs/INSTALACION.md` | Usuario: **todas las opciones de instalación** (Windows/Linux/Mac, móvil, offline, SQL) |
| `docs/GUIA_RAPIDA.md` | Usuario: 1 página para arrancar |
| `docs/MANUAL_USUARIO.md` | Usuario: manual completo paso a paso, sin conocimientos previos |
| `docs/MODELO_FINANCIERO.md` | Ambos: fórmulas, umbrales, clasificación y alertas explicadas |
| `docs/DESPLIEGUE_MULTI_PC.md` | Usuario: instalar como **plataforma en varias PC** (red local, SQL, VPS, .exe) |
| `docs/EJECUTABLE_WINDOWS.md` | Usuario: crear el **.exe de Windows** sin Python |
| `docs/ROLES_Y_MULTIUSUARIO.md` | Ambos: diseño multi-cálculo, multi-tarea, **usuarios y roles** (próxima versión) |
| `docs/GITHUB_Y_SINCRONIZACION.md` | Usuario: publicar el proyecto en **GitHub** y sincronizar versiones/actualizaciones |
| `docs/DESARROLLADORES.md` | Desarrolladores: arquitectura, módulos, extensiones, pruebas, empaquetado |

También dentro de la app: vista **Guía** (Primeros pasos · Glosario simple · Fórmulas · Preguntas frecuentes).

## 7. Estructura del proyecto

```
Klculos-Emprend/
├── run.py                     # lanzador único (escritorio / --web)
├── requirements.txt
├── app/
│   ├── main.py                # enrutador + shell (rail filtrado por rol, 14 micro-apps)
│   ├── state.py               # EstadoApp: sesión, roles, espacios, tareas, alertas
│   ├── core/                  # CAPA 1 (modelos, finanzas, indicadores, alertas,
│   │                          #   monedas, espacios, salvas, usuarios/roles, tareas)
│   ├── data/                  # CAPA 2 (JSON cifrado E2E, blockchain, repositorios, migrador)
│   ├── ai/                    # CAPA 3 (enjambre + OpenAI híbrido)
│   ├── services/              # CAPA 4 (auth con roles, QR, email, exportador)
│   └── ui/                    # CAPA 5 (14 vistas y componentes Flet)
├── docs/                      # documentación usuario + desarrolladores
├── tests/                     # suite unittest (69 pruebas)
├── config/                    # settings.json (IA, SMTP, bases de datos)
├── data/                      # se crea al primer arranque (JSON cifrado + Klculos_Emp.db)
└── demo_output/               # reportes de ejemplo generados con la demo
```

## 8. Pruebas

```bash
python -m unittest discover -s tests -v      # 69 pruebas
python run.py --doctor                        # diagnóstico de la instalación
```

## 9. Novedades y hoja de ruta

✅ **Hecho en v3.5:** menú lateral desplazable (las 14 opciones siempre accesibles en pantallas bajas, sin recortes), tarjeta de **Accesos rápidos** en el Panel con todas las micro-apps a un clic (filtrada por rol) y tarjeta de **Configuración importante** con espacio activo, empresa, moneda/tasa y sesión, más botones "Abrir Ajustes" y "Actualizar tasas en línea".

✅ **Hecho en v3.0:** multi-usuario con 5 roles (dueño, admin, editor, consulta, visualizador) y matriz de permisos, usuarios con clave del cofre envuelta (cada quien entra con su propia contraseña), vista Usuarios, multi-tarea en segundo plano (vista Tareas: exportaciones y migración SQL sin congelar la UI), guía DOCX completa de despliegue (ejecutable, otras PC, evaluación de opciones).

✅ **Hecho en v1.1/2.x:** monedas (CUP default + 23 mundiales, tasas en línea), espacios de trabajo con asistente de 4 pasos, salvas de configuración, ejecutable Windows (`empaquetar_windows.bat`), guía GitHub, despliegue multi-PC.

- **Comparador entre espacios** y transferencias entre negocios.
- **Cambio de contraseña maestra** con re-envoltura de todos los usuarios.
- **Modo servidor robusto** para 5–10 usuarios simultáneos en red local (ver `docs/DESPLIEGUE_MULTI_PC.md`).

## 10. Notas

- **Sin Docker** y multiplataforma: solo Python 3.10–3.13 (recomendado 3.12; con 3.14 la app se rescata sola al modo navegador).
- Poca señal: todo el cálculo es local; las únicas llamadas externas son OpenAI (opcional) y SMTP (opcional), con degradación elegante.
- La calibración de umbrales con el ebook original se hace editando `app/core/indicators/catalog.py` (fórmulas, umbrales y acciones); los cambios futuros quedan sellados en la cadena.
