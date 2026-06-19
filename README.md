# Savvi - Finanzas Personales Inteligentes

**Savvi** es una solucion integral de gestion financiera diseñada para eliminar la friccion en el registro de gastos diarios y proporcionar claridad sobre la salud econmica del usuario. Este proyecto es la materializacion de un proceso de ingenieria de software documentado, aplicando principios de **Clean Architecture**, **Cloud Computing** y diseño **Offline-First**.

## Stack Tecnologico

La arquitectura de Savvi es hibrida, combinando la agilidad de un *Backend as a Service* (BaaS) con el procesamiento avanzado en la nube:

* **Frontend:** [Flutter](https://flutter.dev/) (Framework multiplataforma)
*   **Gestión de Estado:** [Riverpod](https://riverpod.dev/) (Arquitectura reactiva y testeable).
*   **Base de Datos Principal:** [Supabase](https://supabase.com/) (PostgreSQL relacional).
*   **Persistencia Local:** [SQLite](https://sqlite.org/) (Estrategia Offline-First).
*   **Cloud Engine:** [Python](https://www.python.org/) + [FastAPI](https://fastapi.tiangolo.com/) (Procesamiento de reportes).
*   **Infraestructura:** [Google Cloud Platform](https://cloud.google.com/) (Cloud Run & Storage).


## Estructura del Proyecto (Clean Architecture)

El codigo esta organizado por **Features** (caracteristicas), facilitando el mantenimiento y la escalabilidad del sistema:

```text
lib/
 ├── core/              # Lógica global, constantes, temas y utilidades.
 │    ├── constants/    # API Keys y configuraciones de servicios.
 │    ├── theme/        # Design System (Colores, Tipografías).
 │    └── utils/        # Formateadores y validadores.
 ├── data/              # Capa de datos y persistencia.
 │    ├── models/       # Modelos de datos (clases Dart).
 │    └── repositories/ # Lógica de sincronización Supabase <-> SQLite.
 ├── features/          # Funcionalidades específicas del negocio.
 │    ├── auth/         # Registro, Login y Gestión de sesión.
 │    ├── dashboard/    # Resumen financiero y gráficas.
 │    ├── savings/      # Gestión de metas de ahorro.
 │    └── transactions/ # CRUD de ingresos y egresos.
 ├── shared/            # Componentes visuales reutilizables (UI Kit).
 └── main.dart          # Punto de entrada de la aplicación.