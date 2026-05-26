extends Node2D

@export var escena_basura = preload("res://objeto.tscn")

@export_group("Texturas de Residuos")
@export var texturas_organico: Array[Texture2D]
@export var texturas_inorganico: Array[Texture2D]
@export var texturas_reciclable: Array[Texture2D]
@export var texturas_reutilizable: Array[Texture2D]
@export var texturas_enganosa: Array[Texture2D] 

@export var tamano_objetivo: float = 80.0 
@export var limite_basura_en_pantalla: int = 15 

var tiempo_generacion: float = 2.0
var tipos_comunes = ["organico", "inorganico", "reciclable", "enganosa"]

var cache_poligonos: Dictionary = {}
var hilo_carga: Thread
var detener_hilo: bool = false # NUEVA VARIABLE: Nuestro botón de pánico para frenar el hilo

func _ready():
	# Creamos un nuevo hilo de procesador y lo ponemos a trabajar
	hilo_carga = Thread.new()
	hilo_carga.start(_tarea_pesada_en_segundo_plano)

# NUEVA FUNCIÓN: Se activa automáticamente si el nodo es destruido o cambias de escena
func _exit_tree():
	detener_hilo = true
	# Si el hilo sigue trabajando, le decimos que termine de forma segura antes de cerrar
	if hilo_carga != null and hilo_carga.is_started():
		hilo_carga.wait_to_finish()

# --- ESTA FUNCIÓN CORRE EN OTRO NÚCLEO DEL PROCESADOR ---
func _tarea_pesada_en_segundo_plano():
	var todas_las_texturas = []
	todas_las_texturas.append_array(texturas_organico)
	todas_las_texturas.append_array(texturas_inorganico)
	todas_las_texturas.append_array(texturas_reciclable)
	todas_las_texturas.append_array(texturas_reutilizable)
	todas_las_texturas.append_array(texturas_enganosa)
	
	var cache_temporal = {}
	
	for textura in todas_las_texturas:
		# REVISIÓN DE SEGURIDAD: Si el spawner ya no existe, salimos inmediatamente
		if detener_hilo: 
			return 
			
		if textura != null and not cache_temporal.has(textura):
			# Las matemáticas brutales ocurren aquí, pero no congelan el juego
			var imagen = textura.get_image()
			var bitmap = BitMap.new()
			bitmap.create_from_image_alpha(imagen)
			var poligonos = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, imagen.get_size()), 2.0)
			
			cache_temporal[textura] = poligonos
			
	# Solo enviamos la señal si el juego sigue activo y no nos han cancelado la carga
	if not detener_hilo:
		call_deferred("_carga_terminada", cache_temporal)

# --- DE VUELTA AL JUEGO PRINCIPAL ---
func _carga_terminada(resultado_cache):
	# Apagamos el hilo correctamente para liberar memoria
	if hilo_carga != null and hilo_carga.is_started():
		hilo_carga.wait_to_finish()
	
	# Guardamos los cálculos en nuestra variable
	cache_poligonos = resultado_cache

	# Arrancamos los botes de basura
	var timer = Timer.new()
	timer.wait_time = tiempo_generacion
	timer.autostart = true
	timer.timeout.connect(lanzar_basura)
	add_child(timer)
	timer.start()

func lanzar_basura():
	if escena_basura == null: return
		
	var basura_actual = get_tree().get_nodes_in_group("residuos")
	if basura_actual.size() >= limite_basura_en_pantalla: return 
		
	var basura = escena_basura.instantiate()
	var permite_reutilizable = Global.include_second_use
	var velocidad_nivel = Global.falling_speed
	
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
	
	# Usamos call_deferred para no causar un micro-tirón al añadir el nodo a la escena
	get_tree().current_scene.call_deferred("add_child", basura)
	
	var punto_parada = Vector2(pos_x, viewport_size.y / 2)
	if basura.has_method("setup"): basura.setup(punto_parada, 20.0)

# Simplificamos esta función porque ya no calcula nada, solo lee el diccionario
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
