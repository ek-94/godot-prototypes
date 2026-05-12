extends CharacterBody3D

@onready var visuals: Node3D = $visuals
@onready var player = get_parent().get_node("Player")
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer

var speed = 1.0

func _ready():
	animation_player.play("walking")
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var dir = player.global_position - global_position
	dir.y = 0
	dir = dir.normalized()
	
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	
	var target = player.global_position
	target.y = global_position.y
	
	look_at(target)

	
	move_and_slide()
