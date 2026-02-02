extends StaticBody2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
var is_open: bool = false

func _ready():
	animated_sprite.play("closed")

func try_to_open():
	if is_open:
		return
	if GameManager.points >= 75:
		is_open = true
		animated_sprite.play("opening")
		await animated_sprite.animation_finished
		collision_shape.set_deferred("disabled", true)
		
	else:
		print("¡Puerta cerrada! Faltan puntos.")
