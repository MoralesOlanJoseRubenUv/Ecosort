# En global.gd
extends Node

var puntos: int = 0
var vidas: int = 3
var falling_speed: float = 200.0
var include_second_use: bool = true

signal puntos_actualizados(nuevo_valor)
signal vidas_actualizadas(nuevo_valor)
signal game_over
signal juego_ganado # Nueva señal

func modificar_puntos(cantidad: int):
	puntos = max(0, puntos + cantidad)
	puntos_actualizados.emit(puntos)
	
	# Condición de victoria[cite: 27]
	if puntos >= 1000:
		juego_ganado.emit()

func modificar_vidas(cantidad: int):
	vidas += cantidad
	vidas_actualizadas.emit(vidas)
	if vidas <= 0:
		game_over.emit()
