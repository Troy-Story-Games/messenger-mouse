extends Control
class_name PauseMenu

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_resume_button_pressed() -> void:
    hide_menu()
    get_tree().paused = false

func _on_save_and_quit_pressed() -> void:
    SaveAndLoad.quit_game()

func hide_menu() -> void:
    resume_button.disabled = true
    animation_player.play("hide")
    await animation_player.animation_finished
    hide()

func show_menu() -> void:
    show()
    animation_player.play("show")
    await animation_player.animation_finished
    resume_button.disabled = false
    resume_button.grab_focus()

func _on_pause_manager_paused() -> void:
    show_menu()

func _on_pause_manager_unpaused() -> void:
    hide_menu()
