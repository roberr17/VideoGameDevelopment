extends Area2D

@export var rise_speed: float = 15.0 

func _physics_process(delta):
	global_position.y -= rise_speed * delta

func _on_body_entered(body):
	if body.is_in_group("Player"): 
		body.die() 
 
