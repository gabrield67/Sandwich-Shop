class_name Sauce
extends Ingredient

@onready var chart_display = $"Flavor Display/Flavor Viewport/Flavor Chart"

var sauce_index = 0
var sauce_colors = []
var sauce_machine
var original_position
var spawn_timer = 2
var spawning = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_size = scale
	scale = Vector3(0,0,0)
	original_position = position
	isSauce = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawning:
		spawn_timer = spawn_timer-delta 
		if not isHeld:
			position = original_position + Vector3(0,.5*spawn_timer,0) 
		scale = original_size*(2-spawn_timer)*.5
		if spawn_timer <= 0:
			scale = original_size
			if not isHeld:
				position = original_position
			spawning = false
	
func init_sauce(index: int, colorsA: Array, machine) -> void:
	var material = StandardMaterial3D.new()
	sauce_colors = colorsA
	material.albedo_color = sauce_colors[index]
	$MeshInstance3D.set_surface_override_material(0, material)
	sauce_index = index
	sauce_machine = machine
	if sauce_index == 0:
		ingredient_flavors = [2,0,0]
	elif sauce_index == 1:
		ingredient_flavors = [0,2,0]
	elif sauce_index == 2:
		ingredient_flavors = [0,0,2]
	elif sauce_index == 3:
		ingredient_flavors = [1,1,1]
	chart_display.update_chart_data(ingredient_flavors)
	
func handle_sauce() -> void:
	$AddToSandwichSound.play()
	sauce_machine.current_timer = 0
	sauce_machine.spawned = false
	#sauce [ Color.PURPLE,  Color.GREEN, Color.ORANGE, Color.WHITE]
	#flavor  [ Color.RED,  Color.YELLOW, Color.BLUE, Color.GREEN]
	sauce_machine.play_sound()

	queue_free()
	print('sauce')
