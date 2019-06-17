tool
extends Node2D

signal esconder_personaje(valor)
signal ubicar_personaje(celda)
signal esconder_salida(valor)
signal ubicar_salida(celda)
signal esconder_pared

var celda_personaje
var celda_salida
var celdas_paredes

func _ready():
	for celda in self.get_children():
		celda.connect("notificar_tipo", self, "cambio_celda")
		if celda.tipo == "Personaje":
			celda_personaje = celda
		elif celda.tipo == "Salida":
			celda_salida = celda

func cambio_celda(tipo, celda):
	match tipo:
		"Ninguno":
			if celda_personaje and celda_personaje.name == celda.name:
				emit_signal("esconder_personaje", true)
				celda_personaje = null
			if celda_salida and celda_salida.name == celda.name:
				emit_signal("esconder_salida", true)
				celda_salida = null
		"Personaje":
			if celda_personaje:
				celda_personaje.tipo = "Ninguno"
			emit_signal("ubicar_personaje", celda)
			emit_signal("esconder_personaje", false)
			celda_personaje = celda
		"Pared":
			pass
		"Salida":
			if celda_salida:
				celda_salida.tipo = "Ninguno"
			emit_signal("ubicar_salida", celda)
			emit_signal("esconder_salida", false)
			celda_salida = celda
