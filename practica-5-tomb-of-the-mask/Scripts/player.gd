extends CharacterBody2D
@export var move_speed: float = 300.0


enum State { IDLE, MOVING }
var current_state = State.IDLE
var move_direction = Vector2.ZERO
var dead:bool = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var hurt: AudioStreamPlayer2D = $Hurt
@onready var movement_particles: GPUParticles2D = $MovementParticles


func _ready():
	animated_sprite.play("idle")

func _physics_process(delta):
	GameManager.update_max_height(global_position.y)
	match current_state:
		State.IDLE:
			if movement_particles.emitting:
				movement_particles.emitting = false
			get_input_direction()
			if move_direction != Vector2.ZERO:
				current_state = State.MOVING
				animated_sprite.play("slide")
				jump.play()
				
		State.MOVING:
			

			velocity = move_direction * move_speed
			var collision = move_and_collide(velocity * delta)
			if not movement_particles.emitting:
				movement_particles.emitting = true

			if collision:
				var wall_normal = collision.get_normal().round()
				if wall_normal == Vector2.UP:
					animated_sprite.rotation_degrees = 0
				elif wall_normal == Vector2.DOWN:
					animated_sprite.rotation_degrees = 180
				elif wall_normal == Vector2.LEFT:
					animated_sprite.rotation_degrees = -90 
				elif wall_normal == Vector2.RIGHT:
					animated_sprite.rotation_degrees = 90 
					
				current_state = State.IDLE
				move_direction = Vector2.ZERO
				velocity = Vector2.ZERO
				if (dead == true):
					animated_sprite.play("die")
				else:
					animated_sprite.play("idle")

				check_collision(collision.get_collider())

func get_input_direction():
	move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if move_direction.x != 0:
		move_direction.y = 0
	move_direction = move_direction.normalized().round()

func check_collision(collider):
	if collider.is_in_group("Spikes"):
		die()
	if collider.is_in_group("Door"):
		collider.try_to_open()

func die():
	print("¡Has muerto!")
	current_state = State.IDLE 
	set_physics_process(false) 
	dead = true
	animated_sprite.play("die")
	movement_particles.emitting = false
	hurt.play()
	await get_tree().create_timer(1.5).timeout
	GameManager.restart_game() 
