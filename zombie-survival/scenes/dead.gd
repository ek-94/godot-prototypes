extends State

func enter():
	actor.velocity = Vector3.ZERO
	actor.is_dead = true
	actor.turn_on_ragdoll()
