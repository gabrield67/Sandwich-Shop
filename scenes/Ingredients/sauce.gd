class_name Sauce
extends Ingredient

var sauce_index = 0
var sauce_colors = []
var sauce_machine
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_size = scale
	isSauce = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func init_sauce(index: int, colorsA: Array, machine) -> void:
	var material = StandardMaterial3D.new()
	sauce_colors = colorsA
	material.albedo_color = sauce_colors[index]
	$MeshInstance3D.set_surface_override_material(0, material)
	sauce_index = index
	sauce_machine = machine
	
	
func handle_sauce(flavor_profile) -> void:
	sauce_machine.current_timer = 0
	sauce_machine.spawned = false
	#sauce [ Color.PURPLE,  Color.GREEN, Color.ORANGE, Color.WHITE]
	#flavor  [ Color.RED,  Color.YELLOW, Color.BLUE, Color.GREEN]

	if sauce_index == 0:
		flavor_profile.add_flavor(2,0,0,0)
	elif sauce_index == 1:
		flavor_profile.add_flavor(0,2,0,0)
	elif sauce_index == 2:
		flavor_profile.add_flavor(0,0,2,0)
	elif sauce_index == 3:
		flavor_profile.multiply_flavor(2,2,2,2)
	queue_free()
	print('sauce')
