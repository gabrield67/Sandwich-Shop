extends Area3D
var hand_scene = preload("res://models/monster_hand.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_hand()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_enter(body: Node3D)->void:
	body.queue_free()
	add_hand()
	pass

func add_hand()->void:
	var hs = hand_scene.instantiate()
	$AudioStreamPlayer.play()
	add_child(hs)
	hs.scale = Vector3(.5,.5,.5)
	randomize()
	var x = (randf()-.5)*1
	var y = (randf()-.5)*1
	var z = (randf()-.5)*1
	hs.rotation = Vector3(x	,y,z)
	hs.rotation_order = 2
	hs.position = Vector3(0	, 0, 0) 
	pass
