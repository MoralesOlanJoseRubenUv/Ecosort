extends Node2D

@export var escena_basura = preload("res://objeto.tscn")

@export_group("Texturas de Residuos")
@export var texturas_organico: Array[Texture2D]
@export var texturas_inorganico: Array[Texture2D]
@export var texturas_reciclable: Array[Texture2D]
@export var texturas_reutilizable: Array[Texture2D]

# Reducido a 80.0 para dar un respiro visual y que los objetos no se amontonen tanto
@export var tamano_objetivo: float = 80.0 
# Límite máximo de basura activa en el escenario al mismo tiempo
@export var limite_basura_en_pantalla: int = 15 

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
	# --- MANEJO DE ERRORES Y LÍMITES DE POBLACIÓN ---
	if escena_basura == null: 
		push_error("No hay escena de basura asignada al spawner.")
		return
		
	# Contamos cuántos residuos tienen la etiqueta del grupo actualmente
	var basura_actual = get_tree().get_nodes_in_group("residuos")
	if basura_actual.size() >= limite_basura_en_pantalla:
		return # Detiene la ejecución para no saturar el nivel
	# -------------------------------------------------
		
	var basura = escena_basura.instantiate()
	var permite_reutilizable = Global.include_second_use
	var velocidad_nivel = Global.falling_speed
	
	var probabilidad = randf()
	var tipo_elegido = ""
	var textura_a_asignar: Texture2D = null
	
	# --- SELECCIÓN ALEATORIA DE IMAGEN ---
	if permite_reutilizable and probabilidad < 0.15:
		tipo_elegido = "reutilizable"
		if not texturas_reutilizable.is_empty():
			textura_a_asignar = texturas_reutilizable.pick_random()
	else:
		tipo_elegido = tipos_comunes.pick_random()
		match tipo_elegido:
			"organico": 
				if not texturas_organico.is_empty():
					textura_a_asignar = texturas_organico.pick_random()
			"inorganico": 
				if not texturas_inorganico.is_empty():
					textura_a_asignar = texturas_inorganico.pick_random()
			"reciclable": 
				if not texturas_reciclable.is_empty():
					textura_a_asignar = texturas_reciclable.pick_random()

	# --- ESCALADO AUTOMÁTICO Y CREACIÓN DE HITBOX PERFECTO ---
	var sprite = basura.get_node_or_null("Sprite2D")
	if is_instance_valid(sprite) and textura_a_asignar != null:
		sprite.texture = textura_a_asignar
		
		# Calcular escala proporcional óptima
		var lado_mayor = max(textura_a_asignar.get_width(), textura_a_asignar.get_height())
		var escala_final = tamano_objetivo / lado_mayor
		sprite.scale = Vector2(escala_final, escala_final)
		
		# Generar el borde de colisión exacto leyendo los canales alfa
		_generar_hitbox_exacta(basura, sprite)
	else:
		push_warning("La basura generada carece de Sprite2D o la textura devuelta es nula.")

	# --- CONFIGURACIÓN E INSTANCIACIÓN FINAL ---
	basura.trash_type = tipo_elegido
	if "speed" in basura:
		basura.speed = velocidad_nivel

	# Etiquetamos el nodo antes de agregarlo al árbol para que el conteo sea exacto
	basura.add_to_group("residuos")

	var viewport_size = get_viewport().get_visible_rect().size
	var pos_x = randf_range(100, viewport_size.x - 100)
	basura.global_position = Vector2(pos_x, -50)
	get_tree().current_scene.add_child(basura)
	
	var punto_parada = Vector2(pos_x, viewport_size.y / 2)
	if basura.has_method("setup"):
		basura.setup(punto_parada, 20.0)


# --- FUNCIÓN GENERADORA DE COLISIONES REALES POR MAPA DE BITS ---
func _generar_hitbox_exacta(nodo_basura: Node2D, sprite: Sprite2D):
	if not is_instance_valid(nodo_basura) or not is_instance_valid(sprite) or sprite.texture == null:
		return

	var imagen = sprite.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(imagen)

	# El valor '2.0' controla la fidelidad de los vértices (menor es más detallado)
	var poligonos = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, imagen.get_size()), 2.0)

	if poligonos.is_empty():
		return # Si falla el escaneo, conservará el CollisionShape2D cuadrado base

	var colision_poligono = CollisionPolygon2D.new()
	colision_poligono.polygon = poligonos[0]
	colision_poligono.scale = sprite.scale
	
	if sprite.centered:
		colision_poligono.position = -(imagen.get_size() / 2.0) * sprite.scale

	# Removemos de forma segura el hitbox anterior si existía uno
	var colision_vieja = nodo_basura.get_node_or_null("CollisionShape2D")
	if is_instance_valid(colision_vieja):
		colision_vieja.queue_free()

	nodo_basura.add_child(colision_poligono)
