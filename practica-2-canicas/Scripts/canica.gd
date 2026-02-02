extends RigidBody2D

@export var fuerza_salto = 400
@onready var spawnpoint: Marker2D = $"../Spawnpoint"  
@onready var ray_cast_suelo: RayCast2D = $RayCastSuelo
@onready var inicio: RigidBody2D = $"../Inicio"




func _physics_process(_delta):
	if Input.is_action_just_pressed("jump") and is_on_floor(): 
		apply_central_impulse(Vector2(0, -fuerza_salto))
		

func is_on_floor() -> bool:
	return ray_cast_suelo.is_colliding() 
	
	
func _process(_delta: float) -> void:
	ray_cast_suelo.rotation = -rotation 
