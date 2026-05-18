extends MeshInstance3D

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
# --- Terrain settings ---
var terrain_size = 2000
var terrain_resolution = 500
var terrain_height = 100

# --- Noise settings ---
var noise_frequency = 0.003
var noise_octaves = 4
var noise_gain = 0.5
var noise_lacunarity = 2.0
var noise = FastNoiseLite.new()

func get_terrain_height(x, z):
	return noise.get_noise_2d(x, z) * terrain_height
	
func spawn_enemies(amount):
	for i in range(amount):
		var enemy = enemy_scene.instantiate()
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
		
func _ready():
	# Create noise
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_frequency
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = noise_octaves
	noise.fractal_gain = noise_gain
	noise.fractal_lacunarity = noise_lacunarity

	# Build mesh
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var step = float(terrain_size) / terrain_resolution

	for x in range(terrain_resolution):
		for z in range(terrain_resolution):
			# Square corners
			var x0 = x * step - terrain_size / 2.0
			var x1 = (x + 1) * step - terrain_size / 2.0
			var z0 = z * step - terrain_size / 2.0
			var z1 = (z + 1) * step - terrain_size / 2.0

			# Heights
			var y00 = noise.get_noise_2d(x0, z0) * terrain_height
			var y10 = noise.get_noise_2d(x1, z0) * terrain_height
			var y01 = noise.get_noise_2d(x0, z1) * terrain_height
			var y11 = noise.get_noise_2d(x1, z1) * terrain_height

			# Triangle 1
			st.add_vertex(Vector3(x0, y00, z0))
			st.add_vertex(Vector3(x1, y10, z0))
			st.add_vertex(Vector3(x0, y01, z1))

			# Triangle 2
			st.add_vertex(Vector3(x1, y10, z0))
			st.add_vertex(Vector3(x1, y11, z1))
			st.add_vertex(Vector3(x0, y01, z1))

	st.generate_normals()

	# Create mesh
	mesh = st.commit()

	# Material
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.0, 0.536, 0.0, 1.0)
	mesh.surface_set_material(0, mat)

	# Collision
	create_trimesh_collision()
	
	spawn_enemies(150)

	print("Terrain made!")
