tool
extends Node2D

var espera_movimiento = 0
var moviendo_personaje = false
var direccion_movimiento = Vector2()
var objetivo_alcanzado = false
var pared_node = preload("res://fichas/Pared.tscn")

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
	# Conectar señales
	$CeldasContainer.connect("ubicar_personaje", self, "ubicar_personaje")
	$CeldasContainer.connect("esconder_personaje", self, "esconder_personaje")
	$CeldasContainer.connect("ubicar_salida", self, "ubicar_salida")
	$CeldasContainer.connect("esconder_salida", self, "esconder_salida")
	$CeldasContainer.connect("ubicar_pared", self, "ubicar_pared")
	$CeldasContainer.connect("eliminar_pared", self, "eliminar_pared")
	$Personaje.connect("personaje_movido", self, "mover_personaje")
	# Ubicar paredes
	for celda in $CeldasContainer.celdas_paredes:
		self.ubicar_pared(celda)

func mover_personaje(dir):
	if objetivo_alcanzado:
		return
	espera_movimiento += 1
	if not moviendo_personaje and espera_movimiento == 2:
		moviendo_personaje = true
		direccion_movimiento = dir * 48.0
		while(true):
			var posicion_personaje = $CeldasContainer.celda_personaje.get_position()
			var celda_destino = $CeldasContainer.obtener_celda_en(
				posicion_personaje + direccion_movimiento
			)
			if celda_destino:
				if celda_destino.tipo == "Pared":
					break
				yield($Personaje.mover(celda_destino.get_position()), "completed")
				$CeldasContainer.celda_personaje = celda_destino
				if $CeldasContainer.celda_personaje.tipo == "Salida":
					# El jugador ha llegado a la salida
					objetivo_alcanzado = true
					print("Has llegado a la salida!")
					break
			else:
				break
		moviendo_personaje = false
		espera_movimiento = 0

# ------------------------------------------------------------------------------
# Funciones de retroalimentación en inspector
# ------------------------------------------------------------------------------
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

func ubicar_pared(celda):
	var pared = pared_node.instance()
	pared.set_position(celda.get_position())
	$Paredes.add_child(pared)

func eliminar_pared(celda):
	for pared in $Paredes.get_children():
		if pared.get_position() == celda.get_position():
			pared.queue_free()
# ------------------------------------------------------------------------------