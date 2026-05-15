extends RigidBody3D

var explosion_scene: PackedScene = preload("res://scenes/explosion.tscn")
@export var explosion_force = 7
@export var rotation_force = 10

func _physics_process(delta: float) -> void:
	if get_contact_count() > 0:
		if linear_velocity.length() >= 1:
			linear_velocity -= linear_velocity.normalized() * 0.2
		
func _on_timer_timeout() -> void:
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	visible = false
	linear_velocity = Vector3.ZERO
	$CollisionShape3D.disabled = true
	var bodies = $Area3D.get_overlapping_bodies()

	for body in bodies:
		if body.is_in_group("enemies"):
			body.apply_force(global_position, "head", explosion_force, explosion_force, rotation_force)
	
