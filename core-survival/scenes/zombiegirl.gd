extends CharacterBody3D

@onready var camera = get_parent().find_child("Camera3D")
@onready var blood_particles_scene = preload("res://scenes/blood_particles.tscn")
@onready var player = get_parent().find_child("Player")
@onready var col: CollisionShape3D = $CollisionShape3D
@onready var capsule = $CollisionShape3D.shape as CapsuleShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $StateMachine
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var damage_collision_box: CollisionShape3D = $damage_hitbox/damage_collision_box
@onready var attack_hitbox: Area3D = $attack_hitbox

@export var run_speed = 4
var health = 100
var attack_dmg = 25
var is_attacking = false
var is_dead = false
var shape

func _ready():
	shape = damage_collision_box.shape as BoxShape3D
	navigation_agent_3d.target_desired_distance = 0.05
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func deal_damage():
	var bodies = attack_hitbox.get_overlapping_bodies()
	if player in bodies:
		player.take_damage(attack_dmg)		
	
func take_damage(dmg, pos):
	print("YEEEE")
	var blood_particles = blood_particles_scene.instantiate()
	blood_particles.global_position = pos
	get_tree().current_scene.add_child(blood_particles)
	if health > 0:
		health -= dmg
		if health < 25:
			state_machine.change_state("Crawl")
			
func _on_navigation_agent_3d_navigation_finished() -> void:
	velocity = Vector3.ZERO # Replace with function body.

func _on_timer_timeout() -> void:
	pass
	#turn_on_ragdoll() # Replace with function body.
