extends CanvasLayer

var overlay: ColorRect
var panel: Panel
var slider_musica: HSlider
var slider_efectos: HSlider

var btn_abrir: Button 
var estado_pausa_previo: bool = false 

var volumen_musica_lineal: float = 0.5
var volumen_efectos_lineal: float = 0.4
var ruta_guardado = "user://ajustes_ecosort.cfg"

func _ready():
	layer = 100 
	process_mode = Node.PROCESS_MODE_ALWAYS 

	# --- NUEVO: Cargamos tu tema principal ---
	var tema_juego = preload("res://TemaPrincipal.tres")

	# 1. BOTÓN DE ENGRANAJE
	btn_abrir = Button.new()
	btn_abrir.text = "⚙️ Ajustes"
	btn_abrir.theme = tema_juego # <--- Le aplicamos tu diseño
	btn_abrir.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	btn_abrir.offset_left = -160
	btn_abrir.offset_top = 20
	btn_abrir.offset_right = -20
	btn_abrir.offset_bottom = 70
	btn_abrir.add_theme_font_size_override("font_size", 22)
	btn_abrir.pressed.connect(_abrir_ajustes)
	add_child(btn_abrir)

	# 2. FONDO OSCURO
	overlay = ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.7)
	overlay.hide() 
	add_child(overlay)

	# 3. PANEL CENTRAL
	panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(500, 350)
	panel.offset_left = -250
	panel.offset_top = -175
	panel.offset_right = 250
	panel.offset_bottom = 175
	overlay.add_child(panel)

	var titulo = Label.new()
	titulo.text = "Ajustes de Sonido"
	titulo.set_anchors_preset(Control.PRESET_TOP_WIDE)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.offset_top = 20
	titulo.add_theme_font_size_override("font_size", 30)
	titulo.add_theme_color_override("font_color", Color(0.2, 0.8, 0.3)) 
	panel.add_child(titulo)

	# 4. SLIDER MÚSICA
	var lbl_musica = Label.new()
	lbl_musica.text = "Música de Fondo:"
	lbl_musica.position = Vector2(50, 90)
	lbl_musica.add_theme_font_size_override("font_size", 20)
	panel.add_child(lbl_musica)

	slider_musica = HSlider.new()
	slider_musica.position = Vector2(50, 130)
	slider_musica.size = Vector2(400, 30)
	slider_musica.max_value = 1.0
	slider_musica.step = 0.05
	slider_musica.value_changed.connect(_on_musica_cambiada)
	panel.add_child(slider_musica)

	# 5. SLIDER VIDEOS
	var lbl_efectos = Label.new()
	lbl_efectos.text = "Sonido del Entorno (Videos):"
	lbl_efectos.position = Vector2(50, 180)
	lbl_efectos.add_theme_font_size_override("font_size", 20)
	panel.add_child(lbl_efectos)

	slider_efectos = HSlider.new()
	slider_efectos.position = Vector2(50, 220)
	slider_efectos.size = Vector2(400, 30)
	slider_efectos.max_value = 1.0
	slider_efectos.step = 0.05
	slider_efectos.value_changed.connect(_on_efectos_cambiados)
	panel.add_child(slider_efectos)

	# 6. BOTÓN CERRAR
	var btn_cerrar = Button.new()
	btn_cerrar.text = "Guardar y Continuar"
	btn_cerrar.theme = tema_juego # <--- Le aplicamos tu diseño también
	btn_cerrar.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	btn_cerrar.custom_minimum_size = Vector2(250, 50)
	btn_cerrar.offset_left = -125
	btn_cerrar.offset_top = -70
	btn_cerrar.offset_right = 125
	btn_cerrar.offset_bottom = -20
	btn_cerrar.add_theme_font_size_override("font_size", 20)
	btn_cerrar.pressed.connect(_cerrar_ajustes)
	panel.add_child(btn_cerrar)

	cargar_ajustes()

func _abrir_ajustes():
	estado_pausa_previo = get_tree().paused 
	overlay.show()
	get_tree().paused = true 

func _cerrar_ajustes():
	overlay.hide()
	if not estado_pausa_previo:
		get_tree().paused = false 
	guardar_ajustes()

func mostrar_boton():
	btn_abrir.show()

func ocultar_boton():
	btn_abrir.hide()
	overlay.hide() 

func _on_musica_cambiada(valor: float):
	volumen_musica_lineal = valor
	var db = linear_to_db(valor) if valor > 0.01 else -80.0
	var bus_idx = AudioServer.get_bus_index("Musica")
	AudioServer.set_bus_volume_db(bus_idx, db)

func _on_efectos_cambiados(valor: float):
	volumen_efectos_lineal = valor
	var db = linear_to_db(valor) if valor > 0.01 else -80.0
	var bus_idx = AudioServer.get_bus_index("Videos")
	AudioServer.set_bus_volume_db(bus_idx, db)

func guardar_ajustes():
	var config = ConfigFile.new()
	config.set_value("Audio", "musica", volumen_musica_lineal)
	config.set_value("Audio", "efectos", volumen_efectos_lineal)
	config.save(ruta_guardado)

func cargar_ajustes():
	var config = ConfigFile.new()
	var err = config.load(ruta_guardado)
	
	if err == OK:
		volumen_musica_lineal = config.get_value("Audio", "musica", 0.5)
		volumen_efectos_lineal = config.get_value("Audio", "efectos", 0.4)
	else:
		volumen_musica_lineal = 0.5
		volumen_efectos_lineal = 0.4
		
	slider_musica.value = volumen_musica_lineal
	slider_efectos.value = volumen_efectos_lineal
	
	_on_musica_cambiada(volumen_musica_lineal)
	_on_efectos_cambiados(volumen_efectos_lineal)
