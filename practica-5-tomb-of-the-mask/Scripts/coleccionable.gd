extends Area2D
@export var points_value: int = 5
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	animated_sprite_2d.play("idle_bubble")
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.add_points(points_value)
		
		collision_shape_2d.set_deferred("disabled", true)
		animated_sprite_2d.play("picked_bubble")
		audio_stream_player_2d.play()
		

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "picked_bubble" :
		queue_free()
	
