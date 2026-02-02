extends RigidBody2D

@export var velocidad_rotacion = 90.0  # grados por segundo
var girando = false

func _process(delta):
	if Input.is_action_just_pressed("accion_personalizada"):  # definís esta acción como "G"
		girando = true
	
	if girando:
		rotation_degrees += velocidad_rotacion * delta
		# Detener rotación después de cierto ángulo
		if rotation_degrees >= 135:
			girando = false


func _on_limite_inferior_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		rotation = 0
		modulate = Color("99d9eaff")
