extends Area2D

@export var speed := 200.0
@export var damage := 10

var target: Node2D
var last_target: Node2D
var dir

func _ready():
	target = find_target()
	dir = (target.global_position - global_position).normalized()

func _physics_process(delta):
	global_position += dir * speed * delta
	
func find_target() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return null
	
	print(last_target)
	if last_target != null:
		enemies.erase(last_target)
		
	var closest = enemies[0]
	var closest_dist := global_position.distance_squared_to(closest.global_position)
	
	for enemy in enemies:
		if enemy != null:
			var d = global_position.distance_squared_to(enemy.global_position)
			if d < closest_dist:
				closest = enemy
				closest_dist = d
	
	return closest

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(20)
			last_target = body
			target = find_target()
			dir = (target.global_position - global_position).normalized()
