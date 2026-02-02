extends Area2D
@onready var player: CharacterBody2D = $"../Player"
@onready var win_screen: CanvasLayer = $"../WinScreen"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.velocity = Vector2.ZERO
		win_screen.show()
		player.set_physics_process(false)
