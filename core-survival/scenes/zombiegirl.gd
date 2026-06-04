extends CharacterBody3D

@onready var camera = get_parent().find_child("Camera3D")
@onready var blood_particles_scene = preload("res://scenes/blood_particles.tscn")
@onready var player = get_parent().find_child("Player")
@onready var col: CollisionShape3D = $CollisionShape3D
@onready var capsule = $CollisionShape3D.shape as CapsuleShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var damage_collision_box: CollisionShape3D = $damage_hitbox/damage_collision_box

@export var run_speed = 4
var health = 100
var is_attacking = false
var is_dead = false
var shape

func _ready():
	shape = damage_collision_box.shape as BoxShape3D
	animation_player.play("zombie_run")
	navigation_agent_3d.target_desired_distance = 0.05

func take_damage(dmg, pos):
	print("YEEEE")
	var blood_particles = blood_particles_scene.instantiate()
	blood_particles.global_position = pos
	get_tree().current_scene.add_child(blood_particles)
	if health > 0:
		health -= dmg
		if health < 50:
			shape.size = Vector3(0.627,0.4,0.627)
			run_speed = 4
	
func _physics_process(delta: float) -> void:
		if not is_on_floor():
			velocity += get_gravity() * delta
			move_and_slide()
			
		if !is_attacking and is_on_floor():
			var target = player.global_position
			
			navigation_agent_3d.set_target_position(target)

			if navigation_agent_3d.is_navigation_finished():
				velocity = Vector3.ZERO
				
				if animation_player.current_animation != "zombie_run":
					animation_player.play("zombie_run")
				
				move_and_slide()
				return

			var destination = navigation_agent_3d.get_next_path_position()
			var local_destination = destination - global_position
			local_destination.y = 0

			var direction = local_destination.normalized()
			velocity = direction * run_speed
			
			
			if direction.length() > 0:
				look_at(global_position + direction, Vector3.UP)
				rotate_y(PI)
				
			if health < 50:
				if animation_player.current_animation != "running_crawl":
					animation_player.play("running_crawl")
				
			elif animation_player.current_animation != "zombie_run":
				animation_player.play("zombie_run")

			move_and_slide()

func _on_navigation_agent_3d_navigation_finished() -> void:
	velocity = Vector3.ZERO # Replace with function body.

func _on_timer_timeout() -> void:
	pass
	#turn_on_ragdoll() # Replace with function body.
