class_name Ingredient
extends StaticBody3D



var isHeld = false
var bread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_particles():
	pass
	#$MeshInstance3D/GPUParticles3D.restart()
	#$MeshInstance3D/GPUParticles3D.emitting = true
