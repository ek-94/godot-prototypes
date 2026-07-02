extends RigidBody3D

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(100)
	queue_free()
