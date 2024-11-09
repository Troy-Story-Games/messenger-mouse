extends CanvasLayer
class_name UI

var running: bool = false
var time: = 0.0 : set = set_time

@onready var clock: Label = $Control/Clock

func start_timer() -> void:
    time = 0.0
    running = true

func stop_timer() -> float:
    var ret: = time
    time = 0.0
    running = false
    return ret

func _process(delta: float) -> void:
    if not running:
        return
    time += delta

func set_time(value: float) -> void:
    time = value
    # TODO: minute:second
    clock.text = str(int(value)) + "s"
