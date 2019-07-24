tool
extends Sprite

# Definir variables de inspector
export(String, "Ninguno", "Personaje", "Pared", "Salida", "Llave", "Cerradura", "Portal", "Agujero") var tipo = "Ninguno" setget tipo_set, tipo_get

# Definir señales
signal notificar_tipo(tipo, celda)

# Definir variables
var ficha_asociada = null

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
	emit_signal("notificar_tipo", tipo, self)

func tipo_set(new_value):
	tipo = new_value
	emit_signal("notificar_tipo", new_value, self)
	
func tipo_get():
	return tipo

func asignar_ficha(nueva_ficha):
	ficha_asociada = nueva_ficha