extends Control
class_name PauseMenu

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton

func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false

func _on_save_and_quit_pressed() -> void:
	SaveAndLoad.quit_game()

func _on_pause_manager_paused() -> void:
	resume_button.grab_focus()
	show()

func _on_pause_manager_unpaused() -> void:
	hide()
