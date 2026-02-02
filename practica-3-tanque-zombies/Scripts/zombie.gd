extends CharacterBody2D

@export var target : Node2D = null

var gravity = 500
var speed = 220
var jump_force = 300
var is_dead = false

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_detector: RayCast2D = $RayCast2D #Raycast que detecta obstaculos grandes



func _physics_process(delta: float):
	if not is_dead:
		if not GameManager.is_game_over: #Si los zombies no han ganado, ejecut
			#aplicar la gravedad
			if not is_on_floor():
				velocity.y += gravity * delta
			else:
				velocity.y = 0
		

			#Aplicar la velocidad en la direccion del tanque
			var direction_x_tank = (target.global_position.x - global_position.x)
			var direction_x_vector = Vector2(direction_x_tank, -100).normalized().x
			velocity.x = direction_x_vector * speed
				
			
			#Bloque que determina si el zombie se mueve y aplica la animacion 
			if velocity.x != 0:
				animated_sprite_2d.play("walking") 
				#SI se mueve, girar el sprite y el RayCast
				if velocity.x < 0:
					animated_sprite_2d.flip_h = true 
					wall_detector.target_position.x = -25
				else:
					animated_sprite_2d.flip_h = false
					wall_detector.target_position.x = 25
				
			#Deteccion de obstaculos grandes
			if wall_detector.is_colliding():
				velocity.y = -jump_force - 100
			
			move_and_slide()
		else:
			animated_sprite_2d.play("idle")

	

func _on_area_2d_body_entered(body: Node2D) -> void: #Si los zombies colisionan con el tanque, actualizar el game manager
	if body.get_groups().has("Tank"):
		GameManager.end_game()
		
func die() -> void: #Funcion que cambia el estado del zombie a muerto
	if is_dead:
		return
	velocity.x = 0 
	collision_shape_2d.set_deferred("disabled", true)
	animated_sprite_2d.play("destroy")
	is_dead = true
	
func _on_animated_sprite_2d_animation_finished() -> void: #Cuando acaba la animacion de morir, eliminar la instancia
	if animated_sprite_2d.animation == "destroy":
		queue_free()
	
