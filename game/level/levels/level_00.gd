extends Level
class_name TutorialLevel

@onready var controller_animated_control_tiles: TileMapLayer = $ControllerAnimatedControlTiles
@onready var keyboard_animated_control_tiles: TileMapLayer = $KeyboardAnimatedControlTiles

func _ready() -> void:
	if Input.get_connected_joypads():
		controller_animated_control_tiles.show()
		keyboard_animated_control_tiles.hide()
	else:
		keyboard_animated_control_tiles.show()
		controller_animated_control_tiles.hide()
	
	super()
