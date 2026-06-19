extends CharacterBody3D

@onready var camera = get_parent().find_child("Camera3D")
@onready var state_machine: Node = $StateMachine
@onready var player = get_parent().find_child("zombie")
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var mouse_ray : RayCast3D = camera.find_child("raycast_mouse")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $visuals/erika/AnimationPlayer
@onready var visuals: Node3D = $visuals
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $visuals/Sketchfab_Scene/Sketchfab_model/fbx_merge_fbx/Object_2/RootNode/Root/Object_5/Skeleton3D/PhysicalBoneSimulator3D
@onready var health_bar: ProgressBar = $ProgressBar

@export var run_speed = 10
var health = 100
var is_dead = false
var target 

func _ready():
	health_bar.value = health
	navigation_agent_3d.target_desired_distance = 0.05

func take_damage(dmg):
	if health > 0:
		health -= dmg
		health_bar.value = health
		if health <= 0:
			die()
		
func die():
	is_dead = true
	turn_on_ragdoll()
	
func turn_on_ragdoll():
	velocity = Vector3.ZERO
	collision.disabled = true
	animation_player.stop()
	physical_bone_simulator_3d.physical_bones_start_simulation()
	physical_bone_simulator_3d.active = true
	
	for bone in physical_bone_simulator_3d.get_children():
		if bone is PhysicalBone3D:
			bone.linear_velocity = velocity
			bone.apply_central_impulse(velocity * 0.2)
	
func _physics_process(delta: float) -> void:
		if not is_on_floor():
				velocity += get_gravity() * delta
				move_and_slide()

func _on_timer_timeout() -> void:
	pass
	#turn_on_ragdoll() # Replace with function body.
