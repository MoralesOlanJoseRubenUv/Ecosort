extends Area2D

@export var tipo_de_bote: String = "indefinido"

func _process(_delta):
	for area in get_overlapping_areas():
		if "trash_type" in area and not area.is_dragging:
			procesar_puntos(area)

func procesar_puntos(objeto):
	var eco_manager = get_tree().current_scene.get_node_or_null("CanvasLayer/EcoFeedback")
	
	var nombre_item = ""
	var sprite = objeto.get_node_or_null("Sprite2D")
	if is_instance_valid(sprite) and sprite.texture != null and sprite.texture.resource_path != "":
		nombre_item = sprite.texture.resource_path.get_file().get_basename()
	
	# Sumamos al volumen de interacción
	Global.basura_procesada += 1
	
	if objeto.trash_type == self.tipo_de_bote or (self.tipo_de_bote == "inorganico" and objeto.trash_type == "enganosa"):
		
		# Acierto
		Global.basura_correcta += 1
		
		if objeto.trash_type == "reutilizable":
			Global.modificar_puntos(100)
		else:
			Global.modificar_puntos(50)
			
		aplicar_feedback(Color.GREEN)
		
		if eco_manager:
			eco_manager.reaccionar_acierto(objeto.trash_type, nombre_item) 
			
	else:
		# Error general
		Global.basura_incorrecta += 1
		Global.intervenciones_eco += 1
		
		# --- ANÁLISIS PEDAGÓGICO FINO ---
		# A) Contaminación: Metió basura a reciclaje
		if self.tipo_de_bote == "reciclable" and objeto.trash_type != "reciclable":
			Global.errores_contaminacion += 1
			
		# B) Reúso perdido: No usó el estante amarillo
		if objeto.trash_type == "reutilizable" and self.tipo_de_bote != "reutilizable":
			Global.errores_reuso += 1
			
		# C) Trampas: Cayó en un residuo engañoso
		if objeto.trash_type == "enganosa":
			Global.errores_trampas += 1

		Global.modificar_puntos(-25)
		Global.modificar_vidas(-1)
		aplicar_feedback(Color.RED)

	if objeto.has_method("queue_free"):
		objeto.queue_free()

func aplicar_feedback(color_flash):
	var t = create_tween()
	t.tween_property(self, "modulate", color_flash, 0.1)
	t.tween_property(self, "modulate", Color.WHITE, 0.1)
