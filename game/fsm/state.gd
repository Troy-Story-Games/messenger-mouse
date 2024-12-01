extends RefCounted
class_name State

@warning_ignore("unused_signal")
signal finished()

var actor: Node2D : set = set_actor

func set_actor(value: Node2D) -> State:
    actor = value
    return self

func enter() -> void:
    pass

func process_state(_delta: float) -> void:
    pass

func exit() -> void:
    pass
