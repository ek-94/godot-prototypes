extends State

func enter():
	actor.velocity = Vector3.ZERO
	actor.animation_player.play("zombie_attack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var bodies = actor.attack_hitbox.get_overlapping_bodies()
	
	if bodies.is_empty():
		state_machine.change_state("Chase")
	else:
		for body in bodies:
			if body == actor.player:
				if body.health > 10:
					actor.animation_player.play("zombie_attack")
				else:
					actor.global_position = body.global_position
					state_machine.change_state("GroundBite")
