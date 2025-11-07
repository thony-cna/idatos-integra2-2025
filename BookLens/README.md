# BookLens

BookLens es una plataforma para la integración y visualización de datos relacionados con libros. Este proyecto está dividido en dos partes principales: **backend** (Django) y **frontend** (React).

## Estructura del Proyecto

```
BookLens/
├── backend/      # API REST construida con Django
├── frontend/     # Aplicación web construida con React y pnpm
├── README.md
└── ...
```

---

## Levantar el Backend

1. **Configurar Base de Datos (PostgreSQL)**

   a. Crear la carpeta `postgresql` en `%appdata%` si no existe.

   b. Dentro de la carpeta `postgresql`, crear dos archivos:

   - `.pg_service.conf`:

     ```ini
     [postgres]
     host=localhost
     port=5432
     dbname=idatos     # Se debe cambiar si se uso otro nombre de base de datos
     user=postgres
     ```

   - `pgpass.conf`:
     ```
     localhost:5432:idatos:postgres:1234
     ```
     Donde:
     - `idatos`: Nombre de la base de datos (cambiar si usaste otro)
     - `1234`: Contraseña de PostgreSQL (cambiar por tu contraseña)

2. **Entrar a la carpeta del backend:**

   ```bash
   cd backend
   ```

3. **Crear y activar un entorno virtual:**

   ```powershell
   # Crear el entorno virtual (solo la primera vez)
   python -m venv venv

   # Activar el entorno virtual
   # En Windows (PowerShell):
   .\venv\Scripts\activate
   # En Windows (CMD):
   venv\Scripts\activate
   # En Mac/Linux:
   source venv/bin/activate
   ```

4. **Instalar dependencias y correr el servidor:**

   ```bash
   # Asegúrate de estar dentro del entorno virtual (verás (venv) al inicio del prompt)
   python manage.py migrate
   python manage.py runserver
   ```

---

## Levantar el Frontend

1. **Entrar a la carpeta del frontend:**

   ```bash
   cd frontend
   ```

2. **Instalar dependencias con pnpm:**

   ```bash
   pnpm install
   ```

3. **Iniciar la aplicación:**
   ```bash
   pnpm run dev
   ```

---

## Notas

- Asegúrate de tener Python 3.10+ y pnpm instalados.
- El backend corre por defecto en `http://localhost:8000` y el frontend en `http://localhost:5173`.
- Configura las variables de entorno según sea necesario en cada carpeta.
