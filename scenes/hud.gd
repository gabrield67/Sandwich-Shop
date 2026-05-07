extends CanvasLayer

@onready var timer: Timer = $"Control/Radial Timer/Level Timer"
@onready var radialProgress: TextureProgressBar = $"Control/Radial Timer"
@export var levelTime: int = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set Level Timer
	timer.wait_time = levelTime
	timer.one_shot = true
	timer.start()
	
	radialProgress.max_value = timer.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#update Level Timer
	radialProgress.value = timer.time_left
