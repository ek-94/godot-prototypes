extends State

func enter():
	actor.is_dead = true
	actor.turn_on_ragdoll()
