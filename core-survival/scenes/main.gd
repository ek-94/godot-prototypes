extends Node3D

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

func _ready():
	for i in 30:
		var enemy = enemy_scene.instantiate()
		get_tree().current_scene.add_child(enemy)

		var radius = 5.0
		var angle = randf() * TAU
		var distance = randf() * radius

		var offset = Vector3(
			cos(angle) * distance,
			0,
			sin(angle) * distance
		)

		enemy.global_position = global_position + offset
