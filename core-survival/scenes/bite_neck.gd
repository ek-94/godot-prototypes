extends State

func enter():
	actor.velocity = Vector3.ZERO
	actor.animation_player.play("zombie_bite")
