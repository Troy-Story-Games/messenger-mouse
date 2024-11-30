extends Control
class_name PauseMenu

var options_open: bool = false
var cheats_open: bool = false
var is_paused: bool = false

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var options: Options = $Options
@onready var options_button: BeepButton = $CenterContainer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton
@onready var cheats_button: BeepButton = $CenterContainer/VBoxContainer/CheatsButton
@onready var cheat_code_list_ui: CheatCodeListUI = $CheatCodeListUI

func _ready() -> void:
    options.visibility_changed.connect(_on_options_visibility_changed)
    cheat_code_list_ui.visibility_changed.connect(_on_cheats_ui_visibility_changed)
    show_hide_cheats()

func show_hide_cheats():
    if not SaveAndLoad.save_data.cheats.size():
        cheats_button.hide()
    else:
        cheats_button.show()
        return

    var current_level = MainInstances.current_level
    if current_level and is_instance_valid(current_level):
        if current_level.num_cheats_found:
            cheats_button.show()

func _on_resume_button_pressed() -> void:
    is_paused = false
    hide_menu()
    Events.request_script_pause.emit(false)

func hide_menu() -> void:
    resume_button.disabled = true
    animation_player.play("hide")
    await animation_player.animation_finished
    options.hide()
    hide()

func _process(_delta: float) -> void:
    if not is_paused:
        return
    if options_open:
        return
    if cheats_open:
        return
    if Input.is_action_just_pressed("ui_cancel"):
        hide_menu()
        Events.request_script_pause.emit(false)

func show_menu() -> void:
    show()
    show_hide_cheats()
    animation_player.play("show")
    await animation_player.animation_finished
    resume_button.disabled = false
    resume_button.grab_focus()

func _on_pause_manager_paused() -> void:
    is_paused = true
    show_menu()

func _on_pause_manager_unpaused() -> void:
    is_paused = false
    hide_menu()

func _on_quit_button_pressed() -> void:
    get_tree().quit(0)

func overlay_visibility_changed(visible: bool) -> void:
    if visible:
        options_button.disabled = true
        quit_button.disabled = true
        resume_button.disabled = true
        cheats_button.disabled = true
        options_button.hide()
        cheats_button.hide()
        quit_button.hide()
        resume_button.hide()
    else:
        options_button.disabled = false
        quit_button.disabled = false
        resume_button.disabled = false
        cheats_button.disabled = false
        options_button.show()
        cheats_button.show()
        quit_button.show()
        resume_button.show()
        resume_button.grab_focus()

func _on_options_visibility_changed() -> void:
    overlay_visibility_changed(options.visible)
    if not options.visible:
        # Without a timeout the "Input.is_action_just_pressed("ui_cancel") is true
        # when using it to get out of the options and so the pause menu closes too
        await get_tree().create_timer(0.2).timeout
        set_deferred("options_open", false)

func _on_cheats_ui_visibility_changed() -> void:
    overlay_visibility_changed(cheat_code_list_ui.visible)
    if not cheat_code_list_ui.visible:
        # Without a timeout the "Input.is_action_just_pressed("ui_cancel") is true
        # when using it to get out of the options and so the pause menu closes too
        await get_tree().create_timer(0.2).timeout
        set_deferred("cheats_open", false)

func _on_options_button_pressed() -> void:
    options_open = true
    options.show()

func _on_main_menu_button_pressed() -> void:
    is_paused = false
    Events.request_script_pause.emit(false)
    get_tree().change_scene_to_file("res://game/ui/main_menu.tscn")

func _on_cheats_button_pressed() -> void:
    cheats_open = true
    cheat_code_list_ui.show()
