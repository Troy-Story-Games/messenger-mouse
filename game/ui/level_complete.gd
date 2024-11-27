extends Control
class_name LevelComplete

signal next_level()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_button: BeepButton = $CenterContainer/VBoxContainer/ContinueButton
@onready var secrets: Label = $CenterContainer/VBoxContainer/HBoxContainer/SecretsAndCheats/Secrets
@onready var cheats: Label = $CenterContainer/VBoxContainer/HBoxContainer/SecretsAndCheats/Cheats
@onready var best_time: Label = $CenterContainer/VBoxContainer/HBoxContainer/Times/BestTime
@onready var current_time: Label = $CenterContainer/VBoxContainer/HBoxContainer/Times/CurrentTime

func _ready() -> void:
	hide()
	continue_button.disabled = true
	Events.next_level.connect(_on_next_level)

func _on_next_level(stats: Dictionary):
	show()

	# Show stats
	best_time.text = "Best Time: " + Utils.ms_to_string(stats.best_time)
	current_time.text = "Time: " + Utils.ms_to_string(stats.last_time)
	secrets.text = "Secrets: %02d/%02d" % [stats.secrets_found, stats.num_secrets]
	cheats.text = "Cheats: %02d/%02d" % [stats.cheats_found, stats.num_cheats]
	
	get_tree().paused = true
	continue_button.disabled = false
	continue_button.grab_focus()
	animation_player.play("show")

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	hide()
	animation_player.play(&"RESET")
	continue_button.disabled = true
	next_level.emit()

func _on_save_and_quit_pressed() -> void:
	SaveAndLoad.quit_game()
