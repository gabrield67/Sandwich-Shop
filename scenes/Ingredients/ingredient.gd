class_name Ingredient
extends StaticBody3D



var isHeld = false
var isHovered = false
var original_size;
var bread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_size = scale
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_grab():
	pass
	#$MeshInstance3D/GPUParticles3D.restart()
	#$MeshInstance3D/GPUParticles3D.emitting = true

func on_hover():
	scale = original_size * 1.2
	pass
func on_stop_hover():
	scale = original_size
	pass
