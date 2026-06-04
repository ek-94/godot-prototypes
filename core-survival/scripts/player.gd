extends CharacterBody3D

@onready var camera_mount: Node3D = $camera_mount
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var visuals: Node3D = $visuals
@onready var raycast: RayCast3D = $camera_mount/Camera3D/RayCast3D
@onready var printer: Timer = $printer
@onready var noise = get_parent().noise
@onready var terrain_height = get_parent().terrain_height
@onready var health_bar: ProgressBar = $ProgressBar

var grenade_scene: PackedScene = preload("res://scenes/ball.tscn")
var shuriken_scene: PackedScene = preload("res://scenes/shuriken.tscn")
var campfire_scene: PackedScene = preload("res://scenes/campfire.tscn")

var SPEED = 3.0
var health = 100

var walk_speed = 2.0
var sprint_speed = 4.0
var running = false
var is_attacking = false

const JUMP_VELOCITY = 5

var sens = 0.2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_bar.value = 100

func take_damage(dmg):
	health -= dmg
	health_bar.value = health
	print(health)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		visuals.rotate_y(deg_to_rad(event.relative.x * sens))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens))
		
func throw_grenade():
	#var grenade = grenade_scene.instantiate()
	#get_tree().current_scene.add_child(grenade)
#
	#grenade.global_position = global_position + -transform.basis.z
	#grenade.global_position.y += 1
	#grenade.apply_central_impulse(-transform.basis.z * 14)
	var shuriken = shuriken_scene.instantiate()
	get_tree().current_scene.add_child(shuriken)

	shuriken.global_position = global_position
		
	shuriken.global_position.y += 1.1
	var target 
	
	if raycast.is_colliding():
		print("colliding")
		target = raycast.get_collision_point()
	else:
		print("not_colliding")
		target = raycast.to_global(raycast.target_position)
		
	var dir = (target - shuriken.global_position).normalized()
	shuriken.look_at(shuriken.global_position + dir, Vector3.UP)
	shuriken.linear_velocity = dir * 12
	
func attack():
	var end = raycast.to_global(raycast.target_position)
	end.y = visuals.global_position.y
	visuals.look_at(end)
	is_attacking = true
	animation_player.play("kick")
		
func _physics_process(delta: float) -> void:
# Add the gravity.
	if is_on_floor() and is_attacking:
		velocity = Vector3.ZERO
		
	if Input.is_action_pressed("sprint"):
		SPEED = sprint_speed
		running = true
	else:
		SPEED = walk_speed
		running = false
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("throw_grenade"):
		throw_grenade()
		
	if Input.is_action_just_pressed("build"):
		spawn_campfire()
	
	if Input.is_action_just_pressed("attack"):
		attack()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !is_attacking:
		var input_dir := Input.get_vector("left", "right", "forward", "backwards")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if running:
				if animation_player.current_animation != "running":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
				
			visuals.look_at(position + direction)
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func spawn_campfire():
	if raycast.is_colliding():
		print("colliding")
		var target = raycast.get_collision_point()
		var campfire_instance = campfire_scene.instantiate()
		
		campfire_instance.global_position = target
		print("Root scale:", campfire_instance.scale)

		for child in campfire_instance.get_children():
			print(child.name, child.scale)
		get_tree().current_scene.add_child(campfire_instance)
	
func hit():
	var hit = raycast.get_collider()
	if is_instance_valid(hit):
		if hit.is_in_group("enemies"):
			hit.die()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_attacking = false
