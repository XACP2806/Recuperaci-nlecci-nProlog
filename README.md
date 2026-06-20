# RPG Prolog Engine — Simulador Lógico de Aventuras y Combates

Aplicación web académica que integra Laravel y Prolog para simular la toma de decisiones, evaluación de requisitos y resolución de combates en un entorno RPG.

## Descripción

**RPG Prolog Engine** es un sistema híbrido que utiliza un frontend en Laravel para la interacción con el usuario y un backend estrictamente lógico programado en SWI-Prolog. El sistema permite a los usuarios formar equipos de aventureros y enviarlos a misiones o batallas. 

Toda la evaluación de victoria, derrota o viabilidad de misiones no se programa con condicionales tradicionales en PHP, sino que se delega a una **Base de Conocimientos (Prolog)** que evalúa recursivamente los niveles, inventarios y requisitos del equipo.

---

## Flujo del Proyecto

> **Usuario final selecciona su equipo en la interfaz**
> ⬇
> **Elección de acción: Enviar a Misión o Iniciar Batalla**
> ⬇
> **Laravel formatea los datos y ejecuta el comando en la terminal**
> ⬇
> **Prolog evalúa hechos y reglas lógicas (Niveles, objetos, recursividad)**
> ⬇
> **Prolog genera un reporte gramaticalmente correcto**
> ⬇
> **Laravel captura la salida estándar y la muestra en la consola virtual**

---

## Stack Tecnológico

| Capa / Módulo | Tecnología |
| :--- | :--- |
| **Frontend / Interfaz** | Laravel + Blade + Bootstrap 5 (CDN) |
| **Controlador** | PHP 8.x |
| **Motor Lógico (Cerebro)** | SWI-Prolog |
| **Integración** | `shell_exec` (CLI / Comandos de Sistema) |
| **Estilos** | CSS Custom (Dark Theme RPG) |
| **Gestión de dependencias**| Composer |

---

## Estructura del Repositorio

acceso-estadio-laravel/
├── app/
│   ├── Http/
│   │   └── Controllers/
│   │       └── GameController.php    <-- Intermediario PHP-Prolog
├── public/
├── resources/
│   └── views/
│       └── game.blade.php            <-- Interfaz gráfica del simulador
├── routes/
│   └── web.php                       <-- Definición de rutas web
├── .env
├── README.md
└── Actividad_extra.pl                <-- Base de conocimientos lógicos (Motor Prolog)


---

## Módulos del Sistema

### 1. Interfaz de Usuario (Frontend Web)
Se encarga de recolectar las decisiones del jugador y mostrar los resultados de manera visual e intuitiva.
* Selección múltiple de personajes para formar un escuadrón.
* Paneles divididos para elegir entre el módulo de "Misiones" o "Batallas".
* Visualizador de resultados tipo "Consola de comandos" (Oráculo).

### 2. Controlador de Integración (Laravel)
Actúa como puente de comunicación.
* Recibe el array de personajes desde la vista.
* Formatea los datos de PHP a listas de Prolog (ej. `['Elara', 'Kael']`).
* Construye el comando de ejecución llamando al ejecutable `swipl`.
* Captura la salida generada por Prolog y la devuelve a la vista mediante sesiones.

### 3. Base de Conocimientos (Backend Lógico)
Archivo `.pl` que contiene el estado del mundo y la lógica del juego.
* **Hechos:** Define los personajes, sus clases, niveles, inventarios, enemigos y misiones.
* **Reglas:** Evalúa mediante recursividad si la suma de niveles del equipo es suficiente para un reto.
* **Procesamiento de Lenguaje:** Formula oraciones coherentes dependiendo de si el equipo es de uno o varios integrantes (singular/plural).

---

## Base de Conocimientos y Lógica (Prolog)

En lugar de una base de datos relacional (SQL), el sistema utiliza predicados y afirmaciones lógicas:

**Hechos principales definidos:**
* `personaje(Nombre, Clase, Nivel).`
* `tiene(Personaje, Objeto).`
* `mision(ID, Nombre, NivelRequerido, ObjetoRequerido).`
* `enemigo(Nombre, Vida, Danio).`
* `arma(Nombre, MultiplicadorDanio).`

---

## Reglas de Negocio

### Misiones
* Un equipo es una lista variable de personajes (de 1 a N).
* Para que una misión sea viable, la suma total de los niveles del equipo debe ser mayor al nivel de dificultad de la misión.
* **Restricción de Objetos:** Al menos **un** integrante del equipo debe poseer en su inventario todos los objetos requeridos por la misión. Si falta nivel o el objeto, la misión se declara como fallida.

### Batallas
* Para ganar una batalla, el daño total del equipo debe ser estrictamente mayor a la vida del enemigo.
* El daño se calcula sumando el nivel base de cada personaje más el modificador de poder de sus armas equipadas (ej. la *Espada de luz* otorga daño extra).
* Si el daño total no supera la vida del enemigo, el equipo es derrotado.

---

## Rutas Principales

| Ruta | Método | Controlador | Descripción |
| :--- | :--- | :--- | :--- |
| `/` | `GET` | `GameController@index` | Carga la interfaz principal y los selectores |
| `/consultar` | `POST` | `GameController@consultar` | Procesa el formulario, ejecuta Prolog y retorna el resultado |

---

## Instalación y Ejecución

**Requisitos Previos:**
Debes tener instalado **PHP**, **Composer** y **SWI-Prolog** (asegurándote de que el comando `swipl` esté agregado a las variables de entorno/PATH de tu sistema).

**1. Clonar el repositorio**
git clone [tu-enlace-de-github]
cd juego_laravel


**2. Instalar dependencias de Laravel**
composer install


**3. Configurar entorno y generar clave**
copy .env.example .env
php artisan key:generate


**4. Configurar Ruta del Motor Lógico**
Abre el archivo `app/Http/Controllers/GameController.php` y asegúrate de que la variable `$pathProlog` apunte a la ubicación exacta del archivo `Actividad_extra.pl` en tu máquina local.

**5. Levantar el servidor**
php artisan serve

La aplicación quedará disponible en: http://127.0.0.1:8000

---

## Validaciones Implementadas

* Validación en el backend para evitar consultas si el usuario envía un equipo vacío.
* Captura de errores por si el ejecutable `swipl` no se encuentra en el sistema.
* Resolución de fallos lógicos (Prolog hace un "catch-all" automático gracias al orden de sus reglas, evitando que la aplicación colapse si no se cumplen las condiciones de éxito).

---

## Participante

| Integrante | Rol |
| :--- | :--- |
| **Xavier Cardenas** | Desarrollador Full-Stack (Laravel) y Programador Lógico (Prolog) |

> *Proyecto académico — Lenguajes de Programación · UEES · 2026*
