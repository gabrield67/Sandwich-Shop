extends StaticBody3D

var sauce_scene = preload("res://scenes/Ingredients/Sauce.tscn")


var spawned = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not spawned:
		print("spawn sauce")
		var s = sauce_scene.instantiate()
		get_parent().add_child(s)
		s.position = $"Spawn Point".global_position
		spawned = true
	pass
