extends State

func enter():
	actor.velocity = Vector3.ZERO
	actor.target = null
	
	if actor.animation_player.current_animation != "erika_idle":
				actor.animation_player.play("erika_idle")
	
	actor.move_and_slide()
