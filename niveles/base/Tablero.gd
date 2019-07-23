tool
extends Node2D

signal esconder(ficha)
signal ubicar(ficha, celda)
signal eliminar(ficha, celda)

var celda_personaje
var celda_salida
var celdas_pared = []
var celdas_llave = []
var celdas_cerradura = []

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
			if celda_personaje and celda_personaje.name == celda.name:
				emit_signal("esconder", "personaje", true)
				celda_personaje = null
			if celda_salida and celda_salida.name == celda.name:
				emit_signal("esconder", "salida", true)
				celda_salida = null
		"Personaje":
			if celda_personaje:
				celda_personaje.tipo = "Ninguno"
			emit_signal("ubicar", "personaje", celda)
			emit_signal("esconder" , "personaje", false)
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
	# Verificar si alguna celda ya no es llave
	restaurar_celdas(celdas_llave, "Llave")
	# Verificar si alguna celda ya no es cerradura
	restaurar_celdas(celdas_cerradura, "Cerradura")

func obtener_celda_en(pos):
	for celda in get_children():
		if celda.get_position() == pos:
			return celda

func poner_en_arreglo(tipo, celda):
	match tipo:
		"Pared":
			celdas_pared.append(celda)
		"Llave":
			celdas_llave.append(celda)
		"Cerradura":
			celdas_cerradura.append(celda)

func asignar_a_celdas(tipo, celda):
	poner_en_arreglo(tipo, celda)
	emit_signal("ubicar", tipo.to_lower(), celda)

func restaurar_celdas(arreglo, tipo):
	for celda in arreglo:
		if celda.tipo_get() != tipo:
			emit_signal("eliminar", tipo.to_lower(), celda)