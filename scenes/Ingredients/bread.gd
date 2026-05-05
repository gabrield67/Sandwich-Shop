
extends Area3D


var on_material 
var off_material 

@export var ingredients = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_material = StandardMaterial3D.new()
	on_material.albedo_color = Color.RED
	
	off_material = StandardMaterial3D.new()
	off_material.albedo_color = Color.YELLOW
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_entered(body: Node3D) -> void:
	if body is Ingredient:
		#print (body.name)
		if body.isHeld:
			if(body):
				body.bread = self;
			$MeshInstance3D.set_surface_override_material(0, on_material)
			
func on_exited(body: Node3D) -> void:
	if body is Ingredient:
		#print (body.name)
		if body.isHeld:
			if body:
				body.bread = null
				self.material_off()
			
func material_off() -> void:
	$MeshInstance3D.set_surface_override_material(0, off_material)
	
func add_to_sandwich(ingredient: Node3D):
	ingredients.push_back(ingredient)
	update_positions()
	
func remove_from_sandwich(ingredient: Node3D):
	ingredients.erase(ingredient)
	update_positions()
	
func update_positions():
	var i = 0
	for a in ingredients:
		a.position = self.position + Vector3(0,1,0) + Vector3(0,.35,-.25		)*i
		i = i+1
