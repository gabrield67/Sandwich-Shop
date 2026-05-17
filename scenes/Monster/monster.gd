extends Area3D
var hand_scene = preload("res://models/monster_hand.tscn")
var hands = [];
var playedSound = false
var firstAdd = true
var gameEnd = false
var wait_time = 3.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _process(delta:float)->void:
	if wait_time > 0:
		wait_time -= delta
	
	if wait_time <= 0 and firstAdd:
		add_hand()
	
func on_enter(body: Node3D)->void:
	body.queue_free()
	add_hand()
	GlobalEvents.ingredients_wasted.emit()

func add_hand()->void:
	var hs = hand_scene.instantiate()
	randomize()
	
	if firstAdd:
		firstAdd = false
		hs.rotation = Vector3(0	,4.5,0)
	else:
		var x = ((randf()-.5)*1.1)*0.3
		var y = ((randf()-.5)*3.1)-1.5
		var z = ((randf()-.5)*1.1)*0.3
		hs.rotation = Vector3(x	,y,z)
		if not gameEnd:
			$Monster.play()
	if not gameEnd:
		add_child(hs)
		hands.push_back(hs)
	
	#hs.scale = Vector3(.5,.5,.5)
	randomize()
	
	hs.rotation_order = 2
	hs.original_rotation =hs.rotation
	hs.position = Vector3(-.5	, 0, -.5) 
	hs.original_position =hs.global_position
	
	hand_anims()
	if hands.size() > 10:
		disperse()
	
func hand_anims():
	for h in hands:
		h.start_anim = true
		
func disperse():
	gameEnd = true
	if not playedSound:
		$Squeaking.play()
		await get_tree().create_timer(0.5).timeout
		$Squeaking2.play()
		playedSound = true
	var i = 0
	for h in hands:
		i = i+ 1 
		if i == 3:
			get_parent().get_parent().on_loss()
		h.start_disperse = true
		h.disperse_pt_1 = $"Step 1".global_position
		h.disperse_pt_2 = $"Step 2".global_position
		await get_tree().create_timer(.5).timeout
