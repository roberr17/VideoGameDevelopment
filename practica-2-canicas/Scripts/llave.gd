extends Sprite2D
@onready var puerta: RigidBody2D = $"../Puerta"


func _on_hitbox_llave_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		visible = false
		print("You can win now!!!!")
