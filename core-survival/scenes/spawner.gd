extends Node3D

func spawn_enemies(scene, amount, noise, terrain_height):
	for i in range(amount):
		var enemy = scene.instantiate()
		get_tree().current_scene.add_child(enemy)

		var radius = 100
		var angle = randf() * TAU
		var distance = randf() * radius

		var x = cos(angle) * distance
		var z = sin(angle) * distance

		# World position
		var world_x = global_position.x + x
		var world_z = global_position.z + z

		# Sample terrain at world coords
		var y = noise.get_noise_2d(world_x, world_z) * terrain_height
		
		print(Vector3(world_x, y + 2, world_z))
		enemy.global_position = Vector3(world_x, y + 2, world_z)
		await get_tree().process_frame

		#print(enemy.global_position)
