extends CanvasLayer

signal juego_pausado(estado)
signal nivel_ganado
signal nivel_perdido

var on_main_menu = false
var min_movimientos = 0
var max_movimientos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuPrincipal/Contenedor/Continuar.connect("pressed", self, "cerrar_main_menu")
	$MenuPrincipal/Contenedor/Salir.connect("pressed", self, "cerrar_juego")
	$MenuPrincipal.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('ui_cancel'):
		if not on_main_menu:
			$MenuPrincipal.show()
			yield(get_tree().create_timer(0.1), "timeout")
			on_main_menu = true
			emit_signal("juego_pausado", true)
		else:
			cerrar_main_menu()

func cerrar_main_menu():
	$MenuPrincipal.hide()
	yield(get_tree().create_timer(0.1), "timeout")
	on_main_menu = false
	emit_signal("juego_pausado", false)

func cerrar_juego():
	get_tree().quit()

func actualizar_movimientos(nuevo_valor):
	$Movimiento/Contenedor/Conteo.text = String(nuevo_valor)

func establecer_movimientos(minimos, maximos):
	min_movimientos = minimos
	max_movimientos = maximos
	$Movimiento/Contenedor/Min.text = "Mínimo: %d" % minimos
	$Movimiento/Contenedor/Max.text = "Máximo: %d" % maximos
	
func mostrar_mensaje(movimientos_hechos):
	var ganado = true
	if movimientos_hechos == min_movimientos:
		$Mensajes/Super.show()
	elif movimientos_hechos <= max_movimientos:
		$Mensajes/Victoria.show()
	else:
		ganado = false
		$Mensajes/Derrota.show()

	yield(get_tree().create_timer(1.5), "timeout")
	if ganado:
		emit_signal("nivel_ganado")
	else:
		emit_signal("nivel_perdido")

func ocultar_mensaje():
	$Mensajes/Super.hide()
	$Mensajes/Victoria.hide()
	$Mensajes/Derrota.hide()