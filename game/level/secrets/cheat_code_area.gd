extends Secret
class_name CheatCodeArea

@onready var cheat_code_ui: CheatCodeUI = $UI/CheatCodeUI

func set_found(value: bool) -> void:
    super(value)
    if value:
        sprite_2d.hide()
        await get_tree().create_timer(0.25).timeout
        cheat_code_ui.display_cheat_code(secret_data)
    else:
        sprite_2d.show()
