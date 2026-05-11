extends Node

@export var raccoon_scene : PackedScene

@onready var slots = [
	$"Raccoon Placement/Slot",
	$"Raccoon Placement/Slot2",
	$"Raccoon Placement/Slot3",
	$"Raccoon Placement/Slot4"
]

@onready var raccoons_node = $"Raccoons"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_empty_slots()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_raccoon_in_slot(slot):
	var raccoon = raccoon_scene.instantiate()
	raccoons_node.add_child(raccoon)
	raccoon.global_position = slot.global_position
	raccoon.slot = slot
	slot.current_raccoon = raccoon
	raccoon.sandwich_completed.connect(_on_sandwich_completion)
	
	
func fill_empty_slots():
	for slot in slots:
		if slot.is_empty():
			spawn_raccoon_in_slot(slot)
	
	
func _on_sandwich_completion(raccoon):
	#TODO set raccoon reaction
	var slot = raccoon.slot
	slot.current_raccoon = null
	raccoon.queue_free()
	await get_tree().create_timer(.5).timeout
	fill_empty_slots()
