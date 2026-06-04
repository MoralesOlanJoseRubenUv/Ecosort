extends Node2D

@export var escena_basura = preload("res://objeto.tscn")

@export_group("Texturas de Residuos")
@export var texturas_organico: Array[Texture2D]
@export var texturas_inorganico: Array[Texture2D]
@export var texturas_reciclable: Array[Texture2D]
@export var texturas_reutilizable: Array[Texture2D]
@export var texturas_enganosa: Array[Texture2D] 

@export var tamano_objetivo: float = 80.0 
@export var limite_basura_en_pantalla: int = 40 

var tiempo_generacion: float = 2.0
var tipos_comunes = ["organico", "inorganico", "reciclable", "enganosa"]

var cache_poligonos: Dictionary = {}
var timer_generacion: Timer

# Controladores de carga fluida
var hilo_carga: Thread
var detener_hilo: bool = false
var math_terminada: bool = false
var tutorial_terminado: bool = false

func _ready():
	if has_node("/root/MusicaFondo"):
		get_node("/root/MusicaFondo").reproducir_juego()
		
	timer_generacion = Timer.new()
	timer_generacion.wait_time = tiempo_generacion
	timer_generacion.autostart = false 
	timer_generacion.timeout.connect(lanzar_basura)
	add_child(timer_generacion)

	if has_node("/root/Global"):
		get_node("/root/Global").juego_activo = false

	
	if Global.nivel_actual > 1:
		tutorial_terminado = true

	
	if not Global.cache_poligonos.is_empty():
		
		cache_poligonos = Global.cache_poligonos.duplicate()
		math_terminada = true
		_intentar_iniciar_juego()
		return
		
	hilo_carga = Thread.new()
	hilo_carga.start(_tarea_pesada_en_segundo_plano)

	var nivel = 1
	if has_node("/root/Global"):
		var global = get_node("/root/Global")
		nivel = global.get("nivel_actual")
		
	# 2. LANZAMOS EL TUTORIAL AL INSTANTE
	if nivel == 1:
		tutorial_terminado = false
		call_deferred("_mostrar_tutorial")
	else:
		tutorial_terminado = true # En nivel 2 y 3 no hay tutorial

func _exit_tree():
	detener_hilo = true
	if hilo_carga != null and hilo_carga.is_started():
		hilo_carga.wait_to_finish()

func _tarea_pesada_en_segundo_plano():
	var todas_las_texturas = []
	todas_las_texturas.append_array(texturas_organico)
	todas_las_texturas.append_array(texturas_inorganico)
	todas_las_texturas.append_array(texturas_reciclable)
	todas_las_texturas.append_array(texturas_reutilizable)
	todas_las_texturas.append_array(texturas_enganosa)
	
	var cache_temporal = {}
	for textura in todas_las_texturas:
		if detener_hilo: return 
		if textura != null and not cache_temporal.has(textura):
			var imagen = textura.get_image()
			var bitmap = BitMap.new()
			bitmap.create_from_image_alpha(imagen)
			var poligonos = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, imagen.get_size()), 2.0)
			cache_temporal[textura] = poligonos
			
	if not detener_hilo:
		call_deferred("_carga_terminada", cache_temporal)

func _carga_terminada(resultado_cache):
	if hilo_carga != null and hilo_carga.is_started():
		hilo_carga.wait_to_finish()
	
	cache_poligonos = resultado_cache
	math_terminada = true # La compu ya terminó
	_intentar_iniciar_juego()

func _mostrar_tutorial():
	var escena_tutorial = preload("res://Scenes/tutorial_overlay.tscn") 
	var tutorial = escena_tutorial.instantiate()
	get_tree().current_scene.add_child(tutorial)
	
	tutorial.tutorial_cerrado.connect(_on_tutorial_cerrado)

func _on_tutorial_cerrado():
	tutorial_terminado = true # El jugador ya terminó
	_intentar_iniciar_juego()

func _intentar_iniciar_juego():
	
	if math_terminada and tutorial_terminado:
		
		
		if Global.cache_poligonos.is_empty():
			Global.cache_poligonos = cache_poligonos.duplicate()
			
		
		if has_node("/root/Global"):
			get_node("/root/Global").juego_activo = true 
			
		if timer_generacion.is_stopped():
			timer_generacion.start() 
			
			
			lanzar_basura()

# --------------------------------
func lanzar_basura():
	if escena_basura == null: return
		
	var basura_actual = get_tree().get_nodes_in_group("residuos")
	if basura_actual.size() >= limite_basura_en_pantalla: return 
		
	var basura = escena_basura.instantiate()
	
	var permite_reutilizable = false
	var velocidad_nivel = 150.0
	if has_node("/root/Global"):
		var global = get_node("/root/Global")
		permite_reutilizable = global.get("include_second_use")
		velocidad_nivel = global.get("falling_speed")
	
	var probabilidad = randf()
	var tipo_elegido = ""
	var textura_a_asignar: Texture2D = null
	
	if permite_reutilizable and probabilidad < 0.15:
		tipo_elegido = "reutilizable"
		if not texturas_reutilizable.is_empty(): textura_a_asignar = texturas_reutilizable.pick_random()
	else:
		tipo_elegido = tipos_comunes.pick_random()
		match tipo_elegido:
			"organico": if not texturas_organico.is_empty(): textura_a_asignar = texturas_organico.pick_random()
			"inorganico": if not texturas_inorganico.is_empty(): textura_a_asignar = texturas_inorganico.pick_random()
			"reciclable": if not texturas_reciclable.is_empty(): textura_a_asignar = texturas_reciclable.pick_random()
			"enganosa": if not texturas_enganosa.is_empty(): textura_a_asignar = texturas_enganosa.pick_random()

	var sprite = basura.get_node_or_null("Sprite2D")
	if is_instance_valid(sprite) and textura_a_asignar != null:
		sprite.texture = textura_a_asignar
		var lado_mayor = max(textura_a_asignar.get_width(), textura_a_asignar.get_height())
		var escala_final = tamano_objetivo / lado_mayor
		sprite.scale = Vector2(escala_final, escala_final)
		_asignar_hitbox_desde_cache(basura, sprite)

	basura.set("trash_type", tipo_elegido)
	if "speed" in basura: basura.set("speed", velocidad_nivel)

	basura.add_to_group("residuos")

	var viewport_size = get_viewport().get_visible_rect().size
	var pos_x = randf_range(100, viewport_size.x - 100)
	basura.global_position = Vector2(pos_x, -50)
	
	get_tree().current_scene.call_deferred("add_child", basura)
	
	var punto_parada = Vector2(pos_x, viewport_size.y / 2)
	if basura.has_method("setup"): basura.setup(punto_parada, 20.0)

func _asignar_hitbox_desde_cache(nodo_basura: Node2D, sprite: Sprite2D):
	if not is_instance_valid(nodo_basura) or not is_instance_valid(sprite) or sprite.texture == null: return

	var textura = sprite.texture
	if not cache_poligonos.has(textura): return
		
	var poligonos = cache_poligonos[textura]
	if poligonos.is_empty(): return 

	var colision_poligono = CollisionPolygon2D.new()
	colision_poligono.polygon = poligonos[0]
	colision_poligono.scale = sprite.scale
	if sprite.centered: colision_poligono.position = -(textura.get_size() / 2.0) * sprite.scale

	var colision_vieja = nodo_basura.get_node_or_null("CollisionShape2D")
	if is_instance_valid(colision_vieja): colision_vieja.queue_free()

	nodo_basura.add_child(colision_poligono)
