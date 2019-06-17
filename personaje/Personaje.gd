extends Node2D

signal personaje_movido(dir)

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
	pass

# Llamado en cada frame. 'delta' es el tiempo transcurrido desde el frame anterior.
func _process(delta):
	var direccion = Vector2()
	var se_mueve = false

	if Input.is_action_pressed('ui_right'):
		direccion.x += 1
		se_mueve = true
	if Input.is_action_pressed('ui_left'):
		direccion.x -= 1
		se_mueve = true
	if Input.is_action_pressed('ui_up'):
		direccion.y -= 1
		se_mueve = true
	if Input.is_action_pressed('ui_down'):
		direccion.y += 1
		se_mueve = true

	if se_mueve:
		emit_signal("personaje_movido", direccion)

func mover(destino):
	$Tween.interpolate_property(
		self,
		"position",
		self.get_position(),
		destino,
		0.1,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$Tween.start()
	yield($Tween, "tween_completed")