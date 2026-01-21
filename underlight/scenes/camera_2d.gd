extends Camera2D

@export var zoom_in := 2

func _ready():
	zoom = Vector2(zoom_in,zoom_in)
