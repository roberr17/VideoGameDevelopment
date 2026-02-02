extends Camera2D
@onready var player: CharacterBody2D = $"../Player"

@onready var pantalla_1: Marker2D = $"../Pantalla1"
@onready var pantalla_2: Marker2D = $"../Pantalla2"
@onready var pantalla_3: Marker2D = $"../Pantalla3"
@onready var pantalla_4: Marker2D = $"../Pantalla4"


enum State { ZERO,ONE,TWO,THREE,FOUR, FIVE}
var current_state = State.ZERO

var zoom_por_defecto = 2.0
var margenIzq = -90.0
var margenDcho = 240.0
var smoothing = 4.0
var target_x:float
@onready var camera: Camera2D = $"."

func _process(delta):
		if player.global_position.y > -1360:
			self.global_position.y = player.global_position.y
		else:
			self.global_position.y = -1360
		match current_state:
			State.ZERO:
				self.global_position.x = lerp(self.global_position.x, 0.0, smoothing*delta)
			State.ONE:
				self.global_position.x = lerp(self.global_position.x, pantalla_1.global_position.x, smoothing*delta)
				self.zoom = zoom.lerp(Vector2(1.5,1.5), smoothing*delta)
			State.TWO:
				self.global_position.x = lerp(self.global_position.x, pantalla_2.global_position.x, smoothing*delta)
				self.zoom = zoom.lerp(Vector2(1.8,1.8), smoothing*delta)
			State.THREE:
				self.global_position.x = lerp(self.global_position.x, pantalla_3.global_position.x, smoothing*delta)
				self.zoom = zoom.lerp(Vector2(1.5,1.5), smoothing*delta)
			State.FOUR:
				self.global_position.x = lerp(self.global_position.x, pantalla_4.global_position.x, smoothing*delta)
				self.zoom = zoom.lerp(Vector2(1.2,1.2), smoothing*delta)

				

func _on_pantalla_1_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		current_state = State.ONE

func _on_pantalla_2_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		current_state = State.TWO

func _on_pantalla_3_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		current_state = State.THREE

func _on_pantalla_4_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		current_state = State.FOUR
