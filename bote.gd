extends Area2D

@export var tipo_de_bote: String = "indefinido"

func _process(_delta):
	for area in get_overlapping_areas():
		if "trash_type" in area and not area.is_dragging:
			procesar_puntos(area)

func procesar_puntos(objeto):
	# --- LA NUEVA REGLA DE ORO ---
	# Es correcto si el tipo coincide exactamente, 
	# O si el bote es el "inorganico" y la basura es "enganosa".
	if objeto.trash_type == self.tipo_de_bote or (self.tipo_de_bote == "inorganico" and objeto.trash_type == "enganosa"):
		
		if objeto.trash_type == "reutilizable":
			Global.modificar_puntos(100)
		else:
			Global.modificar_puntos(50)
			
		aplicar_feedback(Color.GREEN)
	else:
		# Si se equivoca, pierde puntos y UNA VIDA
		Global.modificar_puntos(-25)
		Global.modificar_vidas(-1) 
		aplicar_feedback(Color.RED)
	
	objeto.queue_free()

func aplicar_feedback(color_flash):
	var t = create_tween()
	t.tween_property(self, "modulate", color_flash, 0.1)
	t.tween_property(self, "modulate", Color.WHITE, 0.1)
