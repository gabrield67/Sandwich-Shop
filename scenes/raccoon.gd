extends Node3D

@export var raccoonTime: int = 10

@onready var timer: Timer = $"Raccoon Timer"
@onready var progressBar = $"SubViewport/Timer 3D"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = raccoonTime
	progressBar.max_value = raccoonTime
	timer.one_shot = true
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progressBar.value = timer.time_left
