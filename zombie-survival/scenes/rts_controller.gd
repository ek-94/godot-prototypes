extends Node

@onready var actor = get_parent()
@onready var state_machine

func _ready():
	await get_tree().process_frame
	state_machine = actor.state_machine
	
func _physics_process(delta):
	if Input.is_action_pressed("move"):
		var mouse_pos = get_viewport().get_mouse_position()

		var ray_origin = actor.camera.project_ray_origin(mouse_pos)
		var ray_direction = actor.camera.project_ray_normal(mouse_pos)
		var ray_end = ray_origin + ray_direction * 1000

		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var result = actor.get_world_3d().direct_space_state.intersect_ray(query)
		
		if result:
			if result.collider is CharacterBody3D:
				if result.collider != actor.target:
					actor.target = result.collider
					state_machine.change_state("Follow")
			else:
				actor.navigation_agent_3d.set_target_position(result.position)
				state_machine.change_state("Move")
