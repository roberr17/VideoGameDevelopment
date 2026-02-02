extends CharacterBody2D
@export var move_speed: float = 60.0
var move_direction: Vector2 = Vector2.RIGHT # Empezar moviéndose a la derecha

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast = $RayCast2D
func _ready() -> void:
	animated_sprite.play("default")
	
	
func _physics_process(_delta):

	velocity = move_direction * move_speed
	move_and_slide()
	
	if ray_cast.is_colliding():
		move_direction *= -1.0
		animated_sprite.flip_h = not animated_sprite.flip_h
		ray_cast.target_position.x *= -1.0
