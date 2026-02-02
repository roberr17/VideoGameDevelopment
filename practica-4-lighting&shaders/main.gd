extends Node2D

var luces_estan_encendidas = true

func _input(event):
	if event.is_action_pressed("ui_accept"):
		toggle_lights()

func toggle_lights():
	luces_estan_encendidas = not luces_estan_encendidas

	for light in get_tree().get_nodes_in_group("luces"):
		light.visible = luces_estan_encendidas

	var valor_shader = 0.0
	if luces_estan_encendidas:
		valor_shader = 1.0

	for sprite in get_tree().get_nodes_in_group("sprites_con_luz"):
		var mat = sprite.material as ShaderMaterial
		if mat:
			mat.set_shader_parameter("luz", valor_shader)
	   
