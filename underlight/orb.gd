extends Area2D

@export var speed := 200.0
@export var min_damage := 1	
@export var max_damage := 2

var target: Node2D
var last_target: Node2D
var dir = Vector2(1,1)

func _ready():
	target = find_target()
	if target != null:
		dir = (target.global_position - global_position).normalized()

func _physics_process(delta):
	global_position += dir * speed * delta
	
func find_target() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	if enemies.is_empty():
		return null
	
	if last_target != null:
		enemies.erase(last_target)
		if enemies.is_empty():
			return null
		

	#var closest = enemies[0]
	#var closest_dist := global_position.distance_squared_to(closest.global_position)
	#
	#for enemy in enemies:
		#if enemy != null:
			#var d = global_position.distance_squared_to(enemy.global_position)
			#if d < closest_dist:
				#closest = enemy
				#closest_dist = d
	
	return enemies.pick_random()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			var damage = randi_range(min_damage, max_damage)
			body.take_damage(damage)
			last_target = body
			target = find_target()
			if target == null:
				dir *= -1
			else:
				dir = (target.global_position - global_position).normalized()
