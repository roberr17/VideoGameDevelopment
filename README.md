# 🎮 Advanced Game Dev & AI Portfolio

![Status](https://img.shields.io/badge/Status-Completed-success)
![Tech](https://img.shields.io/badge/Focus-Game_Engine_%26_AI-blueviolet)
![Algorithm](https://img.shields.io/badge/Algorithms-A*_MinMax_PCG-orange)

Este repositorio compila una serie de **6 prácticas avanzadas** desarrolladas como parte de una especialización en Tecnología de Videojuegos. El objetivo de esta colección es demostrar la implementación técnica de mecánicas complejas, motores físicos, programación gráfica (Shaders) y sistemas de Inteligencia Artificial.

## 📂 Índice de Proyectos

### 🏗️ Parte 1: Mecánicas y Motor (Game Physics & Graphics)

---

#### 🧱 1. The Incredible Machine (Físicas 2D) `[p2-canicas]`
> *Simulación basada en el clásico juego de puzles físicos.*

* **🎮 Jugabilidad:** El jugador debe resolver puzles colocando estratégicamente objetos (trampolines, ventiladores, rampas) en el escenario para guiar una bola autónoma desde un punto de partida hasta la meta, aprovechando la gravedad y las colisiones.
* **Tecnologías:** Detección de colisiones, resolución de restricciones (constraints), **Joints** (Distance, Revolute, Prismatic) y simulación de cuerpos rígidos.

---

#### 🚜 2. Tank Game (Arquitectura y Control) `[p3-tankgame]`
> *Juego de combate de tanques con control vectorial.*

* **🎮 Jugabilidad:** Shooter 2D con controles tipo "tanque" (rotación del chasis y movimiento independientes). El jugador maneja una torreta móvil para apuntar y disparar proyectiles con balística calculada, destruyendo objetivos mientras navega por el entorno.
* **Tecnologías:** Transformaciones matriciales 2D, jerarquía de objetos (padre-hijo) y sistema de proyectiles.

---

#### 💡 3. Lighting and Shaders (Programación Gráfica) `[p4-lighting&shaders]`
> *Implementación de un sistema de iluminación dinámico desde cero.*

* **🎮 Jugabilidad:** Demo técnica interactiva donde el usuario controla la posición de una fuente de luz ("luciérnaga") en tiempo real. Permite alternar entre modos de visualización para observar cómo la luz interactúa con las texturas y mapas de normales del entorno.
* **Tecnologías:** Vertex & Fragment Shaders, Modelos de luz ambiental/difusa/especular (**Phong**) y Normal Mapping.

---

#### ⚡ 4. Tomb of the Mask Inspiration (Mecánicas Arcade) `[p5-tomb-of-the-mask]`
> *Recreación de las mecánicas de movimiento rápido del juego "Tomb of the Mask".*

* **🎮 Jugabilidad:** Juego de laberintos de ritmo rápido. El personaje se mueve en líneas rectas y no se detiene hasta chocar con una pared (mecánica de deslizamiento). El objetivo es recolectar puntos y evitar trampas enemigas con reflejos rápidos.
* **Tecnologías:** Detección de colisiones continua (CCD), gestión de estados del jugador y diseño de niveles basado en tiles.

<br>

### 🧠 Parte 2: Inteligencia Artificial Aplicada (AI)

---

#### 🗺️ 5. Procedural Generation & Pathfinding (PCG + Nav) `[p3-pathfinding]`
> *Sistema híbrido que genera mundos infinitos y permite a la IA navegar por ellos.*

* **🎮 Jugabilidad:** Experiencia tipo RTS (Estrategia en tiempo real). El usuario puede generar infinitos mapas de cuevas aleatorios con un clic. Al seleccionar un destino en el mapa, el personaje calcula y recorre automáticamente la ruta óptima esquivando los muros generados.
* **Tecnologías:** **Cellular Automata** para generación de mapas, ruido procedural (**Perlin**) y algoritmo **A* (A-Star)** con suavizado de rutas.

---

#### ♟️ 6. Minmax & Alpha-Beta Pruning (IA Estratégica) `[p7-alphabeta-prunning]`
> *Desarrollo de una IA capaz de jugar juegos de estrategia por turnos.*

* **🎮 Jugabilidad:** Juego de mesa estratégico (Zero-sum game) contra la CPU. El jugador realiza su movimiento y la IA responde instantáneamente con la jugada óptima para bloquear al humano o ganar la partida, anticipando múltiples turnos en el futuro.
* **Tecnologías:** Algoritmo **MinMax**, **Poda Alfa-Beta** para optimización de árboles de decisión y heurísticas de evaluación de tablero.

---

## 🛠️ Stack Tecnológico General

* **Lenguajes:** Godot (GDScript/C#).
* **Gráficos:** OpenGL / HLSL / GLSL.
* **Conceptos Clave:**
    * Finite State Machines (FSM).
    * Entity Component System (ECS).
    * Matemáticas vectoriales y matriciales.
    * Heurísticas de búsqueda.

## 📸 Galería

| Físicas (Incredible Machine) | Iluminación (Shaders) | IA (Pathfinding) |
|:---:|:---:|:---:|
| ![Physics](url_imagen_1) | ![Shaders](url_imagen_2) | ![AI Pathfinding](url_imagen_3) |

## ✒️ Autor

* **[Roberto]** - *Desarrollador de Software & Game AI* - [GitHub](https://github.com/roberr17)
