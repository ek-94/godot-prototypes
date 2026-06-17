extends State

func enter():
	actor.velocity = Vector3.ZERO
	actor.target = null
	
	if actor.animation_player.current_animation != "zombie_02_Idle":
				actor.animation_player.play("zombie_02_Idle")
	
	actor.move_and_slide()
