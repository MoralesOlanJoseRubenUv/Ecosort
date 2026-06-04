extends Control

var tema_juego = preload("res://TemaPrincipal.tres")

var banco_preguntas = [
	{ "pregunta": "¿Cuál es el primer paso de la regla de las 3R?", "opciones": ["Reutilizar", "Reciclar", "Reducir", "Rechazar"], "correcta": 2 },
	{ "pregunta": "¿Qué significa el concepto de 'Economía Circular'?", "opciones": ["Vender productos en círculos cerrados.", "Un modelo donde los residuos se convierten en recursos.", "Usar solo monedas y no billetes.", "Reciclar únicamente envases redondos."], "correcta": 1 },
	{ "pregunta": "¿Qué tipo de residuo tarda más en degradarse en la naturaleza?", "opciones": ["Cáscara de plátano", "Papel periódico", "Botella de vidrio", "Lata de aluminio"], "correcta": 2 },
	{ "pregunta": "¿Cuál de estos objetos se considera 'Basura Electrónica' (E-waste)?", "opciones": ["Baterías y celulares viejos", "Discos de vinilo", "Focos incandescentes", "Cables de algodón"], "correcta": 0 },
	{ "pregunta": "¿Por qué no se debe tirar el aceite de cocina por el fregadero?", "opciones": ["Porque oxida las tuberías rápidamente.", "Porque un litro de aceite contamina mil litros de agua.", "Porque atrae plagas a la cocina.", "Porque rompe el filtro del grifo."], "correcta": 1 },
	{ "pregunta": "¿Qué gas de efecto invernadero se produce en los vertederos por la basura orgánica?", "opciones": ["Oxígeno", "Helio", "Metano", "Argón"], "correcta": 2 },
	{ "pregunta": "¿Cuál es el principal beneficio de hacer composta en casa?", "opciones": ["Atraer animales silvestres.", "Reducir la basura orgánica y crear abono natural.", "Secar la tierra más rápido.", "Eliminar las malas hierbas del jardín."], "correcta": 1 },
	{ "pregunta": "¿Qué son los microplásticos?", "opciones": ["Juguetes de plástico muy pequeños.", "Fragmentos de plástico menores a 5 milímetros.", "Bolsas de plástico biodegradables.", "Envases de viaje para champú."], "correcta": 1 },
	{ "pregunta": "¿Qué tipo de bolsa tiene menor impacto ambiental si se usa cientos de veces?", "opciones": ["Bolsa de plástico de un solo uso.", "Bolsa de papel.", "Bolsa de tela de algodón.", "Bolsa de basura negra."], "correcta": 2 },
	{ "pregunta": "¿Qué significa que un producto sea 'Biodegradable'?", "opciones": ["Que brilla en la oscuridad.", "Que puede ser descompuesto por organismos biológicos.", "Que está hecho de plástico reciclado.", "Que es comestible para los humanos."], "correcta": 1 },
	{ "pregunta": "¿Qué residuo NUNCA debe ir en el contenedor de reciclaje de papel?", "opciones": ["Cajas de cartón corrugado.", "Hojas de cuaderno.", "Servilletas usadas y manchadas de comida.", "Sobres de cartas."], "correcta": 2 },
	{ "pregunta": "¿Para qué sirve el símbolo del triángulo con flechas y un número dentro en los envases?", "opciones": ["Para indicar cuántas veces se puede usar.", "Para identificar el tipo de resina plástica y si es reciclable.", "Para indicar el precio del producto.", "Para mostrar el nivel de toxicidad."], "correcta": 1 },
	{ "pregunta": "¿Cuál es la fuente de energía renovable que aprovecha el calor del interior de la Tierra?", "opciones": ["Eólica", "Solar", "Geotérmica", "Hidroeléctrica"], "correcta": 2 },
	{ "pregunta": "¿A qué se refiere la 'Huella de Carbono'?", "opciones": ["A la marca que deja un zapato sucio.", "Al total de emisiones de gases de efecto invernadero que generamos.", "A la cantidad de carbón que usamos para cocinar.", "Al polvo negro en el aire."], "correcta": 1 },
	{ "pregunta": "¿Qué es la Obsolescencia Programada?", "opciones": ["Un programa de televisión sobre tecnología.", "Diseñar productos para que duren para siempre.", "La vida útil de un software.", "Crear productos con una vida útil corta para forzar su reemplazo."], "correcta": 3 },
	{ "pregunta": "¿Cuál de estas acciones ahorra más agua en el hogar?", "opciones": ["Cerrar la llave mientras te cepillas los dientes.", "Dejar la manguera abierta en el jardín.", "Lavar el coche todos los días.", "Usar la lavadora con una sola prenda."], "correcta": 0 },
	{ "pregunta": "¿Qué porcentaje aproximado de la superficie de la Tierra está cubierta por agua?", "opciones": ["30%", "50%", "71%", "90%"], "correcta": 2 },
	{ "pregunta": "¿Por qué es importante proteger a las abejas?", "opciones": ["Porque producen cera para velas.", "Porque son los principales polinizadores de nuestros alimentos.", "Porque su zumbido es relajante.", "Porque espantan a otras plagas."], "correcta": 1 },
	{ "pregunta": "¿Qué sector es el mayor consumidor de agua dulce a nivel mundial?", "opciones": ["El uso doméstico.", "La industria textil.", "La agricultura.", "La minería."], "correcta": 2 },
	{ "pregunta": "¿Qué material reciclable puede ser derretido y reutilizado infinitas veces sin perder calidad?", "opciones": ["Papel", "Cartón", "Plástico", "Vidrio y Aluminio"], "correcta": 3 },
	{ "pregunta": "¿Qué es el 'Greenwashing' (Lavado Verde)?", "opciones": ["Lavar la ropa con jabón biodegradable.", "Pintar los envases de color verde.", "Marketing engañoso para parecer ecológicos sin serlo.", "Plantar árboles en zonas urbanas."], "correcta": 2 },
	{ "pregunta": "¿Qué es el Compostaje Bokashi?", "opciones": ["Un tipo de abono químico.", "Un método japonés de fermentación de residuos orgánicos.", "Una marca de tierra para macetas.", "Una técnica para quemar hojas secas."], "correcta": 1 },
	{ "pregunta": "¿Qué tipo de residuos se depositan generalmente en el contenedor rojo?", "opciones": ["Papel y cartón.", "Vidrio.", "Residuos peligrosos o bioinfecciosos.", "Plásticos y latas."], "correcta": 2 },
	{ "pregunta": "¿Cuál es la principal causa de la deforestación mundial?", "opciones": ["Expansión agrícola y ganadera.", "Incendios naturales.", "Construcción de carreteras.", "Fabricación de papel higiénico."], "correcta": 0 },
	{ "pregunta": "¿Qué problema causan las toallitas húmedas desechadas por el inodoro?", "opciones": ["Ninguno, son biodegradables.", "Limpian las tuberías.", "Bloquean los sistemas de alcantarillado.", "Alimentan a los peces."], "correcta": 2 },
	{ "pregunta": "¿Cuál es la ventaja de consumir productos locales y de temporada?", "opciones": ["Son más bonitos.", "Reducen las emisiones por transporte y almacenamiento.", "Siempre son más caros.", "Duran años sin echarse a perder."], "correcta": 1 },
	{ "pregunta": "¿Qué gas absorben los árboles durante la fotosíntesis?", "opciones": ["Oxígeno", "Nitrógeno", "Dióxido de Carbono (CO2)", "Monóxido de Carbono"], "correcta": 2 },
	{ "pregunta": "¿Qué pasa con las pilas alcalinas si se tiran en la basura normal?", "opciones": ["Se convierten en abono.", "Contaminan el suelo y el agua con metales pesados.", "Se deshacen sin problema.", "Explotan de inmediato."], "correcta": 1 },
	{ "pregunta": "¿Qué material es el poliestireno expandido (Unicel) y cuál es su problema?", "opciones": ["Un papel especial, muy fácil de reciclar.", "Un vidrio ligero, muy frágil.", "Un plástico inflado con aire, casi imposible de reciclar.", "Un metal blanco, muy pesado."], "correcta": 2 },
	{ "pregunta": "¿Qué es el desarrollo sostenible?", "opciones": ["Crecer económicamente sin importar el medio ambiente.", "Satisfacer necesidades actuales sin comprometer las del futuro.", "Dejar de usar tecnología moderna.", "Construir edificios más altos."], "correcta": 1 },
	{ "pregunta": "¿Qué certificado asegura que la madera o el papel provienen de bosques bien gestionados?", "opciones": ["ISO 9001", "FDA", "FSC (Forest Stewardship Council)", "CE"], "correcta": 2 },
	{ "pregunta": "¿Por qué es malo liberar globos de helio al cielo?", "opciones": ["Hacen mucho ruido al explotar.", "Tapan el sol.", "Al caer, los animales los confunden con comida y mueren.", "Gastan todo el helio del mundo."], "correcta": 2 },
	{ "pregunta": "¿Qué hábito en el trabajo ayuda más a reducir el uso de papel?", "opciones": ["Imprimir solo por un lado.", "Usar correos y firmas digitales.", "Escribir con letra muy pequeña.", "Usar papel de colores."], "correcta": 1 },
	{ "pregunta": "¿Cuál es el principal componente de las 'Islas de Basura' en los océanos?", "opciones": ["Madera", "Metales pesados", "Plásticos y redes de pesca", "Vidrio"], "correcta": 2 },
	{ "pregunta": "¿Qué electrodoméstico consume más energía en casa por estar siempre conectado?", "opciones": ["El microondas", "La licuadora", "El refrigerador", "El tostador"], "correcta": 2 },
	{ "pregunta": "¿Qué significa hacer 'Upcycling' (Suprarreciclaje)?", "opciones": ["Tirar cosas hacia arriba.", "Transformar un residuo en un objeto de mayor valor.", "Romper el plástico en pedazos.", "Andar en bicicleta al trabajo."], "correcta": 1 },
	{ "pregunta": "¿Cuál es el impacto de los fertilizantes químicos en los océanos?", "opciones": ["Ayudan a que los peces crezcan más.", "Limpian el agua.", "Crean 'zonas muertas' sin oxígeno por el exceso de nutrientes.", "Salinizan el agua dulce."], "correcta": 2 },
	{ "pregunta": "¿Qué son los combustibles fósiles?", "opciones": ["Combustibles hechos a base de agua.", "Fuentes de energía como el carbón y el petróleo.", "Baterías recargables.", "Restos de dinosaurios vivos."], "correcta": 1 },
	{ "pregunta": "¿Por qué las bombillas LED son mejores que las incandescentes?", "opciones": ["Son más calientes.", "Consumen hasta un 80% menos de energía y duran más.", "Son más baratas de fabricar.", "Se ven mejor en fotos."], "correcta": 1 },
	{ "pregunta": "¿Qué significa el término 'Biodiversidad'?", "opciones": ["Un parque zoológico.", "La variedad de vida en la Tierra en todas sus formas.", "Una planta exótica.", "La cantidad de humanos en el mundo."], "correcta": 1 },
	{ "pregunta": "¿Qué debes hacer con tus medicamentos caducados?", "opciones": ["Tirarlos a la basura común.", "Tirarlos por el inodoro.", "Llevarlos a puntos de acopio especiales en farmacias.", "Guardarlos en el botiquín por si acaso."], "correcta": 2 },
	{ "pregunta": "¿Cuál es la regla de oro para el reciclaje de envases tetra pak?", "opciones": ["Cortarlos en tiras.", "Quitarles la tapa y aplastarlos completamente.", "Llenarlos con agua.", "Separar el cartón del aluminio a mano."], "correcta": 1 },
	{ "pregunta": "¿Qué es la huella hídrica?", "opciones": ["Las marcas de pies mojados en el piso.", "El volumen total de agua dulce usada para producir bienes y servicios.", "La cantidad de agua en una botella.", "El nivel del mar en la costa."], "correcta": 1 },
	{ "pregunta": "¿Qué impacto tiene el 'Fast Fashion' (Moda Rápida)?", "opciones": ["Genera toneladas de ropa desechada y alta contaminación de agua.", "Fomenta el reciclaje de prendas.", "Ayuda a conservar el agua.", "Es un modelo sostenible a largo plazo."], "correcta": 0 },
	{ "pregunta": "¿Por qué es importante apagar los aparatos electrónicos en lugar de dejarlos en 'Standby'?", "opciones": ["Para que no se sobrecalienten.", "Para evitar el consumo de energía fantasma o vampiro.", "Para que duren más años.", "No hace ninguna diferencia."], "correcta": 1 },
	{ "pregunta": "¿Qué es el 'Ecodiseño'?", "opciones": ["Diseñar con color verde.", "Integrar criterios ambientales en todas las fases de diseño de un producto.", "Hacer dibujos de árboles.", "Vender productos más caros."], "correcta": 1 },
	{ "pregunta": "¿Qué significa 'Soberanía Alimentaria'?", "opciones": ["Comer solo en restaurantes caros.", "El derecho de los pueblos a definir sus propias políticas ecológicas de comida.", "Prohibir la venta de alimentos extranjeros.", "Una dieta basada solo en semillas."], "correcta": 1 },
	{ "pregunta": "¿Qué daño causan las colillas de cigarro en el medio ambiente?", "opciones": ["Ninguno.", "Liberan toxinas y microplásticos que contaminan el agua.", "Fertilizan el suelo.", "Sirven de nido para aves."], "correcta": 1 },
	{ "pregunta": "¿Cómo ayuda la dieta a reducir la huella de carbono personal?", "opciones": ["Comiendo más comida procesada.", "Reduciendo el consumo de carnes rojas y priorizando vegetales.", "Usando cubiertos de plástico.", "Comiendo solo de noche."], "correcta": 1 },
	{ "pregunta": "¿Por qué los tickets de compra brillantes (papel térmico) no suelen ser reciclables?", "opciones": ["Por su tamaño.", "Porque contienen Bisfenol-A (BPA) que contamina el reciclaje.", "Porque el color se borra.", "Porque son muy delgados."], "correcta": 1 }
]

var preguntas_seleccionadas: Array = []
var indice_actual: int = 0
var correctas: int = 0
var incorrectas: int = 0

var indice_boton_correcto: int = 0
var texto_respuesta_correcta: String = ""

var botones_opciones: Array[Button] = []
var lbl_marcador: Label
var lbl_pregunta: Label
var lbl_feedback: Label
var btn_continuar: Button
var vbox: VBoxContainer
var barra_progreso: ProgressBar
var panel_cristal: Panel

# --- VARIABLES PARA EL HILO DE CARGA DEL SIGUIENTE NIVEL ---
var cargando_siguiente: bool = false
var tiempo_carga: float = 0.0
var _min_loading_time: float = 3.5

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	var fondo = TextureRect.new()
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	var gradiente = Gradient.new()
	gradiente.add_point(0.0, Color(0.05, 0.2, 0.15)) 
	gradiente.add_point(1.0, Color(0.01, 0.08, 0.05))
	var tex = GradientTexture2D.new()
	tex.gradient = gradiente
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1, 1)
	fondo.texture = tex
	fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fondo)

	panel_cristal = Panel.new()
	panel_cristal.set_anchors_preset(Control.PRESET_CENTER)
	panel_cristal.custom_minimum_size = Vector2(850, 580)
	panel_cristal.offset_left = -425
	panel_cristal.offset_top = -290
	panel_cristal.offset_right = 425
	panel_cristal.offset_bottom = 290
	panel_cristal.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var estilo_panel = StyleBoxFlat.new()
	estilo_panel.bg_color = Color(0.1, 0.15, 0.12, 0.9) 
	estilo_panel.corner_radius_top_left = 30
	estilo_panel.corner_radius_top_right = 30
	estilo_panel.corner_radius_bottom_left = 30
	estilo_panel.corner_radius_bottom_right = 30
	estilo_panel.border_width_left = 2
	estilo_panel.border_width_top = 2
	estilo_panel.border_width_right = 2
	estilo_panel.border_width_bottom = 2
	estilo_panel.border_color = Color(0.4, 0.9, 0.5, 0.3) 
	estilo_panel.shadow_color = Color(0, 0, 0, 0.6)
	estilo_panel.shadow_size = 20
	panel_cristal.add_theme_stylebox_override("panel", estilo_panel)
	add_child(panel_cristal)

	barra_progreso = ProgressBar.new()
	barra_progreso.set_anchors_preset(Control.PRESET_TOP_WIDE)
	barra_progreso.custom_minimum_size = Vector2(700, 10)
	barra_progreso.offset_left = 75
	barra_progreso.offset_right = -75
	barra_progreso.offset_top = 30
	barra_progreso.max_value = 5
	barra_progreso.step = 1
	barra_progreso.show_percentage = false
	
	var estilo_barra_fondo = StyleBoxFlat.new()
	estilo_barra_fondo.bg_color = Color(0.2, 0.3, 0.2, 0.5)
	estilo_barra_fondo.corner_radius_top_left = 8
	estilo_barra_fondo.corner_radius_top_right = 8
	estilo_barra_fondo.corner_radius_bottom_left = 8
	estilo_barra_fondo.corner_radius_bottom_right = 8
	barra_progreso.add_theme_stylebox_override("background", estilo_barra_fondo)
	
	var estilo_barra_llena = StyleBoxFlat.new()
	estilo_barra_llena.bg_color = Color(0.3, 0.8, 0.4)
	estilo_barra_llena.corner_radius_top_left = 8
	estilo_barra_llena.corner_radius_top_right = 8
	estilo_barra_llena.corner_radius_bottom_left = 8
	estilo_barra_llena.corner_radius_bottom_right = 8
	barra_progreso.add_theme_stylebox_override("fill", estilo_barra_llena)
	panel_cristal.add_child(barra_progreso)

	lbl_marcador = Label.new()
	lbl_marcador.set_anchors_preset(Control.PRESET_TOP_WIDE)
	lbl_marcador.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_marcador.offset_top = 50
	lbl_marcador.add_theme_font_size_override("font_size", 20)
	lbl_marcador.add_theme_color_override("font_color", Color(0.7, 0.85, 0.7))
	panel_cristal.add_child(lbl_marcador)

	lbl_pregunta = Label.new()
	lbl_pregunta.set_anchors_preset(Control.PRESET_TOP_WIDE)
	lbl_pregunta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_pregunta.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl_pregunta.autowrap_mode = TextServer.AUTOWRAP_WORD
	lbl_pregunta.custom_minimum_size = Vector2(750, 100)
	lbl_pregunta.offset_top = 80
	lbl_pregunta.offset_left = 50
	lbl_pregunta.offset_right = -50
	lbl_pregunta.add_theme_font_size_override("font_size", 24)
	lbl_pregunta.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel_cristal.add_child(lbl_pregunta)

	vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.custom_minimum_size = Vector2(700, 250)
	vbox.offset_left = -350
	vbox.offset_top = -60
	vbox.offset_right = 350
	vbox.offset_bottom = 190
	vbox.add_theme_constant_override("separation", 10)
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	panel_cristal.add_child(vbox)

	for i in range(4):
		var btn = Button.new()
		btn.theme = tema_juego 
		btn.custom_minimum_size = Vector2(700, 50)
		btn.add_theme_font_size_override("font_size", 18)
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND 
		btn.pivot_offset = Vector2(350, 25) 
		
		btn.mouse_entered.connect(_animar_hover_boton.bind(btn, true))
		btn.mouse_exited.connect(_animar_hover_boton.bind(btn, false))
		btn.pressed.connect(_verificar_respuesta.bind(i, btn))
		vbox.add_child(btn)
		botones_opciones.append(btn)

	lbl_feedback = Label.new()
	lbl_feedback.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	lbl_feedback.custom_minimum_size = Vector2(750, 40) 
	lbl_feedback.offset_left = -375 
	lbl_feedback.offset_right = 375 
	lbl_feedback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_feedback.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl_feedback.offset_top = -130
	lbl_feedback.offset_bottom = -90
	lbl_feedback.add_theme_font_size_override("font_size", 18)
	lbl_feedback.autowrap_mode = TextServer.AUTOWRAP_WORD
	lbl_feedback.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel_cristal.add_child(lbl_feedback)

	btn_continuar = Button.new()
	btn_continuar.theme = tema_juego
	btn_continuar.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	btn_continuar.custom_minimum_size = Vector2(300, 50)
	btn_continuar.offset_left = -150
	btn_continuar.offset_top = -70
	btn_continuar.offset_right = 150
	btn_continuar.offset_bottom = -20
	btn_continuar.add_theme_font_size_override("font_size", 20)
	btn_continuar.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND 
	btn_continuar.pivot_offset = Vector2(150, 25)
	
	btn_continuar.mouse_entered.connect(_animar_hover_boton.bind(btn_continuar, true))
	btn_continuar.mouse_exited.connect(_animar_hover_boton.bind(btn_continuar, false))
	
	btn_continuar.hide()
	btn_continuar.pressed.connect(_siguiente_accion)
	panel_cristal.add_child(btn_continuar)

	_preparar_sesion()

# --- ESTA FUNCIÓN SE ENCARGA DEL TIEMPO DE CARGA EN SEGUNDO PLANO ---
func _process(delta):
	if cargando_siguiente:
		tiempo_carga += delta
		var progreso = []
		var estado = ResourceLoader.load_threaded_get_status("res://Scenes/mundo.tscn", progreso)
		
		# Esperamos a que la escena cargue Y que pase el tiempo mínimo de la pantalla de consejos
		if estado == ResourceLoader.THREAD_LOAD_LOADED and tiempo_carga >= _min_loading_time:
			cargando_siguiente = false
			var packed_scene = ResourceLoader.load_threaded_get("res://Scenes/mundo.tscn")
			get_tree().change_scene_to_packed(packed_scene)

func _animar_hover_boton(boton: Button, entrando: bool):
	if boton.disabled: return
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if entrando:
		tween.tween_property(boton, "scale", Vector2(1.05, 1.05), 0.1)
	else:
		tween.tween_property(boton, "scale", Vector2(1.0, 1.0), 0.1)

func _preparar_sesion():
	banco_preguntas.shuffle()
	preguntas_seleccionadas = banco_preguntas.slice(0, 5)
	indice_actual = 0
	correctas = 0
	incorrectas = 0
	_mostrar_pregunta()

func _mostrar_pregunta():
	lbl_feedback.text = ""
	btn_continuar.hide()
	barra_progreso.value = indice_actual
	lbl_marcador.text = "🎯 Aciertos: %d   |   ❌ Errores: %d" % [correctas, incorrectas]
	
	var datos = preguntas_seleccionadas[indice_actual]
	lbl_pregunta.text = datos["pregunta"]

	var opciones_mezcladas = datos["opciones"].duplicate()
	texto_respuesta_correcta = opciones_mezcladas[datos["correcta"]]
	opciones_mezcladas.shuffle()

	for i in range(4):
		botones_opciones[i].text = opciones_mezcladas[i]
		botones_opciones[i].disabled = false
		botones_opciones[i].modulate = Color.WHITE 
		botones_opciones[i].scale = Vector2(1.0, 1.0)
		
		if opciones_mezcladas[i] == texto_respuesta_correcta:
			indice_boton_correcto = i
		
	panel_cristal.modulate = Color(1, 1, 1, 0)
	panel_cristal.position.y += 20
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(panel_cristal, "modulate", Color(1, 1, 1, 1), 0.4)
	tween.parallel().tween_property(panel_cristal, "position:y", panel_cristal.position.y - 20, 0.4)

func _verificar_respuesta(indice_elegido: int, boton_presionado: Button):
	for btn in botones_opciones:
		btn.disabled = true 
		
	boton_presionado.scale = Vector2(1.0, 1.0)

	if indice_elegido == indice_boton_correcto:
		correctas += 1
		lbl_feedback.text = "¡Excelente deducción!"
		lbl_feedback.add_theme_color_override("font_color", Color(0.3, 1.0, 0.4)) 
		boton_presionado.modulate = Color(0.2, 1.0, 0.2) 
		var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(boton_presionado, "scale", Vector2(1.05, 1.05), 0.5)
	else:
		incorrectas += 1
		lbl_feedback.text = "Incorrecto. La respuesta era:\n" + texto_respuesta_correcta
		lbl_feedback.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4)) 
		boton_presionado.modulate = Color(1.0, 0.2, 0.2) 
		botones_opciones[indice_boton_correcto].modulate = Color(0.2, 1.0, 0.2)
		var tween = create_tween()
		tween.tween_property(boton_presionado, "position:x", boton_presionado.position.x + 10, 0.05)
		tween.tween_property(boton_presionado, "position:x", boton_presionado.position.x - 20, 0.05)
		tween.tween_property(boton_presionado, "position:x", boton_presionado.position.x + 10, 0.05)
		
	lbl_marcador.text = "🎯 Aciertos: %d   |   ❌ Errores: %d" % [correctas, incorrectas]
	barra_progreso.value = indice_actual + 1

	if indice_actual < 4:
		btn_continuar.text = "Siguiente Pregunta"
	else:
		btn_continuar.text = "Ver Resultados"
		
	btn_continuar.show()

func _siguiente_accion():
	indice_actual += 1
	if indice_actual < 5:
		_mostrar_pregunta()
	else:
		_mostrar_resultados_finales()

func _mostrar_resultados_finales():
	vbox.hide()
	lbl_marcador.hide()
	lbl_feedback.hide()
	barra_progreso.hide()
	btn_continuar.hide()
	lbl_pregunta.hide()
	
	var global = get_node("/root/Global")
	var paso_trivia = (correctas >= 3)
	global.trivia_ganada = paso_trivia
	
	# --- ARREGLO DEL BUG DE DESBLOQUEO: Actualizamos el progreso máximo de inmediato ---
	if paso_trivia:
		var sig_nivel = global.nivel_actual + 1
		if sig_nivel <= global.total_niveles and sig_nivel > global.max_nivel_desbloqueado:
			global.max_nivel_desbloqueado = sig_nivel

	# --- EL NUEVO REPORTE ECOLÓGICO ---
	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_CENTER)
	scroll.custom_minimum_size = Vector2(800, 400)
	scroll.offset_left = -400
	scroll.offset_top = -220
	scroll.offset_right = 400
	scroll.offset_bottom = 180
	panel_cristal.add_child(scroll)
	
	var caja_reporte = VBoxContainer.new()
	caja_reporte.set_anchors_preset(Control.PRESET_TOP_WIDE)
	caja_reporte.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	caja_reporte.add_theme_constant_override("separation", 15)
	scroll.add_child(caja_reporte)
	
	var lbl_titulo_reporte = Label.new()
	if paso_trivia:
		lbl_titulo_reporte.text = "¡REPORTE DE IMPACTO AMBIENTAL APROBADO!"
		lbl_titulo_reporte.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5))
	else:
		lbl_titulo_reporte.text = "REPORTE DE IMPACTO AMBIENTAL: FALLIDO"
		lbl_titulo_reporte.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))
	lbl_titulo_reporte.add_theme_font_size_override("font_size", 28)
	lbl_titulo_reporte.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caja_reporte.add_child(lbl_titulo_reporte)

	# Matemáticas del reporte
	var minutos = int(global.tiempo_jugado) / 60
	var segundos = int(global.tiempo_jugado) % 60
	var tiempo_formateado = "%02d:%02d" % [minutos, segundos]
	
	var tasa_aciertos = 0
	if global.basura_procesada > 0:
		tasa_aciertos = int((float(global.basura_correcta) / float(global.basura_procesada)) * 100.0)

	var max_vidas = 3.0 
	if global.nivel_actual == 1: max_vidas = 5.0
	elif global.nivel_actual == 3: max_vidas = 1.0
	
	# Porcentaje de daño a la playa
	var degradacion = int(((max_vidas - float(global.vidas)) / max_vidas) * 100.0)

	var texto_estadisticas = """
[b]1. Datos de Trazabilidad[/b]
• Usuario: %s
• Nivel Jugado: Zona %d
• Tiempo de Operación: %s
• Volumen Total de Residuos Procesados: %d unidades

[b]2. Rendimiento Operativo (In-Game)[/b]
• Eficiencia de Clasificación: %d%% de aciertos
• Residuos Correctos: %d | Residuos Incorrectos: %d

[b]3. Analítica Pedagógica[/b]
• Errores de Integridad (Contaminación de Reciclaje): %d
• Oportunidades de Reuso Perdidas (Estante Amarillo): %d
• Fallos por 'Residuos Engañosos' (Trampas visuales): %d

[b]4. Impacto en el Ecosistema[/b]
• Intervenciones de Eco (Alertas Formativas): %d
• Nivel de Degradación Final de la Playa: %d%%

[b]5. Resultados del Examen Teórico[/b]
• Aciertos: %d/5
""" % [
		global.id_sesion, global.nivel_actual, tiempo_formateado, global.basura_procesada,
		tasa_aciertos, global.basura_correcta, global.basura_incorrecta,
		global.errores_contaminacion, global.errores_reuso, global.errores_trampas,
		global.intervenciones_eco, degradacion, correctas
	]

	var lbl_stats = RichTextLabel.new()
	lbl_stats.bbcode_enabled = true
	lbl_stats.text = texto_estadisticas
	lbl_stats.custom_minimum_size = Vector2(750, 450)
	lbl_stats.add_theme_font_size_override("normal_font_size", 18)
	lbl_stats.add_theme_font_size_override("bold_font_size", 20)
	lbl_stats.add_theme_color_override("default_color", Color(0.8, 0.9, 0.8))
	caja_reporte.add_child(lbl_stats)

	var caja_botones = HBoxContainer.new()
	caja_botones.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	caja_botones.custom_minimum_size = Vector2(850, 60)
	caja_botones.offset_left = -425
	caja_botones.offset_top = -80
	caja_botones.offset_right = 425
	caja_botones.offset_bottom = -20
	caja_botones.alignment = BoxContainer.ALIGNMENT_CENTER
	caja_botones.add_theme_constant_override("separation", 50)
	panel_cristal.add_child(caja_botones)

	var btn_menu = Button.new()
	btn_menu.theme = tema_juego
	btn_menu.text = "Volver al Menú"
	btn_menu.custom_minimum_size = Vector2(250, 50)
	btn_menu.add_theme_font_size_override("font_size", 20)
	btn_menu.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND 
	btn_menu.pressed.connect(_salir_al_menu)
	caja_botones.add_child(btn_menu)

	# --- BOTÓN SIGUIENTE NIVEL ---
	if paso_trivia and global.nivel_actual < global.total_niveles:
		var btn_siguiente = Button.new()
		btn_siguiente.theme = tema_juego
		btn_siguiente.text = "Siguiente Nivel"
		btn_siguiente.custom_minimum_size = Vector2(250, 50)
		btn_siguiente.add_theme_font_size_override("font_size", 20)
		btn_siguiente.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5))
		btn_siguiente.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND 
		btn_siguiente.pressed.connect(_ir_siguiente_nivel)
		caja_botones.add_child(btn_siguiente)

func _salir_al_menu():
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Scenes/LevelSelectionMenu.tscn")

func _ir_siguiente_nivel():
	get_tree().paused = false 
	var global = get_node("/root/Global")
	
	global.trivia_ganada = false
	
	# Preparamos los datos del siguiente nivel
	var sig_nivel = global.nivel_actual + 1
	global.nivel_actual = sig_nivel
	
	# Reseteamos todas las métricas de trazabilidad para la nueva partida
	global.tiempo_jugado = 0.0 
	global.basura_procesada = 0
	global.basura_correcta = 0
	global.basura_incorrecta = 0
	global.errores_contaminacion = 0
	global.errores_reuso = 0
	global.errores_trampas = 0
	global.intervenciones_eco = 0
	
	# Configuramos la dificultad replicando la lógica exacta de tu LevelSelectionMenu.cs
	if sig_nivel == 2:
		global.falling_speed = 250.0
		global.vidas = 3
		global.include_second_use = false
	elif sig_nivel == 3:
		global.falling_speed = 400.0
		global.vidas = 1
		global.include_second_use = true

	# --- EL PROCESO DE CARGA ---
	# Escondemos el reporte y sacamos tu pantalla de carga animada
	panel_cristal.hide()
	var escena_carga = load("res://Scenes/pantalla_carga.tscn")
	var pantalla = escena_carga.instantiate()
	add_child(pantalla)
	
	# Iniciamos la carga en segundo plano igual que tu C#
	ResourceLoader.load_threaded_request("res://Scenes/mundo.tscn")
	tiempo_carga = 0.0
	cargando_siguiente = true
