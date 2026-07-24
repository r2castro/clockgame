extends Area2D
class_name Gear

enum states {PLACED, PLACING, SPINNING}
@export var state: states = states.PLACED

@export var gear_size: int = 2

var potential_source: Gear = null
var source_gear: Gear
var connected_gears: Array[Gear] = []
var spin_dir: bool

var cursor_position := position

func set_position_cursor(pos: Vector2):
	cursor_position = pos


func process_placing_position() -> void:
	# the better way to solve this
	# seems to be
	# a seperate area2D node
	# to act as a cursor
	
	var radius = $CollisionShape2D.shape.radius
	var close_gears = get_overlapping_areas()
	if close_gears.is_empty():
		position = cursor_position
		modulate = Color('white')
		potential_source = null
		return
	
	var closest = close_gears[0]
	var closest_dir = closest.position - cursor_position
	var closest_radius
	for g: Gear in close_gears:
		var dir = g.position - cursor_position
		var g_radius = g.get_node('CollisionShape2D').shape.radius
		if dir.length() <= closest_dir.length():
			closest = g
			closest_dir = dir
			closest_radius = g_radius
	
	var candidate_position = closest.position - closest_dir.normalized() * (radius + closest_radius) * 0.9
	if closest_dir.length() > closest.position.distance_to(candidate_position):
		position = cursor_position
		modulate = Color('white')
		potential_source = null
		return
	for g: Gear in close_gears:
		if g == closest:
			continue
		var g_radius = g.get_node('CollisionShape2D').shape.radius
		var dir = candidate_position - g.position
		var displacement =  dir.normalized() * (radius + closest_radius) * 1.1
		candidate_position = g.position + displacement
	position = candidate_position
	potential_source = closest
	modulate = Color('green')


func spin(clockwise: bool) -> void:
	state = states.SPINNING
	spin_dir = clockwise
	for g in connected_gears:
		g.spin(not clockwise)


func _process(delta: float) -> void:
	if state == states.PLACED:
		return
	
	if state == states.SPINNING:
		if spin_dir:
			rotate(delta)
		else:
			rotate(-delta)
	
	if state == states.PLACING:
		process_placing_position()
		# incredibly bad code
		process_placing_position()


func _on_area_entered(area: Area2D) -> void:
	pass



func _on_area_exited(area: Area2D) -> void:
	pass


func place():
	state = states.PLACED
	modulate = Color('white')
	source_gear = potential_source
	potential_source.connected_gears.append(self)
