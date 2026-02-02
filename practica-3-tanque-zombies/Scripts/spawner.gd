extends Node2D
class_name Spawner
@onready var tank: CharacterBody2D = $"../Tank_CharacterBody2D"

@export var scene: PackedScene
@export var tiempo_minimo: float = 1.0
@export var tiempo_maximo: float = 5.0

#Patron Spawner visto en clase
var pos_array:Array[Vector2] = []
var timer:Timer

func _ready() -> void:
	for child in get_children():
		if child is Marker2D:
			pos_array.push_back(child.global_position)
			
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timeout"))
	timer.start(randf_range(tiempo_minimo, tiempo_maximo))
	
func _on_timeout() -> void:
	if not GameManager.is_game_over:
		if pos_array.size() == 0:
			return
	
		var pos = pos_array.pick_random()
		var instance = scene.instantiate()
		instance.target = tank
		instance.global_position = pos
		add_child(instance)
		timer.start(randf_range(tiempo_minimo, tiempo_maximo))
