extends Node

var puntos: int = 0
var vidas: int = 3
var falling_speed: float = 200.0
var include_second_use: bool = true
var nivel_actual: int = 1
var max_nivel_desbloqueado: int = 1
var total_niveles: int = 3

var arrastrando_algo: bool = false 
var trivia_ganada: bool = false 
var juego_activo: bool = false
var cache_poligonos: Dictionary = {}

# --- NUEVAS MÉTRICAS PEDAGÓGICAS Y DE TRAZABILIDAD ---
var id_sesion: String = ""
var tiempo_jugado: float = 0.0
var basura_procesada: int = 0
var basura_correcta: int = 0
var basura_incorrecta: int = 0

var errores_contaminacion: int = 0 
var errores_reuso: int = 0         
var errores_trampas: int = 0       
var intervenciones_eco: int = 0    

signal puntos_actualizados(nuevo_valor)
signal vidas_actualizadas(nuevo_valor)
signal game_over
signal juego_ganado 

func _ready():
	# Generamos el ID anónimo del alumno
	randomize()
	id_sesion = "Alumno_" + str(randi() % 1000 + 1)

func _process(delta):
	# Cronómetro exacto de la partida (se detiene si hay pausa)
	if get_tree() and not get_tree().paused and juego_activo:
		tiempo_jugado += delta

func modificar_puntos(cantidad: int):
	puntos = max(0, puntos + cantidad)
	puntos_actualizados.emit(puntos)
	
	if puntos >= 1000:
		juego_ganado.emit()
		puntos = 0
		vidas = 3
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/pantalla_victoria.tscn")

func modificar_vidas(cantidad: int):
	vidas += cantidad
	vidas_actualizadas.emit(vidas)
	if vidas <= 0:
		game_over.emit()
