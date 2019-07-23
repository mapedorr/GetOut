extends "res://fichas/Ficha.gd"

func al_chocar(celda = null, juego = null):
	if juego and juego.tiene_llave():
		juego.quitar_llave()
		.eliminar(celda)