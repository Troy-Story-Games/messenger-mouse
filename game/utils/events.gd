extends Node

@warning_ignore("unused_signal")
signal request_camera_target(new_target: RemoteTransform2D)
@warning_ignore("unused_signal")
signal request_camera_screenshake(amount: float, duration: float)
@warning_ignore("unused_signal")
signal request_camera_limits(camera_limits: CameraLimits)
@warning_ignore("unused_signal")
signal toggle_cheat(cheat_name: String)
@warning_ignore("unused_signal")
signal player_hurt()
@warning_ignore("unused_signal")
signal player_checkpoint(global_position: Vector2)
@warning_ignore("unused_signal")
signal player_died()
@warning_ignore("unused_signal")
signal next_level(stats: Dictionary)
@warning_ignore("unused_signal")
signal enemy_killed(enemy: Enemy)
@warning_ignore("unused_signal")
signal flame_timer_timeout()
@warning_ignore("unused_signal")
signal flame_relight_start()
@warning_ignore("unused_signal")
signal flame_relight_complete()
@warning_ignore("unused_signal")
signal flame_relight_progress(amount: float)
@warning_ignore("unused_signal")
signal flame_collected()
@warning_ignore("unused_signal")
signal secret_found(secret: Secret)
@warning_ignore("unused_signal")
signal cheat_found(cheat: Secret)
@warning_ignore("unused_signal")
signal request_script_pause(pause: bool)
@warning_ignore("unused_signal")
signal level_stay_here()
