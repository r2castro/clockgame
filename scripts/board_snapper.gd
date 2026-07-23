extends Node2D

var GearScene = preload("res://scenes/gear.tscn")


@onready
var gear = $Gear
@onready
var source = $Source

@onready
var radius = $Source/CollisionShape2D.shape.radius


func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	var source_pos = source.position
	var distance: Vector2 = mouse_pos - source_pos

	gear.set_position_cursor(mouse_pos)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if gear.modulate == Color('green'):
			print('click')
			await gear.place()
			gear = GearScene.instantiate()
			gear.state = gear.states.PLACING
			gear.set_position_cursor(get_local_mouse_position())
			add_child(gear)
