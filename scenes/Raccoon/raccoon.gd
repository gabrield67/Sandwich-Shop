class_name Raccoon
extends Area3D

@export var raccoonTime: int = 10

@onready var timer: Timer = $"Raccoon Timer"
@onready var progressBar = $"Timer Display/Timer Viewport/Timer 3D"
@onready var raccoon_click = $"Raccoon Click"
@onready var thought_bubble_display = $"Flavor Display"
@onready var thought_bubble_label =$"Flavor Display/Flavor Viewport/Thought Bubble/Label"
@onready var timer_display = $"Timer Display"
@onready var chart_display = $"Flavor Display/Flavor Viewport/Thought Bubble/Flavor Chart"

@export var test_raccoon_spawn: bool = false
@export var bar_width = 40
@export var spacing = 20
@export var height_scale = 10

@export var min_target_flavors = 2
@export var max_target_flavors = 4

var target_flavors: Array[int] = [0, 0, 0]
var ingredient_flavors: Array[int] = [0, 0, 0]

var is_active = true

var original_model_pos 
var needs_to_enter = true
var enter_timer = 0.0

var original_size	;

signal sandwich_completed(raccoon)

var slot: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_model_pos =$WholeRaccoonModel.position
	# set up timer
	timer.wait_time = raccoonTime
	progressBar.max_value = raccoonTime
	timer.one_shot = true
	timer_display.hide()
	
	# set up thought bubble
	thought_bubble_display.hide()
	randomize_target()
	
	chart_display.update_chart_data(target_flavors)
	
	original_size = scale
	# start game
	#TODO change this after animations come in
	#await get_tree().create_timer(.5).timeout
	#thought_bubble_display.show()
	#timer_display.show()
	#timer.start()
	
	if test_raccoon_spawn:
		pass
		#raccoon_click.input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progressBar.value = timer.time_left
	thought_bubble_label.text = str(target_flavors)
	if is_active:
		if needs_to_enter:
			
			$TargetFlavorProfile.visible = false
			$WholeRaccoonModel.position = original_model_pos - Vector3(0,0,(2-enter_timer))
			enter_timer = enter_timer + delta  
			if enter_timer >= 2:
				thought_bubble_display.show()
				needs_to_enter = false;
				$WholeRaccoonModel.position = original_model_pos
				enter_timer = 0
				thought_bubble_display.show()
				timer_display.show()
				timer.start()
			
			
func randomize_target() -> void:
	# generates a new target 
	# creates an array of ints where the sum is between the min and max target flavors
	randomize()

	var final: Array[int] = [0, 0, 0]
	var total_sum: int = randi_range(min_target_flavors, max_target_flavors)

	for i in total_sum:
		var random_index: int = randi() % 3
		final[random_index] += 1

	target_flavors = final
	
func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			pass
			#emit_signal("sandwich_completed", self)
	
func make_active() -> void:
	is_active  = true
	$TargetFlavorProfile.visible = true
	thought_bubble_display.visible = true
	thought_bubble_display.show()
	
func make_inactive() -> void:
	is_active = false
	thought_bubble_display.hide()
	thought_bubble_display.visible = false
	$WholeRaccoonModel.position = original_model_pos - Vector3(0,0,(2))
	$TargetFlavorProfile.visible = false
	
func on_entered_area(area: Area3D) -> void:
	if is_active:
		if area is Bread:
			#print (body.name)
			if(area):
				area.bread2 = self;
				#$MeshInstance3D.visible = true
				scale = original_size*1.2
			

func on_exited_area(area: Area3D) -> void:
	if is_active:
		if area is Bread:
			#print (body.name)
			if area:
				if area.bread2 == self:
					area.bread2 = null
				self.material_off()
				
func material_off() -> void:
	#$MeshInstance3D.visible = false
	scale = original_size
	
func eat_sandwich(sandwich: Node3D):
	if sandwich is Bread:
		on_finished(sandwich)
		sandwich. clean_up_bread()
		
func on_finished(ingredient: Node3D):
	$SandwichEatParticles.restart()
	$SandwichEatParticles.emitting = true
	if check_imperfect_sandwich(ingredient.get_actual_flavor_profile(), target_flavors):
		get_parent().good_sandwich_event()
		print("Good Sandwich")
		if ingredient.get_actual_flavor_profile() == target_flavors:
			get_parent().good_sandwich_event()
			print("Perfect Sandwich")
	else:
		print()
		get_parent().bad_sandwich_event()
		print("Bad Sandwich")
		
	GlobalEvents.sandwich_completed.emit(get_parent())
	thought_bubble_display.hide()
	timer_display.hide()
	clean_up_raccoon()
	
func clean_up_raccoon():
	needs_to_enter = true
	randomize_target()
	chart_display.update_chart_data(target_flavors)

func check_imperfect_sandwich(actual_flavor, target_flavor) -> bool:
	for i in range(actual_flavor.size()):
			if actual_flavor[i] < target_flavor[i]:
				return false
	return true
