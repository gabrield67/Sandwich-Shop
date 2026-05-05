class_name Ingredient
extends StaticBody3D



var isHeld = false
var isHovered = false
var move_on_start = false
var despawn = false
var time_to_despawn = 6
var move_speed = 2
var move_direction = Vector3(1,0,0)
var original_size;
var bread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_size = scale
	#$FlavorProfile.add_flavor(3,4,2,3)
	#print("new ingredient")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_on_start:
		position = position + (move_direction*move_speed*delta)
		time_to_despawn = time_to_despawn-delta 
		if time_to_despawn <= 0:
			queue_free()
	pass
	
func on_grab():
	move_on_start = false
	despawn = false
	pass
	#$MeshInstance3D/GPUParticles3D.restart()
	#$MeshInstance3D/GPUParticles3D.emitting = true

func on_hover():
	scale = original_size * 1.2
	pass
func on_stop_hover():
	scale = original_size
	pass
	
func add_flavor(f:int ) -> void:
	if f == 1:
		$FlavorProfile.add_flavor(1,0,0,0)
	elif f == 2:
		$FlavorProfile.add_flavor(0,1,0,0)
	elif f == 3:
		$FlavorProfile.add_flavor(0,0,1,0)
	elif f == 4:
		$FlavorProfile.add_flavor(0,0,0,1)

func get_flavor_amounts() -> Array:
	return $FlavorProfile.get_flavor_amounts()
