extends TabContainer
class_name BeepTabContainer

func _ready() -> void:
	tab_selected.connect(Utils.menu_beep)
	tab_changed.connect(Utils.menu_beep)
	focus_exited.connect(Utils.menu_beep)
