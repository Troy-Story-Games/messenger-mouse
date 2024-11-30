extends Control
class_name CheatCodeUI

var viewed_long_enough: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cheat_title_label: Label = $CenterContainer/HBoxContainer/CheatTitleLabel
@onready var cheat_code_label: Label = $CenterContainer/HBoxContainer/CheatCodeLabel
@onready var viewed_long_enough_label: Label = $CenterContainer/HBoxContainer/ViewedLongEnoughLabel
@onready var timer: Timer = $Timer

func _ready() -> void:
	viewed_long_enough = false
	hide()

func display_cheat_code(cheat_code: CheatCode) -> void:
	show()
	animation_player.play("show")
	Events.request_script_pause.emit(true)
	cheat_title_label.text = cheat_code.cheat_name
	cheat_code_label.text = Utils.generate_cheat_string(cheat_code.button_combo)

func _process(_delta: float) -> void:
	if viewed_long_enough:
		if Input.get_connected_joypads():
			viewed_long_enough_label.text = "A to continue"
		else:
			viewed_long_enough_label.text = "SPACE to continue"
		return
	var show_time = 4
	if not timer.is_stopped():
		show_time = timer.time_left
	viewed_long_enough_label.text = "Look! %02d" % show_time

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if not viewed_long_enough:
		return

	if event.is_action_pressed("jump") or event.is_action_pressed("crouch") or event.is_action_pressed("pause"):
		animation_player.play(&"RESET")
		hide()
		viewed_long_enough = false
		Events.request_script_pause.emit(false)

func _on_timer_timeout() -> void:
	viewed_long_enough = true
