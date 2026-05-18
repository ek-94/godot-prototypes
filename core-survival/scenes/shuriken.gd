extends RigidBody3D

@onready var mesh = $"Shuriken6_Ninja thingz_0"
var stuck

func _process(delta):
	if not stuck:
		mesh.rotate_x(-5 * delta)


func _on_body_entered(body: Node) -> void:
	print("ok")
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	stuck = true
	freeze = true
	$CollisionShape3D.disabled = true
