; ===================================================================
; Rovers - Parte 4: nueva funcionalidad sobre el dominio base
;
; Cambios respecto al dominio original (rovers_dominio.pddl):
;
; 1) Nuevo predicado "suitable_for_lander": indica que un waypoint es
;    fisicamente adecuado para que el lander este ahi (suficiente
;    radiacion solar para repostaje y posibilidad de comunicacion con
;    la Tierra). Es un predicado sobre el tipo waypoint, no depende
;    del lander concreto ni de su nombre, por lo que el cambio es
;    generico para cualquier numero de landers.
;
; 2) Las acciones que usan el lander (recharge, communicate_soil_data,
;    communicate_rock_data, communicate_image_data) ahora exigen que
;    el waypoint donde esta el lander cumpla suitable_for_lander. Si
;    el lander esta en un sitio no adecuado, estas acciones dejan de
;    ser aplicables.
;
; 3) Nuevo operador "tow_lander": permite que dos rovers DIFERENTES
;    remolquen el lander de un waypoint a otro. Usa las mismas
;    restricciones que el movimiento normal (navigate-bat): can_traverse,
;    visible y bateria, pero exigidas para los dos rovers a la vez.
;    Los tres vehiculos (rover1, rover2 y el lander) empiezan y
;    terminan en el mismo punto. Consume un nivel de bateria de cada
;    uno de los dos rovers. No se usan fluents numericos: se sigue el
;    mismo esquema de niveles discretos (blevel) que ya usa navigate-bat.
;
; Nota: se evitan tildes y caracteres especiales en todo el fichero,
; incluidos los comentarios, tal como pide el enunciado.
; ===================================================================

(define (domain Rover-battery)
(:requirements :typing :strips :equality)
(:types rover waypoint store camera mode lander objective
       blevel battery
)

(:predicates (at ?x - rover ?y - waypoint)
             (at_lander ?x - lander ?y - waypoint)
             (can_traverse ?r - rover ?x - waypoint ?y - waypoint)
	     (equipped_for_soil_analysis ?r - rover)
             (equipped_for_rock_analysis ?r - rover)
             (equipped_for_imaging ?r - rover)
             (empty ?s - store)
             (have_rock_analysis ?r - rover ?w - waypoint)
             (have_soil_analysis ?r - rover ?w - waypoint)
             (full ?s - store)
	     (calibrated ?c - camera ?r - rover)
	     (supports ?c - camera ?m - mode)
             (available ?r - rover)
             (visible ?w - waypoint ?p - waypoint)
             (have_image ?r - rover ?o - objective ?m - mode)
             (communicated_soil_data ?w - waypoint)
             (communicated_rock_data ?w - waypoint)
             (communicated_image_data ?o - objective ?m - mode)
	     (at_soil_sample ?w - waypoint)
	     (at_rock_sample ?w - waypoint)
             (visible_from ?o - objective ?w - waypoint)
	     (store_of ?s - store ?r - rover)
	     (calibration_target ?i - camera ?o - objective)
	     (on_board ?i - camera ?r - rover)
	     (channel_free ?l - lander)
            (battery_installed ?r - rover ?b - battery ?bmax ?bcur - blevel)
	     (lower ?l1 ?l2 - blevel)
            ; NUEVO (Parte 4): waypoint fisicamente apto para el lander
            (suitable_for_lander ?w - waypoint)
)


(:action navigate-bat
:parameters (?r - rover ?y - waypoint ?z - waypoint
              ?b - battery ?bmax ?bcur ?bnext - blevel
)
:precondition (and (can_traverse ?r ?y ?z) (available ?r) (at ?r ?y)
                (visible ?y ?z)
                (battery_installed ?r ?b ?bmax ?bcur)
                (lower ?bnext ?bcur)
	    )
:effect (and (not (at ?r ?y)) (at ?r ?z)
             (not (battery_installed ?r ?b ?bmax ?bcur) )
             (battery_installed ?r ?b ?bmax ?bnext)
		)
)

; NUEVO (Parte 4): dos rovers diferentes remolcan el lander de un
; waypoint a otro. Restricciones analogas a navigate-bat, pero
; aplicadas a los dos rovers, y el lander viaja junto a ellos.
(:action tow_lander
:parameters (?r1 ?r2 - rover ?l - lander ?y - waypoint ?z - waypoint
              ?b1 - battery ?bmax1 ?bcur1 ?bnext1 - blevel
              ?b2 - battery ?bmax2 ?bcur2 ?bnext2 - blevel
)
:precondition (and (not (= ?r1 ?r2))
                (at ?r1 ?y) (at ?r2 ?y) (at_lander ?l ?y)
                (available ?r1) (available ?r2)
                (can_traverse ?r1 ?y ?z) (can_traverse ?r2 ?y ?z)
                (visible ?y ?z)
                (battery_installed ?r1 ?b1 ?bmax1 ?bcur1) (lower ?bnext1 ?bcur1)
                (battery_installed ?r2 ?b2 ?bmax2 ?bcur2) (lower ?bnext2 ?bcur2)
	    )
:effect (and (not (at ?r1 ?y)) (at ?r1 ?z)
             (not (at ?r2 ?y)) (at ?r2 ?z)
             (not (at_lander ?l ?y)) (at_lander ?l ?z)
             (not (battery_installed ?r1 ?b1 ?bmax1 ?bcur1))
             (battery_installed ?r1 ?b1 ?bmax1 ?bnext1)
             (not (battery_installed ?r2 ?b2 ?bmax2 ?bcur2))
             (battery_installed ?r2 ?b2 ?bmax2 ?bnext2)
		)
)

(:action recharge
:parameters (?r - rover ?l - lander ?w - waypoint
              ?b - battery ?bmax ?bcur - blevel
)
:precondition (and (at ?r ?w) (at_lander ?l ?w)
                (battery_installed ?r ?b ?bmax ?bcur)
                ; NUEVO (Parte 4): solo se puede recargar si el lander
                ; esta en un waypoint apto
                (suitable_for_lander ?w)
	    )
:effect (and
             (not (battery_installed ?r ?b ?bmax ?bcur) )
             (battery_installed ?r ?b ?bmax ?bmax)
		)
)

(:action sample_soil
:parameters (?r - rover ?s - store ?p - waypoint)
:precondition (and (at ?r ?p) (at_soil_sample ?p) (equipped_for_soil_analysis ?r) (store_of ?s ?r) (empty ?s)
		)
:effect (and (not (empty ?s)) (full ?s) (have_soil_analysis ?r ?p) (not (at_soil_sample ?p))
		)
)

(:action sample_rock
:parameters (?r - rover ?s - store ?p - waypoint)
:precondition (and (at ?r ?p) (at_rock_sample ?p) (equipped_for_rock_analysis ?r) (store_of ?s ?r)(empty ?s)
		)
:effect (and (not (empty ?s)) (full ?s) (have_rock_analysis ?r ?p) (not (at_rock_sample ?p))
		)
)

(:action drop
:parameters (?r - rover ?s - store)
:precondition (and (store_of ?s ?r) (full ?s)
		)
:effect (and (not (full ?s)) (empty ?s)
	)
)

(:action calibrate
 :parameters (?r - rover ?i - camera ?t - objective ?w - waypoint)
 :precondition (and (equipped_for_imaging ?r) (calibration_target ?i ?t) (at ?r ?w) (visible_from ?t ?w)(on_board ?i ?r)
		)
 :effect (calibrated ?i ?r)
)

(:action take_image
 :parameters (?r - rover ?p - waypoint ?o - objective ?i - camera ?m - mode)
 :precondition (and (calibrated ?i ?r)
			 (on_board ?i ?r)
                      (equipped_for_imaging ?r)
                      (supports ?i ?m)
			  (visible_from ?o ?p)
                     (at ?r ?p)
               )
 :effect (and (have_image ?r ?o ?m)(not (calibrated ?i ?r))
		)
)

(:action communicate_soil_data
 :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_soil_analysis ?r ?p)
                   (visible ?x ?y)(available ?r)(channel_free ?l)
                   ; NUEVO (Parte 4): el lander debe estar en un waypoint apto
                   (suitable_for_lander ?y)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)
		(communicated_soil_data ?p)(available ?r)
	)
)

(:action communicate_rock_data
 :parameters (?r - rover ?l - lander ?p - waypoint ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_rock_analysis ?r ?p)
                   (visible ?x ?y)(available ?r)(channel_free ?l)
                   ; NUEVO (Parte 4): el lander debe estar en un waypoint apto
                   (suitable_for_lander ?y)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)(communicated_rock_data ?p)(available ?r)
          )
)

(:action communicate_image_data
 :parameters (?r - rover ?l - lander ?o - objective ?m - mode ?x - waypoint ?y - waypoint)
 :precondition (and (at ?r ?x)(at_lander ?l ?y)(have_image ?r ?o ?m)(visible ?x ?y)(available ?r)(channel_free ?l)
                   ; NUEVO (Parte 4): el lander debe estar en un waypoint apto
                   (suitable_for_lander ?y)
            )
 :effect (and (not (available ?r))(not (channel_free ?l))(channel_free ?l)(communicated_image_data ?o ?m)(available ?r)
          )
)

)
