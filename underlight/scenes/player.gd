extends CharacterBody2D

@onready var sprite = $sprite
const speed = 300.0


func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	velocity = direction.normalized() * speed
	move_and_slide()

	# flip sprite when moving horizontally
	if direction.x != 0:
		sprite.flip_h = direction.x > 0
