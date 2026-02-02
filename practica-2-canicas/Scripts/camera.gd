extends Camera2D

@export var objetivo: RigidBody2D
@export var suavizado := 0.1

func _process(_delta):
	if objetivo:
		global_position = lerp(global_position, objetivo.global_position, suavizado)
		
