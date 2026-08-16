---
name: pr
description: Crea un pull request de los cambios pendientes — rama, commit, push y gh pr create — con título y descripción en español siguiendo la convención del repositorio. Úsala cuando el usuario pida abrir un PR, subir los cambios, crear una rama para entregar o publicar el trabajo de la actividad. Delega la ejecución en Haiku, el modelo más barato.
allowed-tools: Bash, Glob, Grep, Read, Agent, AskUserQuestion
model: haiku
---

# Crear pull request

Repositorio: `1756096090/Actividad2_rovers`, base `main`. Todo el texto del
commit y del PR va **en español**.

## Convenciones

| Elemento | Regla | Ejemplo |
| --- | --- | --- |
| Rama | `<tipo>/<descripcion-corta>` en kebab-case | `chore/estructura-carpetas` |
| Tipo | `feat`, `fix`, `docs`, `chore`, `refactor` | — |
| Commit | Conventional Commits, asunto imperativo ≤ 72 car. | `chore: reorganizar la estructura de la actividad 2` |
| Título PR | mismo asunto que el commit principal | — |

Cuerpo del PR:

```markdown
## Qué cambia
- <viñetas concretas, una por cambio real>

## Por qué
<una o dos frases>

## Cómo verificarlo
- <comando o comprobación manual>
```

## Procedimiento

1. **Diagnóstico.** En paralelo: `git status --short`, `git branch --show-current`,
   `git log --oneline -5`, `git diff --stat` y `git diff --cached --stat`.
   Si no hay nada pendiente ni commits por delante de `origin/main`, dilo y para.

2. **Redacción.** Lee el diff real (no adivines) y redacta rama, mensaje de
   commit y cuerpo del PR. Las viñetas describen lo que el diff hace, nunca lo
   que se pretendía hacer. Muéstraselo al usuario y espera su visto bueno.
   Si hay varios cambios sin relación entre sí, propón separarlos en PRs
   distintos antes de seguir.

3. **Ejecución (delegada, siempre en Haiku).**

   ```
   Agent(subagent_type: "preparador-pr", model: "haiku",
         run_in_background: false,
         prompt: "<rama + mensaje de commit + cuerpo del PR aprobados,
                  literales, y qué archivos añadir>")
   ```

   Si `preparador-pr` no aparece en la lista de agentes (por ejemplo en la sesión
   en que se acaba de crear), usa el mismo prompt con
   `subagent_type: "general-purpose", model: "haiku"` y copia al principio del
   prompt las reglas de `.claude/agents/preparador-pr.md`. El modelo **siempre**
   es `haiku`: nunca ejecutes este paso con un modelo más caro ni sin el
   parámetro `model`.

4. **Verificación.** Comprueba tú mismo el resultado: `git log --oneline -3`,
   `git status --short` y la URL del PR. Reporta lo que realmente pasó, incluido
   lo que falló.

## Restricciones

- Nunca commits ni push directos a `main`: siempre rama + PR.
- Nunca `--force`, `--no-verify` ni reescritura de historial.
- No añadas al commit archivos temporales de Office (`~$*.docx`), `.obsidian/`
  ni nada que parezca una credencial. Si aparecen, avisa y propón un
  `.gitignore`.
- `gh` puede no estar autenticado en esta máquina. Si `gh auth status` falla,
  para y pide al usuario que escriba `! gh auth login` en el prompt (el prefijo
  `!` ejecuta el comando en la sesión, que es interactivo y no puedes hacerlo
  tú). El commit y el push pueden quedar hechos; el PR se crea después.
- El binario `gh` está disponible (v2.94).
