extends State

func enter():
	if actor.animation_player.current_animation != "zombie_run":
			actor.animation_player.play("zombie_run")

func physics_update(delta):
	if actor.is_on_floor():
		var target = actor.player.global_position
		
		actor.navigation_agent_3d.set_target_position(target)

		if actor.navigation_agent_3d.is_navigation_finished():
			actor.velocity = Vector3.ZERO
			
			if actor.animation_player.current_animation != "zombie_run":
				actor.animation_player.play("zombie_run")

		var destination = actor.navigation_agent_3d.get_next_path_position()
		var local_destination = destination - actor.global_position
		local_destination.y = 0

		var direction = local_destination.normalized()
		actor.velocity = direction * actor.run_speed
		
		if direction.length() > 0:
			actor.look_at(actor.global_position + direction, Vector3.UP)
			actor.rotate_y(PI)
		
		var bodies = actor.attack_hitbox.get_overlapping_bodies()
		
		for body in bodies:
			if body == actor.player:
				state_machine.change_state("Attack")
