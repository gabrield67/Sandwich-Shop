class_name Ingredient
extends StaticBody3D


var tomatoMesh = preload("res://models/tomato_mesh.tscn")
var fishMesh = preload("res://models/fishBonesMesh.tscn")
var lettuceMesh = preload("res://models/lettuceMesh.tscn")
var breadMesh = preload("res://models/breadMesh.tscn")


var isHeld = false
var isSauce = false
var isHovered = false
var move_on_start = false
var despawn = false
var time_to_despawn = 8
var move_speed = 2
var move_direction = Vector3(1,0,0)
var original_size;
var bread
var ingredient_types = ['Tomato', 'Lettuce','Fish Bone', 'Bread']
var ingredient_scales = [1, 1,.75, 1.5	]
var meshes = [tomatoMesh , lettuceMesh,fishMesh, breadMesh]
var spawnedMesh
var type_index = 0

var spawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_size = scale
	$tomatoMesh.queue_free()
	
	randomize()
	assign_type_index()
	
	spawnedMesh = meshes[type_index].instantiate()
	spawnedMesh.scale = Vector3(ingredient_scales [type_index],ingredient_scales [type_index],ingredient_scales [type_index])
	add_child(spawnedMesh)
	add_flavor(type_index + 1)
	var dub = randi_range(0,1)
	if dub >= 1:
		add_flavor(randi_range(1,4))
	#$FlavorProfile.add_flavor(3,4,2,3)
	#print("new ingredient")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_on_start:
		if not spawner.upgradeTime:
			position = position + (move_direction*move_speed*delta)
			time_to_despawn = time_to_despawn-delta 
			if time_to_despawn <= 0:
				queue_free()
				GlobalEvents.ingredients_wasted.emit()
	pass
	
func assign_type_index() ->void:
	type_index = randi_range(0, 3)
	if type_index == 3:
		var test = randi_range(0,3)
		if test >= 3:
			type_index = randi_range(0, 3)

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

func play_add_to_sandwich() -> void:
	$AddToSandwichSound.play()
