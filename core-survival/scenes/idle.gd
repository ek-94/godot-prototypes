extends State

func enter():
	actor.animation_player.play("zombie_idle")
	
func physics_update(delta):
	print("in here")
	var distance = actor.global_position.distance_to(actor.player.global_position)
	
	if distance <= 5:
		state_machine.change_state("Chase")
