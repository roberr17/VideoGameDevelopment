extends Area2D

@export var strength: float = 1200.0

func _on_body_entered(body: RigidBody2D):
	if body is RigidBody2D:
		body.apply_central_impulse(Vector2.UP*strength)
