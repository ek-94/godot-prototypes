extends State

func enter():
	if actor.animation_player.current_animation != "zombie_02_Attack":
		actor.animation_player.play("zombie_02_Attack")
		
func physics_update(delta):
	if actor.animation_player.current_animation != "zombie_02_Attack":
		var bodies = actor.attack_hitbox.get_overlapping_bodies()
		if bodies.is_empty():
			state_machine.change_state("Follow")
