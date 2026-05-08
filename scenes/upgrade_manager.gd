class_name Upgrade_Manager
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bread4.make_inactive()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func good_sandwich_event():
	get_parent().good_sandwich_event()
	pass
	
func bad_sandwich_event():
	get_parent().bad_sandwich_event()
	pass
