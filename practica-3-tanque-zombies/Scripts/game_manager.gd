extends Node

var is_game_over: bool = false

func end_game(): #Funcion que cambia el estado de la partida a perdido si el zombie toca al tanque
	if is_game_over:
		return
	print("¡PARTIDA PERDIDA!")
	is_game_over = true
