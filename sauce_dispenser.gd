extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_color(color)->void:
	var material = StandardMaterial3D.new()
	
	material.albedo_color = color
	$Torus.set_surface_override_material(0, material)
	
