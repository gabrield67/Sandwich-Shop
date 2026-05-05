extends Node3D

const DIST = 1000



var grabbed_object = null
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
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			if firstPress:
				get_mouse_world_pos(mouse)
				if grabbed_object:
					grabbed_object.start_particles()
					
					if grabbed_object.bread:
						grabbed_object.bread.remove_from_sandwich(grabbed_object)
				firstPress = false
		elif event.button_index == 1 and not event.is_pressed():
			prev_grabbed_object = grabbed_object
			#prevCardHeight = 3
			if grabbed_object.bread:
				grabbed_object.bread.material_off()
				grabbed_object.bread.add_to_sandwich(grabbed_object)
			grabbed_object.isHeld = false
			grabbed_object = null
			firstPress = true
	
			
func get_mouse_world_pos(mouse_in:Vector2):
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
			grabbed_object = result.collider
			grabbed_object.isHeld = true
			#print("here2")
			cardHeight = 0
			
func get_grab_position():
	#zPos = ($"Camera Pivot/Camera3D".position -  grabbed_object.position).length()*.5
	var pre_position = get_viewport().get_camera_3d().project_position(mouse, zPos);
	var line = ($"Camera Pivot/Camera3D".global_position - pre_position)
	var ratio = ((cardHeightOrig + cardHeight) - $"Camera Pivot/Camera3D".global_position[1])/line[1]
	var line_fin = line*ratio
	return $"Camera Pivot/Camera3D".global_position + line_fin
