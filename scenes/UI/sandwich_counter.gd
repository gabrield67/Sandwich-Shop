extends Node3D

var ui_array =[]
var totalLength = 15.0
var number_of_sandwiches = 4
var current_sandwich= 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initCounterUI(4)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initCounterUI(number_of_sandwiches: float) -> void:
	self.number_of_sandwiches = number_of_sandwiches
	for i in ui_array:
		i.queue_free()
	ui_array.clear()
	for i in range(0, number_of_sandwiches):
		addBox(number_of_sandwiches, i, false)
	
func addBox(number_of_sandwiches: float, place: int, filled:bool) ->void:
	var static_body = StaticBody3D.new()
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = BoxMesh.new()
	static_body.add_child(mesh_instance)
	
	var on_material = StandardMaterial3D.new()
	if filled:
		on_material.albedo_color = Color.RED
	else:
		on_material.albedo_color = Color.ALICE_BLUE
	mesh_instance.set_surface_override_material(0, on_material)
	if filled:
		ui_array[place] = static_body
	else: 
		ui_array.push_back(static_body)
	self.add_child(static_body)
	static_body.position = position -Vector3(totalLength*1.0/2,0,0) + Vector3((place+.5)*totalLength*1.0/number_of_sandwiches,0,0)
	static_body.scale = Vector3(totalLength*.9/number_of_sandwiches,.5,.5)	
	pass

func addSandwich():
	ui_array[current_sandwich].queue_free()
	addBox(number_of_sandwiches,current_sandwich,true)
	
	current_sandwich = current_sandwich+1
	if current_sandwich == number_of_sandwiches:
		current_sandwich = 0
		number_of_sandwiches = number_of_sandwiches+1
		initCounterUI(number_of_sandwiches)
		get_parent().startUpgradeTime()
		
