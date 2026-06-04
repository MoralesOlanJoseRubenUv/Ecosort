extends CanvasLayer

signal tutorial_cerrado

func _ready():
	# --- NUEVO: MAGIA DE PAUSA ---
	# Le decimos a este tutorial que funcione aunque el juego esté pausado
	self.process_mode = Node.PROCESS_MODE_ALWAYS 
	
	# Le decimos a la música que siga sonando aunque el juego se pause
	if has_node("/root/MusicaFondo"):
		get_node("/root/MusicaFondo").process_mode = Node.PROCESS_MODE_ALWAYS
		
	# ¡PAUSAMOS TODO EL JUEGO! (El cronómetro de tiempo, enemigos, física, todo se detiene)
	get_tree().paused = true
	# 1. FONDO OSCURO (Filtro para oscurecer el juego de fondo y que resalte el panel)
	var fondo = ColorRect.new()
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo.color = Color(0, 0, 0, 0.6) # Negro al 60% de opacidad
	add_child(fondo)

	# 2. PANEL CENTRAL (La "ventana" del tutorial)
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(850, 550)
	panel.offset_left = -425
	panel.offset_top = -275
	panel.offset_right = 425
	panel.offset_bottom = 275
	add_child(panel)

	# 3. TÍTULO
	var titulo = Label.new()
	titulo.text = "¡Bienvenido a EcoSort!"
	titulo.set_anchors_preset(Control.PRESET_TOP_WIDE)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.offset_top = 20
	titulo.add_theme_font_size_override("font_size", 38)
	titulo.add_theme_color_override("font_color", Color(0.2, 0.8, 0.3)) # Verde Ecológico
	panel.add_child(titulo)

	# 4. TEXTO EXPLICATIVO (Con colores dinámicos por cada bote)
	var texto = RichTextLabel.new()
	texto.bbcode_enabled = true
	texto.text = "[center]Tu misión es limpiar la playa antes de que la contaminación se salga de control.\n\n"
	texto.text += "[color=#4CAF50]• Bote Verde (Orgánico):[/color] Restos de comida, cáscaras, abono.\n"
	texto.text += "[color=#2196F3]• Bote Azul (Reciclable):[/color] Plástico limpio, aluminio, cartón.\n"
	texto.text += "[color=#9E9E9E]• Bote Gris (Inorgánico):[/color] Basura sucia, tickets, colillas.\n"
	texto.text += "[color=#FFFFFF]• Estantería (Reutilizable):[/color] Frascos y cajas en buen estado.\n\n"
	texto.text += "[color=#FF5252]¡Cuidado![/color] Los objetos sucios arruinan el reciclaje. ¡Piensa bien antes de tirar![/center]"
	texto.set_anchors_preset(Control.PRESET_CENTER)
	texto.custom_minimum_size = Vector2(750, 250)
	texto.offset_left = -375
	texto.offset_top = -140
	texto.offset_right = 375
	texto.offset_bottom = 110
	texto.add_theme_font_size_override("normal_font_size", 22)
	panel.add_child(texto)

	# 5. IMÁGENES DE LOS BOTES (Un contenedor que las formará automáticamente)
	var contenedor_botes = HBoxContainer.new()
	contenedor_botes.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	contenedor_botes.alignment = BoxContainer.ALIGNMENT_CENTER
	contenedor_botes.custom_minimum_size = Vector2(700, 100)
	contenedor_botes.offset_left = -350
	contenedor_botes.offset_top = -180
	contenedor_botes.offset_right = 350
	contenedor_botes.offset_bottom = -80
	contenedor_botes.add_theme_constant_override("separation", 60)
	panel.add_child(contenedor_botes)

	# ---> ¡ATENCIÓN AQUÍ! PON LAS RUTAS DE TUS IMÁGENES <---
	# Copia la ruta de tus 4 imágenes de botes desde el panel de archivos de Godot y pégalas aquí.
	var rutas_botes = [
		"res://bin_organico.svg",       # Cambia por la ruta de tu bote orgánico
		"res://bin_reciclable.svg",        # Cambia por la ruta de tu bote reciclable
		"res://bin_no_reciclable.svg",        # Cambia por la ruta de tu bote inorgánico
		"res://vidrio.png"   # Cambia por la ruta de tu estantería
	]

	for ruta in rutas_botes:
		var tex_rect = TextureRect.new()
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex_rect.custom_minimum_size = Vector2(90, 90)
		if ResourceLoader.exists(ruta):
			tex_rect.texture = load(ruta)
		contenedor_botes.add_child(tex_rect)

	# 6. BOTÓN "ENTENDIDO"
	var boton = Button.new()
	boton.text = "¡Entendido, a limpiar!"
	boton.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	boton.custom_minimum_size = Vector2(300, 60)
	boton.offset_left = -150
	boton.offset_top = -70
	boton.offset_right = 150
	boton.offset_bottom = -10
	boton.add_theme_font_size_override("font_size", 24)
	boton.pressed.connect(_on_entendido_pressed)
	panel.add_child(boton)

func _on_entendido_pressed():
	# --- NUEVO: REANUDAR JUEGO ---
	get_tree().paused = false # ¡Quitamos la pausa para que el tiempo vuelva a correr!
	tutorial_cerrado.emit()
	queue_free()
