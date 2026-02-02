extends Area2D
@export var strength: float = 4000.0

func _on_body_entered(body: Node2D):
	if body is RigidBody2D:
		body.apply_central_impulse(Vector2.RIGHT*strength)
