extends Label

func _ready():
	GameManager.points_updated.connect(_on_points_updated)
	text = "Points: %s" % GameManager.points

func _on_points_updated(new_points):
	text = "Points: %s" % new_points
