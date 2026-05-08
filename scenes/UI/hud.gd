extends CanvasLayer

@onready var timer: Timer = $"Control/Timer Container/Radial Timer/Level Timer"
@onready var waste: TextureProgressBar = $"Control/Waste Container/Waste Progress"
@onready var radialProgress: TextureProgressBar = $"Control/Timer Container/Radial Timer"
@onready var wasteLabel: Label = $"Control/Waste Container/Label"


@export var levelTime: int = 30
@export var maxWaste: int = 10

var wasteCount: int = 0

var goodSandwichCount: int = 0
var badSandwichCount: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set Level Timer
	timer.wait_time = levelTime
	timer.one_shot = true
	timer.start()
	
	radialProgress.max_value = timer.wait_time
	
	#set Waste Progress Bar
	waste.max_value = maxWaste


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#update Level Timer
	radialProgress.value = timer.time_left
	
	#update Wasted Items
	#GlobalEvents.ingredients_wasted.connect(_on_ingredients_wasted)

# Update Trash Progress Bar every time there's a wasted ingredient
func _on_ingredients_wasted():
	wasteCount += 1
	waste.value = wasteCount
	if wasteCount > maxWaste:
		GlobalEvents.max_ingredients_wasted.emit()
		
func addGoodSandwich() -> void:
	goodSandwichCount = goodSandwichCount + 1
	get_parent().startUpgradeTime()
	
func addBadSandwich() -> void:
	badSandwichCount = badSandwichCount + 1
	get_parent().startUpgradeTime()
	
