extends State

func enter():
	actor.running_speed = 5
	actor.animation_player.play("running_crawl")
