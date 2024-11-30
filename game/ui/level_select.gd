extends Control
class_name LevelSelect

var max_level_index: int = 0

@onready var back_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/BackButton
@onready var levels: ItemList = $VBoxContainer/Levels

func _ready() -> void:
	back_button.grab_focus()
	back_button.focus_entered.connect(func(): levels.deselect_all())
	if not SaveAndLoad.save_data.levels.size():
		push_error("no completed levels yet. Cannot level select")
		go_back()
		return

	var level_keys: Array = SaveAndLoad.save_data.levels.keys()
	level_keys.sort()
	for level_key in level_keys:
		var saved_level_stats = SaveAndLoad.save_data.levels[level_key]
		levels.add_item(saved_level_stats.level_name, load(saved_level_stats.level_image))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		go_back()
	if event.is_action_pressed("ui_accept"):
		var idxs = levels.get_selected_items()
		if idxs:
			_on_levels_item_clicked(idxs[0], Vector2(0,0), 0)

func go_back() -> void:
	get_tree().change_scene_to_file("res://game/ui/main_menu.tscn")

func _on_back_button_pressed() -> void:
	go_back()

func _on_levels_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	SaveAndLoad.save_data.play_selected_level = index
	get_tree().change_scene_to_file("res://game/world/world.tscn")
