extends CharacterBody3D

@onready var camera = get_parent().find_child("Camera3D")
@onready var mouse_ray : RayCast3D = camera.find_child("raycast_mouse")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $visuals/Sketchfab_Scene/AnimationPlayer
@onready var visuals: Node3D = $visuals
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $visuals/Sketchfab_Scene/Sketchfab_model/fbx_merge_fbx/Object_2/RootNode/Root/Object_5/Skeleton3D/PhysicalBoneSimulator3D

func _ready():
	navigation_agent_3d.target_desired_distance = 0.05
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity += get_gravity() * delta
			
	if Input.is_action_pressed("move"):
		var mouse_pos = get_viewport().get_mouse_position()

		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_direction = camera.project_ray_normal(mouse_pos)
		var ray_end = ray_origin + ray_direction * 1000

		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		
		navigation_agent_3d.set_target_position(result.position)

	if navigation_agent_3d.is_navigation_finished():
		velocity = Vector3.ZERO
		
		if animation_player.current_animation != "zombie_02_Idle":
			animation_player.play("zombie_02_Idle")
		
		move_and_slide()
		return

	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	local_destination.y = 0

	var direction = local_destination.normalized()
	velocity = direction * 3
	
	
	if direction.length() > 0:
		visuals.look_at(global_position + direction, Vector3.UP)
		visuals.rotate_y(PI)

	if animation_player.current_animation != "zombie_02_Run":
		animation_player.play("zombie_02_Run")

	move_and_slide()
		


func _on_navigation_agent_3d_navigation_finished() -> void:
	print("ok")
	velocity = Vector3.ZERO # Replace with function body.
