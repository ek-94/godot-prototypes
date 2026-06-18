extends CharacterBody3D

@onready var camera = get_parent().find_child("Camera3D")
@onready var player = get_parent().find_child("zombie")
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var mouse_ray : RayCast3D = camera.find_child("raycast_mouse")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $visuals/Sketchfab_Scene/AnimationPlayer
@onready var visuals: Node3D = $visuals
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $visuals/Sketchfab_Scene/Sketchfab_model/fbx_merge_fbx/Object_2/RootNode/Root/Object_5/Skeleton3D/PhysicalBoneSimulator3D
@onready var attack_hitbox: Area3D = $attack_hitbox
@onready var health_bar: ProgressBar = $ProgressBar

@export var run_speed = 3
var is_attacking = false
var health = 100
var target

func _ready():
	navigation_agent_3d.set_target_position(randomPos())
	navigation_agent_3d.target_desired_distance = 0.05

func attack():
	is_attacking = true
	animation_player.play("zombie_02_Attack")
	
func turn_on_ragdoll():
	collision.disabled = true
	animation_player.stop()
	physical_bone_simulator_3d.physical_bones_start_simulation()
	physical_bone_simulator_3d.active = true
	
	for bone in physical_bone_simulator_3d.get_children():
		if bone is PhysicalBone3D:
			bone.linear_velocity = velocity
			bone.apply_central_impulse(velocity * 0.2)
			
func randomPos():
	return Vector3(
		randi_range(-10, 10),
		global_position.y,
		randi_range(-10, 10)
	)
	
func _physics_process(delta: float) -> void:
	if !is_attacking:
		if not is_on_floor():
				velocity += get_gravity() * delta
				move_and_slide()
		

func _on_navigation_agent_3d_navigation_finished() -> void:
	velocity = Vector3.ZERO # Replace with function body.


func _on_timer_timeout() -> void:
	pass
	#turn_on_ragdoll() # Replace with function body.

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "zombie_02_Attack":
		is_attacking = false
		
func deal_damage(dmg):
	var bodies = attack_hitbox.get_overlapping_bodies()
	for body in bodies:
		if body is CharacterBody3D:
			body.take_damage(dmg)
