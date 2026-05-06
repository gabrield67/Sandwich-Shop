
extends Area3D


var on_material 
var off_material 

var original_size


@export var ingredients = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_size = scale
	on_material = StandardMaterial3D.new()
	on_material.albedo_color = Color.RED
	
	off_material = StandardMaterial3D.new()
	off_material.albedo_color = Color.YELLOW
	randomize()
	$TargetFlavorProfile.add_flavor( randi_range(0, 4) 
	, randi_range(0, 4)
	, randi_range(0, 4)
	, randi_range(0, 4)
	)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_entered(body: Node3D) -> void:
	if body is Ingredient:
		#print (body.name)
		if(body):
			body.bread = self;
			#$MeshInstance3D.set_surface_override_material(0, on_material)
			scale = original_size*1.2
func on_exited(body: Node3D) -> void:
	if body is Ingredient:
		#print (body.name)
		if body:
			if body.bread == self:
				body.bread = null
			self.material_off()
			
func material_off() -> void:
	#$MeshInstance3D.set_surface_override_material(0, off_material)
	scale = original_size
	
func add_to_sandwich(ingredient: Node3D):
	ingredients.push_back(ingredient)
	var a = ingredient.get_flavor_amounts()
	ingredient.play_add_to_sandwich()
	$ActualFlavorProfile.add_flavor(a[0],a[1], a[2], a[3])
	if $ActualFlavorProfile.compare($TargetFlavorProfile):
		off_material.albedo_color = Color.DARK_GREEN
		on_material.albedo_color = Color.GREEN
	update_positions()
	
func remove_from_sandwich(ingredient: Node3D):
	var a = ingredient.get_flavor_amounts()
	$ActualFlavorProfile.remove_flavor(a[0],a[1], a[2], a[3])
	ingredients.erase(ingredient)
	update_positions()
	
func update_positions():
	var i = 0
	for a in ingredients:
		a.position = self.position + Vector3(0,1,0) + Vector3(0,.35,-.25		)*i
		i = i+1
