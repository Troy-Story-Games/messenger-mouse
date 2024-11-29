extends State
class_name PlayerLightFlameState

const CampfireScene = preload("res://game/player/campfire.tscn")

const LIGHT_FIRE_FRAME_1 = 26
const LIGHT_FIRE_FRAME_2 = 27
const BUTTON_PROGRESS_CREDIT = 0.025

var progress: float = 0.0
var campfire: Campfire

func enter() -> void:
    var player: Player = actor as Player
    Events.flame_relight_start.emit()
    player.hurtbox.is_invincible = true
    player.animation_player.stop()
    player.attack_animation_player.stop()
    player.attack_animation_player.play(&"RESET")
    player.sprite_2d.frame = LIGHT_FIRE_FRAME_1
    player.light_flame_background_mask.show()
    player.relight_flame_ui.show()
    campfire = Utils.instantiate_scene_on_level(CampfireScene, player.global_position)
    campfire.apply_central_impulse(Vector2(75 * sign(player.flip_anchor.scale.x), -75))
    progress = 0.0

func smash(player: Player) -> void:
    if player.sprite_2d.frame == LIGHT_FIRE_FRAME_1:
        player.sprite_2d.frame = LIGHT_FIRE_FRAME_2
    else:
        player.sprite_2d.frame = LIGHT_FIRE_FRAME_1
    player.relight_sparks.emitting = true
    progress += BUTTON_PROGRESS_CREDIT
    campfire.set_progress(progress)
    Events.flame_relight_progress.emit(progress)

func done(player: Player) -> void:
    Events.flame_relight_complete.emit()
    player.light_flame_background_mask.hide()
    player.animation_player.play("idle")
    player.relight_flame_ui.hide()
    player.hurtbox.is_invincible = false
    player.relight_sparks.emitting = false
    finished.emit()

func process_state(_delta: float) -> void:
    var player: Player = actor as Player
    if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("crouch") or Input.is_action_just_pressed("jump"):
        smash(player)
    elif Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_up"):
        smash(player)
    else:
        player.relight_sparks.emitting = false
    if progress >= 1.0:
        done(player)
