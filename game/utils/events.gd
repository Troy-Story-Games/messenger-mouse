extends Node

signal request_camera_target(new_target: RemoteTransform2D)
signal request_camera_screenshake(amount: float, duration: float)
signal request_camera_limits(camera_limits: CameraLimits)
signal toggle_cheat(cheat_name: String)
