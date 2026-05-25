extends Node2D

@export var escena_basura = preload("res://objeto.tscn")

@export_group("Texturas de Residuos")
@export var textura_organico: Texture2D
@export var textura_inorganico: Texture2D
@export var textura_reciclable: Texture2D
@export var textura_reutilizable: Texture2D

# --- NUEVA VARIABLE ---
@export var tamano_objetivo: float = 120.0 # Ajusta este valor en el Inspector para cambiar el tamaño de todos
# ----------------------

var tiempo_generacion: float = 2.0
var tipos_comunes = ["organico", "inorganico", "reciclable"]

func _ready():
	var timer = Timer.new()
	timer.wait_time = tiempo_generacion
	timer.autostart = true
	timer.timeout.connect(lanzar_basura)
	add_child(timer)
	timer.start()

func lanzar_basura():
	if escena_basura == null: return
		
	var basura = escena_basura.instantiate()
	
	var permite_reutilizable = Global.include_second_use
	var velocidad_nivel = Global.falling_speed
	
	var probabilidad = randf()
	var tipo_elegido = ""
	var textura_a_asignar: Texture2D = null
	
	if permite_reutilizable and probabilidad < 0.15:
		tipo_elegido = "reutilizable"
		textura_a_asignar = textura_reutilizable
	else:
		tipo_elegido = tipos_comunes.pick_random()
		match tipo_elegido:
			"organico": textura_a_asignar = textura_organico
			"inorganico": textura_a_asignar = textura_inorganico
			"reciclable": textura_a_asignar = textura_reciclable

	# --- LÓGICA DE ESCALADO AUTOMÁTICO ---
	var sprite = basura.get_node_or_null("Sprite2D")
	if sprite and textura_a_asignar:
		sprite.texture = textura_a_asignar
		
		# Obtenemos el lado más largo de la imagen original
		var lado_mayor = max(textura_a_asignar.get_width(), textura_a_asignar.get_height())
		
		# Calculamos la escala necesaria para llegar al tamaño objetivo
		# Ejemplo: Si el objetivo es 120px y la banana mide 1200px, la escala será 0.1
		var escala_final = tamano_objetivo / lado_mayor
		
		sprite.scale = Vector2(escala_final, escala_final)
	# -------------------------------------

	basura.trash_type = tipo_elegido
	if "speed" in basura:
		basura.speed = velocidad_nivel

	var viewport_size = get_viewport().get_visible_rect().size
	var pos_x = randf_range(100, viewport_size.x - 100)
	basura.global_position = Vector2(pos_x, -50)
	get_tree().current_scene.add_child(basura)
	
	var punto_parada = Vector2(pos_x, viewport_size.y / 2)
	basura.setup(punto_parada, 20.0)
