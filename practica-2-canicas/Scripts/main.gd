extends Node2D

@onready var canica: RigidBody2D = $Canica

@onready var rectangulo_poligono: Polygon2D = $Rectangulo/RectanguloPoligono
@onready var rectangulo_colision: CollisionPolygon2D = $Rectangulo/RectanguloColision
@onready var pinchos_poligono: Polygon2D = $Pinchos/PinchosPoligono
@onready var pinchos_colision: CollisionPolygon2D = $Pinchos/PinchosColision
@onready var inicio_poligono: Polygon2D = $Inicio/InicioPoligono
@onready var inicio_colision: CollisionPolygon2D = $Inicio/InicioColision
@onready var rampa_poligono: Polygon2D = $Rampa/RampaPoligono
@onready var rampa_colision: CollisionPolygon2D = $Rampa/RampaColision
@onready var inicio: StaticBody2D = $Inicio
var rota_ya = false
var rotando = false
var objetivo_rot = inicio.rotation + deg_to_rad(180)
var velocidad_rot = 2.0 




func _ready() -> void:
	rectangulo_colision.polygon = rectangulo_poligono.polygon
	pinchos_colision.polygon = pinchos_poligono.polygon
	inicio_colision.polygon = inicio_poligono.polygon
	rampa_colision.polygon = rampa_poligono.polygon

func _input(event):
	if event.is_action_pressed("accion_personalizada") and not rota_ya:
		rota_ya = true
		rotando = true
		objetivo_rot = inicio.rotation + deg_to_rad(180)  

func _process(delta):
	if rotando:
		inicio.rotation = lerp(inicio.rotation, objetivo_rot, 0.1)
		if abs(inicio.rotation - objetivo_rot) < 0.01:
			inicio.rotation = objetivo_rot
			rotando = false
			
