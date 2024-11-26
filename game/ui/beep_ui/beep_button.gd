extends Button
class_name BeepButton

func _ready() -> void:
    focus_exited.connect(Utils.menu_beep)
    focus_entered.connect(Utils.menu_beep)
