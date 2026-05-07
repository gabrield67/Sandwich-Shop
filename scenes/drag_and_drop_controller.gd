extends Node3D

const DIST = 1000



var grabbed_object = null
var hover_object = null
var mouse = Vector2()
var zPos = 5	
var cardHeightOrig = 3
var cardHeight = 0

var liftHeight = 0

var prevCardHeight = liftHeight

var prev_grabbed_object = null
var grab_position = Vector2()
var firstPress = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#@$AudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grabbed_object:
		#cardHeight = clamp(cardHeight+delta*6,0,liftHeight);
		grabbed_object.position = get_grab_position()
		
			
	if prev_grabbed_object:
		if prev_grabbed_object != grabbed_object:
			#prevCardHeight = clamp(prevCardHeight+delta*-5	,0,liftHeight);
			#prev_grabbed_object.position[1] = cardHeightOrig +  prevCardHeight
			pass
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse =event.position
		get_mouse_world_pos(mouse, false)
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			if firstPress:
				get_mouse_world_pos(mouse, true)
				if grabbed_object:
					grabbed_object.on_grab()
					$"Pickup Sound".play()
					
					if grabbed_object.bread:
						grabbed_object.bread.remove_from_sandwich(grabbed_object)
				firstPress = false
		elif event.button_index == 1 and not event.is_pressed():
			
			#prevCardHeight = 3
			if grabbed_object:
				
				if grabbed_object.bread:
					grabbed_object.bread.material_off()
					grabbed_object.bread.add_to_sandwich(grabbed_object)
				else:
					$"Drop Sound".play()
				grabbed_object.isHeld = false
				prev_grabbed_object = grabbed_object
				
				grabbed_object = null
			firstPress = true
	
			
func get_mouse_world_pos(mouse_in:Vector2, try_grab:bool):
	var space = get_world_3d().direct_space_state
	var start = get_viewport().get_camera_3d().project_ray_origin(mouse_in)
	var end = get_viewport().get_camera_3d().project_position(mouse_in, DIST)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end 
	
	var result = space.intersect_ray(params)
	
	if result.is_empty()==false:
		
		#print(result.collider.get_class())
		#print("here0")
		if result.collider is Ingredient:
			#print("here1")
			if try_grab:
				grabbed_object = result.collider
				grabbed_object.isHeld = true
				#print("here2")
				cardHeight = 0
			else:
				if hover_object:
					if hover_object != result.collider:
						hover_object.isHovered = false
						hover_object.on_stop_hover()
				hover_object = result.collider;
				hover_object.isHovered = true
				hover_object.on_hover()
		else:
			if hover_object:
				hover_object.isHovered = false
				hover_object.on_stop_hover()
	else:
		if hover_object:
			hover_object.isHovered = false
			hover_object.on_stop_hover()
func get_grab_position():
	#zPos = ($"Camera Pivot/Camera3D".position -  grabbed_object.position).length()*.5
	var pre_position = get_viewport().get_camera_3d().project_position(mouse, zPos);
	var line = ($"Camera Pivot/Camera3D".global_position - pre_position)
	var ratio = ((cardHeightOrig + cardHeight) - $"Camera Pivot/Camera3D".global_position[1])/line[1]
	var line_fin = line*ratio
	return $"Camera Pivot/Camera3D".global_position + line_fin

func play_win_sound():
	$WinSound.play()

func play_lose_sound():
	$LoseSound.play()
	
func good_sandwich_event():
	play_win_sound()
	pass
	
func bad_sandwich_event():
	play_lose_sound()
	pass
