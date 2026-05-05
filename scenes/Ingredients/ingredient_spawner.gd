extends Node3D
var ingredient_scene = preload("res://scenes/Ingredients/Ingredient.tscn")
var spawn_wait_time = 1.8
var timer = 0
var moving_ingredients = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer = timer + delta
	if timer >= spawn_wait_time:
		#print("here")
		timer = 0
		var ingredient = ingredient_scene.instantiate()
		print(position)
		
		get_parent().add_child(ingredient)
		ingredient.position = position
		ingredient.move_on_start = moving_ingredients
		ingredient.despawn = true
		randomize() 
		var my_random_int = randi_range(1, 4)
		ingredient.add_flavor(my_random_int)
	pass
