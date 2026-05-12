extends Node3D

const DIST = 1000

@onready var timer: Timer = $"Game Timer"
@onready var hud: CanvasLayer = $"HUD"

# drag and drop functionality
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

# sauce upgrades
var upgradeTime = false

# game data
var wasteCount: int = 0

var goodSandwichCount: int = 0
var badSandwichCount: int = 0

@export var gameTime: int = 30
@export var maxWaste: int = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#@$AudioStreamPlayer.play()

	# Game Timer
	hud.setMaxTimer(gameTime)
	timer.wait_time = gameTime
	timer.one_shot = true
	timer.start()

	set_parameters()
	# Waste Tracking
	hud.setMaxWaste(maxWaste)
	
	# listeners
	GlobalEvents.ingredients_wasted.connect(_on_ingredients_wasted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	# handle grabbed object
	if grabbed_object:
		#cardHeight = clamp(cardHeight+delta*6,0,liftHeight);
		grabbed_object.update_position( get_grab_position())
		
			
	if prev_grabbed_object:
		if prev_grabbed_object != grabbed_object:
			#prevCardHeight = clamp(prevCardHeight+delta*-5	,0,liftHeight);
			#prev_grabbed_object.position[1] = cardHeightOrig +  prevCardHeight
			pass
	
	# handle game timer
	hud.updateTimer(timer.time_left)

func set_parameters():
	$IngredientSpawner.conveyor_move_speed= $Parameters.conveyor_move_speed
	$IngredientSpawner.spawn_wait_time= $Parameters.ingredient_spawn_wait_time
	$IngredientSpawner.bread_ingredient_frequency= $Parameters.bread_ingredient_frequency
	
	$UpgradeManager.min_target_flavors = $Parameters.min_target_flavors
	$UpgradeManager.max_target_flavors = $Parameters.max_target_flavors
	$UpgradeManager.init_bread() 
	
	$HUD.debug_upgrades =  $Parameters.debug_upgrades
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse =event.position
		get_mouse_world_pos(mouse, false)
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			if firstPress:
				#get_mouse_world_pos also gets the grabbed object if its an ingredient
				#In upgrade time it handles the upgrade on click
				get_mouse_world_pos(mouse, true)
				if grabbed_object:
					grabbed_object.on_grab()
					$"Pickup Sound".play()
					if grabbed_object is Ingredient:
						if grabbed_object.bread:
							grabbed_object.bread.remove_from_sandwich(grabbed_object)
				firstPress = false
		elif event.button_index == 1 and not event.is_pressed():
			
			#prevCardHeight = 3
			if grabbed_object:
				if grabbed_object is Ingredient:
					if grabbed_object.bread:
						print('drop bread')
						grabbed_object.bread.material_off()
						grabbed_object.bread.add_to_sandwich(grabbed_object)
					else:
						$"Drop Sound".play()
						grabbed_object.queue_free()
					grabbed_object.isHeld = false
					prev_grabbed_object = grabbed_object
				elif grabbed_object is Bread:
					if grabbed_object.bread2:
						grabbed_object.bread2. add_to_sandwich(grabbed_object)
					grabbed_object.return_to_position()
				
				grabbed_object = null
			firstPress = true
	
			
func get_mouse_world_pos(mouse_in:Vector2, try_grab:bool):
	var space = get_world_3d().direct_space_state
	var start = get_viewport().get_camera_3d().project_ray_origin(mouse_in)
	var end = get_viewport().get_camera_3d().project_position(mouse_in, DIST)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end 
	params.collide_with_areas = true
	
	var result = space.intersect_ray(params)
	
	if result.is_empty()==false:
		
		#print(result.collider.get_class())
		#print("here0")
		if upgradeTime:
			#print('upgrade time')
			print(result.collider.get_class())
			if result.collider is Upgrade_Manager:
				#print('upgrade manager')
				pass
			if result.collider is Ingredient:
				#print('ingredient')
				pass
			if hover_object:
					hover_object.isHovered = false
					hover_object.on_stop_hover()
			if result.collider is Bread:
				#print('bread')
				if try_grab:
					if not result.collider.is_active:
						result.collider.make_active()
						stopUpgradeTime()
			if result.collider is Bread2:
				#print('bread2')
				if try_grab:
					if not result.collider.is_active:
						result.collider.make_active()
						stopUpgradeTime()
						
			if result.collider is SauceMachine:
				#print('sauce')
				if try_grab:
					if not result.collider.is_active:
						result.collider.make_active()
						stopUpgradeTime()
		else:
			if result.collider is Ingredient:
				#print("here1")
				if try_grab:
					if result.collider.onBread:
						grabbed_object = result.collider.bread
					else:
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
				if try_grab:
					if result.collider is Bread:
						grabbed_object = result.collider
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
	$HUD.addGoodSandwich()
	pass
	
func bad_sandwich_event():
	play_lose_sound()
	$HUD.addBadSandwich()
	pass

func startUpgradeTime():
	upgradeTime = true
	$IngredientSpawner.upgradeTime = true
	$Parameters.conveyor_move_speed = $Parameters.conveyor_move_speed*1.02
	$Parameters.max_target_flavors =$Parameters.max_target_flavors+.5
	$Parameters.ingredient_spawn_wait_time =$Parameters.ingredient_spawn_wait_time*.99
	$DirectionalLight3D.light_energy =0
	set_parameters()
	$UpgradeManager.startUpgradeLights()
	pass
	
func stopUpgradeTime():
	upgradeTime = false
	$IngredientSpawner.upgradeTime = false
	$DirectionalLight3D.light_energy =1
	$UpgradeManager.stopUpgradeTime()
# Time Functions
func _on_game_timer_timeout():
	print("Time's Up")
	GlobalEvents.level_timer_end.emit()
	
# update Trash Progress Bar every time there's a wasted ingredient
func _on_ingredients_wasted():
	wasteCount += 1
	hud.updateWaste(wasteCount)
	if wasteCount > maxWaste:
		print("Max Ingredients Wasted")
		GlobalEvents.max_ingredients_wasted.emit()
