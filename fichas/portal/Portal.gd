extends "res://fichas/Ficha.gd"

func al_llegar(celda = null, juego = null):
	juego.entrar_portal(celda, self)