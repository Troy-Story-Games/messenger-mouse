extends Node2D
class_name World

const MainMenuScene: PackedScene = preload("res://game/ui/main_menu.tscn")
const PlayerScene: PackedScene = preload("res://game/player/player.tscn")

@export var min_time_left_on_respawn: float = 15.0

var current_level: Level
var current_level_idx: int = 0
var zoom_out_enabled: bool = false
var last_checkpoint: Vector2

@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var ui: UI = $UI
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_fade: ColorRect = $UI/LevelFade
@onready var pause_manager: PauseManager = $PauseManager

func _ready() -> void:
    MainInstances.pause_manager = pause_manager
    Events.toggle_cheat.connect(_on_toggle_cheat)
    Events.player_checkpoint.connect(_on_player_checkpoint)
    Events.player_died.connect(_on_player_died)
    if current_level_idx == 0:
        if SaveAndLoad.save_data.play_selected_level != -1:
            current_level_idx = SaveAndLoad.save_data.play_selected_level
            SaveAndLoad.save_data.play_selected_level = -1
            SaveAndLoad.save_game()
        else:
            current_level_idx = SaveAndLoad.save_data.next_level_index
    call_deferred("next_level")

func _on_player_checkpoint(checkpoint_pos: Vector2) -> void:
    last_checkpoint = checkpoint_pos

func _on_toggle_cheat(cheat_name: String):
    if cheat_name == "zoom_out":
        if not zoom_out_enabled:
            zoom_out_enabled = true
            player_camera.zoom = Vector2(0.55, 0.55)
        else:
            zoom_out_enabled = false
            player_camera.zoom = Vector2(1, 1)

func _on_player_died() -> void:
    var time_left = current_level.get_time_left()
    if time_left < min_time_left_on_respawn:
        current_level.set_time_left(min_time_left_on_respawn)
    call_deferred("respawn")

func respawn() -> void:
    print_debug("respawn player at ", last_checkpoint)
    var player: Player = PlayerScene.instantiate()
    add_child(player)
    player.global_position = last_checkpoint

func next_level() -> void:
    var player: Player = MainInstances.player

    if current_level_idx >= len(Utils.levels):
        SaveAndLoad.save_data.next_level_index = 0
        SaveAndLoad.save_data.game_completed = true
        SaveAndLoad.save_game()

        # TODO: Credits
        get_tree().change_scene_to_packed(MainMenuScene)
        return

    if player and is_instance_valid(player):
        player.hurtbox.is_invincible = true
        player.hurtbox.set_deferred("monitorable", false)
        player.hurtbox.set_deferred("monitoring", false)
        player.hitbox.set_deferred("monitorable", false)
        player.hitbox.set_deferred("monitoring", false)
        player.collision_polygon_2d.disabled = true
        player.global_position = Vector2.ZERO
        player.hide()

    if current_level:
        current_level.queue_free()

    if current_level_idx >= SaveAndLoad.save_data.next_level_index:
        # So continue works
        SaveAndLoad.save_data.next_level_index = current_level_idx
        SaveAndLoad.save_game()

    current_level = Utils.get_level(current_level_idx).instantiate()
    add_child(current_level)
    print("Start position updated to: ", current_level.start_position.global_position)
    last_checkpoint = current_level.start_position.global_position
    MainInstances.current_level = current_level
    start_level(player)

func start_level(player: Player) -> void:
    if player and is_instance_valid(player):
        player.hurtbox.is_invincible = false
        player.hurtbox.set_deferred("monitorable", true)
        player.hurtbox.set_deferred("monitoring", true)
        player.hitbox.set_deferred("monitorable", true)
        player.hitbox.set_deferred("monitoring", true)
        player.collision_polygon_2d.disabled = false
        player.show()

    level_fade.show()
    ui.set_total_cheats(current_level.get_num_cheats())
    ui.set_total_secrets(current_level.get_num_secrets())
    ui.set_flame_progress_max(current_level.time_limit)
    animation_player.play("fade_to_transparent")
    await animation_player.animation_finished
    level_fade.hide()
    animation_player.play(&"RESET")

    if current_level_idx == 0:
        ui.show_tutorial()
        Events.request_script_pause.emit(true)
        await ui.ui_tutorial_complete
        Events.request_script_pause.emit(false)

func _process(_delta: float) -> void:
    if not current_level or not is_instance_valid(current_level):
        return
    var time_left = current_level.get_time_left()
    var level_time = current_level.get_level_time()
    ui.set_flame_progress(time_left)
    ui.set_time_ms(level_time)
    ui.set_secrets_found(current_level.num_secrets_found)
    ui.set_cheats_found(current_level.num_cheats_found)

func _on_level_complete_next_level() -> void:
    current_level_idx += 1
    call_deferred("next_level")
