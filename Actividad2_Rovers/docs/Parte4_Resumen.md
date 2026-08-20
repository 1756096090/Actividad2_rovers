## Idea central

Resultados reales de ejecutar `rovers_parte4_dominio.pddl` +
`rovers_parte4_problema.pddl` contra el servicio remoto
`solver.planning.domains:5001` (el mismo backend que usa
`editor.planning.domains` y el plugin PDDL de VS Code).

> [!note] Evidencia visual pendiente
> Estos datos se obtuvieron llamando al servicio directamente. Falta
> repetir la misma ejecución en `editor.planning.domains` o VS Code y
> capturar la pantalla para el Apéndice de la memoria — el resultado será
> idéntico porque es el mismo backend.

## Planificador 1: BFWS -- FF-parser (`dual-bfws-ffparser`)

- Búsqueda: **1-BFWS** (Best-First Width Search).
- Nodos generados: **89**. Nodos expandidos: **39**.
- Coste del plan: **10** acciones.

## Plan generado (BFWS)

| Orden | Acción |
| --- | --- |
| 1 | `tow_lander rover1 rover0 general waypoint0 waypoint2 bat1 b4 b2 b1 bat0 b4 b2 b1` |
| 2 | `navigate-bat rover1 waypoint2 waypoint3 bat1 b4 b1 b0` |
| 3 | `sample_rock rover1 rover1store waypoint3` |
| 4 | `communicate_rock_data rover1 general waypoint3 waypoint3 waypoint2` |
| 5 | `navigate-bat rover0 waypoint2 waypoint1 bat0 b4 b1 b0` |
| 6 | `sample_soil rover0 rover0store waypoint1` |
| 7 | `communicate_soil_data rover0 general waypoint1 waypoint1 waypoint2` |
| 8 | `calibrate rover0 camera0 objective1 waypoint1` |
| 9 | `take_image rover0 waypoint1 objective1 camera0 high_res` |
| 10 | `communicate_image_data rover0 general objective1 high_res waypoint1 waypoint2` |

## Planificador 2: LAMA-first

- Búsqueda: greedy best-first perezosa, guiada por `landmark_sum`
  (26 landmarks) + heurística FF.
- Estados expandidos: **10**. Generados: **69**. Evaluados: **13**
  (24 evaluaciones). Dead ends: 2.
- Coste del plan: **10** acciones (igual que BFWS).

## Plan generado (LAMA-first)

| Orden | Acción |
| --- | --- |
| 1 | `tow_lander rover0 rover1 general waypoint0 waypoint2 bat0 b4 b2 b1 bat1 b4 b2 b1` |
| 2 | `calibrate rover0 camera0 objective1 waypoint2` |
| 3 | `navigate-bat rover0 waypoint2 waypoint1 bat0 b4 b1 b0` |
| 4 | `take_image rover0 waypoint1 objective1 camera0 high_res` |
| 5 | `communicate_image_data rover0 general objective1 high_res waypoint1 waypoint2` |
| 6 | `sample_soil rover0 rover0store waypoint1` |
| 7 | `communicate_soil_data rover0 general waypoint1 waypoint1 waypoint2` |
| 8 | `navigate-bat rover1 waypoint2 waypoint3 bat1 b4 b1 b0` |
| 9 | `sample_rock rover1 rover1store waypoint3` |
| 10 | `communicate_rock_data rover1 general waypoint3 waypoint3 waypoint2` |

## Comentario general

Ambos planificadores encuentran coste 10 y **los dos usan `tow_lander`
como primer paso**, confirmando que el problema de prueba obliga a usar
la nueva funcionalidad de inmediato. El orden interno difiere porque cada
planificador prioriza distinto la rama de rover0 (foto+suelo) frente a la
de rover1 (roca), pero ambas ramas son independientes entre sí una vez
remolcado el lander y el dominio usa coste unitario, así que cualquier
entrelazado válido cuesta igual.

## Prueba de necesidad: dominio sin `tow_lander`

Se repitió la misma ejecución con una copia del dominio en la que se
eliminó únicamente la acción `tow_lander` (se mantuvo la restricción
`suitable_for_lander` en `recharge`/`communicate_*`). Resultado del
planificador:

```
ff: goal can be simplified to FALSE. No plan will solve it
```

Sin la nueva acción, el lander queda atrapado en `waypoint0` (no apto)
para siempre y el problema pasa a ser **irresoluble**. Esto confirma que
la funcionalidad añadida en la Parte 4 no es redundante: es condición
necesaria para que exista solución en este caso de prueba.

## Ideas para el análisis crítico

- Con una instancia tan pequeña no se aprecia bien la diferencia de
  escalabilidad entre la búsqueda por anchura acotada de BFWS y la
  búsqueda greedy guiada por heurísticas de LAMA; valdría la pena repetir
  la comparación con más waypoints/rovers.
- `tow_lander` no exige que el waypoint de destino sea
  `suitable_for_lander` — podría remolcarse el lander a otro punto
  igual de inadecuado. El enunciado no lo exige para esta parte, pero es
  una limitación a mencionar en la memoria.

## Resultado

El dominio y el problema de la Parte 4 son compatibles con ambos
planificadores de referencia, la nueva funcionalidad se ejercita
correctamente en el caso de prueba, y se verificó de forma directa que es
necesaria (sin ella el problema no tiene solución).
