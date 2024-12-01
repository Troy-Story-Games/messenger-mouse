extends Control
class_name CheatCodeListUI

@export var cheat_image: Texture2D
@export var go_back_to: String = "res://game/ui/main_menu.tscn"

var cheats_dict: Dictionary = {}
var cheat_names: Array = []

@onready var back_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/BackButton
@onready var cheats: ItemList = $VBoxContainer/Cheats
@onready var cheat_code_ui: CheatCodeUI = $CheatCodeUI

func _ready() -> void:
	if go_back_to:
		back_button.grab_focus()
		back_button.focus_entered.connect(func(): cheats.deselect_all())
	visibility_changed.connect(_on_visibility_changed)
	update_cheats()

func _on_visibility_changed() -> void:
	if visible:
		update_cheats()
		back_button.grab_focus()
		back_button.focus_entered.connect(func(): cheats.deselect_all())

func update_cheats() -> void:
	cheats.clear()
	cheats_dict = SaveAndLoad.save_data.cheats.duplicate(true)
	var current_level = MainInstances.current_level
	if current_level and is_instance_valid(current_level):
		cheats_dict.merge(current_level.cheats_found, true)

	cheat_names = cheats_dict.keys()
	cheat_names.sort()
	for cheat_name in cheat_names:
		var cheat_data = cheats_dict[cheat_name]
		var cheat_text: String = cheat_data.name + ": " + Utils.generate_cheat_string(cheat_data.button_combo, 0)
		cheats.add_item(cheat_text, cheat_image)

func go_back() -> void:
	if go_back_to:
		get_tree().change_scene_to_file(go_back_to)
	else:
		hide()

func _on_back_button_pressed() -> void:
	go_back()

func _on_cheats_item_activated(index: int) -> void:
	process_mode = ProcessMode.PROCESS_MODE_DISABLED
	var cheat_data = cheats_dict[cheat_names[index]]
	cheat_code_ui.display_cheat_code_from_dict(cheat_data)
	cheat_code_ui.viewed_long_enough = true

func _on_cheat_code_ui_cheat_code_ui_closed() -> void:
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
