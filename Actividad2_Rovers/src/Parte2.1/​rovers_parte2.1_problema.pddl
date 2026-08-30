(define (problem roverprob25262) (:domain Rover-battery)
(:objects
	general - Lander
	colour high_res low_res - Mode
	rover0 - Rover
	rover0store - Store
	waypoint0 waypoint1 waypoint2 waypoint3 waypoint4 - Waypoint
	camera0 - Camera
	objective0 objective1 - Objective
    b0 b1 b2 b3 b4 b5 - Blevel
    bat0 - Battery
	)
(:init
	(visible waypoint1 waypoint0)
	(visible waypoint0 waypoint1)
	(visible waypoint2 waypoint0)
	(visible waypoint0 waypoint2)
	(visible waypoint2 waypoint1)
	(visible waypoint1 waypoint2)
	(visible waypoint3 waypoint0)
	(visible waypoint0 waypoint3)
	(visible waypoint3 waypoint1)
	(visible waypoint1 waypoint3)
	(visible waypoint3 waypoint2)
	(visible waypoint2 waypoint3)
	; Visibilidad de waypoint4 entre waypoint1 y waypoint2 bidireccional
	(visible waypoint1 waypoint4)
	(visible waypoint4 waypoint1)
	(visible waypoint2 waypoint4)
	(visible waypoint4 waypoint2)
	(at_soil_sample waypoint0)
	(at_rock_sample waypoint1)
	(at_soil_sample waypoint2)
	(at_rock_sample waypoint2)
	(at_soil_sample waypoint3)
	(at_rock_sample waypoint3)
	; Agregar muestras de suelo y roca en waypoint4
	(at_soil_sample waypoint4)
    (at_rock_sample waypoint4)
	(at_lander general waypoint2)
	(channel_free general)
	(at rover0 waypoint1)
	(available rover0)
	(store_of rover0store rover0)
	(empty rover0store)
	(equipped_for_soil_analysis rover0)
	(equipped_for_rock_analysis rover0)
	(equipped_for_imaging rover0)
	(can_traverse rover0 waypoint3 waypoint0)
	(can_traverse rover0 waypoint0 waypoint3)
	(can_traverse rover0 waypoint3 waypoint1)
	(can_traverse rover0 waypoint1 waypoint3)
	(can_traverse rover0 waypoint1 waypoint2)
	(can_traverse rover0 waypoint2 waypoint1)
	; Agregar que si puede viajar desde waypoint4 entre waypoint1 y waypoint2 bidireccionalmente
	(can_traverse rover0 waypoint1 waypoint4)
	(can_traverse rover0 waypoint4 waypoint1)
	(can_traverse rover0 waypoint2 waypoint4)
	(can_traverse rover0 waypoint4 waypoint2)
	(on_board camera0 rover0)
	(calibration_target camera0 objective1)
	(supports camera0 colour)
	(supports camera0 high_res)
	; Bateria cargada en rover 0
	(battery_installed rover0 bat0 b4 b2)
	; Niveles de bateria
	(lower b0 b1) (lower b1 b2) (lower b2 b3) (lower b3 b4) (lower b4 b5)
	; Visibilidad de objetivos
	(visible_from objective0 waypoint0)
	(visible_from objective0 waypoint1)
	(visible_from objective0 waypoint2)
	(visible_from objective0 waypoint3)
	(visible_from objective1 waypoint0)
	(visible_from objective1 waypoint1)
	(visible_from objective1 waypoint2)
)

(:goal (and
   (communicated_soil_data waypoint2)
   (communicated_rock_data waypoint3)
   (communicated_image_data objective1 high_res)
   ;Comunicado de datos de suelo en waypoint4
   (communicated_soil_data waypoint4)
   ;Comunicado de datos de roca en waypoint4
   (communicated_rock_data waypoint4)
   ; el rover debe regresar a waypoint1
   (at rover0 waypoint1)
   )
)
)
