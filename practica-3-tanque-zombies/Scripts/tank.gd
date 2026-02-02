extends CharacterBody2D
var gravity = 500
var speed = 320
var jump_force = 400
var ball_strength = 1000
@onready var cannon_sprite_2d: Sprite2D = $Cannon_Sprite2D
@onready var sight: Marker2D = $Cannon_Sprite2D/Sight
@export var cannon_ball: PackedScene
@onready var body_animated_sprite_2d: AnimatedSprite2D = $Body_CollisionShape2D/Body_AnimatedSprite2D
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound



func _physics_process(delta: float) -> void: #Aplicar la gravedad y el movimiento en funcion de los inputs
	if not GameManager.is_game_over:
		if not is_on_floor():
			velocity.y += gravity * delta
		else:
			velocity.y = max(velocity.y, 0)
	
		var input_direction := 0
		if Input.is_action_pressed("ui_left"):
			input_direction -= 1
		if Input.is_action_pressed("ui_right"):
			input_direction += 1
		velocity.x = input_direction * speed
		if velocity.x != 0:
			body_animated_sprite_2d.play("moving")
		else:
			body_animated_sprite_2d.play("idle")
	
		if Input.is_action_pressed("ui_up") and is_on_floor():
			velocity.y = -jump_force
		move_and_slide()


func _input(event: InputEvent) -> void: 
	if event is InputEventMouseMotion : 
		cannon_sprite_2d.rotation = global_position.angle_to_point(viewport_pos_to_world(event.position))-PI #Que el canon siga al mouse
	
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed and not GameManager.is_game_over: #Instanciar la bola, determinar su direccion y hacer sonido
		var ball_instance = cannon_ball.instantiate() 
		var direction = (viewport_pos_to_world(event.position) - sight.global_position).normalized()
		ball_instance.global_position = sight.global_position
		get_tree().root.add_child(ball_instance)
		ball_instance.apply_central_impulse(direction * ball_strength)
		shoot_sound.play()
		
		

func viewport_pos_to_world (event_pos : Vector2) -> Vector2:
	return get_viewport().get_canvas_transform().affine_inverse() * event_pos
