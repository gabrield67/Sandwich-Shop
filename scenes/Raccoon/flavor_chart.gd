@tool
extends Control

var targets: Array = []

func update_chart_data(current_targets: Array)-> void:
	targets = current_targets
	queue_redraw()

# styling
@export var bar_color: Array[Color] = [ Color.RED,  Color.YELLOW, Color.BLUE, Color.GREEN]
@export var spacing: float = 20.0
@export var max_chart_value: float = 5.0

func _draw() -> void:
	if targets.is_empty():
		return

	# calculating dimensions based on current size
	var num_bars: int = targets.size() -1
	var total_spacing: float = spacing * (num_bars + 1)
	var bar_width: float = (size.x - total_spacing) / num_bars
	

	# create each bar
	for i in range(num_bars):
		var x_pos: float = spacing + i * (bar_width + spacing)
		var normalized_height = (targets[i] / max_chart_value) * size.y
		var y_pos: float = size.y - normalized_height
		var bar_rect: Rect2 = Rect2(x_pos, y_pos, bar_width, normalized_height)
		
		draw_rect(bar_rect, bar_color[i])
