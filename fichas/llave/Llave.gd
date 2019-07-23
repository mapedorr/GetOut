extends "res://fichas/Ficha.gd"

func al_llegar(celda = null, juego = null):
	juego.guardar_llave()
	.eliminar(celda)
