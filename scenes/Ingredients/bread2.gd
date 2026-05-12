class_name Bread2
extends FlavorManager

var on_material 
var off_material 

var is_active = true;

var original_size
var min_target_flavors = 2
var max_target_flavors = 4
var target_flavors: Array
var current_flavors: Array = [0, 0, 0, 0]


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
	randomize_target()

func randomize_target() -> void:
	$TargetFlavorProfile.clear()
	
	randomize()
	
	var total = randi_range(min_target_flavors,max_target_flavors)
	
	for i in range(total):
		var a = [0,0,0,0]
		var ind = randi_range(0,2	)
		a[ind] = 1
	
		$TargetFlavorProfile.add_flavor( a[0],a[1],a[2],a[3])

func on_entered(body: Node3D) -> void:
	if is_active:
		if body is Bread:
			#print (body.name)
			if(body):
				body.bread2 = self;
				$MeshInstance3D.visible = true
				scale = original_size*1.2
			

func on_exited(body: Node3D) -> void:
	if is_active:
		if body is Ingredient:
			#print (body.name)
			if body:
				if body.bread == self:
					body.bread = null
				self.material_off()
				
func on_entered_area(area: Area3D) -> void:
	if is_active:
		if area is Bread:
			#print (body.name)
			if(area):
				area.bread2 = self;
				$MeshInstance3D.visible = true
				scale = original_size*1.2
			

func on_exited_area(area: Area3D) -> void:
	if is_active:
		if area is Bread:
			#print (body.name)
			if area:
				if area.bread2 == self:
					area.bread2 = null
				self.material_off()
			
func material_off() -> void:
	$MeshInstance3D.visible = false
	scale = original_size
	
func add_to_sandwich(ingredient: Node3D):
	if ingredient is Bread:
		on_finished(ingredient)
		ingredient. clean_up_bread()
	
func on_finished(ingredient: Node3D):
	$SandwichEatParticles.restart()
	$SandwichEatParticles.emitting = true
	if ingredient.get_actual_flavor_profile() .compare($TargetFlavorProfile):
		get_parent().good_sandwich_event()
		print("Good Sandwich")
		if ingredient.get_actual_flavor_profile() .compare_exact($TargetFlavorProfile):
			get_parent().good_sandwich_event()
	else:
		get_parent().bad_sandwich_event()
		print("Bad Sandwich")
		
	GlobalEvents.sandwich_completed.emit(get_parent())
	clean_up_bread()
	
func clean_up_bread():
	
	$ActualFlavorProfile.clear()
	randomize_target()
	
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
