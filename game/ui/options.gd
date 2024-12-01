extends Control
class_name Options

@export var go_back_to: String = "res://game/ui/main_menu.tscn"

var animation_list: Array[String] = ["idle", "walk", "run", "jump", "fall", "double_jump", "slide", "launch", "climb"]

@onready var back_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/BackButton
@onready var animated_sprite_2d: AnimatedSprite2D = $VBoxContainer/MarginContainer2/TabContainer/Controls/ControlsPanel/HBoxContainer/AnimatedSprite/AnimatedSprite2D
@onready var master_h_slider: HSlider = $VBoxContainer/MarginContainer2/TabContainer/Sound/Panel/CenterContainer/VBoxContainer/Master/MasterHSlider
@onready var music_h_slider: HSlider = $VBoxContainer/MarginContainer2/TabContainer/Sound/Panel/CenterContainer/VBoxContainer/Music/MusicHSlider
@onready var sound_fxh_slider: HSlider = $VBoxContainer/MarginContainer2/TabContainer/Sound/Panel/CenterContainer/VBoxContainer/SoundFX/SoundFXHSlider

func _ready() -> void:
	if go_back_to:
		back_button.grab_focus()
	visibility_changed.connect(_on_visibility_changed)

	var audio = SaveAndLoad.save_data.settings.get("audio", {})
	master_h_slider.set_value_no_signal(audio.Master)
	music_h_slider.set_value_no_signal(audio.Music)
	sound_fxh_slider.set_value_no_signal(audio.SoundFX)

func _on_visibility_changed() -> void:
	if visible:
		back_button.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		go_back()

func go_back() -> void:
	SaveAndLoad.save_game()
	if go_back_to:
		get_tree().change_scene_to_file(go_back_to)
	else:
		hide()

func _on_back_button_pressed() -> void:
	go_back()

func _on_timer_timeout() -> void:
	var old = animation_list.pop_front()
	animation_list.append(old)
	animated_sprite_2d.play(animation_list[0])

func set_volume(bus_name: String, value: float) -> void:
	SaveAndLoad.save_data.settings.audio[bus_name] = value
	Utils.set_volume(bus_name, value)

func _on_master_h_slider_value_changed(value: float) -> void:
	set_volume("Master", value)

func _on_music_h_slider_value_changed(value: float) -> void:
	set_volume("Music", value)

func _on_sound_fxh_slider_value_changed(value: float) -> void:
	set_volume("SoundFX", value)
