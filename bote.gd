extends Area2D

@export var tipo_de_bote: String = "indefinido"

func _process(_delta):
	for area in get_overlapping_areas():
		if "trash_type" in area and not area.is_dragging:
			procesar_puntos(area)

func procesar_puntos(objeto):
	var eco_manager = get_tree().current_scene.get_node_or_null("CanvasLayer/EcoFeedback")
	
	# --- EL TRUCO: Extraemos el nombre exacto de la imagen ---
	var nombre_item = ""
	var sprite = objeto.get_node_or_null("Sprite2D")
	if is_instance_valid(sprite) and sprite.texture != null and sprite.texture.resource_path != "":
		# Esto convierte "res://.../cajapizza(sucia).png" a "cajapizza(sucia)"
		nombre_item = sprite.texture.resource_path.get_file().get_basename()
	
	# Evaluamos si la metió en el bote correcto
	if objeto.trash_type == self.tipo_de_bote or (self.tipo_de_bote == "inorganico" and objeto.trash_type == "enganosa"):
		
		if objeto.trash_type == "reutilizable":
			Global.modificar_puntos(100)
		else:
			Global.modificar_puntos(50)
			
		aplicar_feedback(Color.GREEN)
		
		if eco_manager:
			eco_manager.reaccionar_acierto(objeto.trash_type, nombre_item) # Le pasamos el nombre!
			
	else:
		Global.modificar_puntos(-25)
		Global.modificar_vidas(-1) 
		aplicar_feedback(Color.RED)
		
		if eco_manager:
			# Le pasamos qué era, en dónde lo metió por error, y el nombre de la foto
			eco_manager.reaccionar_error(objeto.trash_type, self.tipo_de_bote, nombre_item)
	
	objeto.queue_free()

func aplicar_feedback(color_flash):
	var t = create_tween()
	t.tween_property(self, "modulate", color_flash, 0.1)
	t.tween_property(self, "modulate", Color.WHITE, 0.1)
