extends Node3D

var flavor1 = []
var flavor2 = []
var flavor3 = []
var flavor4 = []

var points = []

var isVisible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	points.push_back($Flavor1)
	points.push_back($Flavor2)
	points.push_back($Flavor3)
	points.push_back($Flavor4)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func multiply_flavor(f1:int, f2:int, f3:int, f4:int) -> void:
	multiply_flavor_helper(f1, flavor1,1)
	multiply_flavor_helper(f2, flavor2,2)
	multiply_flavor_helper(f3, flavor3,3)
	multiply_flavor_helper(f4, flavor4,4)
	
func multiply_flavor_helper(num:int, f_arr:Array, f:int ):
	if num > 1:
		add_flavor_helper(f_arr.size()*(num-1), f_arr,f)
	elif num == 1:
		pass
	else:
		remove_flavor_block(f_arr, f-1)

func add_flavor(f1:int, f2:int, f3:int, f4:int) -> void:
	add_flavor_helper(f1, flavor1,1)
	add_flavor_helper(f2, flavor2,2)
	add_flavor_helper(f3, flavor3,3)
	add_flavor_helper(f4, flavor4,4)
	
	
func remove_flavor(f1:int, f2:int, f3:int, f4:int) -> void:
	remove_flavor_helper(f1, flavor1,1)
	remove_flavor_helper(f2, flavor2,2)
	remove_flavor_helper(f3, flavor3,3)
	remove_flavor_helper(f4, flavor4,4)
	
func add_flavor_helper(num:int, f_arr:Array, f:int ):
	if num > 0:
		for i in range(num):
			add_flavor_block(f_arr, f-1)

func remove_flavor_helper(num:int, f_arr:Array, f:int ):
	if num > 0:
		for i in range(num):
			remove_flavor_block(f_arr, f-1)


func add_flavor_block(f_arr:Array,f):
	var static_body = StaticBody3D.new()
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = BoxMesh.new()
	static_body.add_child(mesh_instance)
	
	var on_material = StandardMaterial3D.new()
	mesh_instance.set_surface_override_material(0, on_material)
	f_arr.push_back(static_body)
	if isVisible:
		self.add_child(static_body)
	static_body.position = points[f].position + Vector3(0,f_arr.size()*.6,0)
	static_body.scale = Vector3(.5,.5,.5)	
	pass
	
func remove_flavor_block(f_arr:Array,f):
	if f_arr.size() >= 1:
		var a = f_arr.pop_back()
		a.queue_free()
	
func get_flavor_amounts() -> Array:
	return [flavor1.size(),flavor2.size(),flavor3.size(),flavor4.size()]
	
func compare(other:Node3D) -> bool:
	if other.flavor1.size() <= flavor1.size() and other.flavor2.size() <= flavor2.size()  and other.flavor3.size() <= flavor3.size()  and other.flavor4.size() <= flavor4.size():
		return true
	else:
		return false
func compare_exact(other:Node3D) -> bool:
	if other.flavor1.size() == flavor1.size() and other.flavor2.size() == flavor2.size()  and other.flavor3.size() == flavor3.size()  and other.flavor4.size() == flavor4.size():
		return true
	else:
		return false
		
func clear() -> void:
	for i in flavor1:
		i.queue_free()
	flavor1.clear()
	for i in flavor2:
		i.queue_free()
	flavor2.clear()
	for i in flavor3:
		i.queue_free()
	flavor3.clear()
	for i in flavor4:
		i.queue_free()
	flavor4.clear()
	
	
