extends CharacterBody3D

@onready var visuals: Node3D = $visuals
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $visuals/mixamo_base/Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var printer: Timer = $printer
@onready var blood_particles_scene = preload("res://scenes/blood_particles.tscn")

@onready var player = get_parent().get_node("Player")
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var timer: Timer = $Timer
@onready var body_parts = {
	"head": physical_bone_simulator_3d.get_node("Physical Bone mixamorig_Head"),
	"hips": physical_bone_simulator_3d.get_node("Physical Bone mixamorig_Hips")
	}

var dead = true
var getting_up = false
var speed = 1.0
var idle = true
var health = 100

func _ready():
	pass
	
func take_damage(damage, pos):
	var blood_particles = blood_particles_scene.instantiate()
	blood_particles.global_position = pos
	get_tree().current_scene.add_child(blood_particles)
	if health > 0:
		health -= damage
		if health < 0:
			die()
	
func turn_on_ragdoll():
	collision.disabled = true
	animation_player.stop()
	physical_bone_simulator_3d.physical_bones_start_simulation()
	physical_bone_simulator_3d.active = true
	velocity = Vector3.ZERO

func apply_force(global_pos, body_part, forward_force, up_force, rotation_force):
	timer.start()
	dead = true
	turn_on_ragdoll()
	var hit_dir = (global_position - global_pos).normalized()
	var launch = hit_dir * forward_force + Vector3.UP * up_force
	
	for bone in physical_bone_simulator_3d.get_children():
		if bone is PhysicalBone3D:
			bone.linear_velocity = launch + Vector3(
			randf_range(-rotation_force, rotation_force),
			randf_range(-rotation_force, rotation_force),
			randf_range(-rotation_force, rotation_force)
		)
	
func die():
	timer.start()
	dead = true
	turn_on_ragdoll()
	var hit_dir = (global_position - player.global_position).normalized()
	#var hips = physical_bone_simulator_3d.get_node("Physical Bone mixamorig_Hips")
	var launch = hit_dir * 8 + Vector3.UP * 3
	

	for bone in physical_bone_simulator_3d.get_children():
		if bone is PhysicalBone3D:
			bone.linear_velocity = launch
			body_parts["head"].apply_central_impulse(hit_dir * 1 + Vector3.UP * 0.1)
			
func _physics_process(delta: float) -> void:
	if getting_up:
		if not is_on_floor():
			velocity += get_gravity() * delta
			move_and_slide()
			return
	
	if not is_on_floor():
			velocity += get_gravity() * delta
			move_and_slide()
			
	if animation_player.current_animation != "idle" and !getting_up:
		animation_player.play("idle")
		
	if not idle:	
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
	pass
