extends CharacterBody3D

@onready var visuals: Node3D = $visuals
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $visuals/mixamo_base/Armature/Skeleton3D/PhysicalBoneSimulator3D

@onready var player = get_parent().get_node("Player")
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer


var dead = false
var speed = 1.0

func _ready():
	#physical_bone_simulator_3d.physical_bones_start_simulation()
	animation_player.play("walking")
	
func _physics_process(delta: float) -> void:
	if not dead:
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
	dead = true
	collision.disabled = true
	physical_bone_simulator_3d.active = true
	animation_player.stop()
	velocity = Vector3.ZERO
	physical_bone_simulator_3d.physical_bones_start_simulation()
	var hit_dir = (global_position - player.global_position).normalized()
	var head = physical_bone_simulator_3d.get_node("Physical Bone mixamorig_Head")
	#var hips = physical_bone_simulator_3d.get_node("Physical Bone mixamorig_Hips")
	var launch = hit_dir * 8 + Vector3.UP * 3

	for bone in physical_bone_simulator_3d.get_children():
		if bone is PhysicalBone3D:
			head.apply_central_impulse(hit_dir * 1 + Vector3.UP * 0.1)
			bone.linear_velocity = launch
