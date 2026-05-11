extends Node3D
var ingredient_scene = preload("res://scenes/Ingredients/Ingredient.tscn")
var spawn_wait_time = 1.8
var timer = 0
var moving_ingredients = true
var despawn_count: int = 0
var upgradeTime = false
var conveyor_move_speed = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer = timer + delta
	if timer >= spawn_wait_time:
		#print("here")
		timer = 0
		if upgradeTime:
			pass
		else:
			var ingredient = ingredient_scene.instantiate()
			ingredient.move_speed = conveyor_move_speed
			ingredient.time_to_despawn = 16.0/conveyor_move_speed
			#print(position)
			ingredient.spawner = self
			get_parent().add_child(ingredient)
			ingredient.position = position
			ingredient.move_on_start = moving_ingredients
			ingredient.despawn = true
			#randomize() 
			#var my_random_int = randi_range(1, 4)
			#ingredient.add_flavor(my_random_int)
	pass
