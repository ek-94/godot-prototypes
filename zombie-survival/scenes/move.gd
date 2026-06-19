extends State

func enter():
	if actor.animation_player.current_animation != "zombie_02_Run":
		actor.animation_player.play("zombie_02_Run")

func physics_update(delta):
	if actor.navigation_agent_3d.is_navigation_finished():
			actor.state_machine.change_state("Follow")
			
	var destination = actor.navigation_agent_3d.get_next_path_position()
	var local_destination = destination - actor.global_position
	local_destination.y = 0

	var direction = local_destination.normalized()
	actor.velocity = direction * actor.run_speed
	
	if direction.length() > 0:
		actor.look_at(actor.global_position + direction, Vector3.UP)
		actor.rotate_y(PI)

	actor.move_and_slide()
