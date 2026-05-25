# En global.gd
extends Node

var puntos: int = 0
var vidas: int = 3
var falling_speed: float = 200.0
var include_second_use: bool = true
var nivel_actual: int = 1
var max_nivel_desbloqueado: int = 1
var total_niveles: int = 3

# Candado global para que el jugador solo pueda sostener un objeto a la vez
var arrastrando_algo: bool = false 

signal puntos_actualizados(nuevo_valor)
signal vidas_actualizadas(nuevo_valor)
signal game_over
signal juego_ganado # Nueva señal

func modificar_puntos(cantidad: int):
	# Protegemos matemáticamente el valor para que nunca baje de cero
	puntos = max(0, puntos + cantidad)
	puntos_actualizados.emit(puntos)
	
	# Condición de victoria
	if puntos >= 1000:
		juego_ganado.emit()

func modificar_vidas(cantidad: int):
	vidas += cantidad
	vidas_actualizadas.emit(vidas)
	if vidas <= 0:
		game_over.emit()
