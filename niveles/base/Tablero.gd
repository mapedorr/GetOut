tool
extends Node2D

signal esconder(ficha)
signal ubicar(ficha, celda)
signal eliminar(ficha, celda)

var celda_personaje
var celda_salida
var celdas_pared = []

func _ready():
	for celda in self.get_children():
#		Guardar las celdas que tienen un tipo único
		if celda.tipo == "Personaje":
			celda_personaje = celda
		elif celda.tipo == "Salida":
			celda_salida = celda
		else:
#			Guardar las celdas que pueden repetirse
			poner_en_arreglo(celda.tipo, celda)

#		Conectar señales de celda
		celda.connect("notificar_tipo", self, "cambio_celda")

func cambio_celda(tipo, celda):
	match tipo:
		"Ninguno":
			esconder_celda_unica(celda_personaje, "personaje", celda)
			esconder_celda_unica(celda_salida, "salida", celda)
		"Personaje":
			if celda_personaje:
				celda_personaje.tipo = "Ninguno"
			emit_signal("ubicar", "personaje", celda)
			emit_signal("esconder", "personaje", false)
			celda_personaje = celda
		"Salida":
			if celda_salida:
				celda_salida.tipo = "Ninguno"
			emit_signal("ubicar", "salida", celda)
			emit_signal("esconder", "salida", false)
			celda_salida = celda
		_:
			asignar_a_celdas(tipo, celda)
	# Verificar si alguna celda ya no es pared
	restaurar_celdas(celdas_pared, "Pared")

func obtener_celda_en(pos):
	for celda in get_children():
		if celda.get_position() == pos:
			return celda

func poner_en_arreglo(tipo, celda):
	match tipo:
		"Pared":
			celdas_pared.append(celda)

func esconder_celda_unica(ref_celda, ficha, celda):
	if ref_celda and ref_celda.name == celda.name:
		emit_signal("esconder", ficha, true)
		ref_celda = null

func asignar_a_celdas(tipo, celda):
	poner_en_arreglo(tipo, celda)
	emit_signal("ubicar", tipo.to_lower(), celda)

func restaurar_celdas(arreglo, tipo):
	for celda in arreglo:
		if celda.has_method("tipo_get") and celda.tipo_get() != tipo:
			emit_signal("eliminar", tipo.to_lower(), celda)