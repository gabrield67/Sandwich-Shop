extends Node3D

var is_dead = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_dead:
		pass
	else:
		$DeadInd1.visible = false
		$DeadInd2.visible = false
		$DeadInd3.visible = false
		$DeadInd4.visible = false
	
	$WinInd.visible = false
	$WinInd2.visible = false
	$WinInd3.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_dead():
	$DeadInd1.visible = true
	$DeadInd2.visible = true
	$DeadInd3.visible = true
	$DeadInd4.visible = true
	
func set_win():
	$WinInd.visible = true
	$WinInd2.visible = true
	$WinInd3.visible = true
	
