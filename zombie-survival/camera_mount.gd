extends Node3D

var rotate_speed = 0.5
var camera_speed = 3
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var camera: Camera3D = $Camera3D


func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rotate_camera"):
			rotate_y(deg_to_rad(-event.relative.x * rotate_speed))
			camera.rotate_x(deg_to_rad(-event.relative.y * rotate_speed))

func _physics_process(delta):
	var move_dir = Vector3.ZERO

	if Input.is_action_pressed("left"):
		move_dir += -global_basis.x
	if Input.is_action_pressed("right"):
		move_dir += global_basis.x
	if Input.is_action_pressed("forward"):
		move_dir += -global_basis.z
	if Input.is_action_pressed("backwards"):
		move_dir += global_basis.z

	move_dir.y = 0
	if Input.is_action_just_released("zoom_in"):
		var dir = raycast.global_position - raycast.to_global(raycast.target_position)
		dir = dir.normalized()
		position += -dir * camera_speed * delta
	
	if Input.is_action_just_released("zoom_out"):
		var dir = raycast.global_position - raycast.to_global(raycast.target_position)
		dir = dir.normalized()
		position += dir * camera_speed * delta
		

	if move_dir != Vector3.ZERO:
		move_dir = move_dir.normalized()
		position += move_dir * camera_speed * delta
