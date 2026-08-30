- **Parte 3. Ejecución y evaluación del planificador**

  Ejecute el planificador para generar un plan con cada uno de los
  ficheros anteriores. Responda a las siguientes preguntas en la memoria
  de la actividad.

**[Métricas Summary]{.underline}**

  -----------------------------------------------------------
  **Métrica**               **Caso      **Caso     **Caso
                            inicial**   2.1**      2.2**
  ------------------------- ----------- ---------- ----------
  **Costo del plan          12          20         45
  (acciones)**                                     

  **Nodos generados**       166         369        736

  **Nodos expandidos**      113         181        392

  **Metas detectadas**      6           6          12

  **Tiempo de búsqueda      0.000502    0.001586   0.002989
  (secs)**                                         

  **Makespan (tiempo        0.019       0.019      0.044
  simulado)**                                      

  **Planes encontrados**    1           1          1
  -----------------------------------------------------------

- 3.1. Analice el resultado (plan) y la ejecución (según lo indicado en
  Pautas de Elaboración) del planificador para el caso 2.1. Compare con
  los datos obtenidos en el caso inicial. ¿El *rover* realiza algún
  movimiento innecesario? ¿Puede explicar por qué cree que ocurre esto?

  **[Detallo las características de planner :]{.underline}**

  Se ha corrido el package que habilita el **FF parser version of the
  Best First Width Search** **planner.** Se trata de un planner clásico
  basado en búsqueda en espacio de estados.

  Variante "Fast": Optimiza la implementación de BFS para generar y
  expandir nodos más rápido, reduciendo operaciones redundantes.

  **Importante:** Encuentra el plan con el menor número de acciones (si
  todas las acciones tienen costo uniforme). No se garantiza la ruta más
  eficiente si existen alternativas equivalentes.

  **[Resumen de las principales métricas]{.underline}**

- Nodes generated during search: 369

- Nodes expanded during search: 181

- Goals found: 6

- Goals_Edges found: 6

- Plan found with cost: 20

- Fast-BFS search completed in 0.001586 secs

- Metric: 0.01900000000000001

- Makespan: 0.01900000000000001

- States evaluated: undefined

- Planner found 1 plan(s) in 3.645secs.

  **[Detalle -- metricas de la búsqueda]{.underline}**

- Para tener una idea del tamaño de la búsqueda, el parser generó 118
  acciones posibles a partir del estado inicial, siendo 47 los
  predicados y/ condiciones que describen el estado del mundo.

- El algoritmo detectó 6 metas (goals) y las pudo finalmente encontrar.

  Nodes generated= 369 / expanded= 181: Se generaron 369 estados
  candidatos y se expandieron 181 en detalle.

- En costo del plan, en 20 se relaciona con la cantidad de acciones
  llevadas a cabo. Para simplificar, el costo es igual a la longitud del
  plan.

- Fast-BFS , la métrica del tiempo en que se tarda en encontrar el plan,
  0.001586 secs (segundos)

- Metric / Makespan: 0.019**,** miden el tiempo "simulado" dentro del
  modelo PDDL

- Planner found 1 plan(s) in 3.645secs, significa la sumatoria de tiempo
  de búsqueda pura y tiempo de ejecución completo.

  ![](media/image1.png){width="6.268055555555556in"
  height="2.3097222222222222in"}

![](media/image2.png){width="3.6321314523184602in"
height="1.125057961504812in"}

![](media/image3.png){width="3.583517060367454in"
height="0.8542104111986002in"}

- **Aspectos relevantes:**

  Dentro de la consigna de la actividad 2.1, el principal factor a tener
  en cuenta en este caso, es la agregación de un nuevo WP4 y que el
  rover tiene que finalizar en el WP1. Asimismo, como objetivo a lograr,
  se agrega que hay que informar las muestras tomadas de suelo y roca
  del WP4. En definitiva, estamos agregando complejidad al escenario
  planteado respecto al inicial por lo que es de esperar mayores
  cantidades de pasos hacia el objetivo final.

  Básicamente el rover aprovecha su posición y toma las fotos desde
  donde está situado WP1, por supuesto tiene que chequear y calibrar la
  cámara antes. Luego se dirige al WP4 donde tomas las muestras de suelo
  y roca respectivamente. Se dirige con una de las muestras cargada
  hacia al WP2. Una vez allí, aprovecha para vaciarse y tomar la muestra
  de suelo del WP2. En este punto opta por dirigirse al WP1 para enviar
  los datos de la muestra tomada en el WP2 y se descarga para dirigirse
  al WP3. Una vez allí toma la muestra de roca, dispara la señal luego
  de visibilizar al Lander (que está situado en el WP2) y decide
  finalizar su trayecto hacia el WP1. En definitiva, el planner eligió
  WP1 como nodo de comunicación por heurística, aunque WP3 también era
  posible. Hay que comentar que, para enviar datos, hay que visibilizar
  la posición del Lander ubicado en el WP2, o sea no puedo mandar datos
  estando en el WP2, porque no hay visibilización.

  **Análisis comparado**

  Desde ya que el plan alternativo tiene mayor complejidad, ya que se
  agregan mayores restricciones (rover finalice en WP1) y un objetivo
  más completo para la toma muestras en WP4.

  La acción del planner que puede cuestionarse tiene que ver con que una
  vez que el rover se encuentra en el WP2, tiene la chance de ir hacia
  el WP3 o bien WP1 para enviar la información de la muestra de roca
  (WP2), se recuerda que la visibilidad hacia el WP2 se logra desde WP3
  o bien WP1. Por algún motivo, el planner decide enviar al rover al WP1
  para enviar los datos de la muestra de suelo del WP2, para viajar
  luego vacío al WP3. Podría haber optado por enviar al rover al WP3
  directamente, enviar la señal al wp2 y si partir desde ahí para
  finalizar su trayecto en el WP1.

  En la concepción de la herramienta no necesariamente asegura
  optimalidad en la infinidad de estados posibles, solo se asegura que
  un plan sea el de menor costo entre los que va analizando. También
  entiendo que el algoritmo prioriza el tiempo de ejecución y tal vez
  marginalmente no haya mucha diferencia entre las alternativas, por lo
  que se asegura una búsqueda más rápida y viable.

  En cuanto a las métricas comparadas, el plan 2.1 tiene un costo
  considerable mayor de 20 respecto a 12 de la situación inicial. Los
  nodos generados y expandidos (369 vs 166), y (181 vs 113) evidencian
  el aumento de complejidad. El algoritmo sigue siendo rápido, pero en
  términos relativos duplicó el tiempo de resolución (0.001244 secs
  versus 0.000502 secs)

- 3.2. Analice el resultado (plan) y la ejecución (según lo indicado en
  Pautas de Elaboración) del planificador para el caso 2.2 y compare con
  el plan original. ¿El nuevo plan utiliza el nuevo *rover* (rover1)
  introducido en el problema? ¿Lo hace de la mejor forma posible? ¿Puede
  evaluar por qué se da este efecto?

  **[Detalle -- métricas de la búsqueda]{.underline}**

- Para tener una idea del tamaño de la búsqueda, el parser generó 172
  acciones posibles a partir del estado inicial, siendo 59 los
  predicados y/ condiciones que describen el estado del mundo.

- El algoritmo detectó 12 metas (goals) y las pudo finalmente encontrar.

  Nodes generated= 736 / expanded= 392: Se generaron 736 estados
  candidatos y se expandieron 392 en detalle.

- En costo del plan, en 45 se relaciona con la cantidad de acciones
  llevadas a cabo. Para simplificar, el costo es igual a la longitud del
  plan

- Está la métrica del tiempo en que se tarda en encontrar el plan,
  0.002989 secs (segundos)

- Metric / Makespan: 0.044**,** miden el tiempo "simulado" dentro del
  modelo PDDL

- Planner found 1 plan(s) in 3.645secs, significa la sumatoria de tiempo
  de búsqueda pura y tiempo de ejecución completo.

![](media/image4.png){width="6.268055555555556in"
height="2.089583333333333in"}

![](media/image5.png){width="3.694634733158355in"
height="1.1320024059492564in"}

![](media/image6.png){width="3.2362773403324585in"
height="0.8819892825896762in"}

- **Aspectos relevantes:**

  Dentro de la consigna, se menciona como elemento nuevo el agregado de
  un nuevo rover (rover1), que tendrá la capacidad de moverse y sacar
  imágenes de todos los objetivos planteados. Por una cuestión de
  prestaciones y del ejercicio se decide agregarle todos los modos
  posibles a la cámara (colour, high res, low res). El planner arranca
  con el rover0 que esta en el WP1 tomando muestras de suelo para ser
  enviadas el WP2. También toma fotos del objetivo1 en hig res y del
  objetivo0 a color. El rover1 que se sitúa en WP0 entra en acción
  tomando imágenes restantes, obj1 color, obj0 HR, obj0 LR, obj1 LR. Con
  eso se completa las tareas relativas a imágenes.

  Luego aparece el rover0 situado en WP1, viaja hasta el WP2, deja su
  carga, recarga batería y toma muestras de suelo y roca, haciendo dos
  viajes con el WP1, o sea para poder trasmitir la información necesita
  de la visibilidad del WP2. Desde el WP1 viaja al WP3. Estando ahí,
  toma muestras de suelo y roca que son datos comunicados al WP2. Desde
  ahí viaja el WP0, vacía su carga, y finalmente toma muestras de suelo
  que luego serán informadas al WP2.

  **Análisis comparado**

  El nuevo plan que incorpora el rover1, en base a las definiciones que
  tienen, está capacitado para solo tomar imágenes, y es lo que realiza
  cuando está situado en el WP0. Es decir, de acuerdo con el objetivo,
  saca todas las imágenes que le son afines al cumplimiento del
  objetivo, si bien es una tarea compartida con el rover0, el rover1
  cumple con su parte para lo que fue programado en el dominio.

  Hay algo interesante para plantear que tiene que ver con las funciones
  del rover1. Al estar limitado en sus funciones como "sacador de
  fotos", todo el trabajo restante de recolección de muestras recae en
  el rover0, por tanto, el plan final se hace bastante más extenso que
  el original. (comparar costo de 45 versus 12), o sea en más de 3 veces
  costoso!!!.\
  Si se hubieran definido otras capacidades al rover1, probablemente se
  hubieran acortado los movimientos de su partner, rover0. La generación
  y expansión de los nodos también reflejan lo extensivo del plan
  comparado con el original, siendo (736 vs 166), y (392 vs 113)
  evidencian el aumento de las acciones ya que las tareas de movimiento
  han recaído en el rover0.

  En conclusión, el nuevo plan distribuye solo las imágenes, dejando el
  resto igual, por lo que el planner agrega mayores cantidades de pasos
  que repercuten en los tiempos de ejecución del algoritmo pasando de
  una situación inicial de 0.000502 secs, a una realización del plan en

  0.002989 secs, es decir es términos relativos, si es evidente.
