---
name: estructurar
description: Reorganiza y renombra los archivos del repositorio de la actividad (PDDL, documentación, imágenes, entregables) siguiendo la convención del máster. Úsala cuando el usuario pida ordenar, estructurar, renombrar, limpiar nombres de archivo o preparar la entrega. Delega el trabajo mecánico en Haiku, el modelo más barato.
allowed-tools: Bash, Glob, Grep, Read, Edit, Agent, AskUserQuestion
model: haiku
---

# Estructurar y renombrar

Objetivo: dejar el repositorio con nombres y carpetas consistentes **sin tocar el
contenido** de los archivos (salvo rutas rotas en los `.md`).

## Convención

| Elemento | Regla | Ejemplo |
| --- | --- | --- |
| Nombres | sin espacios ni acentos, `_` como separador | `Rubrica_MIA_RYPA_act2.xlsx` |
| Código | minúsculas | `rovers_dominio.pddl` |
| Notas Obsidian | `PascalCase`, se enlazan por nombre | `Documentacion.md` |
| Entregable | `muinar04_act<N>.<ext>`, sin ` (1)` ni ` copia` | `muinar04_act2.docx` |
| Imágenes | `act<N>_<descripcion>[_NN].png` | `act2_planificador_01.png` |

Estructura objetivo:

```
Actividad<N>_<Tema>/
  src/        .pddl y código
  docs/       Documentacion.md, Resumen.md
  entrega/    muinar04_act<N>.docx, rúbrica
  images/     capturas
README.md     en la raíz
```

## Procedimiento

1. **Inventario.** `git status --short` y `git ls-files` + Glob de los no
   versionados. Detecta: espacios, acentos, sufijos `(1)`, mayúsculas
   inconsistentes, archivos fuera de su carpeta.

2. **Plan.** Presenta al usuario la tabla `antes -> después` y espera su visto
   bueno **antes de mover nada**. Si algún nombre es ambiguo (p. ej. qué describe
   `image1.png`), abre los archivos con Read para nombrarlos bien, y usa
   AskUserQuestion sólo si sigue sin poder decidirse.

3. **Ejecución (delegada, siempre en Haiku).** Una vez aprobado, lanza el
   subagente con el plan aprobado literal en el prompt, en primer plano:

   ```
   Agent(subagent_type: "organizador-archivos", model: "haiku",
         run_in_background: false,
         prompt: "<tabla antes -> después aprobada + instrucción de arreglar
                  referencias rotas en los .md>")
   ```

   Si `organizador-archivos` no aparece en la lista de agentes (por ejemplo en la
   sesión en que se acaba de crear), usa el mismo prompt con
   `subagent_type: "general-purpose", model: "haiku"` y copia al principio del
   prompt las reglas de `.claude/agents/organizador-archivos.md`. El modelo
   **siempre** es `haiku`: nunca ejecutes este paso con un modelo más caro ni sin
   el parámetro `model`.

   Tú no ejecutas los `git mv`: ése es el trabajo barato y mecánico.

4. **Verificación.** Al volver el subagente: `git status --short`, comprueba que
   no quedan referencias rotas (Grep de `](`, `[[`, rutas `.pddl`/`.png` en los
   `.md`) y que ningún archivo se ha perdido. Reporta el resultado real, incluido
   lo que el subagente no pudo hacer.

5. **Commit.** Sólo si el usuario lo pide.

## Restricciones

- Nunca borres archivos; si un destino ya existe, para y pregunta.
- Nada de reescribir contenido de `.pddl`, `.docx` o `.xlsx`.
- Rutas siempre entrecomilladas: el repo tiene espacios y acentos.
- `git mv` para lo versionado (conserva el historial), `mv` para lo demás.
