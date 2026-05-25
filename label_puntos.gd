extends Label

func _ready():
	# Nos conectamos al Singleton Global para recibir los puntos
	if Global.has_signal("puntos_actualizados"):
		Global.puntos_actualizados.connect(_on_puntos_actualizados)
	
	text = "Puntos: 0"
	print(">>> Label de puntos listo")

func _on_puntos_actualizados(nuevo_valor):
	text = "Puntos: " + str(nuevo_valor)
