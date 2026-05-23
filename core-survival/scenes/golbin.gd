extends CharacterBody3D
@onready var physical_bone_simulator_3d: PhysicalBoneSimulator3D = $visuals/Sketchfab_Scene/Sketchfab_model/root/GLTF_SceneRootNode/G_Armature_68/GLTF_created_0/Skeleton3D/PhysicalBoneSimulator3D

func _ready():
	pass
func _physics_process(delta: float) -> void:
	print(physical_bone_simulator_3d.is_simulating_physics())
	if not is_on_floor():
		velocity += get_gravity() * delta
		move_and_slide()
			
func _on_timer_timeout() -> void:
	physical_bone_simulator_3d.physical_bones_start_simulation()
