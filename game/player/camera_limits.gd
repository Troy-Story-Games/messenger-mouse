extends Control
class_name CameraLimits

func _ready() -> void:
    Events.request_camera_limits.emit.call_deferred(self)
    hide()
