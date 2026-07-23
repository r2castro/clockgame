extends Area2D
class_name Gear

enum states {PLACED, PLACING, SPINNING}
@export var state: states = states.PLACED

var potential_source: Gear = null
var source_gear: Gear
var connected_gears: Array[Gear] = []

var cursor_position = position

func set_position_cursor(pos: Vector2):
	cursor_position = pos

func update_closest_source():
	var gears = get_overlapping_areas()
	for g in gears:
		if g.position.distance_to(cursor_position) < potential_source.position.distance_to(cursor_position):
			potential_source = g
			print('changedd')
		

func _physics_process(delta: float) -> void:
	if state == states.PLACING:
		
		# incredibly bad code
		if potential_source:
			update_closest_source()
			var source_pos := potential_source.position
			var dir := source_pos.direction_to(cursor_position)
			var candidate_pos = source_pos + dir * potential_source.get_node('CollisionShape2D').shape.radius * 1.9
			if source_pos.distance_to(candidate_pos) < source_pos.distance_to(cursor_position):
				candidate_pos = cursor_position
			position = candidate_pos
		else:
			position = cursor_position


func _on_area_entered(area: Area2D) -> void:
	potential_source = area
	if state == states.PLACING:
		modulate = Color('green')


func _on_area_exited(area: Area2D) -> void:
	if area == potential_source:
		potential_source = null
		modulate = Color('white')


func place():
	state = states.PLACED
	modulate = Color('white')
	source_gear = potential_source
	potential_source.connected_gears.append(self)
