extends Node
class_name CheatCodeListener

const CHEAT_CODE_INPUT_TIMEOUT: = 1.0

var cheats_path := "res://game/world/cheats/"
var current_seq: Array[String] = []

@onready var cheat_codes: Dictionary
@onready var input_timer: Timer = Timer.new()

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	add_child(input_timer)
	input_timer.one_shot = true
	cheat_codes = Utils.load_dict_from_path(cheats_path, [".tres"])

func check_sequence() -> void:
	var matched_some_cheat: bool = false

	print_verbose("Current cheat code sequence: ", current_seq)
	for cheat_name in cheat_codes:
		var cheat_code: CheatCode = cheat_codes[cheat_name] as CheatCode
		if current_seq != cheat_code.button_combo.slice(0, len(current_seq)):
			continue
		matched_some_cheat = true

		# We matched partial at least - check if we're done
		if current_seq == cheat_code.button_combo:
			print_verbose("Cheat activated! ", cheat_name)
			SoundFx.play("cheat_code")
			Events.toggle_cheat.emit(cheat_name)
			input_timer.stop()
			current_seq.clear()
			break
		break

	if not matched_some_cheat:
		print_verbose("Cheat input failed!")
		input_timer.stop()
		current_seq.clear()

func _physics_process(_delta: float) -> void:
	if input_timer.is_stopped():
		current_seq.clear()
		input_timer.start(CHEAT_CODE_INPUT_TIMEOUT)

	var pressed_action: String = ""
	if Input.is_action_just_pressed("move_up"):
		pressed_action = "move_up"
	elif Input.is_action_just_pressed("move_down"):
		pressed_action = "move_down"
	elif Input.is_action_just_pressed("move_left"):
		pressed_action = "move_left"
	elif Input.is_action_just_pressed("move_right"):
		pressed_action = "move_right"
	elif Input.is_action_just_pressed("crouch"):
		pressed_action = "crouch"
	elif Input.is_action_just_pressed("jump"):
		pressed_action = "jump"
	elif Input.is_action_just_pressed("pause"):
		pressed_action = "pause"
	elif Input.is_action_just_pressed("attack"):
		pressed_action = "attack"

	if not pressed_action:
		return

	# Start it over for valid input
	input_timer.start(CHEAT_CODE_INPUT_TIMEOUT)
	current_seq.append(pressed_action)
	check_sequence()
