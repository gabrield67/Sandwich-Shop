extends TextureProgressBar

@onready var timer: Timer = $"Level Timer"

@export var levelTime: int = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = levelTime
	timer.one_shot = true
	timer.start()
	
	max_value = timer.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = timer.time_left
