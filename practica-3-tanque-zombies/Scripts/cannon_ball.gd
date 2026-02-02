extends RigidBody2D

@export var particulas_explosion : PackedScene
@onready var destruccion_area_2d: Area2D = $Destruccion_Area2D
@onready var ground: Ground = get_node("/root/Node2D/Ground")




func _on_body_entered(body: Node) -> void:
	if body.get_groups().has("Ground") or body.get_groups().has("Enemy"):
		if particulas_explosion:
			var explosion_instance = particulas_explosion.instantiate()
			explosion_instance.global_position = global_position
			get_tree().root.add_child(explosion_instance)
			
		if ground is Ground:
			ground.update_polygon_2d(global_position)
			for overlap in destruccion_area_2d.get_overlapping_bodies():
				if overlap.get_groups().has("Enemy"):
					if overlap.has_method("die"):
						overlap.die()
					particulas_explosion.instantiate()
			queue_free()
			
