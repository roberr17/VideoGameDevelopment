extends RigidBody2D
@onready var puerta: RigidBody2D = $"."


func _on_hitbox_llave_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		self.visible = false
		self.collision_layer = 2
		self.collision_mask = 2
		
