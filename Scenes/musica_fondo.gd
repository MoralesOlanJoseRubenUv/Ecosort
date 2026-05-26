extends AudioStreamPlayer

# Canciones de menús
var pista_login = preload("res://Musica/musicainiciodesesion.mp3") 
var pista_selector = preload("res://Musica/musicaseleccionnivel.mp3")

# --- TUS 3 PISTAS PARA EL JUEGO ---
var pista_juego_limpio = preload("res://Musica/musicaingame.mp3")
var pista_juego_sucio = preload("res://Musica/musicaingameintermedia.mp3")
var pista_juego_critico = preload("res://Musica/musicaingamepeorescenario.mp3")

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

# Le agregamos el parámetro "estado" (si no se le manda nada, será "limpio" por defecto)
func reproducir_juego(estado: String = "limpio"):
	var pista_elegida = pista_juego_limpio
	
	# Seleccionamos la música basada en cómo está la playa
	match estado:
		"limpio":
			pista_elegida = pista_juego_limpio
		"sucio":
			pista_elegida = pista_juego_sucio
		"critico":
			pista_elegida = pista_juego_critico
			
	# Si la canción correcta ya está sonando, no hacemos nada para evitar que se reinicie
	if stream == pista_elegida and playing:
		return
		
	stream = pista_elegida
	play()

func detener_musica():
	stop()
