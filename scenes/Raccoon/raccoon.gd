extends Node3D

@export var raccoonTime: int = 10

@onready var timer: Timer = $"Raccoon Timer"
@onready var progressBar = $"Timer Display/Timer Viewport/Timer 3D"
@onready var raccoon_click = $"Raccoon Click"
@onready var thought_bubble_display = $"Flavor Display"
@onready var timer_display = $"Timer Display"
@export var test_raccoon_spawn: bool = false

signal sandwich_completed(raccoon)

var slot: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = raccoonTime
	progressBar.max_value = raccoonTime
	timer.one_shot = true
	thought_bubble_display.hide()
	timer_display.hide()
	
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


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("sandwich_completed", self)
	
