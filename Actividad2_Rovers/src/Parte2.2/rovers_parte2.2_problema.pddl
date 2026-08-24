(define (problem roverprob25262) (:domain Rover-battery)
(:objects
	general - Lander
	colour high_res low_res - Mode
	rover0 rover1 - Rover
	rover0store - Store
	waypoint0 waypoint1 waypoint2 waypoint3 - Waypoint
	camera0 camera1 - Camera
	objective0 objective1 - Objective
    b0 b1 b2 b3 b4 b5 - Blevel
    bat0 bat1 - Battery
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
	(at_soil_sample waypoint0)
	(at_rock_sample waypoint1)
	(at_soil_sample waypoint2)
	(at_rock_sample waypoint2)
	(at_soil_sample waypoint3)
	(at_rock_sample waypoint3)
	(at_lander general waypoint2)
	(channel_free general)
	(at rover0 waypoint1)
	; Agregar que rover1 inicia en waypoint0
	(at rover1 waypoint0)
	(available rover0)
	; Agregar que rover1 esta disponible
	(available rover1)
	(store_of rover0store rover0)
	(empty rover0store)
	(equipped_for_soil_analysis rover0)
	(equipped_for_rock_analysis rover0)
	(equipped_for_imaging rover0)
	(equipped_for_imaging rover1)
	(can_traverse rover0 waypoint3 waypoint0)
	(can_traverse rover0 waypoint0 waypoint3)
	(can_traverse rover0 waypoint3 waypoint1)
	(can_traverse rover0 waypoint1 waypoint3)
	(can_traverse rover0 waypoint1 waypoint2)
	(can_traverse rover0 waypoint2 waypoint1)
	; Agregar que rover1 puede viajar entre waypoint3 y waypoint0, waypoint1 y waypoint2 bidireccionalmente
	(can_traverse rover1 waypoint3 waypoint0)
	(can_traverse rover1 waypoint0 waypoint3)
	(can_traverse rover1 waypoint3 waypoint1)
	(can_traverse rover1 waypoint1 waypoint3)
	(can_traverse rover1 waypoint1 waypoint2)
	(can_traverse rover1 waypoint2 waypoint1)
	; Agregar rutas para que rover1 pueda moverse entre waypoint2 y waypoint0/waypoint3,
	; tomar imagenes y regresar al lander para recargar la bateria.
	(can_traverse rover1 waypoint0 waypoint2)
	(can_traverse rover1 waypoint2 waypoint0)
	(can_traverse rover1 waypoint3 waypoint2)
	(can_traverse rover1 waypoint2 waypoint3)

	(on_board camera0 rover0)
	; Agregar que camera1 esta a bordo de rover1
	(on_board camera1 rover1)

	(calibration_target camera0 objective1)
	; Agregar que camera1 tiene como objetivo de calibracion objective0 y objective1
	(calibration_target camera1 objective0)
	(calibration_target camera1 objective1)

	(supports camera0 colour)
	(supports camera0 high_res)
	; Agregar que camera1 soporta los modos colour, low_res y high_res
	(supports camera1 colour)
	(supports camera1 low_res)
	(supports camera1 high_res)
	; Bateria cargada en rover 0
	(battery_installed rover0 bat0 b4 b2)
	;Bateria cargada en rover 1 con nivel de bateria b2
	(battery_installed rover1 bat1 b4 b2)
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

	; Agregar que se requiere comunicar los datos de suelo de waypoint0 y waypoint3
	(communicated_soil_data waypoint0)
	(communicated_soil_data waypoint3)

	; Agregar que se requiere comunicar los datos de roca de waypoint1 y waypoint2
	(communicated_rock_data waypoint1)
	(communicated_rock_data waypoint2)


	; Agregar que se requiere comunicar los datos de imagen de objective0 y objective1
	; en los modos colour, high_res y low_res
	(communicated_image_data objective0 colour)
	(communicated_image_data objective0 high_res)
	(communicated_image_data objective0 low_res)
	(communicated_image_data objective1 colour)
	(communicated_image_data objective1 low_res)

   )
)
)
