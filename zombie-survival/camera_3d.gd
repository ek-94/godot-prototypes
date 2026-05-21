extends Camera3D

var rotate_speed = 1.0
var camera_speed = 1


func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rotate_camera"):
			rotate_y(deg_to_rad(-event.relative.x * rotate_speed))

func _physics_process(delta):
	var input_dir = Input.get_vector(
		"left",
		"right",
		"forward",
		"backwards"
	)

	var dir = Vector3(input_dir.x, 0, input_dir.y)
