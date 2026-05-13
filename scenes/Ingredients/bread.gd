class_name Bread
extends Area3D
@onready var display_label =$"Flavor Display/Flavor Viewport/Label"

var bread_scene = preload("res://scenes/Ingredients/Bread.tscn")

var on_material 
var off_material

var min_target_flavors = 2
var max_target_flavors = 4
var is_active = true;

var original_size
var original_size_plate
var final_bread = false
var original_position
var onBread = false
var bread2

var finished: bool = false

@export var ingredients = []
var flavor_tracker: Array[int] = [0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position
	$MeshInstance3D.visible = false
	original_size = $bread.scale
	original_size_plate =  $Plate.scale
	on_material = StandardMaterial3D.new()
	on_material.albedo_color = Color.PINK
	
	off_material = StandardMaterial3D.new()
	off_material.albedo_color = Color.WHITE
	
	display_label.text = str(flavor_tracker)
	
func on_entered(body: Node3D) -> void:
	if is_active:
		if body is Ingredient:
			
			if(body):
				#print ('Entered Bread')
				body.bread = self;
				$MeshInstance3D.visible = true
				$Plate.set_surface_override_material(0, on_material)
				$bread.scale = original_size*1.2
				$Plate.scale = original_size_plate*1.2
				flavor_tracker = add_new_flavors(flavor_tracker, body.ingredient_flavors)
				update_display(flavor_tracker)

func on_exited(body: Node3D) -> void:
	print("exited")
	if is_active:
		if body is Ingredient:
			#print ('Exit Bread')
			if body:
				if body.bread == self:
					body.bread = null
				self.material_off()
				if finished == false:
					flavor_tracker = remove_new_flavors(flavor_tracker, body.ingredient_flavors)
					update_display(flavor_tracker)
				
func material_off() -> void:
	$Plate.set_surface_override_material(0, off_material)
	$MeshInstance3D.visible = false
	$bread.scale = original_size*1
	$Plate.scale = original_size_plate*1
	
func add_to_sandwich(ingredient: Node3D):
	if ingredient.isSauce:
		
		var material = StandardMaterial3D.new()
		material.albedo_color = ingredient.sauce_colors[ingredient.sauce_index]
		var particle_material = $"Sauce Particles".process_material as ParticleProcessMaterial

		if particle_material:
			particle_material.color = ingredient.sauce_colors[ingredient.sauce_index]
		ingredient.handle_sauce($ActualFlavorProfile)
		
		$"Sauce Particles".restart()
		$"Sauce Particles".emitting = true 
	else:
		ingredients.push_back(ingredient)
		ingredient.onBread = true
		ingredient.play_add_to_sandwich()
		update_positions()
		print('on bread')
		if ingredient.type_index == 3:
			on_finished()
	
func on_finished():
	$SandwichEatParticles.restart()
	$SandwichEatParticles.emitting = true
	
	#var newBread = bread_scene.instantiate()
	#newBread.position = position
	#get_parent().add_child(newBread)
	clean_up_bread()
	
func clean_up_bread():
	finished = true
	for i in ingredients:
		i.queue_free()
	ingredients.clear()
	on_material.albedo_color = Color.PINK
	off_material.albedo_color = Color.WHITE
	flavor_tracker = [0, 0, 0, 0]
	update_display(flavor_tracker)
	return_to_position()
	
func get_actual_flavor_profile() -> Array[int]:
	return flavor_tracker

func remove_from_sandwich(ingredient: Node3D):
	var a = ingredient.get_flavor_amounts()
	$ActualFlavorProfile.remove_flavor(a[0],a[1], a[2], a[3])
	ingredients.erase(ingredient)
	update_positions()
	
func update_positions():
	var i = 0.0
	for a in ingredients:
		a.position = self.position + Vector3(1,1.75,-3) + Vector3(0,.35,-.5		)*i
		i = i+1.0

func make_active() -> void:
	is_active  = true
	$bread.visible = true
	
func make_inactive() -> void:
	is_active = false
	$bread.visible = false
	
func return_to_position()  -> void:
	position = original_position
	update_positions()
	
func on_grab() -> void:
	pass

func update_position(position) -> void:
	self.position = position
	update_positions()
	finished = false
	
func add_new_flavors( currentFlavors: Array[int], newFlavors: Array[int]) -> Array[int]:
	var sum: Array[int] = []
	for i in newFlavors.size():
		sum.append(currentFlavors[i] + newFlavors[i])
	return sum
	
func remove_new_flavors(currentFlavors: Array[int], newFlavors: Array[int]) -> Array[int]:
	var sum: Array[int] = []
	for i in newFlavors.size():
		sum.append(currentFlavors[i] - newFlavors[i])
	return sum

func update_display(newFlavors: Array[int]) -> void:
	display_label.text = str(newFlavors)
