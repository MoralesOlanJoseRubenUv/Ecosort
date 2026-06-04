extends Control

var tema_juego = preload("res://TemaPrincipal.tres")
var btn_continuar: Button

# mi variable para controlar a Eco
var eco_personaje: TextureRect

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	var fondo = TextureRect.new()
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	var gradiente = Gradient.new()
	gradiente.add_point(0.0, Color(0.9, 0.8, 0.1)) 
	gradiente.add_point(1.0, Color(0.1, 0.5, 0.2)) 
	var tex = GradientTexture2D.new()
	tex.gradient = gradiente
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1, 1)
	fondo.texture = tex
	# evito que el fondo se trague los clics
	fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	add_child(fondo)

	_crear_explosion_estrellas()

	var titulo = Label.new()
	titulo.text = "¡PLAYA LIMPIA!"
	titulo.set_anchors_preset(Control.PRESET_TOP_WIDE)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.offset_top = -200 
	titulo.add_theme_font_size_override("font_size", 85)
	titulo.add_theme_color_override("font_color", Color(1, 1, 1))
	titulo.add_theme_color_override("font_outline_color", Color(0.1, 0.4, 0.1))
	titulo.add_theme_constant_override("outline_size", 20)
	titulo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(titulo)

	var subtitulo = Label.new()
	subtitulo.text = "¡Excelente trabajo!\nPero la misión para salvar el planeta aún no termina...\nEs hora de poner a prueba lo que aprendiste."
	subtitulo.set_anchors_preset(Control.PRESET_CENTER)
	subtitulo.custom_minimum_size = Vector2(900, 200)
	subtitulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitulo.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	subtitulo.offset_left = -450
	subtitulo.offset_top = -100
	subtitulo.offset_right = 450
	subtitulo.offset_bottom = 100
	subtitulo.add_theme_font_size_override("font_size", 34)
	subtitulo.add_theme_color_override("font_color", Color(0.05, 0.25, 0.1))
	subtitulo.scale = Vector2(0, 0) 
	subtitulo.pivot_offset = Vector2(450, 100)
	subtitulo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(subtitulo)

	eco_personaje = TextureRect.new()
	eco_personaje.texture = load("res://AnimacionFeliz/5.png")
	eco_personaje.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	eco_personaje.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	eco_personaje.custom_minimum_size = Vector2(350, 350) 
	eco_personaje.position = Vector2(-400, 270) 
	eco_personaje.rotation = deg_to_rad(-25)
	# EL ARREGLO VITAL: Hago a Eco "transparente" a los clics del mouse para que no bloquee el boton
	eco_personaje.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(eco_personaje)

	btn_continuar = Button.new()
	btn_continuar.theme = tema_juego
	btn_continuar.text = "¡Entendido! Ir al Examen"
	btn_continuar.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	btn_continuar.custom_minimum_size = Vector2(350, 75)
	btn_continuar.offset_left = -175
	btn_continuar.offset_top = -180
	btn_continuar.offset_right = 175
	btn_continuar.offset_bottom = -105
	btn_continuar.add_theme_font_size_override("font_size", 28)
	btn_continuar.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn_continuar.pivot_offset = Vector2(175, 37.5)
	btn_continuar.modulate = Color(1, 1, 1, 0) 
	btn_continuar.pressed.connect(_ir_a_preguntas)
	add_child(btn_continuar)

	var tween = create_tween()
	
	tween.tween_property(titulo, "offset_top", 120, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	# muevo a eco hasta el -90 para que se quede bien pegado a la orilla izquierda y no tape la E
	tween.parallel().tween_property(eco_personaje, "position:x", -90, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(eco_personaje, "rotation", deg_to_rad(5), 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(subtitulo, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn_continuar, "modulate", Color(1, 1, 1, 1), 0.5)
	
	tween.tween_callback(_iniciar_animaciones_infinitas)

func _crear_explosion_estrellas():
	for i in range(30):
		var estrella = Label.new()
		estrella.text = "⭐" if randf() > 0.5 else "✨"
		estrella.add_theme_font_size_override("font_size", randi_range(20, 65))
		
		estrella.position = Vector2(576, 324) 
		estrella.scale = Vector2(0, 0)
		# hago que las estrellas tampoco bloqueen el mouse por si caen encima del boton
		estrella.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(estrella)

		var angulo = randf() * PI * 2
		var distancia = randf_range(250, 700)
		var pos_final = Vector2(576 + cos(angulo) * distancia, 324 + sin(angulo) * distancia)

		var tween = create_tween().set_parallel(true)
		var tiempo = randf_range(0.8, 1.5)
		tween.tween_property(estrella, "position", pos_final, tiempo).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(estrella, "scale", Vector2(1, 1), tiempo * 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(estrella, "modulate:a", 0.0, tiempo).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN).set_delay(tiempo * 0.5)

func _iniciar_animaciones_infinitas():
	_latido_boton()
	_flotar_eco()

func _latido_boton():
	var tween = create_tween().set_loops()
	tween.tween_property(btn_continuar, "scale", Vector2(1.05, 1.05), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(btn_continuar, "scale", Vector2(1.0, 1.0), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _flotar_eco():
	var base_y = eco_personaje.position.y
	var tween = create_tween().set_loops()
	tween.tween_property(eco_personaje, "position:y", base_y - 20, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(eco_personaje, "position:y", base_y, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _ir_a_preguntas():
	# desactivo el boton para que no le piquen dos veces por accidente
	btn_continuar.disabled = true 
	
	# quito cualquier pausa arrastrada por el WinMenu viejo
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Scenes/nivel_preguntas.tscn")
