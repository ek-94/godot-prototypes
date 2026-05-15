extends Node3D
@onready var fire: GPUParticles3D = $fire
@onready var smoke: GPUParticles3D = $smoke

func _ready():
	fire.restart()
	smoke.restart()
