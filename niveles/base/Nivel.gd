tool
extends Node2D

signal accion_jugador(dir)

export(int) var min_movimientos = 0
export(int) var max_movimientos = 0

var espera_accion = 0
var moviendo_personaje = false
var objetivo_alcanzado = false
var pared_node = preload("res://fichas/pared/Pared.tscn")

# Llamada cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
#	Conectar señales
	conectar()
#	Ubicar paredes
	for celda in $Tablero.celdas_paredes:
		self.ubicar("pared", celda)
#	Ubicar salida
	if $Tablero.celda_salida:
		self.ubicar("salida", $Tablero.celda_salida)
#	Ubicar personaje
	if $Tablero.celda_personaje:
		self.ubicar("personaje", $Tablero.celda_personaje)

func conectar():
#	Señales del Tablero
	$Tablero.connect("ubicar", self, "ubicar")
	$Tablero.connect("esconder", self, "esconder")
	$Tablero.connect("eliminar", self, "eliminar")
#	Señales del Personaje
	$Personaje.connect("accion_personaje", self, "accion_personaje")

func accion_personaje(dir):
	espera_accion += 1
	if espera_accion == 4:
		emit_signal("accion_jugador", dir * 48.0)
		espera_accion = 0

func obtener_celda_destino(dir):
	var posicion_personaje = $Tablero.celda_personaje.get_position()
	return $Tablero.obtener_celda_en(posicion_personaje + dir)

func mover_personaje(celda_destino):
	yield($Personaje.mover(celda_destino), "completed")
	$Tablero.celda_personaje = celda_destino

# ------------------------------------------------------------------------------
# Funciones de retroalimentación en inspector
# ------------------------------------------------------------------------------
func ubicar(ficha, celda):
	match ficha:
		"pared":
			var pared = pared_node.instance()
			pared.set_position(celda.get_position())
			$Paredes.add_child(pared)
		"salida":
			$Salida.set_position(celda.get_position())
		"personaje":
			$Personaje.set_position(celda.get_position())

func esconder(ficha, esconder):
	match ficha:
		"salida":
			$Salida.hide() if esconder else $Salida.show()
		"personaje":
			$Personaje.hide() if esconder else $Personaje.show()

func eliminar(ficha, celda):
	match ficha:
		"pared":
			for pared in $Paredes.get_children():
				if pared.get_position() == celda.get_position():
					pared.queue_free()
# ------------------------------------------------------------------------------