extends Node3D

@onready var terrain_mesh: MeshInstance3D = $navmesh/TerrainMesh
@onready var spawner: Node3D = $spawner
@onready var navmesh: NavigationRegion3D = $navmesh
@onready var zombie_scene = preload("res://scenes/zombie_enemy.tscn")

var terrain_size = 500
var terrain_resolution = 100
var terrain_height = 100

var noise_frequency = 0.003
var noise_octaves = 4
var noise_gain = 0.5
var noise_lacunarity = 2.0
var noise = FastNoiseLite.new()


func _ready():
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_frequency
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = noise_octaves
	noise.fractal_gain = noise_gain
	noise.fractal_lacunarity = noise_lacunarity
	
	terrain_mesh.generate_terrain(noise, terrain_size, terrain_height, terrain_resolution)
	await get_tree().process_frame
	
	navmesh.bake_navigation_mesh()
	spawner.spawn_enemies(zombie_scene, 20, noise, terrain_height)
	
	
