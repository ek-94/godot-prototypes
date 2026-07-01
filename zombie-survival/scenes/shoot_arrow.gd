extends State

func enter():
	print(actor.target.global_position)
	actor.look_at(actor.target.global_position, Vector3.UP)
	actor.rotate_y(PI)
	
	actor.animation_player.play("shoot_arrow")
