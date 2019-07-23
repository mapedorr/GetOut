extends CanvasLayer

signal juego_pausado(estado)

var on_main_menu = false

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
	$Movimiento/Contenedor/Min.text = "Mínimo: %d" % minimos
	$Movimiento/Contenedor/Max.text = "Máximo: %d" % maximos
	
func mostrar_mensaje(tipo):
	match tipo:
		"super":
			$Mensajes/Super.show()
		"victoria":
			$Mensajes/Victoria.show()
		"derrota":
			$Mensajes/Derrota.show()

func ocultar_mensaje():
	$Mensajes/Super.hide()
	$Mensajes/Victoria.hide()
	$Mensajes/Derrota.hide()