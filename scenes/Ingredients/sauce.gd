class_name Sauce
extends Ingredient


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_size = scale
	isSauce = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func handle_sauce(flavor_profile) -> void:
	flavor_profile.add_flavor(5,0,0,0)
	queue_free()
	print('sauce')
