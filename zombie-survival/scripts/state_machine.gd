extends Node

var current_state: State

@onready var actor = get_parent()

func _ready():
	await get_tree().process_frame
	
	for child in get_children():
		child.actor = actor
	
	for child in get_children():
		print(child.name)
	
	current_state = $ShootArrow
	current_state.enter()

func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	
	current_state = get_node(new_state_name)
	current_state.enter()

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)
