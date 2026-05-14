class_name SauceMachine
extends StaticBody3D

var sauce_scene = preload("res://scenes/Ingredients/Sauce.tscn")

var colors =[Color(239.0/256,68.0/256,68.0/256,1),Color(6.0/268,182.0/256, 212.0/256,1),Color(132.0/256,204.0/256,22.0/256,1), Color.WHITE]

var sauce_index = 0;
var spawned = false;
var timer = 1	
var current_timer = 0
var is_active = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		current_timer = current_timer + delta 
		if current_timer >= timer:
			if not spawned:
				print("spawn sauce")
				var s = sauce_scene.instantiate()
				
				get_parent().get_parent().add_child(s)
				s.position = $"Spawn Point".global_position
				s.original_position = s.position
				s.init_sauce(sauce_index, colors, self)
				spawned = true
			current_timer = 0
	pass
	
func init_machine(index:int):
	$sauceDispenser.update_color( colors[index])
	#$sauceDispenser.set_surface_override_material(0, material)
	sauce_index = index
	
func make_active():
	is_active= true
	current_timer = timer
	
func play_sound():
	$SauceSound.play()
