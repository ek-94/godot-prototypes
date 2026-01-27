extends CharacterBody2D

@onready var sprite = $sprite 
@onready var orb_scn = preload("res://scenes/orb.tscn")
const speed = 300.0


func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	velocity = direction.normalized() * speed
	
	if Input.is_action_just_pressed("attack"):
		var orb_scene = orb_scn
		var orb_instance = orb_scene.instantiate()
		orb_instance.position = position
		get_tree().current_scene.add_child(orb_instance)
		
	move_and_slide()

	# flip sprite when moving horizontally
	if direction.x != 0:
		sprite.flip_h = direction.x > 0
