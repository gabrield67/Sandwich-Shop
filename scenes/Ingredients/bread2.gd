extends FlavorManager

var on_material 
var off_material 

var is_active = true;

var original_size

# capture ingredient flavors
var ingredient_flavors: Array

signal ingredient_hovered(ingredient_flavors)
signal ingredient_exited(ingredient_flavors)


@export var ingredients = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MeshInstance3D.visible = false
	original_size = scale


func on_entered(body: Node3D) -> void:
	if is_active:
		if body is Ingredient:
			#print (body.name)
			if(body):
				body.bread = self;
				$MeshInstance3D.visible = true
				scale = original_size*1.2
				ingredient_flavors = body.flavors
				ingredient_hovered.emit(ingredient_flavors)
			

func on_exited(body: Node3D) -> void:
	if is_active:
		if body is Ingredient:
			#print (body.name)
			if body:
				if body.bread == self:
					body.bread = null
				self.material_off()
				ingredient_exited.emit(ingredient_flavors)
			
func material_off() -> void:
	$MeshInstance3D.visible = false
	scale = original_size
	
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
		pass 
	else:
		ingredients.push_back(ingredient)
		var new_flavors = ingredient.get_flavor_amounts()
		print(new_flavors)
		ingredient.play_add_to_sandwich()
		#current_flavors = add_new_flavors(new_flavors, current_flavors)
		#if current_flavors == target_flavors:
			#off_material.albedo_color = Color.LIGHT_GREEN
			#on_material.albedo_color = Color.GREEN
		update_positions()
		if ingredient.type_index == 3:
			on_finished()
	
func on_finished():
	$SandwichEatParticles.restart()
	$SandwichEatParticles.emitting = true
	if $ActualFlavorProfile.compare($TargetFlavorProfile):
		# get_parent().good_sandwich_event()
		print("Good Sandwich")
	else:
		# get_parent().bad_sandwich_event()
		print("Bad Sandwich")
		
	GlobalEvents.sandwich_completed.emit(get_parent())
	clean_up_bread()
	
func clean_up_bread():
	for i in ingredients:
		i.queue_free()
	ingredients.clear()
	$ActualFlavorProfile.clear()
	# randomize_target()
	
# TODO remove this from game manager as well
func remove_from_sandwich(ingredient: Node3D):
	var a = ingredient.get_flavor_amounts()
	# remove flavor
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
