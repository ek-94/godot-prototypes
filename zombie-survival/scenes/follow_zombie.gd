extends State

func enter():
	if actor.animation_player.current_animation != "zombie_02_Run":
		actor.animation_player.play("zombie_02_Run")

func physics_update(delta):
	actor.navigation_agent_3d.set_target_position(actor.target.global_position)
	var destination = actor.navigation_agent_3d.get_next_path_position()
	var local_destination = destination - actor.global_position
	local_destination.y = 0

	var direction = local_destination.normalized()
	actor.velocity = direction * actor.run_speed


	if direction.length() > 0:
		actor.look_at(actor.global_position + direction, Vector3.UP)
		actor.rotate_y(PI)

	if actor.animation_player.current_animation != "zombie_02_Run":
		actor.animation_player.play("zombie_02_Run")
		
	for body in actor.attack_hitbox.get_overlapping_bodies():
		if body == actor.player:
			state_machine.change_state("Attack")

	actor.move_and_slide()
