extends State
class_name PlayerDieState

const PLAYER_DEATH_HOP_HEIGHT: int = 25

func enter() -> void:
	var player: Player = actor as Player
	player.attack_animation_player.play(&"RESET")
	player.remote_transform_2d.remote_path = ""
	player.animation_player.play("die")
	player.collision_polygon_2d.set_deferred("disabled", true)
	player.hurtbox.set_deferred("monitoring", false)
	player.hurtbox.set_deferred("monitorable", false)

	player.get_tree().paused = true
	await player.get_tree().create_timer(0.3).timeout
	player.get_tree().paused = false

	SoundFx.play("player_death")
	Engine.time_scale = 0.5
	Events.request_camera_screenshake.emit(4, 0.5)
	var tween: Tween = player.get_tree().create_tween()
	tween.tween_property(player, "position", player.position - Vector2(0, PLAYER_DEATH_HOP_HEIGHT), 0.2).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(player, "position", player.position + Vector2(0, PLAYER_DEATH_HOP_HEIGHT * 15), 0.4).set_ease(Tween.EASE_IN)
	tween.play()
	tween.finished.connect(death_animation_finished)


func death_animation_finished() -> void:
	Engine.time_scale = 1
	finished.emit()
	
