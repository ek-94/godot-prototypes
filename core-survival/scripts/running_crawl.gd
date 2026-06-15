extends State

func enter():
	actor.run_speed = 5
	actor.animation_player.play("running_crawl")
