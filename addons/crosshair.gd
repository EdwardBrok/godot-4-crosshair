extends Node2D


# Color of whole crosshair.
@export var color : Color = "#0094fe"
@export_range(0, 255) var transparency := 255

# Dot size.
@export_range(0, 10, 0.01) var dot_size : float = 1

# Lines' settings.
@export var lines_enabled := true
@export_range(0, 50, 0.01) var lines_length : float = 5
@export_range(0, 10, 0.01) var lines_width : float = 1
@export_range(0, 20, 0.01) var lines_distance : float = 2

# Paths to lines.
@onready var lines_handler = $LinesHandler
@onready var right_line = $LinesHandler/RightLine
@onready var left_line = $LinesHandler/LeftLine
@onready var top_line = $LinesHandler/TopLine
@onready var bottom_line = $LinesHandler/BottomLine

# Path to dot.
@onready var dot = $DotHandler/Dot


func _ready():
	update_color(color)
	update_lines()
	resize_dot(dot_size)
	pass


@warning_ignore("unused_parameter")
func _process(delta):
	pass
	
# Updates all parameters of lines.
func update_lines() -> void:
	update_lines_visibility(lines_enabled)
	
	# If lines is not enabled, they're ignored by func.
	if lines_enabled == false:
		return
	update_lines_pos(lines_width, lines_distance, lines_length)

func update_color(new_color) -> void:
	# Changes the transparency.
	new_color.a8 = transparency
	
	# Color of dot.
	dot.set_color(new_color)
	
	# If lines is not enabled, they're ignored by func.
	if lines_enabled == false:
		return
	
	# Color of lines.
	right_line.set_color(new_color)
	left_line.set_color(new_color)
	top_line.set_color(new_color)
	bottom_line.set_color(new_color)

# Updates lines' visibility by toggling visibility of their' parent.
func update_lines_visibility(visibility) -> void:
	lines_handler.visible = visibility
	
# Updates lines' position and size.
func update_lines_pos(new_width, new_distance, new_length) -> void:
	update_lines_width(new_width)
	update_lines_length(new_length, new_distance)
	
# Sets size, then reposites dot.
func resize_dot(multiplier) -> void:
	dot.size = Vector2.ONE * 10 * multiplier
	dot.position = dot.size / -2

# Updates lines' width.
func update_lines_width(width) -> void:
	# Right line
	right_line.size.y = width * 10
	right_line.position.y = right_line.get_size().y / -2
	
	# Left line
	left_line.size.y = width * 10
	left_line.position.y = left_line.get_size().y / -2
	
	# Top line
	top_line.size.x = width * 10
	top_line.position.x = top_line.get_size().x / -2
	
	# Bottom line
	bottom_line.size.x = width * 10
	bottom_line.position.x = bottom_line.get_size().x / -2

# Updates lines' position and distance at the same time.
func update_lines_distance(distance) -> void:
	right_line.position.x = distance * 10
	left_line.position.x = -left_line.get_size().x - (distance * 10)
	top_line.position.y = -top_line.get_size().y - (distance * 10)
	bottom_line.position.y = distance * 10

# Updates lines' length and position.
# Uses update_lines_distance() to reposition.
func update_lines_length(length, distance) -> void:
	right_line.size.x = length * 10
	left_line.size.x = length * 10
	top_line.size.y = length * 10
	bottom_line.size.y = length * 10
	
	# Updating lines' position and distance at the same time.
	update_lines_distance(distance)

func got_hit() -> void:
	$HitPlayer.play("hit")

func killed() -> void:
	$KillPlayer.play("kill")
