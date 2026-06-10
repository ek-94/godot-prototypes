extends RigidBody3D

@onready var mesh = $"Shuriken6_Ninja thingz_0"
var stuck

func _process(delta):
	if not stuck:
		mesh.rotate_x(-5 * delta)


func _on_body_entered(body: Node) -> void:
	pass


func _on_damage_hitbox_area_entered(area: Area3D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("enemies"):
		parent.take_damage(15, global_position)
		queue_free() # Replace with function body.
