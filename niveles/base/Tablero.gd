tool
extends Node2D

signal esconder(ficha)
signal ubicar(ficha, celda)
signal eliminar(ficha, celda)

var celda_personaje
var celda_salida
var celdas_paredes = []

func _ready():
	for celda in self.get_children():
#		Guardar las celdas que tienen un tipo específico
		if celda.tipo == "Personaje":
			celda_personaje = celda
		elif celda.tipo == "Salida":
			celda_salida = celda
		elif celda.tipo == "Pared":
			celdas_paredes.append(celda)
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
		"Pared":
			emit_signal("ubicar", "pared", celda)
			celdas_paredes.append(celda)
		"Salida":
			if celda_salida:
				celda_salida.tipo = "Ninguno"
			emit_signal("ubicar", "salida", celda)
			emit_signal("esconder", "salida", false)
			celda_salida = celda
	# Verificar si alguna celda ya no es pared
	for celda in celdas_paredes:
		if celda.tipo != "Pared":
			emit_signal("eliminar", "pared", celda)

func obtener_celda_en(pos):
	for celda in get_children():
		if celda.get_position() == pos:
			return celda