extends Control
class_name Options

var animation_list: Array[String] = ["idle", "walk", "run", "jump", "fall", "double_jump", "slide", "launch", "climb"]

@onready var back_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/BackButton
@onready var animated_sprite_2d: AnimatedSprite2D = $VBoxContainer/MarginContainer2/TabContainer/Controls/ControlsPanel/HBoxContainer/AnimatedSprite/AnimatedSprite2D
@onready var master_h_slider: HSlider = $VBoxContainer/MarginContainer2/TabContainer/Sound/Panel/CenterContainer/VBoxContainer/Master/MasterHSlider
@onready var music_h_slider: HSlider = $VBoxContainer/MarginContainer2/TabContainer/Sound/Panel/CenterContainer/VBoxContainer/Music/MusicHSlider
@onready var sound_fxh_slider: HSlider = $VBoxContainer/MarginContainer2/TabContainer/Sound/Panel/CenterContainer/VBoxContainer/SoundFX/SoundFXHSlider

func _ready() -> void:
    back_button.grab_focus()
    master_h_slider.set_value_no_signal(get_volume("Master"))
    music_h_slider.set_value_no_signal(get_volume("Music"))
    sound_fxh_slider.set_value_no_signal(get_volume("SoundFX"))

func _input(event: InputEvent) -> void:
    if not event is InputEventKey:
        return

    var key_event: InputEventKey = event as InputEventKey
    if key_event.keycode == KEY_ESCAPE:
        go_back()

func go_back() -> void:
    get_tree().change_scene_to_file("res://game/ui/main_menu.tscn")

func _on_back_button_pressed() -> void:
    go_back()

func _on_timer_timeout() -> void:
    var old = animation_list.pop_front()
    animation_list.append(old)
    animated_sprite_2d.play(animation_list[0])

func get_volume(bus_name: String) -> float:
    var idx: = AudioServer.get_bus_index(bus_name)
    var volume_db: = AudioServer.get_bus_volume_db(idx)
    return db_to_linear(volume_db)

func set_volume(bus_name: String, value: float) -> void:
    var idx: = AudioServer.get_bus_index(bus_name)
    AudioServer.set_bus_volume_db(idx, linear_to_db(value))

func _on_master_h_slider_value_changed(value: float) -> void:
    set_volume("Master", value)

func _on_music_h_slider_value_changed(value: float) -> void:
    set_volume("Music", value)

func _on_sound_fxh_slider_value_changed(value: float) -> void:
    set_volume("SoundFX", value)
