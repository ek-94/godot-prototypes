extends CharacterBody2D

@onready var dmg_num_origin = $dmg_num_origin
@onready var sprite = $AnimatedSprite2D
var health = 100
var is_dead = false

func _ready():
	pass
	
func take_damage(damage):
	if health > 0:
		sprite.play("hit")
		health -= damage
		DamageNumbers.display_number(damage, dmg_num_origin.global_position)
	
	if health <= 0:
		remove_from_group("enemies")
		sprite.play("die")

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "hit":
		sprite.play("idle") # Replace with function body.
	if sprite.animation == "die":
		queue_free() # Replace with function body.
