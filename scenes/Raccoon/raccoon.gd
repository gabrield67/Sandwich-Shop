class_name Raccoon
extends Area3D

@export var raccoonTime: int = 10
@export var move_distance: float = 2
#@onready var timer: Timer = $"Raccoon Timer"
#@onready var progressBar = $"Timer Display/Timer Viewport/Timer 3D"
@onready var raccoon_click = $"Raccoon Click"
@onready var thought_bubble_display = $"Flavor Display"
@onready var thought_bubble_label =$"Flavor Display/Flavor Viewport/Thought Bubble/Label"
#@onready var timer_display = $"Timer Display"
@onready var chart_display = $"Flavor Display/Flavor Viewport/Thought Bubble/Flavor Chart"
@onready var color_palette = $"WholeRaccoonModel"

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
var enter_timer = 0.0
var target_position

var original_size
var active_tween: Tween

var slot: Node = null

@export var needs_to_enter: bool = true:
	set(value):
		needs_to_enter = value
		if needs_to_enter and is_active:
			select_random_colors()
			handle_entrance()
			
@export var needs_to_exit: bool = false:
	set(value):
		needs_to_exit = value
		if needs_to_exit and is_active:
			handle_exit()
var entered: bool = false:
	set(value):
		entered = value
		if entered and is_active:
			show_display()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = global_position
	original_model_pos = target_position - Vector3(0,0,2)
	self.position = original_model_pos
	$Sprite3D.visible = false
	# set up timer
	#timer.wait_time = raccoonTime
	#progressBar.max_value = raccoonTime
	#timer.one_shot = true
	
	hide_display()
	randomize_target()
	
	chart_display.update_chart_data(target_flavors)
	
	original_size = scale
	select_random_colors()
	if is_active:
		handle_entrance()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#progressBar.value = timer.time_left
	#thought_bubble_label.text = str(target_flavors)

func _clear_active_tween() -> void:
	if active_tween and active_tween.is_valid():
		active_tween.kill()
		
func handle_entrance() -> void:
	_clear_active_tween()
	
	global_rotation_degrees.y = 0.0
	
	active_tween = create_tween()
	active_tween.tween_property(self, "global_position", target_position, 1)
	active_tween.tween_callback(func():
		entered = true
	)
	
	
func handle_exit() -> void:
	_clear_active_tween()
	
	active_tween = create_tween()
	active_tween.tween_property(self, "global_rotation_degrees:y", 180.0, 0.4)
	active_tween.tween_property(self, "global_position", original_model_pos, 1)
	
	active_tween.tween_callback(func():
		needs_to_exit = false
		needs_to_enter = true
		entered = false
	)
	
func show_display() -> void:
	thought_bubble_display.show()
	thought_bubble_display.visible = true
	#timer_display.show()
	#timer.start()
	
func hide_display() -> void:
	thought_bubble_display.hide()
	thought_bubble_display.visible = false
	#timer_display.hide()

			
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
		
func make_active() -> void:
	_clear_active_tween()
	self.global_position = original_model_pos
	self.global_rotation_degrees.y = 0.0
	
	is_active = true
	$Sprite3D.visible = false
	
	needs_to_enter = true
	
func make_inactive() -> void:
	_clear_active_tween()
	
	is_active = false
	needs_to_enter = false
	needs_to_exit = false
	entered = false
	
	hide_display()
	
	self.global_position = original_model_pos
	self.global_rotation_degrees.y = 0.0
	
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
	#timer_display.hide()
	clean_up_raccoon()
	
func clean_up_raccoon():
	needs_to_exit = true
	randomize_target()
	chart_display.update_chart_data(target_flavors)

func check_imperfect_sandwich(actual_flavor, target_flavor) -> bool:
	for i in range(actual_flavor.size()):
			if actual_flavor[i] < target_flavor[i]:
				return false
	return true
	
func select_random_colors() -> void:
	randomize()
	var random_index = randi() % color_palette.palette_names.size()
	var chosen_palette = color_palette.palette_names[random_index]
	color_palette.apply_color_palette(chosen_palette)
	
func turnOnUpgradeTime() -> void:
	$Sprite3D.visible=true
func turnOffUpgradeTime() -> void:
	$Sprite3D.visible=false
