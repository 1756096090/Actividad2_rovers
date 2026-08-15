## Idea central

La Actividad 2 usa archivos PDDL del problema *Rovers* y el servicio remoto `solver.planning.domains` para generar y visualizar un plan válido.

## Evidencias de ejecución

> [!note] Capturas recibidas por el chat
> Las capturas se han registrado aquí. Para incrustarlas como archivos en Obsidian, deben pegarse o copiarse posteriormente a `99_Adjuntos/Imagenes`.

1. **Configuración del planificador remoto.** En la extensión PDDL de VS Code se seleccionó `Planning as a service (solver.planning.domains)`, correspondiente al servicio indicado por la actividad.
2. **Plan visual.** El visor muestra la secuencia de acciones del rover y los estados de los objetos implicados: calibración de cámara, toma y comunicación de imagen, navegación, recarga, toma y comunicación de muestra de suelo, regreso al almacén, toma y comunicación de muestra de roca.
3. **Salida textual del plan.** Fast-BFS encontró un plan con coste 12 tras expandir 113 nodos. La búsqueda terminó en aproximadamente 0,00053 s; la herramienta informa de un plan encontrado en 2,741 s.

## Plan generado

| Tiempo | Acción |
| --- | --- |
| 0.00000 | `calibrate rover0 camera0 objective1 waypoint1` |
| 0.00100 | `take_image rover0 waypoint1 objective1 camera0 high_res` |
| 0.00200 | `communicate_image_data rover0 general objective1 high_res waypoint1 waypoint2` |
| 0.00300 | `navigate-bat rover0 waypoint1 waypoint2 bat0 b4 b2 b1` |
| 0.00400 | `recharge rover0 general waypoint2 bat0 b4 b1` |
| 0.00500 | `sample_soil rover0 roverStore waypoint2` |
| 0.00600 | `navigate-bat rover0 waypoint2 waypoint1 bat0 b4 b4 b3` |
| 0.00700 | `communicate_soil_data rover0 general waypoint2 waypoint1 waypoint2` |
| 0.00800 | `navigate-bat rover0 waypoint1 waypoint3 bat0 b4 b3 b2` |
| 0.00900 | `drop rover0 roverStore` |
| 0.01000 | `sample_rock rover0 roverStore waypoint3` |
| 0.01100 | `communicate_rock_data rover0 general waypoint3 waypoint3 waypoint2` |

## Resultado

Se obtiene un plan válido que satisface las tareas de imagen, análisis de suelo y análisis de roca del escenario Rovers.
