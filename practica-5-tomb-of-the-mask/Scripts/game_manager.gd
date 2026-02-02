extends Node

signal points_updated(new_points)
signal max_height_updated(new_height)

var points: int = 0

var max_height_reached: float = 0.0


func add_points(amount: int):
	points += amount
	points_updated.emit(points) 

func update_max_height(player_y_position: float):
	if player_y_position < max_height_reached:
		max_height_reached = player_y_position
		max_height_updated.emit(max_height_reached)


func restart_game():
	print("¡Juego reiniciado! Puntos reseteados.")
	points = 0
	points_updated.emit(points)
	max_height_updated.emit(max_height_reached)
	get_tree().reload_current_scene()
