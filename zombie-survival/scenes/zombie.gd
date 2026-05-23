extends CharacterBody3D

@onready var camera = get_parent().find_child("Camera3D")
@onready var mouse_ray : RayCast3D = camera.find_child("raycast_mouse")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("move"):
		var mouse_pos = get_viewport().get_mouse_position()

		# Convert mouse to world ray
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_dir = camera.project_ray_normal(mouse_pos)

		# Set raycast target (local space!)
		var target = ray_origin + ray_dir * 1000
		mouse_ray.target_position = mouse_ray.to_local(target)

		# Force update immediately
		mouse_ray.force_raycast_update()
		var move_target
		if mouse_ray.is_colliding():
			print(mouse_ray.get_collision_point())
			move_target = mouse_ray.get_collision_point()
		else:
			print("No collision")
		
		navigation_agent_3d.set_target_position(move_target)
			
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * 5.0
	move_and_slide()
		
