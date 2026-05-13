extends Node3D

@onready var monsterArmAnim = $monsterPulseAnimation

@onready var original_rotation = rotation
@onready var original_position = position
var start_anim = false
var anim_rot = Vector3(0,0,0)
var anim_timer = 0
var start_disperse = false
var disperse_timer = 0
var disperse_pt_1 = Vector3(0,0,0)
var disperse_pt_2 = Vector3(0,0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	anim_rot = Vector3(randf(), randf(), randf())*(1-(randi_range(0,1)*2))
	pass
	#monsterArmAnim.play("idle")
	
func _process(delta:float)->void:
	if start_anim:
		anim_timer = anim_timer+delta
		if anim_timer < .5:
			rotation = original_rotation + anim_rot * anim_timer*2
		elif anim_timer <1:
			rotation = (original_rotation + anim_rot ) - (anim_rot*(anim_timer-.5)*2)
		else:
			anim_timer = 0 
			start_anim = start_disperse
	if start_disperse:
		disperse_timer = disperse_timer + delta
		if disperse_timer < 1:
			global_position = original_position + ((disperse_pt_1 - original_position)*disperse_timer)
		elif disperse_timer < 2:
			global_position = disperse_pt_1 + ((disperse_pt_2 - disperse_pt_1)*(disperse_timer-1))
		
		else:
			start_disperse = false
