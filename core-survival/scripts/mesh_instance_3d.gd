extends MeshInstance3D
@onready var map: NavigationRegion3D = get_parent()

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var zombie_scene: PackedScene = preload("res://scenes/zombie_enemy.tscn")
# --- Terrain settings ---

# --- Noise settings ---
var noise_frequency = 0.003
var noise_octaves = 4
var noise_gain = 0.5
var noise_lacunarity = 2.0
var noise = FastNoiseLite.new()

func get_terrain_height(x, z, terrain_height):
	return noise.get_noise_2d(x, z) * terrain_height
	
func _ready():
	pass
	
func generate_terrain(noise, terrain_size, terrain_height, terrain_resolution):
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
	
	create_trimesh_collision()
	print("Terrain made!")
	

		
