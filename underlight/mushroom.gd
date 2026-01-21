extends CharacterBody2D

@onready var dmg_num_origin = $dmg_num_origin
var health = 100

func _ready():
	take_damage(10)
	
func take_damage(damage):
	health -= damage
	DamageNumbers.display_number(damage, dmg_num_origin.global_position)
