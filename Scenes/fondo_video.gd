extends VideoStreamPlayer

@export var video_limpio: VideoStream
@export var video_sucio: VideoStream
@export var video_critico: VideoStream

@export var umbral_sucio: int = 15     
@export var umbral_critico: int = 25   

var estado_actual: String = "limpio"

func _ready():
	loop = true 
	stream = video_limpio
	play()
	estado_actual = "limpio"

func _process(_delta):
	var cantidad_basura = get_tree().get_nodes_in_group("residuos").size()
	
	var nuevo_estado = "limpio"
	
	if cantidad_basura >= umbral_critico:
		nuevo_estado = "critico"
	elif cantidad_basura >= umbral_sucio:
		nuevo_estado = "sucio"
	else:
		nuevo_estado = "limpio"
		
	if nuevo_estado != estado_actual:
		_cambiar_video(nuevo_estado)

func _cambiar_video(nuevo_estado: String):
	estado_actual = nuevo_estado
	
	# --- ¡NUEVA LÍNEA! Cambiamos la música global según el estado de la pantalla ---
	MusicaFondo.reproducir_juego(nuevo_estado)
	
	# Efecto de parpadeo rojo
	var t = create_tween()
	var color_flash = Color.RED if nuevo_estado != "limpio" else Color.WHITE
	t.tween_property(self, "modulate", color_flash, 0.2)
	
	# Cambiamos el archivo de video
	match nuevo_estado:
		"limpio": stream = video_limpio
		"sucio": stream = video_sucio
		"critico": stream = video_critico
		
	play()
	t.tween_property(self, "modulate", Color.WHITE, 0.3)
