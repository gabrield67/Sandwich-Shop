extends Node

#ingredient spawner
@export var conveyor_move_speed = .9
@export var ingredient_spawn_wait_time = 2.5

##Chance when bread randomly selected it will stay bread 
@export var bread_ingredient_frequency = .75

#upgrade manager
@export var min_target_flavors = 2
@export var max_target_flavors = 4

#HUD
@export var debug_upgrades = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
