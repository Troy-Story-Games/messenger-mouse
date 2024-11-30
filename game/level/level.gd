extends Node2D
class_name Level

const BonfireParticlesScene = preload("res://game/fx/bonfire_particles.tscn")

@export var level_image: Texture2D
@export var level_name: String = ""
@export var flame_value: float = 0.3
@export var checkpoint_value: float = 15.0
@export var time_limit: float = 75.0
@export var player_outside_limit_threshold: int = 25

var bon_fire_lit: bool = false
var level_stats: Dictionary
var level_timer_running: bool = false
var time_ms: float = 0.0
var initialized: bool = false
var exiting: bool = false
var num_cheats_found: int = 0
var num_secrets_found: int = 0
var secrets_found: Dictionary = {}
var cheats_found: Dictionary = {}

@onready var camera_limits: CameraLimits = $CameraLimits
@onready var start_position: Marker2D = $StartPosition
@onready var level_exit: Area2D = $LevelExit
@onready var secrets: Node = $Secrets
@onready var cheats: Node = $Cheats
@onready var flame_timer: Timer = $FlameTimer
@onready var bon_fire_animation_player: AnimationPlayer = $BonFireAnimationPlayer
@onready var bonfire_area: Area2D = $BonfireArea

func _ready() -> void:
	assert(level_image, "Levels need an image now! Set the level_image export with a Texture2D")
	Events.player_checkpoint.connect(_on_player_checkpoint)
	Events.flame_collected.connect(_on_flame_collected)
	Events.cheat_found.connect(_on_cheat_found)
	Events.secret_found.connect(_on_secret_found)
	Events.flame_relight_start.connect(_on_flame_relight_start)
	Events.flame_relight_complete.connect(_on_flame_relight_complete)
	Events.flame_relight_progress.connect(_on_flame_relight_progress)
	Events.level_stay_here.connect(_on_level_stay_here)
	load_level_stats()

func _on_level_stay_here() -> void:
	# Not switching levels yet
	level_timer_running = true
	exiting = false
	flame_timer.start()
	await get_tree().create_timer(1.5).timeout
	level_exit.set_deferred("monitoring", true)
	level_exit.set_deferred("monitorable", true)

func _on_flame_relight_start() -> void:
	flame_timer.paused = true

func _on_flame_relight_progress(amount: float) -> void:
	var new_time_left = time_limit * amount
	print("Flame relight: ", new_time_left)
	set_time_left(new_time_left)
	flame_timer.paused = true

func _on_flame_relight_complete() -> void:
	set_time_left(time_limit)
	flame_timer.paused = false

func _on_player_checkpoint(_pos: Vector2) -> void:
	var new_time_left = clamp(flame_timer.time_left + checkpoint_value, 0, time_limit)
	flame_timer.start(new_time_left)

func _on_flame_collected() -> void:
	var new_time_left = clamp(flame_timer.time_left + flame_value, 0, time_limit)
	flame_timer.start(new_time_left)

func get_num_secrets() -> int:
	return len(secrets.get_children())

func get_num_cheats() -> int:
	return len(cheats.get_children())

func _on_secret_found(secret: SecretArea) -> void:
	num_secrets_found = clamp(num_secrets_found + 1, 0, level_stats.num_secrets)
	secrets_found[secret.secret_name] = {"found": true}

func _on_cheat_found(cheat: CheatCodeArea) -> void:
	var cheat_code: CheatCode = cheat.secret_data as CheatCode
	num_cheats_found = clamp(num_cheats_found + 1, 0, level_stats.num_cheats)
	cheats_found[cheat.secret_name] = {
		"found": true,
		"button_combo": cheat_code.button_combo,
		"name": cheat_code.cheat_name
	}

func check_player_position(player: Player) -> void:
	if player.dead:
		return  # Player is in the process of dying

	# Check if the player is outside the camera limits by some amount
	var climits_control: Control = camera_limits as Control
	var player_pos = player.position
	if player_pos.x < (climits_control.position.x - player_outside_limit_threshold):
		print("Player off left side of level")
		player.die()
		return
	if player_pos.x > (climits_control.position.x + climits_control.size.x + player_outside_limit_threshold):
		print("Player off right side of level. ", player_pos, " - ", climits_control.position, " - ", climits_control.size)
		player.die()
		return
	if player_pos.y < (climits_control.position.y - player_outside_limit_threshold):
		print("Player off top of level too much")
		player.die()
		return
	if player_pos.y > (climits_control.position.y + climits_control.size.y + player_outside_limit_threshold):
		print("player off bottom of level")
		player.die()
		return

func get_time_left() -> float:
	return flame_timer.time_left

func get_level_time() -> float:
	return time_ms

func set_time_left(value: float) -> void:
	flame_timer.start(value)

func _process(delta: float) -> void:
	if not level_timer_running:
		return
	time_ms += delta * 1000

func _physics_process(_delta: float) -> void:
	var player: = MainInstances.player as Player
	if not player or not is_instance_valid(player):
		return

	if not initialized:
		initialized = true
		level_timer_running = true
		flame_timer.start(time_limit)
		player.global_position = start_position.global_position
		print_debug("level initialized. Player position updated to ", player.global_position)

	check_player_position(player)

func load_level_stats() -> void:
	level_stats = SaveAndLoad.save_data.levels.get(scene_file_path, {})
	level_stats.level_name = level_name
	level_stats.level_image = level_image.resource_path
	level_stats.num_cheats = get_num_cheats()
	level_stats.num_secrets = get_num_secrets()

	if "cheats_found" in level_stats and num_cheats_found > level_stats.cheats_found:
		level_stats.cheats_found = num_cheats_found
	elif "cheats_found" not in level_stats:
		level_stats.cheats_found = num_cheats_found

	if "secrets_found" in level_stats and num_secrets_found > level_stats.secrets_found:
		level_stats.secrets_found = num_secrets_found
	elif "secrets_found" not in level_stats:
		level_stats.secrets_found = num_secrets_found

	num_cheats_found = level_stats.cheats_found
	num_secrets_found = level_stats.secrets_found

func update_stats() -> void:
	if "best_time" in level_stats and time_ms < level_stats.best_time:
		print("New record: ", time_ms)
		level_stats.best_time = time_ms
	elif "best_time" not in level_stats:
		level_stats.best_time = time_ms

	level_stats.last_time = time_ms
	level_stats.cheats_found = num_cheats_found
	level_stats.secrets_found = num_secrets_found

	SaveAndLoad.save_data.cheats.merge(cheats_found, true)
	SaveAndLoad.save_data.secrets.merge(secrets_found, true)

	SaveAndLoad.save_data.levels[scene_file_path] = level_stats
	SaveAndLoad.save_game()

func _on_level_exit_area_entered(area: Area2D) -> void:
	if not exiting and bon_fire_lit:
		# Switch levels
		level_timer_running = false
		exiting = true
		flame_timer.stop()
		SoundFx.play("level_complete", 1, -15, 0)
		update_stats()
		Events.next_level.emit(level_stats)
		level_exit.set_deferred("monitoring", false)
		level_exit.set_deferred("monitorable", false)

func _on_flame_timer_timeout() -> void:
	Events.flame_timer_timeout.emit()

func _on_bonfire_area_area_entered(_area: Area2D) -> void:
	if not bon_fire_lit:
		var particles: CPUParticles2D = Utils.instantiate_scene_on_level(BonfireParticlesScene, bonfire_area.global_position)
		particles.emitting = true
		bon_fire_animation_player.play("spawn")
		await bon_fire_animation_player.animation_finished
		bon_fire_animation_player.play("burn")
		bon_fire_lit = true
