extends Node2D
class_name AnimatedControlHelper

@export_enum("Run", "Climb", "Jump", "Slide", "Attack", "Launch") var control = "Run"

var controller_connected: bool = false

func _ready() -> void:
	if Input.get_connected_joypads():
		controller_connected = true
