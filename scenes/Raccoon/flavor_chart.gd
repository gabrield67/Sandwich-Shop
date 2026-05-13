@tool
extends Control

var targets: Array = []

# styling
@export var bar_color: Array[Color] = [ Color.RED, Color.BLUE, Color.GREEN]
@export var spacing: float = 20.0
@export var max_chart_value: float = 5.0
@export var testing_chart: bool = false

# spacing
@export var notch_outline_color: Color = Color.BLACK
@export var notch_outline_width: float = 1.0
@export var notch_gap: float = 5.0


func update_chart_data(current_targets: Array)-> void:
	targets = current_targets
	queue_redraw()

func _draw() -> void:
	if testing_chart:
		targets = [4, 4, 4]
		
	if targets.is_empty():
		return

	# calculating dimensions based on current size
	var num_bars: int = targets.size()
	var total_spacing: float = spacing * (num_bars + 1)
	var bar_width: float = (size.x - total_spacing) / num_bars
	
	var notch_height: float = size.y / max_chart_value
	var step_height: float = size.y / max_chart_value
	
	# Create each bar
	for i in range(num_bars):
		var x_pos: float = spacing + i * (bar_width + spacing)
		var current_value: int = int(targets[i])
		
		# Loop through each individual unit notch for this bar
		for notch_index in range(current_value):
			var y_pos: float = size.y - ((notch_index + 1) * step_height)
			
			var final_y_pos: float = y_pos + notch_gap
			var final_height: float = step_height - notch_gap
			
			if final_height <= 0:
				continue
				
			var notch_rect: Rect2 = Rect2(x_pos, final_y_pos, bar_width, final_height)

			draw_rect(notch_rect, bar_color[i % bar_color.size()])

			draw_rect(notch_rect, notch_outline_color, false, notch_outline_width)
