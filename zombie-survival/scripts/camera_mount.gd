extends Node3D

@onready var yaw_pivot: Node3D = $yaw_pivot
@onready var pitch_pivot: Node3D = $yaw_pivot/pitch_pivot
@onready var camera: Camera3D = $yaw_pivot/pitch_pivot/Camera3D
@onready var raycast: RayCast3D = $yaw_pivot/pitch_pivot/Camera3D/RayCast3D

var rotate_speed = 0.5
var camera_speed = 3
var mouse_delta = Vector2.ZERO

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
		
	var pivot = raycast.get_collision_point()

	if Input.is_action_pressed("rotate_camera"):
		rotate_camera()

func rotate_camera():
	if !Input.is_action_pressed("rotate_camera"):
		return

	var pivot = raycast.get_collision_point()
	
	if pivot == null:
		return

	var yaw_amount = deg_to_rad(-mouse_delta.x * rotate_speed)
	var pitch_amount = deg_to_rad(-mouse_delta.y * rotate_speed)

	# Orbit controller around pivot (horizontal)
	global_position = pivot + (global_position - pivot).rotated(
		Vector3.UP,
		yaw_amount
	)

	# Rotate yaw
	yaw_pivot.rotate_y(yaw_amount)

	# Rotate pitch
	pitch_pivot.rotate_x(pitch_amount)

	# Clamp pitch
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(-80),
		deg_to_rad(80)
	)
	
func _process(delta: float) -> void:
	var move_dir = Vector3.ZERO

	var forward = -yaw_pivot.global_basis.z
	var right = yaw_pivot.global_basis.x

	forward.y = 0
	right.y = 0

	forward = forward.normalized()
	right = right.normalized()

	if Input.is_action_pressed("left"):
		move_dir += -right
	if Input.is_action_pressed("right"):
		move_dir += right
	if Input.is_action_pressed("forward"):
		move_dir += forward
	if Input.is_action_pressed("backwards"):
		move_dir += -forward

	move_dir.y = 0
	
	if move_dir != Vector3.ZERO:
		move_dir = move_dir.normalized()
		position += move_dir * camera_speed * delta
		
	if Input.is_action_just_released("zoom_in"):
		var dir = raycast.global_position - raycast.to_global(raycast.target_position)
		dir = dir.normalized()
		position += -dir * camera_speed * delta
	
	if Input.is_action_just_released("zoom_out"):
		var dir = raycast.global_position - raycast.to_global(raycast.target_position)
		dir = dir.normalized()
		position += dir * camera_speed * delta
		
func _physics_process(delta):
	pass
