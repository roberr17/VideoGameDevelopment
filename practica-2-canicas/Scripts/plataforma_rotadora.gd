extends StaticBody2D
var velocidad_rotacion = 50

func _process(delta):
	rotation -= deg_to_rad(velocidad_rotacion) * delta 
