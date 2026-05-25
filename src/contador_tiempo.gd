extends Label

@export var tiempo_limite: float = 120.0 # 2 minutos por defecto
var tiempo_restante: float

func _ready():
	tiempo_restante = tiempo_limite
	actualizar_texto()

func _process(delta):
	if tiempo_restante > 0:
		tiempo_restante -= delta
		actualizar_texto()
		
		if tiempo_restante <= 0:
			tiempo_restante = 0
			actualizar_texto()
			Global.game_over.emit() # Si el tiempo acaba, pierde[cite: 27]

func actualizar_texto():
	var minutos = int(tiempo_restante) / 60
	var segundos = int(tiempo_restante) % 60
	# Formato 00:00
	text = "Tiempo: %02d:%02d" % [minutos, segundos]
