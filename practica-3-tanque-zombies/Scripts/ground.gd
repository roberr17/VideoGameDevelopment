extends StaticBody2D
class_name Ground

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready() -> void:
	copy_collision()
	
func copy_collision()-> void:
	collision_polygon_2d.polygon = polygon_2d.polygon
	
	
func update_polygon_2d(pos: Vector2) -> void: #Actualizar el poligono con los crateres de las explosiones
	var local_pos = to_local(pos)
	var new_values = draw_circle_polygon(local_pos, 100, 100)
	var res = Geometry2D.clip_polygons(polygon_2d.polygon, new_values)
	
	if res.size() > 0:
		polygon_2d.polygon = res[0]
	
	call_deferred("copy_collision")


func draw_circle_polygon(pos: Vector2, points_nb: int, radius: float) -> PackedVector2Array: #Dibujar circulo
	var points := PackedVector2Array()
	for i in range(points_nb + 1):
		var angle = deg_to_rad(i * 360.0 / points_nb)
		points.push_back(pos + Vector2(cos(angle), sin(angle)) * radius)
	return points
