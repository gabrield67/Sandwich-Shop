extends CanvasLayer

@onready var waste: TextureProgressBar = $"Control/Waste Container/Waste Progress"
@onready var radialProgress: TextureProgressBar = $"Control/Timer Container/Radial Timer"


@export var levelTime: int = 30
@export var maxWaste: int = 10

var debug_upgrades = false

var goodSandwichCount: int = 0
var badSandwichCount: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
