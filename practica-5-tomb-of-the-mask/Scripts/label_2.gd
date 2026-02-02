extends Label

func _ready():
	GameManager.max_height_updated.connect(_on_max_height_updated)
	text = "Max Height: %s" % abs(roundi(GameManager.max_height_reached))

func _on_max_height_updated(new_height):
	update_label(new_height)

func update_label(height_value):
	var altura_limpia = abs(roundi(height_value))
	text = "Max Height: %s" % altura_limpia
