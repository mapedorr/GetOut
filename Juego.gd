extends Node2D

export(Array, PackedScene) var niveles

var moviendo_personaje = false
var objetivo_alcanzado = false
var movimientos_hechos = 0
var en_pausa = false
var nivel_actual = null
var contador_niveles = 0

func _ready():
	if niveles.size() > 0:
		iniciar_nivel(contador_niveles)
#	Conectar señales de GUI
	$GUI.actualizar_movimientos(movimientos_hechos)
	$GUI.connect("juego_pausado", self, "_en_juego_pausado")

func iniciar_nivel(indice):
	nivel_actual = niveles[indice].instance()
	$Niveles.add_child(nivel_actual)
	#	Configurar GUI
	$GUI.establecer_movimientos(nivel_actual.min_movimientos, nivel_actual.max_movimientos)
#	Conectar señales de nivel
	nivel_actual.connect("accion_jugador", self, "accion_jugador")

func accion_jugador(dir):
	if objetivo_alcanzado:
		return

	if not en_pausa and not moviendo_personaje:
		moviendo_personaje = true
		var pasos_dados = 0

		while(true):
#			En base a la dirección a la cuál se quiere mover el jugador,
#			verificar cuál es la celda a la que debería moverse el Personaje
			var celda_destino = nivel_actual.obtener_celda_destino(dir)
			if celda_destino:
#				- - - - ANTES DE MOVER - - - -
#				Verificar si la celda a la que se quiere mover el Personaje
#				no es un obstáculo
				if es_obstaculo(celda_destino):
					break

#				Desplazar el Personaje a la siguiente celda
				yield(nivel_actual.mover_personaje(celda_destino), "completed")
				pasos_dados += 1

#				- - - - DESPUÉS DE MOVER - - - -
				if celda_destino.tipo == "Salida":
#					El jugador ha llegado a la salida
					objetivo_alcanzado = true
					break
			else:
#				No hacer nada si el jugador intenta salirse del tablero
				break

		if pasos_dados > 0:
#			Actualizar el conteo de movimientos en la interfaz gráfica
			movimientos_hechos += 1
			$GUI.actualizar_movimientos(movimientos_hechos)
		
		if objetivo_alcanzado:
#			Mostrar mensaje de victoria o derrota
			if movimientos_hechos == nivel_actual.min_movimientos:
				$GUI.mostrar_mensaje("super")
			elif movimientos_hechos <= nivel_actual.max_movimientos:
				$GUI.mostrar_mensaje("victoria")
			else:
				$GUI.mostrar_mensaje("derrota")
			yield(get_tree().create_timer(2.0), "timeout")
			$GUI.ocultar_mensaje()
			objetivo_alcanzado = false
			movimientos_hechos = 0
			$GUI.actualizar_movimientos(movimientos_hechos)
			contador_niveles += 1
			if contador_niveles < niveles.size():
				nivel_actual.queue_free()
				iniciar_nivel(contador_niveles)

		moviendo_personaje = false

func obtener_grupo(nombre):
	return get_tree().get_nodes_in_group(nombre)

# Evalúa si la celda recibida como parámetro tiene una ficha de obstáculo encima.
func es_obstaculo(celda):
	for obstaculo in obtener_grupo("obstaculo"):
		if obstaculo.get_position() == celda.get_position():
			return true
	return false

# Evalúa si la celda recibida como parámetro tiene una ficha de parada encima.
func es_parada(celda):
	pass

func _en_juego_pausado(valor):
	en_pausa = valor