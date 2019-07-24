tool
extends "res://fichas/Ficha.gd"

enum DireccionesEnum {IZQ, DER, ARR, ABJ, IZQ_ARR, IZQ_ABJ, DER_ARR, DER_ABJ}
export(DireccionesEnum) var direccion = DireccionesEnum.ARR setget dir_set

func al_llegar(celda = null, juego = null):
	var dir = Vector2()
	match direccion:
		DireccionesEnum.IZQ:
			dir.x -= 1
		DireccionesEnum.DER:
			dir.x += 1
		DireccionesEnum.ARR:
			dir.y -= 1
		DireccionesEnum.ABJ:
			dir.y += 1
		DireccionesEnum.IZQ_ARR:
			dir.x -= 1
			dir.y -= 1
		DireccionesEnum.IZQ_ABJ:
			dir.x -= 1
			dir.y += 1
		DireccionesEnum.DER_ARR:
			dir.x += 1
			dir.y -= 1
		DireccionesEnum.DER_ABJ:
			dir.x += 1
			dir.y += 1
	juego.moviendo_personaje = false
	juego.accion_jugador(dir * 48.0, false)

func dir_set(nuevo_valor):
	match nuevo_valor:
		DireccionesEnum.IZQ:
			$Sprite.set_rotation_degrees(180)
		DireccionesEnum.DER:
			$Sprite.set_rotation_degrees(90)
		DireccionesEnum.ARR:
			$Sprite.set_rotation_degrees(0)
		DireccionesEnum.ABJ:
			$Sprite.set_rotation_degrees(180)
		DireccionesEnum.IZQ_ARR:
			$Sprite.set_rotation_degrees(225)
		DireccionesEnum.IZQ_ABJ:
			$Sprite.set_rotation_degrees(135)
		DireccionesEnum.DER_ARR:
			$Sprite.set_rotation_degrees(45)
		DireccionesEnum.DER_ABJ:
			$Sprite.set_rotation_degrees(135)
	direccion = nuevo_valor