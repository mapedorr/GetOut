tool
extends Sprite

# Definir variables de inspector
export(String, "Ninguno", "Personaje", "Pared", "Salida") var tipo = "Ninguno" setget tipo_set, tipo_get

# Definir señales
signal notificar_tipo(tipo, celda)

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
	emit_signal("notificar_tipo", tipo, self.name)

func tipo_set(new_value):
	tipo = new_value
	emit_signal("notificar_tipo", new_value, self)
	
func tipo_get():
	return tipo