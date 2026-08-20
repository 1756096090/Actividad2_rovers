; ===================================================================
; Rovers - Parte 4: problema de prueba para la nueva funcionalidad
;
; Diseno del caso: el lander (general) empieza en waypoint0, que NO es
; un waypoint apto para el lander. El unico waypoint apto es
; waypoint2 (suitable_for_lander). Por tanto, ninguna accion de
; recharge ni de communicate_* es aplicable hasta que dos rovers
; diferentes (rover0 y rover1) usen el nuevo operador tow_lander para
; desplazar el lander de waypoint0 a waypoint2. Esto obliga al
; planificador a usar la nueva funcionalidad para poder resolver el
; problema.
;
; rover0 y rover1 empiezan junto al lander en waypoint0. Tras
; remolcarlo hasta waypoint2, cada rover se separa para tomar su
; muestra (rover0 -> waypoint1, suelo; rover1 -> waypoint3, roca) y
; ademas rover0 toma una imagen del objective1. Como el grafo de
; visibilidad es completo, ambos pueden comunicar sus datos desde
; donde esten, sin necesidad de volver junto al lander.
; ===================================================================

(define (problem roverprob-parte4) (:domain Rover-battery)
(:objects
	general - Lander
	colour high_res low_res - Mode
	rover0 rover1 - Rover
	rover0store rover1store - Store
	waypoint0 waypoint1 waypoint2 waypoint3 - Waypoint
	camera0 - Camera
	objective0 objective1 - Objective
    b0 b1 b2 b3 b4 b5 - Blevel
    bat0 bat1 - Battery
	)
(:init
	; Grafo de visibilidad completo entre los 4 waypoints
	(visible waypoint1 waypoint0) (visible waypoint0 waypoint1)
	(visible waypoint2 waypoint0) (visible waypoint0 waypoint2)
	(visible waypoint2 waypoint1) (visible waypoint1 waypoint2)
	(visible waypoint3 waypoint0) (visible waypoint0 waypoint3)
	(visible waypoint3 waypoint1) (visible waypoint1 waypoint3)
	(visible waypoint3 waypoint2) (visible waypoint2 waypoint3)

	; Muestras
	(at_soil_sample waypoint1)
	(at_rock_sample waypoint3)

	; El lander empieza en un waypoint NO apto
	(at_lander general waypoint0)
	(channel_free general)

	; Unico waypoint fisicamente apto para el lander (Parte 4)
	(suitable_for_lander waypoint2)

	; Ambos rovers empiezan junto al lander
	(at rover0 waypoint0)
	(at rover1 waypoint0)
	(available rover0)
	(available rover1)

	(store_of rover0store rover0)
	(empty rover0store)
	(store_of rover1store rover1)
	(empty rover1store)

	(equipped_for_soil_analysis rover0)
	(equipped_for_rock_analysis rover1)
	(equipped_for_imaging rover0)

	; Movimientos individuales necesarios (navigate-bat)
	(can_traverse rover0 waypoint0 waypoint2) (can_traverse rover0 waypoint2 waypoint0)
	(can_traverse rover0 waypoint2 waypoint1) (can_traverse rover0 waypoint1 waypoint2)
	(can_traverse rover1 waypoint0 waypoint2) (can_traverse rover1 waypoint2 waypoint0)
	(can_traverse rover1 waypoint2 waypoint3) (can_traverse rover1 waypoint3 waypoint2)

	(on_board camera0 rover0)
	(calibration_target camera0 objective1)
	(supports camera0 colour)
	(supports camera0 high_res)

	; Bateria de cada rover: nivel actual b2, maximo b4
	(battery_installed rover0 bat0 b4 b2)
	(battery_installed rover1 bat1 b4 b2)
	(lower b0 b1) (lower b1 b2) (lower b2 b3) (lower b3 b4) (lower b4 b5)

	; Visibilidad del objetivo a fotografiar
	(visible_from objective1 waypoint0)
	(visible_from objective1 waypoint1)
	(visible_from objective1 waypoint2)
)

(:goal (and
   (communicated_soil_data waypoint1)
   (communicated_rock_data waypoint3)
   (communicated_image_data objective1 high_res)
   )
)
)
