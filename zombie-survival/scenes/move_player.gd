extends State

func enter():
	pass

func physics_update(delta):
	var destination = actor.navigation_agent_3d.get_next_path_position()
	var local_destination = destination - actor.global_position
	local_destination.y = 0

	var direction = local_destination.normalized()
	actor.velocity = direction * actor.run_speed


	if direction.length() > 0:
		actor.visuals.look_at(actor.global_position + direction, Vector3.UP)
		actor.visuals.rotate_y(PI)

	if actor.animation_player.current_animation != "zombie_02_Run":
		actor.animation_player.play("zombie_02_Run")
		
		if actor.navigation_agent_3d.is_navigation_finished():
			state_machine.change_state("Idle")

	actor.move_and_slide()
