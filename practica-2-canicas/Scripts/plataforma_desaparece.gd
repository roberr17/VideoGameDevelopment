extends StaticBody2D
var color: Color = Color ()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("accion_personalizada2"):
		collision_mask = 2
		collision_layer = 2
		modulate = Color(0.0, 0.0, 0.0, 0.831)
	


func _on_limite_inferior_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		collision_layer = 1
		collision_mask = 1
		modulate = Color("99d9eaff")
		
