extends Area2D

@export var fuerza_flotar = 500.0 
var canica: RigidBody2D = null

func _on_body_entered(body):
	if body is RigidBody2D:
		canica = body  

func _on_body_exited(body):
	if body == canica:
		canica = null  

func _physics_process(delta):
	if canica != null:
		canica.global_position.y -= fuerza_flotar * delta  
		canica.linear_velocity.y = 0                      
