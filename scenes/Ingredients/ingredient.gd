class_name Ingredient
extends StaticBody3D

@onready var flavor_display = $"Flavor Display/Flavor Viewport/Label"

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
var conveyor_move_speed = 1
var bread_ingredient_frequency = .25
var onBread = false

var spawner

@export var min_ingredient_flavors: int = 1
@export var max_ingredient_flavors: int = 2
var ingredient_flavors: Array[int] = [0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_size = scale
	$tomatoMesh.queue_free()
	
	randomize()
	
	# instantiate ingredient
	spawnedMesh = meshes[type_index].instantiate()
	spawnedMesh.scale = Vector3(ingredient_scales [type_index],ingredient_scales [type_index],ingredient_scales [type_index])
	add_child(spawnedMesh)
	
	# handle flavors
	generate_flavors()
	flavor_display.text = str(ingredient_flavors)
	#$FlavorProfile.add_flavor(3,4,2,3)
	#print("new ingredient")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_on_start:
		if not spawner.upgradeTime:
			position = position + (move_direction*move_speed*delta)
			time_to_despawn = time_to_despawn-delta 
			if time_to_despawn <= 0:
				queue_free()
				GlobalEvents.ingredients_wasted.emit()
	
func assign_type_index() ->void:
	type_index = randi_range(0, 2)
	if type_index == 3:
		var test = randf()
		if test > bread_ingredient_frequency:
			type_index = randi_range(0, 2)

func on_grab() -> void:
	move_on_start = false
	despawn = false
	#$MeshInstance3D/GPUParticles3D.restart()
	#$MeshInstance3D/GPUParticles3D.emitting = true

func on_hover() -> void:
	scale = original_size * 1.2

func on_stop_hover() -> void:
	scale = original_size
		
func generate_flavors() -> void:
	# creates an array of ints where the sum is between the min and max ingredient flavors
	randomize()

	var final: Array[int] = [0, 0, 0, 0]
	var total_sum: int = randi_range(min_ingredient_flavors, max_ingredient_flavors)

	for i in total_sum:
		var random_index: int = randi() % 4
		final[random_index] += 1

	ingredient_flavors = final

func get_flavor_amounts() -> Array:
	return ingredient_flavors

func play_add_to_sandwich() -> void:
	$AddToSandwichSound.play()

func update_position(position) -> void:
	self.position = position
