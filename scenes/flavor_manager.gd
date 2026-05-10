class_name FlavorManager
extends Node3D

var targetFlavors: Array = []
var currentFlavors: Array = []

func generate_target_flavors() -> Array:
	# generate the target flavors
	# TODO: ADD VARYING DIFFICULTY
	# array of 4 items where the total sum is between 3 and 5
	var a = [0, 0, 0, 0]
	var totalSum = randi_range(3, 5)

	for i in totalSum:
		a[randi() % 4] += 1
		
	set_target_flavors(a)
	return targetFlavors

func generate_ingredient_flavors() -> Array:
	# generate the ingredient flavors
	# TODO: ADD VARYING DIFFICULTY
	# array of 4 items where the total sum is between 1 and 2
	var a = [0, 0, 0, 0]
	var totalSum = randi_range(1, 2)

	for i in totalSum:
		a[randi() % 4] += 1
		
	set_target_flavors(a)
	return targetFlavors

func add_new_current_flavors(newFlavors: Array, currentFlavors: Array) -> Array:
	var sum = []
	for i in newFlavors.size():
		sum.append(currentFlavors[i] + newFlavors[i])
	return sum

# getters + setters
func set_target_flavors(flavors: Array) -> void:
	targetFlavors = flavors

func get_target_flavors() -> Array:
	return targetFlavors

func set_current_flavors(flavors: Array) -> void:
	currentFlavors = flavors

func get_current_flavors() -> Array:
	# TODO: figure out how to get current flavors lol
	return currentFlavors
