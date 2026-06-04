extends AudioStreamPlayer

# mis canciones de menús
var pista_login = preload("res://Musica/musicainiciodesesion.mp3") 
var pista_selector = preload("res://Musica/musicaseleccionnivel.mp3")

# mis 3 pistas para el juego
var pista_juego_limpio = preload("res://Musica/musicaingame.mp3")
var pista_juego_sucio = preload("res://Musica/musicaingameintermedia.mp3")
var pista_juego_critico = preload("res://Musica/musicaingamepeorescenario.mp3")

func _ready():
	# mi candado de seguridad para que la musica nunca se congele en pausas ni en transiciones
	process_mode = Node.PROCESS_MODE_ALWAYS

func reproducir_login():
	if stream == pista_login and playing:
		return 
	stream = pista_login
	play()

func reproducir_selector():
	if stream == pista_selector and playing:
		return
	stream = pista_selector
	play()

func reproducir_juego(estado: String = "limpio"):
	var pista_elegida = pista_juego_limpio
	
	match estado:
		"limpio":
			pista_elegida = pista_juego_limpio
		"sucio":
			pista_elegida = pista_juego_sucio
		"critico":
			pista_elegida = pista_juego_critico
			
	if stream == pista_elegida and playing:
		return
		
	stream = pista_elegida
	play()

func detener_musica():
	stop()
