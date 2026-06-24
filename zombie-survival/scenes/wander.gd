extends State

func enter():
	if actor.animation_player.current_animation != "zombie_02_Run":
		actor.animation_player.play("zombie_02_Run")

func physics_update(delta):
	var direction = actor.global_position.direction_to(actor.target_position)
	
	if direction.length() > 0:
		actor.look_at(actor.global_position + direction, Vector3.UP)
		actor.rotate_y(PI)
		
	if actor.global_position.distance_to(actor.target_position) > 5:
		actor.velocity = direction * actor.run_speed
	else:
		actor.velocity = Vector3.ZERO
		if actor.wander_timer.is_stopped():
			if actor.animation_player.current_animation != "zombie_02_Idle":
				actor.animation_player.play("zombie_02_Idle")
			actor.wander_timer.start()
	
	actor.move_and_slide()
