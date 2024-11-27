extends Node2D
class_name Level

@export var flame_value: float = 0.2
@export var checkpoint_value: float = 5.0
@export var time_limit: float = 30.0
@export var player_outside_limit_threshold: int = 25

var level_stats: Dictionary
var level_timer_running: bool = false
var time_ms: float = 0.0
var initialized: bool = false
var exiting: bool = false
var cheats_found: int = 0
var secrets_found: int = 0

@onready var camera_limits: CameraLimits = $CameraLimits
@onready var start_position: Marker2D = $StartPosition
@onready var level_exit: Area2D = $LevelExit
@onready var secrets: Node = $Secrets
@onready var cheats: Node = $Cheats
@onready var flame_timer: Timer = $FlameTimer

func _ready() -> void:
    Events.player_checkpoint.connect(_on_player_checkpoint)
    Events.flame_collected.connect(_on_flame_collected)
    Events.cheat_found.connect(_on_cheat_found)
    Events.secret_found.connect(_on_secret_found)
    level_stats = load_level_stats()

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

func _on_secret_found(_secret) -> void:
    secrets_found += 1

func _on_cheat_found(_cheat) -> void:
    cheats_found += 1

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

func load_level_stats() -> Dictionary:
    return SaveAndLoad.save_data.levels.get(scene_file_path, {})

func update_stats() -> Dictionary:
    if "best_time" in level_stats and time_ms < level_stats.best_time:
        print("New record: ", time_ms)
        level_stats.best_time = time_ms
    elif "best_time" not in level_stats:
        level_stats.best_time = time_ms

    level_stats.last_time = time_ms
    level_stats.num_cheats = get_num_cheats()
    level_stats.num_secrets = get_num_secrets()

    if "cheats_found" in level_stats and cheats_found > level_stats.cheats_found:
        level_stats.cheats_found = cheats_found
    elif "cheats_found" not in level_stats:
        level_stats.cheats_found = cheats_found

    if "secrets_found" in level_stats and secrets_found > level_stats.secrets_found:
        level_stats.secrets_found = secrets_found
    elif "secrets_found" not in level_stats:
        level_stats.secrets_found = secrets_found

    SaveAndLoad.save_data.levels[scene_file_path] = level_stats
    SaveAndLoad.save_game()
    return level_stats

func _on_level_exit_area_entered(area: Area2D) -> void:
    if not exiting:
        # Switch levels
        level_timer_running = false
        exiting = true
        flame_timer.stop()
        SoundFx.play("level_complete", 1, -15, 0)
        Events.next_level.emit(update_stats())
        level_exit.set_deferred("monitoring", false)
        level_exit.set_deferred("monitorable", false)

func _on_flame_timer_timeout() -> void:
    Events.level_timeout.emit()
