extends Node3D

@export var raccoonTime: int = 10

@onready var timer: Timer = $"Raccoon Timer"
@onready var progressBar = $"Timer Display/Timer Viewport/Timer 3D"
@onready var raccoon_click = $"Raccoon Click"
@onready var thought_bubble_display = $"Flavor Display"
@onready var thought_bubble_label =$"Flavor Display/Flavor Viewport/Thought Bubble/Label"
@onready var timer_display = $"Timer Display"

@export var test_raccoon_spawn: bool = false

var flv = FlavorManager.new()
var current_flavors: Array
var target_flavors: Array

signal sandwich_completed(raccoon)

var slot: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# set up timer
	timer.wait_time = raccoonTime
	progressBar.max_value = raccoonTime
	timer.one_shot = true
	timer_display.hide()
	
	# set up thought bubble
	thought_bubble_display.hide()
	target_flavors = flv.generate_target_flavors()
	current_flavors = target_flavors
	$Bread.ingredient_hovered.connect(_on_ingredient_hover)
	$Bread.ingredient_exited.connect(_on_ingredient_exit)
	
	# start game
	#TODO change this after animations come in
	await get_tree().create_timer(.5).timeout
	thought_bubble_display.show()
	timer_display.show()
	timer.start()
	
	if test_raccoon_spawn:
		raccoon_click.input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progressBar.value = timer.time_left
	thought_bubble_label.text = str(current_flavors)


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("sandwich_completed", self)
	
func _on_ingredient_hover(ingredient_flavors):
	print("hovering")
	current_flavors = flv.add_new_flavors(current_flavors, ingredient_flavors)
	return current_flavors
	
func _on_ingredient_exit(ingredient_flavors):
	current_flavors = flv.remove_new_flavors(current_flavors, ingredient_flavors)
	return current_flavors
	print("exiting")
