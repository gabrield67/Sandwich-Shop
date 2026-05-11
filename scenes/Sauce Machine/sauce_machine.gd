class_name SauceMachine
extends StaticBody3D

var sauce_scene = preload("res://scenes/Ingredients/Sauce.tscn")

var colors = [ Color.RED,  Color.YELLOW, Color.BLUE, Color.WHITE]
var sauce_index = 0;
var spawned = false;
var timer = 5	
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
				s.init_sauce(sauce_index, colors, self)
				spawned = true
			current_timer = 0
	pass
	
func init_machine(index:int):
	var material = StandardMaterial3D.new()
	material.albedo_color = colors[index]
	$Back.set_surface_override_material(0, material)
	$Spawner.set_surface_override_material(0, material)
	sauce_index = index
	
func make_active():
	is_active= true
	current_timer = timer
