---
materia: Razonamiento y planificación automática
actividad: 2
tipo: documentación de ejecución
tags:
  - pddl
  - planificación
  - rovers
---

## Idea central

Se resolvió el problema PDDL *Rovers* mediante la extensión PDDL de VS Code conectada al planificador remoto `solver.planning.domains`. El resultado es un plan válido que comunica una imagen de alta resolución, una muestra de suelo y una muestra de roca.

> [!important] Resultado obtenido
> El planificador encontró una solución de coste 12 para los tres objetivos definidos en `rovers_problema.pddl`.

## Archivos utilizados

| Archivo | Función |
| --- | --- |
| `Actividad2_Rovers/src/rovers_dominio.pddl` | Define los tipos, predicados y acciones del dominio. |
| `Actividad2_Rovers/src/rovers_problema.pddl` | Define el estado inicial, los objetos y los objetivos del problema. |
| [[Resumen]] | Conserva el registro completo de evidencias y el listado del plan. |

## Configuración del planificador

1. Abrir los archivos `.pddl` del dominio y el problema en VS Code.
2. Instalar o activar la extensión **PDDL**.
3. Abrir la selección de planificador con `Ctrl + Alt + P`.
4. En **Planning engine**, elegir **Planning as a service (solver.planning.domains)**.
5. Usar el servicio remoto indicado por la actividad: `https://solver.planning.domains:5001/package`.
6. Ejecutar la búsqueda desde la extensión PDDL.

## Objetivos del problema

El estado objetivo exige comunicar al módulo de aterrizaje los siguientes datos:

- muestra de suelo tomada en `waypoint2`;
- muestra de roca tomada en `waypoint3`;
- imagen de alta resolución de `objective1`.

El rover comienza en `waypoint1`, dispone de cámara, almacén y batería, y puede navegar entre los puntos permitidos por `can_traverse`.

## Ejecución y resultado

El algoritmo **Fast-BFS** expandió 113 nodos y encontró un plan. La búsqueda interna concluyó en aproximadamente 0,00053 segundos; la salida de la extensión informó de 2,741 segundos hasta encontrar el plan.

La solución realiza, en orden:

1. Calibración de la cámara para `objective1`.
2. Captura y comunicación de la imagen de alta resolución.
3. Navegación a `waypoint2`, recarga y toma de muestra de suelo.
4. Regreso a la zona desde la que puede comunicarse la muestra de suelo.
5. Navegación a `waypoint3`, liberación del almacén, toma de muestra de roca y comunicación de sus datos.

## Evidencias

Las capturas recibidas muestran:

- la elección del servicio de planificación remoto;
- el diagrama de acciones y estados del plan;
- la salida textual con las 12 acciones, métrica `0.011000000000000003`, *makespan* equivalente y un plan encontrado.

> [!note] Capturas en Obsidian
> Cuando los PNG se guarden en `99_Adjuntos/Imagenes`, se pueden incrustar aquí con enlaces `![[nombre-de-la-captura.png]]`.

## Conclusión

La ejecución verifica que el dominio y el problema son compatibles con el planificador remoto y que existe una secuencia de acciones capaz de alcanzar todos los objetivos establecidos.
