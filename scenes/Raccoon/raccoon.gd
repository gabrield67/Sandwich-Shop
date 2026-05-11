extends Node3D

@export var raccoonTime: int = 10

@onready var timer: Timer = $"Raccoon Timer"
@onready var progressBar = $"SubViewport/Timer 3D"

@export var test_raccoon_spawn: bool = false

signal sandwich_completed(raccoon)

var slot: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = raccoonTime
	progressBar.max_value = raccoonTime
	timer.one_shot = true
	timer.start()
	
	if test_raccoon_spawn:
		$Area3D.input_event.connect(_on_input_event)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progressBar.value = timer.time_left


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("sandwich_completed", self)
	
