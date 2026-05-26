extends Node2D

@onready var eco = $AnimatedSprite2D 
@onready var globo = $NinePatchRect
@onready var texto = $NinePatchRect/Label

var timer_reaccion: Timer

# ==========================================
# EL CEREBRO DE ECO: DICCIONARIOS DE OBJETOS
# ==========================================

var mensajes_acierto = {
	# ORGÁNICOS
	"cascaraplatano": "¡Potasio puro! Esa cáscara nutrirá muy bien la tierra de nuestra composta.",
	"granoscafe": "¡Huele a café! Los restos de café son abono excelente para las plantas.",
	"bolsasdete(organico)": "¡Muy bien! Las bolsitas de té (sin la grapa) son materia orgánica perfecta.",
	"cascarahuevo": "¡Calcio para la tierra! Los cascarones triturados son grandes fertilizantes.",
	"manzanamordida": "¡A la composta! Ese corazón de manzana volverá a la naturaleza.",
	
	# ENGAÑOSOS (Van a inorgánico)
	"cajapizza(sucia)": "¡Bien hecho! La grasa arruina el cartón, por eso esta caja va directo al inorgánico.",
	"botellacristalsucia": "¡Exacto! Como está muy sucia por dentro, no la aceptan para reciclaje.",
	"latacomidasucia": "¡Buena observación! Los restos de comida arruinarían el lote de reciclaje.",
	"periodicosucio": "¡Así es! El papel manchado de grasa o pintura ya no se puede reciclar.",
	
	# INORGÁNICOS PUROS
	"colillacigarro": "¡Correcto! Las colillas son tóxicas y contaminan el agua, van al bote inorgánico.",
	"chiclemasticado": "¡Bien! El chicle es plástico sintético, no es comida. Va al inorgánico.",
	"ticket(inorganico)": "¡Súper tip! Los tickets de compra tienen químicos térmicos y NUNCA se reciclan.",
	"esponjasucia": "¡Exacto! Las esponjas sintéticas usadas no se reciclan bajo ninguna circunstancia.",
	"panalsucio": "¡Perfecto! Los residuos sanitarios siempre van al inorgánico por seguridad.",
	
	# RECICLABLES LIMPIOS
	"lataaluminiolimpia": "¡El aluminio es el rey! Se puede reciclar infinitas veces ahorrando mucha energía.",
	"botellapetlimpia": "¡Genial! Esa botella PET limpia está lista para convertirse en algo nuevo.",
	"cajaleche": "¡Excelente! Los Tetra Brik limpios se separan en papel, plástico y aluminio.",
	"cartondesarmadolimpio": "¡Perfecto! Acomodar el cartón limpio ahorra espacio en las plantas recicladoras.",
	
	# ESTANTERÍA / REUTILIZABLES
	"botellavidriocontapa": "¡Súper! Esa botella de vidrio entera nos sirve para guardar agua o semillas.",
	"cajazapatos": "¡Buena idea! Esa caja fuerte sirve perfecto para organizar tus cosas.",
	"botedetergente": "¡Genial! Este plástico rígido lo podemos cortar y hacer una maceta."
}

var mensajes_error = {
	# ERRORES CON ENGAÑOSOS (Jugador creyó que se reciclaban)
	"cajapizza(sucia)": "¡Alto ahí! La grasa de la pizza echa a perder el reciclaje. Esta caja va al inorgánico.",
	"botellacristalsucia": "¡Cuidado! El vidrio se recicla, pero si está muy sucio lo rechazan. Iba al inorgánico.",
	"periodicosucio": "¡Atención! El papel manchado de comida pierde sus fibras útiles. Va a la basura general.",
	
	# ERRORES CON ORGÁNICOS
	"cascaraplatano": "¡Oh no! Las cáscaras pudrirían los demás residuos. Su lugar es el bote verde (Orgánico).",
	"cascarahuevo": "¡Ups! El cascarón de huevo es materia orgánica, debimos usarlo para abono.",
	"granoscafe": "¡El café es orgánico! Si lo tiras ahí, ensuciarás materiales que sí se podían reciclar.",
	
	# ERRORES CON INORGÁNICOS
	"colillacigarro": "¡Jamás la recicles! Una colilla contamina miles de litros de agua. Va estricto al inorgánico.",
	"ticket(inorganico)": "¡Trampa común! Los tickets de las tiendas tienen químicos tóxicos, no van con el papel limpio.",
	"chiclemasticado": "¡Cuidado! El chicle pegará y arruinará otros materiales. Es basura inorgánica pura.",
	
	# ERRORES CON RECICLABLES O REUTILIZABLES
	"botellapetlimpia": "¡No desperdicies plástico limpio! Esa botella debió ir al bote azul de reciclaje.",
	"cajaleche": "¡Espera! Esa caja de leche limpia es muy valiosa para reciclarla. ¡No la tires a la basura normal!",
	"cajazapatos": "¡Ay! Esa caja de cartón estaba entera, ¡podíamos darle un segundo uso en la estantería!"
}

# ==========================================

func _ready():
	texto.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# NUEVOS MÁRGENES: Recalibrados para bajar el texto y alejarlo del techo verde
	texto.offset_left = 35    
	texto.offset_right = -35  
	texto.offset_top = 35     # ¡Modificado para empujar desde arriba!
	texto.offset_bottom = -70 # ¡Modificado para darle espacio abajo!
	
	texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texto.autowrap_mode = TextServer.AUTOWRAP_WORD
	texto.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1, 1.0))
	
	globo.hide()
	eco.play("descanso")
	
	timer_reaccion = Timer.new()
	timer_reaccion.one_shot = true
	timer_reaccion.wait_time = 4.5 
	timer_reaccion.timeout.connect(_volver_a_descansar)
	add_child(timer_reaccion)

func reaccionar_acierto(tipo_basura: String, nombre_item: String):
	var mensaje = ""
	
	if mensajes_acierto.has(nombre_item):
		mensaje = mensajes_acierto[nombre_item]
	else:
		match tipo_basura:
			"organico": mensaje = "¡Perfecto! Estos restos nos servirán para hacer composta nutritiva."
			"inorganico": mensaje = "¡Bien hecho! Los residuos no aprovechables van exactamente aquí."
			"reciclable": mensaje = "¡Genial! Este material limpio será procesado para crear cosas nuevas."
			"enganosa": mensaje = "¡Qué buen ojo! Al estar sucio, este objeto ya no se podía reciclar."
			"reutilizable": mensaje = "¡Excelente elección! Le daremos una segunda vida útil a esto."
			_: mensaje = "¡Sigue así! Estás ayudando mucho al planeta."
			
	_mostrar_reaccion("feliz", mensaje)

func reaccionar_error(tipo_basura_real: String, tipo_bote_equivocado: String, nombre_item: String):
	var mensaje = ""
	
	if mensajes_error.has(nombre_item):
		mensaje = mensajes_error[nombre_item]
	else:
		match tipo_basura_real:
			"enganosa": mensaje = "¡Cuidado! Aunque parecía reciclable, al estar sucio contamina a los demás. Iba al inorgánico."
			"organico": mensaje = "¡Ups! Las sobras de comida y materia natural pertenecen al bote verde."
			"reciclable": mensaje = "¡Oh no! Ese material limpio se podía reciclar. ¡Fíjate bien la próxima vez!"
			"reutilizable": mensaje = "¡Ay! Ese objeto aún estaba en muy buen estado para reusarse en casa."
			"inorganico": mensaje = "¡Cuidado! Esa basura no se puede aprovechar para nada, debió ir al bote gris."
			_: mensaje = "¡Ese no era su lugar! Piensa bien antes de clasificarlo."

	_mostrar_reaccion("triste", mensaje)

func _mostrar_reaccion(animacion: String, mensaje_texto: String):
	if mensaje_texto.length() > 75:
		texto.add_theme_font_size_override("font_size", 14)
	elif mensaje_texto.length() > 45:
		texto.add_theme_font_size_override("font_size", 16)
	else:
		texto.add_theme_font_size_override("font_size", 20)
		
	texto.text = mensaje_texto
	eco.play(animacion)
	globo.show()
	timer_reaccion.start()

func _volver_a_descansar():
	globo.hide()
	eco.play("descanso")
