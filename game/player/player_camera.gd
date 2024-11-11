extends Camera2D
class_name PlayerCamera

var _target : RemoteTransform2D : set = set_target

func _ready():
    Events.request_camera_target.connect(set_target)
    Events.request_camera_screenshake.connect(apply_screenshake)

func set_target(value: RemoteTransform2D):
    if _target is RemoteTransform2D:
        _target.remote_path = ""
    _target = value
    _target.remote_path = get_path()
    reset_smoothing()

func apply_screenshake(amount: float, duration: float = 0.3) -> void:
    var tween: = create_tween()
    var orig_offset = offset
    tween.tween_method(shake, amount, 0.0, duration)
    await tween.finished
    offset = orig_offset

func shake(amount: float) -> void:
    offset += Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * amount
