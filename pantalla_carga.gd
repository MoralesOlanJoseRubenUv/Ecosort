extends CanvasLayer

@onready var texto_consejo = $NinePatchRect/Label 
@onready var eco = $Hablando 

var consejos = [
	# --- CLASIFICACIÓN DE RESIDUOS ---
	{"texto": "¡Cuidado! Las cajas de pizza grasosas van al bote inorgánico, no se pueden reciclar.", "animacion": "hablando"},
	{"texto": "Las servilletas de papel usadas con comida van a la basura orgánica.", "animacion": "hablando"},
	{"texto": "¡Nunca tires pilas a la basura común! Son muy tóxicas y requieren un trato especial.", "animacion": "hablando"},
	{"texto": "El papel aluminio limpio se recicla, pero si está muy sucio de comida va a la basura inorgánica.", "animacion": "hablando"},
	{"texto": "Los restos de frutas, verduras y cascarones de huevo son excelentes para hacer composta.", "animacion": "hablando"},
	{"texto": "El aceite de cocina usado jamás va por el fregadero; embotéllalo y tíralo aparte.", "animacion": "hablando"},
	{"texto": "Las botellas de plástico PET deben vaciarse y aplastarse antes de tirarlas para ahorrar espacio.", "animacion": "hablando"},
	{"texto": "Los aparatos electrónicos viejos o rotos deben llevarse a centros de reciclaje especiales.", "animacion": "hablando"},
	
	# --- DATOS CURIOSOS Y RECICLAJE ---
	{"texto": "El vidrio es 100% reciclable y puede reciclarse infinitas veces sin perder calidad.", "animacion": "hablando"},
	{"texto": "¿Sabías que el unicel tarda cientos de años en degradarse? ¡Evítalo siempre que puedas!", "animacion": "hablando"},
	{"texto": "Reciclar plástico ahorra energía para todo el planeta y reduce la contaminación de los mares.", "animacion": "hablando"},
	{"texto": "El cartón corrugado es uno de los materiales más fáciles de reciclar. ¡Aprovéchalo!", "animacion": "hablando"},
	{"texto": "Una sola bolsa de tela puede reemplazar a cientos de bolsas de plástico de un solo uso.", "animacion": "hablando"},
	
	# --- CUIDADO GENERAL DEL PLANETA ---
	{"texto": "Cierra la llave del agua mientras te cepillas los dientes. ¡Cada gota cuenta!", "animacion": "hablando"},
	{"texto": "Apagar las luces al salir de una habitación reduce tu huella de carbono diaria.", "animacion": "hablando"},
	{"texto": "Planta un árbol: además de dar sombra, purifica el aire que todos respiramos.", "animacion": "hablando"},
	{"texto": "Usa envases y termos reutilizables para tu comida en lugar de plásticos desechables.", "animacion": "hablando"},
	{"texto": "Evita los popotes de plástico; la gran mayoría termina contaminando ríos y océanos.", "animacion": "hablando"},
	{"texto": "Desconecta los aparatos que no uses para evitar el consumo de energía eléctrica 'vampiro'.", "animacion": "hablando"},
	{"texto": "Reparar algo roto en lugar de tirarlo es el primer gran paso para ayudar al planeta.", "animacion": "hablando"}
]

func _ready():
	# Forzamos solo el color oscuro para que resalte
	texto_consejo.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1, 1.0)) 
	
	# Efecto visual de aparición suave
	$NinePatchRect.modulate.a = 0
	var t = create_tween()
	t.tween_property($NinePatchRect, "modulate:a", 1, 0.5)
	
	# 1. Elegimos el consejo al azar
	var consejo_elegido = consejos.pick_random()
	var texto_final = consejo_elegido["texto"]
	
	# 2. EVALUAMOS EL TAMAÑO ANTES DE ESCRIBIRLO
	_ajustar_tamano_letra(texto_final)
	
	# 3. Lo mostramos en pantalla y animamos a Eco
	texto_consejo.text = texto_final
	if eco.sprite_frames.has_animation(consejo_elegido["animacion"]):
		eco.play(consejo_elegido["animacion"])

# --- LA MAGIA DEL AUTO-TAMAÑO ---
func _ajustar_tamano_letra(texto: String):
	var cantidad_letras = texto.length()
	var tamano_ideal = 22 # Tamaño grande para textos cortos
	
	if cantidad_letras > 75:
		tamano_ideal = 14 # Tamaño pequeño para textos muy largos
	elif cantidad_letras > 45:
		tamano_ideal = 17 # Tamaño mediano para textos regulares
		
	# Le aplicamos el tamaño calculado al Label
	texto_consejo.add_theme_font_size_override("font_size", tamano_ideal)
