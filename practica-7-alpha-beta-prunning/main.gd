extends Node2D


const BOARD_SIZE = 4
const MAX_DEPTH = 4 

@onready var main_container = $VBoxContainer

var board : Array = [] 
var current_player : int = 0 
var game_over : bool = false

const PLAYER_PIECE = 1
const AI_PIECE = 2

func _ready() -> void:
	var rows = main_container.get_children()
	for r in range(rows.size()):
		var hbox = rows[r]
		if hbox is HBoxContainer:
			var buttons = hbox.get_children()
			for c in range(buttons.size()):
				var button = buttons[c]
				if button is Button:
					if button.pressed.is_connected(_on_button_pressed):
						button.pressed.disconnect(_on_button_pressed)
					button.pressed.connect(_on_button_pressed.bind(r, c))
	start_game()

func start_game() -> void:
	# Tablero vacío
	board = []
	for i in range(BOARD_SIZE):
		var row = []
		for j in range(BOARD_SIZE):
			row.append(0)
		board.append(row)
	
	game_over = false
	
	# Reset visual
	var rows = main_container.get_children()
	for hbox in rows:
		if hbox is HBoxContainer:
			for btn in hbox.get_children():
				btn.text = ""
				btn.disabled = false
				btn.modulate = Color.WHITE
	
	randomize()
	# 50% de probabilidad
	if randf() > 0.5:
		current_player = PLAYER_PIECE
		print("Empiezas TÚ (X)")
	else:
		current_player = AI_PIECE
		print("Empieza la IA (O)")
		set_buttons_enabled(false) 
		await get_tree().create_timer(0.5).timeout
		ai_move()
		
func _unhandled_input(event: InputEvent) -> void:
	# Detectar si se pulsa la tecla R
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		print("Reiniciando el juego...")
		get_tree().reload_current_scene()

func _on_button_pressed(row: int, col: int) -> void:
	if game_over or current_player != PLAYER_PIECE or board[row][col] != 0: 
		return
	
	make_move(row, col, PLAYER_PIECE)
	
	if not game_over:
		current_player = AI_PIECE
		set_buttons_enabled(false)
		await get_tree().create_timer(0.1).timeout
		ai_move()

func make_move(row: int, col: int, piece: int) -> void:
	board[row][col] = piece
	update_button_visual(row, col, piece)
	
	if check_winning_move(board, piece):
		end_game(piece)
	elif is_board_full(board):
		end_game(0)

func update_button_visual(row: int, col: int, piece: int) -> void:
	var hbox = main_container.get_child(row)
	var button = hbox.get_child(col)
	
	if piece == PLAYER_PIECE:
		button.text = "X"
		button.modulate = Color(0.2, 0.8, 1.0)
	else:
		button.text = "O"
		button.modulate = Color(1.0, 0.4, 0.4)
	button.disabled = true


func ai_move() -> void:
	var score = -INF
	var best_move = Vector2i(-1, -1)

	var temp_board = board.duplicate(true)
	for r in range(BOARD_SIZE):
		for c in range(BOARD_SIZE):
			if temp_board[r][c] == 0:
				temp_board[r][c] = AI_PIECE
				var current_score = minimax(temp_board, MAX_DEPTH, -INF, INF, false)
				temp_board[r][c] = 0 # Deshacer
				
				if current_score > score:
					score = current_score
					best_move = Vector2i(r, c)
	
	if best_move.x != -1:
		make_move(best_move.x, best_move.y, AI_PIECE)
		current_player = PLAYER_PIECE
		if not game_over:
			set_buttons_enabled(true)

func minimax(curr_board: Array, depth: int, alpha: float, beta: float, maximizing_player: bool) -> int:
	if check_winning_move(curr_board, AI_PIECE):
		return 1000000 # IA Gana
	if check_winning_move(curr_board, PLAYER_PIECE):
		return -1000000 # Humano Gana
	if is_board_full(curr_board) or depth == 0:
		return score_position(curr_board, AI_PIECE)

	if maximizing_player: # Turno IA
		var max_eval = -INF
		for r in range(BOARD_SIZE):
			for c in range(BOARD_SIZE):
				if curr_board[r][c] == 0:
					curr_board[r][c] = AI_PIECE
					var eval = minimax(curr_board, depth - 1, alpha, beta, false)
					curr_board[r][c] = 0
					max_eval = max(max_eval, eval)
					alpha = max(alpha, eval)
					if beta <= alpha: 
						#print("Pruning IA. Rama cortada en profundidad ", depth) 
						break # Poda
		return max_eval
		
	else: # Turno Humano 
		var min_eval = INF
		for r in range(BOARD_SIZE):
			for c in range(BOARD_SIZE):
				if curr_board[r][c] == 0:
					curr_board[r][c] = PLAYER_PIECE
					var eval = minimax(curr_board, depth - 1, alpha, beta, true)
					curr_board[r][c] = 0
					min_eval = min(min_eval, eval)
					beta = min(beta, eval)
					if beta <= alpha: 
						#print("Pruning Humano. Rama cortada en profundidad ", depth)
						break # Poda
		return min_eval

func score_position(b: Array, piece: int) -> int:
	var score = 0
	
	for r in range(BOARD_SIZE):
		for c in range(BOARD_SIZE):
			if b[r][c] == piece:
				if (r == 1 or r == 2) and (c == 1 or c == 2):
					score += 3

	#todas las líneas posibles de 4 huecos
	
	# Horizontal
	for r in range(BOARD_SIZE):
		var row_array = b[r]
		score += evaluate_window(row_array, piece)
		
	# Vertical
	for c in range(BOARD_SIZE):
		var col_array = []
		for r in range(BOARD_SIZE):
			col_array.append(b[r][c])
		score += evaluate_window(col_array, piece)
		
	# Diagonal Positiva
	var diag1 = [b[0][0], b[1][1], b[2][2], b[3][3]]
	score += evaluate_window(diag1, piece)
	
	# Diagonal Negativa
	var diag2 = [b[0][3], b[1][2], b[2][1], b[3][0]]
	score += evaluate_window(diag2, piece)
	
	return score

func evaluate_window(window: Array, piece: int) -> int:
	var score = 0
	var opp_piece = PLAYER_PIECE
	if piece == PLAYER_PIECE:
		opp_piece = AI_PIECE
	
	var count_piece = window.count(piece)
	var count_empty = window.count(0)
	var count_opp = window.count(opp_piece)
	
	if count_piece == 4:
		score += 1000
	elif count_piece == 3 and count_empty == 1:
		score += 100
	elif count_piece == 2 and count_empty == 2:
		score += 10 

	if count_opp == 3 and count_empty == 1:
		score -= 1000 

	return score

func check_winning_move(b: Array, piece: int) -> bool:
	# Horizontal
	for r in range(BOARD_SIZE):
		if b[r][0] == piece and b[r][1] == piece and b[r][2] == piece and b[r][3] == piece: return true
	# Vertical
	for c in range(BOARD_SIZE):
		if b[0][c] == piece and b[1][c] == piece and b[2][c] == piece and b[3][c] == piece: return true
	# Diagonales
	if b[0][0] == piece and b[1][1] == piece and b[2][2] == piece and b[3][3] == piece: return true
	if b[0][3] == piece and b[1][2] == piece and b[2][1] == piece and b[3][0] == piece: return true
	return false

func is_board_full(b: Array) -> bool:
	for r in range(BOARD_SIZE):
		for c in range(BOARD_SIZE):
			if b[r][c] == 0: return false
	return true

func set_buttons_enabled(state: bool):
	var rows = main_container.get_children()
	for r in range(BOARD_SIZE):
		if r < rows.size():
			var buttons = rows[r].get_children()
			for c in range(BOARD_SIZE):
				if c < buttons.size() and board[r][c] == 0:
					buttons[c].disabled = !state

func end_game(winner: int):
	game_over = true
	if winner == PLAYER_PIECE: print("GANA EL HUMANO!")
	elif winner == AI_PIECE: print("GANA LA IA!")
	else: print("EMPATE!")
	
	var rows = main_container.get_children()
	for hbox in rows:
		for btn in hbox.get_children():
			btn.disabled = true
