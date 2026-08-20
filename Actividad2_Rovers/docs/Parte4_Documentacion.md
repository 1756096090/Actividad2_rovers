---
materia: Razonamiento y planificación automática
actividad: 2
tipo: modificación de dominio (Parte 4)
tags:
  - pddl
  - planificación
  - rovers
  - parte4
---

## Idea central

La Parte 4 pide incorporar una nueva funcionalidad al dominio base
(`rovers_dominio.pddl`): representar que el lander solo puede usarse en
determinados waypoints, y permitir que dos rovers diferentes lo remolquen
a otro punto cuando esté en un lugar inadecuado.

> [!important] Cambio clave
> Sin la nueva acción de remolque, un lander que empieza en un waypoint no
> apto deja **irresoluble** cualquier problema que dependa de comunicar
> datos o recargar batería.

## Archivos utilizados

| Archivo | Función |
| --- | --- |
| `Actividad2_Rovers/src/rovers_parte4_dominio.pddl` | Dominio base + los 3 cambios de la Parte 4 (predicado, restricciones, nuevo operador). |
| `Actividad2_Rovers/src/rovers_parte4_problema.pddl` | Caso de prueba diseñado para exigir el uso de la nueva funcionalidad. |
| [[Parte4_Resumen]] | Resultados reales de ejecución contra el planificador remoto y prueba de necesidad. |

## Cambios sobre el dominio base

**1. Nuevo predicado `(suitable_for_lander ?w - waypoint)`.**
Marca qué waypoints son físicamente adecuados para el lander (radiación
solar suficiente + comunicación con la Tierra). Es unario sobre
`waypoint`, no depende del lander concreto, para mantener el cambio
genérico frente al número/nombre de landers.

**2. Restricción de las acciones que usan el lander.**
`recharge`, `communicate_soil_data`, `communicate_rock_data` y
`communicate_image_data` ahora exigen `(suitable_for_lander ?w)` sobre el
waypoint donde está el lander. Si está en un sitio no adecuado, ninguna de
estas acciones es aplicable.

**3. Nuevo operador `tow_lander`.**
Dos rovers diferentes (`(not (= ?r1 ?r2))`, requiere `:equality`) remolcan
el lander de un waypoint a otro. Restricciones análogas a `navigate-bat`
(`can_traverse` y `visible` para ambos rovers, batería con el mismo
esquema de niveles discretos `blevel`/`lower`, sin fluents numéricos).
Los tres vehículos empiezan y terminan juntos, y la acción consume un
nivel de batería de cada uno de los dos rovers.

## Caso de prueba diseñado

El lander (`general`) empieza en `waypoint0`, que **no** es apto. El único
waypoint apto es `waypoint2` (`suitable_for_lander`). `rover0` y `rover1`
empiezan junto al lander, así que el primer paso de cualquier plan válido
tiene que ser remolcarlo a `waypoint2`; después cada rover se separa a
tomar su muestra (`rover0` → suelo en `waypoint1` + foto de `objective1`;
`rover1` → roca en `waypoint3`) y comunican desde donde terminan, porque
la visibilidad entre los 4 waypoints es completa.

## Pendiente

- [ ] Captura de pantalla de la ejecución en `editor.planning.domains` o
  VS Code (Apéndice de la memoria) — los resultados ya están verificados
  en [[Parte4_Resumen]], falta la evidencia visual.
