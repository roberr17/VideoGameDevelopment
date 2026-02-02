extends GPUParticles2D

func _ready() -> void:
	emitting = true
	
 
func _process(_delta: float) -> void:
	if not emitting and amount_ratio == 1: #Que se destruya cuando pare de emitir y haya emitido todas las particulas
		queue_free()
