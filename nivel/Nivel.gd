tool
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$CeldasContainer.connect("esconder_personaje", self, "esconder_personaje")
	$CeldasContainer.connect("esconder_salida", self, "esconder_salida")
	$CeldasContainer.connect("ubicar_personaje", self, "ubicar_personaje")
	$CeldasContainer.connect("ubicar_salida", self, "ubicar_salida")

func _process(delta):
	pass

func esconder_personaje(esconder):
	if esconder:
		$Personaje.hide()
	else:
		$Personaje.show()

func ubicar_personaje(celda):
	$Personaje.set_position(celda.get_position())

func esconder_salida(esconder):
	if esconder:
		$Salida.hide()
	else:
		$Salida.show()

func ubicar_salida(celda):
	$Salida.set_position(celda.get_position())