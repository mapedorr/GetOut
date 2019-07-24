tool
extends Node2D

signal accion_jugador(dir)

export(int) var min_movimientos = 0
export(int) var max_movimientos = 0

var espera_accion = 0
var moviendo_personaje = false
var pared_node = preload("res://fichas/pared/Pared.tscn")

# Llamada cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
#	Conectar señales
	conectar()

#	---- Ubicar celdas que se pueden repetir
#	Ubicar paredes
	for celda in $Tablero.celdas_pared:
		self.ubicar("pared", celda)

#	---- Ubicar celdas únicas
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

func mover_personaje(celda_destino, animar = true):
	if animar:
		yield($Personaje.mover(celda_destino), "completed")
	else:
		$Personaje.set_position(celda_destino.get_position())
	$Tablero.celda_personaje = celda_destino

func obtener_agujero():
	return $Tablero.celda_agujero

# ------------------------------------------------------------------------------
# Funciones de retroalimentación en inspector
# ------------------------------------------------------------------------------
func ubicar(ficha, celda):
	var instancia = null
	var contenedor = null
	var asignar_ficha = true

	match ficha:
		"pared":
			instancia = pared_node.instance()
			contenedor = $Paredes
		"salida":
			instancia = $Salida
			asignar_ficha = false
		"personaje":
			instancia = $Personaje
			asignar_ficha = false

	if instancia:
		instancia.set_position(celda.get_position())
		if asignar_ficha:
			celda.asignar_ficha(instancia)
		if contenedor:
			contenedor.add_child(instancia)

func esconder(ficha, esconder):
	var nodo_ficha = null
	match ficha:
		"salida":
			nodo_ficha = $Salida
		"personaje":
			nodo_ficha = $Personaje
	nodo_ficha.hide() if esconder else nodo_ficha.show()

func eliminar(ficha, celda):
	var contenedor = null

	match ficha:
		"pared":
			contenedor = $Paredes

	if contenedor:
		for ficha_en_tablero in contenedor.get_children():
			if ficha_en_tablero.get_position() == celda.get_position():
				celda.asignar_ficha(null)
				ficha_en_tablero.queue_free()
# ------------------------------------------------------------------------------