class_name Bread
extends Area3D

var bread_scene = preload("res://scenes/Ingredients/Bread.tscn")

var on_material 
var off_material 

var is_active = true;

var original_size


@export var ingredients = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MeshInstance3D.visible = false
	original_size = scale
	on_material = StandardMaterial3D.new()
	on_material.albedo_color = Color.PINK
	
	off_material = StandardMaterial3D.new()
	off_material.albedo_color = Color.WHITE
	randomize()
	
	var total = randi_range(3,5)
	
	for i in range(total):
		var a = [0,0,0,0]
		var ind = randi_range(0,3)
		a[ind] = 1
	
		$TargetFlavorProfile.add_flavor( a[0]
		,a[1]
		,a[2]
		,a[3]
		)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_entered(body: Node3D) -> void:
	if is_active:
		if body is Ingredient:
			#print (body.name)
			if(body):
				body.bread = self;
				$MeshInstance3D.visible = true
				$Plate.set_surface_override_material(0, on_material)
				scale = original_size*1.2
			

func on_exited(body: Node3D) -> void:
	if is_active:
		if body is Ingredient:
			#print (body.name)
			if body:
				if body.bread == self:
					body.bread = null
				self.material_off()
			
func material_off() -> void:
	$Plate.set_surface_override_material(0, off_material)
	$MeshInstance3D.visible = false
	scale = original_size
	
func add_to_sandwich(ingredient: Node3D):
	ingredients.push_back(ingredient)
	var a = ingredient.get_flavor_amounts()
	ingredient.play_add_to_sandwich()
	$ActualFlavorProfile.add_flavor(a[0],a[1], a[2], a[3])
	if $ActualFlavorProfile.compare($TargetFlavorProfile):
		off_material.albedo_color = Color.LIGHT_GREEN
		on_material.albedo_color = Color.GREEN
	update_positions()
	if ingredient.type_index == 3:
		on_finished()
	
func on_finished():
	if $ActualFlavorProfile.compare($TargetFlavorProfile):
		get_parent().good_sandwich_event()
	else:
		get_parent().bad_sandwich_event()
	
	var newBread = bread_scene.instantiate()
	newBread.position = position
	get_parent().add_child(newBread)
	clean_up_bread()
	
func clean_up_bread():
	for i in ingredients:
		i.queue_free()
	queue_free()
	
func remove_from_sandwich(ingredient: Node3D):
	var a = ingredient.get_flavor_amounts()
	$ActualFlavorProfile.remove_flavor(a[0],a[1], a[2], a[3])
	ingredients.erase(ingredient)
	update_positions()
	
func update_positions():
	var i = 0
	for a in ingredients:
		a.position = self.position + Vector3(0,2.25,-2.5) + Vector3(0,.35,-.25		)*i
		i = i+1


func make_active() -> void:
	is_active  = true
	$TargetFlavorProfile.visible = true
	$bread.visible = true
	pass 
	
func make_inactive() -> void:
	is_active = false
	$bread.visible = false
	$TargetFlavorProfile.visible = false
	pass
