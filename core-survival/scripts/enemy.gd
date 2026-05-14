extends CharacterBody3D

@onready var visuals: Node3D = $visuals
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $visuals/mixamo_base/Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var printer: Timer = $printer

@onready var player = get_parent().get_node("Player")
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var timer: Timer = $Timer

var dead = true
var getting_up = false
var speed = 1.0

func _ready():
	turn_on_ragdoll()
	
func turn_on_ragdoll():
	collision.disabled = true
	animation_player.stop()
	physical_bone_simulator_3d.physical_bones_start_simulation()
	physical_bone_simulator_3d.active = true
	velocity = Vector3.ZERO

func die():
	timer.start()
	dead = true
	turn_on_ragdoll()
	var hit_dir = (global_position - player.global_position).normalized()
	var head = physical_bone_simulator_3d.get_node("Physical Bone mixamorig_Head")
	#var hips = physical_bone_simulator_3d.get_node("Physical Bone mixamorig_Hips")
	var launch = hit_dir * 8 + Vector3.UP * 3

	for bone in physical_bone_simulator_3d.get_children():
		if bone is PhysicalBone3D:
			head.apply_central_impulse(hit_dir * 1 + Vector3.UP * 0.1)
			bone.linear_velocity = launch
			
func _physics_process(delta: float) -> void:
	if getting_up:
		if not is_on_floor():
			velocity += get_gravity() * delta
			move_and_slide()
			return
			
	if not dead:
		if animation_player.current_animation != "walking:":
			animation_player.play("walking")
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		var dir = player.global_position - global_position
		dir.y = 0
		dir = dir.normalized()
		
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
		
		var target = player.global_position
		target.y = global_position.y
		
		look_at(target)
		move_and_slide()


func _on_timer_timeout() -> void:
	# 1. Read ragdoll final position FIRST
	animation_player.play("get_up")
	animation_player.advance(0)
	var hips = physical_bone_simulator_3d.get_node("Physical Bone mixamorig_Hips")
	global_position = hips.global_position
	
	# 2. Stop ragdoll
	physical_bone_simulator_3d.active = false
	physical_bone_simulator_3d.physical_bones_stop_simulation()
	
	# 3. Re-enable character collider
	collision.disabled = false
	velocity = Vector3.ZERO
	# 4. Start get-up
	getting_up = true
	
	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "get_up":
		dead = false
		getting_up = false

func _on_printer_timeout() -> void:
	print(animation_player.current_animation)
