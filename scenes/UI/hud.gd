extends CanvasLayer

@onready var waste: TextureProgressBar = $"Control/Waste Container/Waste Progress"
@onready var radialProgress: TextureProgressBar = $"Control/Timer Container/Radial Timer"


@export var levelTime: int = 30
@export var maxWaste: int = 10

var isPaused = false
var firstPause = true

var debug_upgrades = false

var goodSandwichCount: int = 0
var badSandwichCount: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_click()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass 


# update sandwiches		
func addGoodSandwich() -> void:
	goodSandwichCount = goodSandwichCount + 1
	if debug_upgrades:
		get_parent().startUpgradeTime()
	
func addBadSandwich() -> void:
	badSandwichCount = badSandwichCount + 1
	if debug_upgrades:
		get_parent().startUpgradeTime()
	
# update timer
func setMaxTimer(max_time) -> void:
	radialProgress.max_value = max_time

func updateTimer(current_time)-> void:
	radialProgress.value = current_time

# update waste
func setMaxWaste(max_waste) -> void:
	waste.max_value = max_waste

func updateWaste(current_waste) -> void:
	waste.value = current_waste
	
func pause_click() -> void:
	if isPaused:
		get_tree().paused = false
		isPaused = false
		$Tutorial.visible = false
		$Play.visible =false
	else:
		get_tree().paused = true
		isPaused = true
		if firstPause:
			$Tutorial.visible = true
			firstPause = false
		
func restart_click() -> void:
	get_tree().reload_current_scene()
