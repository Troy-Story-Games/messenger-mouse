extends Node2D
class_name Level

@export var player_outside_limit_threshold: int = 25

var initialized: bool = false
var exiting: bool = false

@onready var camera_limits: CameraLimits = $CameraLimits
@onready var start_position: Marker2D = $StartPosition
@onready var level_exit: Area2D = $LevelExit

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

func _physics_process(_delta: float) -> void:
    var player: = MainInstances.player as Player
    if not player or not is_instance_valid(player):
        return

    if not initialized:
        initialized = true
        player.global_position = start_position.global_position
        print_debug("level initialized. Player position updated to ", player.global_position)

    check_player_position(player)

func _on_level_exit_area_entered(area: Area2D) -> void:
    if not exiting:
        # Switch levels
        exiting = true
        Events.next_level.emit()
        level_exit.set_deferred("monitoring", false)
        level_exit.set_deferred("monitorable", false)
