extends Area2D
@onready var spawnpoint: Marker2D = $"../../Spawnpoint"


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.set_deferred("global_position", spawnpoint.global_position)
		body.set_deferred("linear_velocity", Vector2.ZERO)
		body.set_deferred("angular_velocity", 0)
		print("You lost...Try Again!")
