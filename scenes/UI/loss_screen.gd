extends Node3D

var win = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible=false
	$raccoonHead.set_dead()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_screen():
	if not win:
		self.visible = true
		$raccoonHead.set_dead()
		
func show_win():
	self.visible = true
	win = true 
	$raccoonHead.set_win()
	
func hide_screen():
	self.visible = false
	
