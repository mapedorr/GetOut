extends Node

export(bool) var es_obstaculo = false
export(bool) var es_parada = false

func al_chocar(celda = null, juego = null):
	pass
	
func al_llegar(celda = null, juego = null):
	pass

func al_pasar(celda = null, juego = null):
	pass

func eliminar(celda = null):
	if celda:
		celda.asignar_ficha(null)
	self.queue_free()
