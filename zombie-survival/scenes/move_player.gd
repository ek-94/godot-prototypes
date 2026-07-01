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
		actor.look_at(actor.global_position + direction, Vector3.UP)
		actor.rotate_y(PI)

	if actor.animation_player.current_animation != "erika_run":
		actor.animation_player.play("erika_run")
		
	if actor.navigation_agent_3d.is_navigation_finished():
		state_machine.change_state("Idle")

	actor.move_and_slide()
