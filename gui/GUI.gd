extends CanvasLayer

var on_main_menu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/MenuContainer/Continuar.connect("pressed", self, "cerrar_main_menu")
	$MainMenu/MenuContainer/Salir.connect("pressed", self, "cerrar_juego")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('ui_cancel'):
		if not on_main_menu:
			$MainMenu.show()
			yield(get_tree().create_timer(0.1), "timeout")
			on_main_menu = true
		else:
			cerrar_main_menu()

func cerrar_main_menu():
	$MainMenu.hide()
	yield(get_tree().create_timer(0.1), "timeout")
	on_main_menu = false

func cerrar_juego():
	get_tree().quit()

func actualizar_movimientos(nuevo_valor):
	$Movimiento/VBoxContainer/Conteo.text = String(nuevo_valor)