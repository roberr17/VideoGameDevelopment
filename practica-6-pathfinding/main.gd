extends Node2D

@onready var agent: Sprite2D = $Agent
@onready var tile_map: TileMapLayer = $TileMapLayer

var width = 50
var height = 30 
var noise = FastNoiseLite.new()
var grid_data = {}
var path = []
var current_path_index = 0
var speed = 30.0
var is_moving = false
var start_pos = Vector2i.ZERO
var end_pos = Vector2i.ZERO
var state = "WAITING_START"

class AStarNode:
	var position: Vector2i
	var parent: AStarNode = null
	var g_cost: float = 0.0
	var h_cost: float = 0.0
	var f_cost: float = 0.0

	func _init(pos, p_parent = null, g = 0.0, h = 0.0):
		position = pos
		parent = p_parent
		g_cost = g
		h_cost = h
		f_cost = g + h

func _ready():
	randomize()
	noise.seed = randi()
	noise.frequency = 0.1 
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	generate_maze()
	agent.visible = false

func _process(delta):
	move_agent(delta)

func generate_maze():
	tile_map.clear()
	grid_data.clear()
	path.clear()
	is_moving = false
	noise.seed = randi()
	for x in range(width):
		for y in range(height):
			var value = noise.get_noise_2d(x, y)
			var coords = Vector2i(x, y)
			if value > 0.1:
				tile_map.set_cell(coords, 0, Vector2i(0, 0))
				grid_data[coords] = false
			else:
				tile_map.set_cell(coords, 0, Vector2i(1, 0))
				grid_data[coords] = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var map_pos = tile_map.local_to_map(mouse_pos)
		if not grid_data.has(map_pos) or not grid_data[map_pos]:
			print("Posición inválida (Pared o fuera de rango)")
			return

		if state == "WAITING_START" or state == "FINISHED":
			start_pos = map_pos
			agent.position = tile_map.map_to_local(start_pos)
			agent.visible = true
			state = "WAITING_END"
			print("Inicio fijado en: ", start_pos, ". Selecciona destino.")
			
		elif state == "WAITING_END":
			end_pos = map_pos
			print("Calculando ruta de ", start_pos, " a ", end_pos)
			path = find_path_custom_astar(start_pos, end_pos)
			
			if path.is_empty():
				print("CAMINO NO VÁLIDO (Bloqueado por paredes)")
				state = "WAITING_END" 
			else:
				current_path_index = 0
				is_moving = true
				state = "MOVING"
		
		elif state == "MOVING":
			print("Reiniciando objetivo en marcha")
			is_moving = false
			state = "WAITING_END"
			_input(event)

func find_path_custom_astar(start: Vector2i, target: Vector2i) -> Array:
	var open_list = []
	var closed_set = {}
	
	var start_node = AStarNode.new(start, null, 0, get_manhattan_distance(start, target))
	open_list.append(start_node)

	while open_list.size() > 0:
		var current_node = open_list[0]
		var current_index = 0
		
		for i in range(1, open_list.size()):
			if open_list[i].f_cost < current_node.f_cost:
				current_node = open_list[i]
				current_index = i

		open_list.remove_at(current_index)
		closed_set[current_node.position] = true
		if current_node.position == target:
			var raw_path = retrace_path(current_node)
			return smooth_path(raw_path)
			
		var neighbors = get_neighbors(current_node.position)
		for neighbor_pos in neighbors:
			if closed_set.has(neighbor_pos):
				continue
			var new_g_cost = current_node.g_cost + 1
			var neighbor_in_open = null
			for n in open_list:
				if n.position == neighbor_pos:
					neighbor_in_open = n
					break
			
			if neighbor_in_open == null:
				var new_node = AStarNode.new(neighbor_pos, current_node, new_g_cost, get_manhattan_distance(neighbor_pos, target))
				open_list.append(new_node)
			elif new_g_cost < neighbor_in_open.g_cost:
				neighbor_in_open.g_cost = new_g_cost
				neighbor_in_open.f_cost = new_g_cost + neighbor_in_open.h_cost
				neighbor_in_open.parent = current_node
				
	return []

func get_neighbors(pos: Vector2i) -> Array:
	var list = []
	var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	for dir in directions:
		var check_pos = pos + dir
		if grid_data.has(check_pos) and grid_data[check_pos]:
			list.append(check_pos)
	return list

func get_manhattan_distance(a: Vector2i, b: Vector2i) -> float:
	return abs(a.x - b.x) + abs(a.y - b.y)

func retrace_path(end_node: AStarNode) -> Array:
	var path_list = []
	var current = end_node
	while current != null:
		path_list.append(current.position)
		current = current.parent
	path_list.reverse()
	return path_list

func smooth_path(original_path: Array) -> Array:
	if original_path.size() < 3:
		return original_path
		
	var new_path = [original_path[0]]
	var current_idx = 0

	while current_idx < original_path.size() - 1:
		for i in range(original_path.size() - 1, current_idx, -1):
			if has_line_of_sight(original_path[current_idx], original_path[i]):
				new_path.append(original_path[i]) 
				current_idx = i
				break
				
	return new_path
	
func has_line_of_sight(start_grid: Vector2i, end_grid: Vector2i) -> bool:
	var start_vec = Vector2(start_grid)
	var end_vec = Vector2(end_grid)
	
	var distance = start_vec.distance_to(end_vec)
	var steps = int(distance * 5) 
	if steps == 0: return true
	var agent_radius = 0.30
	var check_offsets = [
		Vector2.ZERO,
		Vector2(agent_radius, agent_radius),  
		Vector2(-agent_radius, -agent_radius), 
		Vector2(agent_radius, -agent_radius),  
		Vector2(-agent_radius, agent_radius)   
	]

	for i in range(1, steps + 1):
		var t = float(i) / steps
		var current_pos_f = start_vec.lerp(end_vec, t)
		
		for offset in check_offsets:
			var point_to_check = current_pos_f + offset
			var map_check = Vector2i(round(point_to_check.x), round(point_to_check.y))
			if grid_data.has(map_check) and grid_data[map_check] == false:
				return false
			
	return true

func move_agent(delta):
	if not is_moving or path.is_empty():
		return

	var target_map_pos = path[current_path_index]
	var target_world_pos = tile_map.map_to_local(target_map_pos)
	var distance_to_target = agent.position.distance_to(target_world_pos)
	var move_step = speed * 10 * delta 
	
	if move_step >= distance_to_target:
		agent.position = target_world_pos 
		current_path_index += 1
		if current_path_index >= path.size():
			print("¡DESTINO ALCANZADO!")
			is_moving = false
			state = "FINISHED"
			generate_maze()
	else:
		var direction = (target_world_pos - agent.position).normalized()
		agent.position += direction * move_step
